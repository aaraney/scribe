local f = import '../formulation.libjsonnet';
local known_formulations = import '../known_formulations.libjsonnet';

local multi_bmi_map(func, formulation) =
  local mods = f.unwrap(formulation);
  local res = std.map(func, mods);

  formulation { params+: {
    modules: res,
  } };

local curry(func, arg) =
  function() func(arg);


multi_bmi_map(
  function(mod)
    mod + f.with_library_dir('/dmod/lib_dir')
  , known_formulations.noahowp_topmodel
)
