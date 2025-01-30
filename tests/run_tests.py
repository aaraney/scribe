#!/usr/bin/env python3
from __future__ import annotations

import difflib
import pathlib
import typing
import subprocess
import logging

logger = logging.getLogger("ngen_jsonnet_tests")


def jsonnet(filename: pathlib.Path) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        ["jsonnet", str(filename)],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
    )


def run_test(test_file: pathlib.Path):
    golden_file = test_file.with_suffix(".jsonnet.golden")
    if not golden_file.exists():
        return {
            "test": test_file,
            "status": "skipped",
            "reason": "skipping no golden file",
        }
    result = jsonnet(test_file)
    if result.returncode != 0:
        return {
            "test": test_file,
            "status": "failed",
            "reason": "`jsonnet` returned with non-zero exit code.",
            "verbose": {
                "cmd": result.args,
                "stdout": result.stdout,
                "stderr": result.stderr,
                "exit_code": result.returncode,
            },
        }

    jsonnet_output = result.stdout.splitlines()
    golden_file_output = golden_file.read_text().splitlines()
    diff = "\n".join(
        difflib.unified_diff(
            jsonnet_output,
            golden_file_output,
            fromfile=str(test_file),
            tofile=str(golden_file),
            n=3,
            lineterm="\n",
        )
    )
    if diff:
        return {
            "test": test_file,
            "status": "failed",
            "reason": "diff does not match",
            "verbose": {
                "diff": diff,
            },
        }
    return {"test": test_file, "status": "passed"}


def test_output_verbose(result) -> bool:
    status: str | None = result["status"]
    assert status is not None
    if status == "passed":
        print(f"{result['test'].name!s}: {status.upper()}")
        return True

    from pprint import pprint

    test_output(result)
    pprint(result["verbose"], sort_dicts=False)
    return False


def test_output(result) -> bool:
    status: str | None = result["status"]
    assert status is not None
    if status != "passed":
        print(f"{result['test'].name!s}: {status.upper()} -- {result['reason']}")
        return False
    return True


def run_tests(
    files: typing.Iterator[pathlib.Path],
) -> dict[pathlib.Path, dict[str, typing.Any]]:
    return {test_file: run_test(test_file) for test_file in files}


def test_results(
    results: dict[pathlib.Path, dict[str, typing.Any]], verbose: bool = False
) -> bool:
    ret = True
    fn = test_output_verbose if verbose else test_output
    for result in results.values():
        if not fn(result):
            ret = False
    return ret


def command_run_tests(
    files: typing.Iterator[pathlib.Path], verbose: bool = False
) -> bool:
    results = run_tests(files)
    return test_results(results, verbose)


def create_test(test_file: pathlib.Path) -> dict[str, typing.Any]:
    golden_file = test_file.with_suffix(".jsonnet.golden")
    if golden_file.exists():
        logger.debug(f"golden file exists. skipping {test_file!s}")
        return {
            "test": test_file,
            "status": "skipped",
            "reason": "golden file already exists",
        }
    result = jsonnet(test_file)
    if result.returncode != 0:
        return {
            "test": test_file,
            "status": "failed",
            "reason": "`jsonnet` returned with non-zero exit code.",
            "verbose": {
                "cmd": result.args,
                "stdout": result.stdout,
                "stderr": result.stderr,
                "exit_code": result.returncode,
            },
        }
    golden_file.write_text(result.stdout)
    return {
        "test": test_file,
        "status": "created",
    }


def create_tests(
    files: typing.Iterator[pathlib.Path],
) -> dict[pathlib.Path, dict[str, typing.Any]]:
    return {test_file: create_test(test_file) for test_file in files}


def create_test_output(result: dict[str, typing.Any]) -> bool:
    if result["status"] == "failed":
        test_output_verbose(result)
        return False
    return True


def create_test_output_verbose(result: dict[str, typing.Any]) -> bool:
    status = result["status"]
    if status == "failed":
        test_output_verbose(result)
        return False
    print(f"{result['test'].name!s}: {status.upper()}")
    return True


def command_create_tests(
    files: typing.Iterator[pathlib.Path], verbose: bool = False
) -> bool:
    results = create_tests(files)
    fn = create_test_output_verbose if verbose else create_test_output
    ret = True
    for result in results.values():
        if not fn(result):
            ret = False
    return ret


def setup_argparse():
    import argparse

    parser = argparse.ArgumentParser()
    parser.add_argument("-v", "--verbose", action="store_true")
    parser.add_argument("action", nargs="?", choices=["test", "create"], default="test")
    return parser


def main() -> int:
    parent_dir = pathlib.Path(__file__).parent
    test_files = parent_dir.glob("*.jsonnet")

    parser = setup_argparse()
    args = parser.parse_args()
    verbose = args.verbose
    fn = command_run_tests if args.action == "test" else command_create_tests
    # flip b.c. shell exit code 0 is success
    return not fn(test_files, verbose=verbose)


if __name__ == "__main__":
    raise SystemExit(main())
