local model = {
  Model(
    eval_params,  // see: EvalParam()
    eval_feature=null,
    binary='ngen',
    realization='realization.json',
    hydrofabric='hydrofabric.gpkg',
    routing_output='troute_output_201609010000.nc',
    strategy='uniform',
    params={},
    plugins=[],
    plugin_settings={},
    val_params=null,
  ):: {
    type: 'ngen',
    binary: binary,
    realization: realization,
    hydrofabric: hydrofabric,
    routing_output: routing_output,
    strategy: strategy,
    params: params,
    plugins: plugins,
    plugin_settings: plugin_settings,
    eval_params: eval_params,
    [if eval_feature == null then null else 'eval_feature']: eval_feature,
    [if val_params == null then null else 'val_params']: val_params,
  },
  with_opt(
    binary=null,
    realization=null,
    hydrofabric=null,
    eval_feature=null,
    routing_output=null,
    strategy=null,
    params=null,
    plugins=null,
    plugin_settings=null,
    eval_params=null,
    val_params=null,
  )::
    std.prune(
      {
        binary: binary,
        realization: realization,
        hydrofabric: hydrofabric,
        eval_feature: eval_feature,
        routing_output: routing_output,
        strategy: strategy,
        params: params,
        plugins: plugins,
        plugin_settings: plugin_settings,
        eval_params: eval_params,
        val_params: val_params,
      }
    ),
  update_opt(
    params=null,
    plugins=null,
    plugin_settings=null,
    eval_params=null,
    val_params=null,
  )::
    std.prune({
      params+: params,
      plugins+: plugins,
      plugin_settings+: plugin_settings,
      eval_params+: eval_params,
      val_params+: val_params,
    }),
  EvalParam(eval_start, eval_stop, objective='kling_gupta', target='min'):: {
    // @param eval_start string in naive UTC time in ISO Format (e.g. '2020-01-01 00:00')
    // @param eval_stop  string in naive UTC time in ISO Format (e.g. '2020-01-01 00:00')
    // @param objective  string "kling_gupta", "nnse", "custom", "single_peak", "volume"
    // @param target     string "min" "max"
    objective: objective,
    evaluation_start: eval_start,
    evaluation_stop: eval_stop,
    target: target,
  },
  ValParam(eval_start, eval_stop, objective='kling_gupta', sim_start=null, sim_stop=null, target='min'):: {
    // @param eval_start string in naive UTC time in ISO Format (e.g. '2020-01-01 00:00')
    // @param eval_stop  string in naive UTC time in ISO Format (e.g. '2020-01-01 00:00')
    // @param objective  string "kling_gupta", "nnse", "custom", "single_peak", "volume"
    // @param sim_start  optional string in naive UTC time in ISO Format (e.g. '2020-01-01 00:00')
    // @param sim_stop   optional string in naive UTC time in ISO Format (e.g. '2020-01-01 00:00')
    // @param objective  string "kling_gupta", "nnse", "custom", "single_peak", "volume"
    // @param target     string "min" "max"
    evaluation_start: eval_start,
    evaluation_stop: eval_stop,
    [if sim_start == null then null else 'sim_start']: sim_start,
    [if sim_stop == null then null else 'sim_stop']: sim_stop,
    // choices are "kling_gupta", "nnse", "custom", "single_peak", "volume"
    objective: objective,
    target: target,
  },
};


local general = {
  General(start_iteration=0, iterations=100, seed=42):: {
    strategy: {
      // Type of strategy, currently supported is estimation
      type: 'estimation',
      // defaults to dds (currently, the only supported algorithm)
      algorithm: 'dds',
    },
    log: true,
    start_iteration: start_iteration,
    // The total number of search iterations to run
    iterations: iterations,
    random_seed: seed,
    workdir: '.',
  },
  with_opt(start_iteration=null, iterations=null, seed=null)::
    std.prune(
      {
        start_iteration: start_iteration,
        iterations: iterations,
        seed: seed,
      }
    ),
};


{
  Config(model, general=general.General()):: {
    general: general,
    model: model,
  },
  model:: model,
  general:: general,
}
