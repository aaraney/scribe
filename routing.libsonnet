local routing_nts(total_seconds, timestep=300) =
  // `timestep` in seconds
  // @param total_seconds int unix timestamp
  // @param timestep int size of t-route timestep
  // @return int
  std.floor(total_seconds / timestep);

local datetime = import 'datetime.libsonnet';
local pathlib = import 'pathlib.libsonnet';
local errors = import 'errors.libsonnet';

local routing_base = {
  start_time:: errors.must_override('start_time (string)'),
  nts:: errors.must_override('nts (int)'),

  hf_basename:: errors.must_override('hf_basename (string)'),
  hf_dirname:: '',
  // do not override this
  _hf:: pathlib.joinPath(self.hf_dirname, self.hf_basename),

  log_parameters: {
    showtiming: true,
    log_level: 'ERROR',
  },
  network_topology_parameters: {
    supernetwork_parameters: {
      title_string: 'Ngen',
      network_type: 'HYFeaturesNetwork',
      geo_file_path: $._hf,
      synthetic_wb_segments: null,
      columns: {
        key: 'id',
        downstream: 'toid',
        dx: 'Length_m',  // was `length_m` < HF 2.2
        n: 'n',
        ncc: 'nCC',
        s0: 'So',
        bw: 'BtmWdth',
        waterbody: 'WaterbodyID', // was `rl_NHDWaterbodyComID` < HF 2.2
        gages: 'gage', // was `rl_gages` < HF 2.2
        tw: 'TopWdth',
        twcc: 'TopWdthCC',
        musk: 'MusK',
        musx: 'MusX',
        cs: 'ChSlp',
        alt: 'alt',
      },
    },
    waterbody_parameters: {
      break_network_at_waterbodies: false,
      level_pool: {
        level_pool_waterbody_parameter_file_path: $._hf,
      },
    },
  },
  compute_parameters: {
    parallel_compute_method: 'by-subnetwork-jit-clustered',
    compute_kernel: 'V02-structured',
    assume_short_ts: true,
    subnetwork_target_size: 10000,
    cpu_pool: 1,
    restart_parameters: {
      start_datetime: $.start_time,
    },
    forcing_parameters: {
      qts_subdivisions: 12,
      dt: 300,
      qlat_input_folder: './',
      qlat_file_pattern_filter: 'nex-*',
      binary_nexus_file_folder: './',
      nts: $.nts,
      max_loop_size: 288,
    },
    data_assimilation_parameters: {
      streamflow_da: {
        streamflow_nudging: false,
        diffusive_streamflow_nudging: false,
      },
      reservoir_da: {
        reservoir_persistence_da: {
          reservoir_persistence_usgs: false,
          reservoir_persistence_usace: false,
        },
        reservoir_rfc_da: {
          reservoir_rfc_forecasts: false,
        },
      },
    },
  },
  output_parameters: {
    stream_output: {
      stream_output_directory: './',
      stream_output_time: 10000000,
      stream_output_type: '.nc',
      stream_output_internal_frequency: 60,
    },
  },
};


{
  Routing(hf, start_time, end_time)::
    // @param hf string path to hydrofabric
    // @param start_time string simulation start time as naive UTC time in ISO Format (e.g. '2020-01-01 00:00')
    // @param end_time string exclusive simulation end time as naive UTC time in ISO Format (e.g. '2020-01-01 00:00')
    routing_base + $.with_hf(hf) + $.with_time(start_time, end_time),

  routing:: routing_base,

  with_hf(hf)::
    // replace the hydrofabric path used in a Routing configuration.
    // example:
    // local routing = include 'routing.libsonnet'
    // local config = Routing("bad_hf.gpkg", "2020-01-01 00:00",  "2025-01-01 00:00");
    // config + with_hf('good_hf.gpkg')
    //
    // @param hf string path to hydrofabric
    $.with_hf_dir(pathlib.dirname(hf)) +
    $.with_hf_basename(pathlib.basename(hf)),

  with_hf_dir(dir):: {
    // change the _directory_ of the hydrofabric path used in a Routing configuration.
    // example:
    // local routing = include 'routing.libsonnet'
    // local config = Routing('hf.gpkg', '2020-01-01 00:00',  '2025-01-01 00:00');
    // config + with_hf_dir('/home/user')
    //
    // @param dir string directory containing hydrofabric
    hf_dirname:: dir,
  },

  with_hf_basename(basename):: {
    // change the _basename_ of the hydrofabric path used in a Routing configuration.
    // example:
    // local routing = include 'routing.libsonnet'
    // local config = Routing('/home/user/hf.gpkg', '2020-01-01 00:00',  '2025-01-01 00:00');
    // config + with_hf_basename('other_hf.gpkg')
    //
    // @param basename string hydrofabric filename
    hf_basename:: basename,
  },

  with_time(start_time, end_time, timestep=300):: {
    // change the start time and nts in a Routing configuration.
    // @param start_time string simulation start time as naive UTC time in ISO Format (e.g. '2020-01-01 00:00')
    // @param end_time string exclusive simulation end time as naive UTC time in ISO Format (e.g. '2020-01-01 00:00')
    local sim_nts = $.nts(start_time, end_time, timestep=timestep),
    start_time:: start_time,
    nts:: sim_nts,
  },

  with_nts(nts):: {
    // @param nts int number of simulation time steps
    nts:: nts,
  },

  nts(start_time, end_time, timestep=300)::
    // @param start_time string simulation start time as naive UTC time in ISO Format (e.g. '2020-01-01 00:00')
    // @param end_time string exclusive simulation end time as naive UTC time in ISO Format (e.g. '2020-01-01 00:00')
    // @return int number of time steps in interval
    local sim_seconds = datetime.timestamp(datetime.parseDatetime(end_time)) - datetime.timestamp(datetime.parseDatetime(start_time));
    assert sim_seconds > 0;
    routing_nts(sim_seconds, timestep=timestep),
}
