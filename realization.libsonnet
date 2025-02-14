local realization_base = {
  local errors = import 'errors.libsonnet',
  formulation:: errors.must_override('formulation (formulation)'),
  forcing:: errors.must_override('forcing (forcing)'),
  global: {
    formulations: [$.formulation],
    forcing: $.forcing,
  },
  time: errors.must_override('time (time)'),
  routing: errors.must_override('routing (routing)'),
};

local pathlib = import 'pathlib.libsonnet';

{
  Realization(formulation=null, forcing=self.Forcing(''), time=self.Time('', ''), routing=self.Routing('')):: {
    global: {
      formulations: if formulation == null then [] else [formulation],
      forcing: forcing,
    },
    time: time,
    routing: routing,
  },

  with_formulation(formulation):: {
    global+: {
      formulations: [formulation],
    },
  },
  with_forcing(forcing):: {
    global+: {
      forcing: forcing,
    },
  },
  with_time(time):: {
    time: time,
  },
  with_routing(routing):: {
    routing: routing,
  },

  Time(start_time, end_time):: {
    start_time: start_time,
    end_time: end_time,
    output_interval: 3600,
  },

  Routing(filename):: {
    t_route_config_file_with_path: filename,
  },

  Forcing(filename, provider='NetCDF'):: {
    path: filename,
    provider: provider,
  },
}
