local bmi_base = {
  local errors = import 'errors.libsonnet',
  name: errors.must_override('name'),
  library_dir:: '',
  library_name:: errors.must_override('::library_name'),
  // do not override
  _library_file:: if std.length(self.library_dir) > 0 then std.join('/', [self.library_dir, self.library_name]) else self.library_name,

  local outer = self,
  params: {
    name: errors.must_override('params.name'),
    model_type_name: errors.must_override('params.model_type_name'),
    library_file: $._library_file,
    forcing_file: '',
    init_config: '',
    allow_exceed_end_time: true,
    main_output_variable: errors.must_override('params.main_output_variable'),
  },
};

local bmi_type(lang) =
  local name = 'bmi_' + lang;
  bmi_base { name: name, params+: { name: name } };


local bmi_variant(model_type_name, main_output_variable, library_name, library_dir='', init_config_file_pattern='', registration_function='') = {
  library_name:: library_name,
  params+: {
    model_type_name: model_type_name,
    main_output_variable: main_output_variable,
    [if !std.isEmpty(init_config_file_pattern) then 'init_config']: init_config_file_pattern,
    [if !std.isEmpty(registration_function) then 'registration_function']: registration_function,
  },
};

local pathlib = import 'pathlib.libsonnet';

{
  bmi_fortran:: bmi_type('fortran'),
  bmi_c:: bmi_type('c'),
  bmi_cpp:: bmi_type('c++'),
  bmi_python:: bmi_type('python'),
  bmi_variant:: bmi_variant,

  MultiBmi(modules, main_output_variable, model_type_name=''):: {
    // convenience function for constructing a MultiBmi formulation from an
    // array of formulations. See `known_formulations.libsonnet` for examples.
    // @param modules array
    // @param main_output_variable string
    // @param model_type_name optional string
    // @return multi bmi formulation
    name: 'bmi_multi',
    params: {
      name: 'bmi_multi',
      model_type_name: model_type_name,
      forcing_file: '',
      init_config: '',
      allow_exceed_end_time: true,
      main_output_variable: main_output_variable,
      modules: modules,
    },
  },

  unwrap(multi)::
    // return the formulations in a MultiBmi as an array
    // @param multi
    // @return []
    multi.params.modules,

  multi_bmi_map(func, formulation)::
    // apply a function over the formulations in a MultiBmi formulation
    //
    // example:
    // local f = import 'formulation.libsonnet';
    // local known_formulations = import 'known_formulations.libsonnet';
    // multi_bmi_map(
    //   function(mod)
    //     mod + f.with_library_dir('/dmod/lib_dir')
    //   , known_formulations.noahowp_topmodel
    // )
    //
    // @param func function(bmi_formulation)
    // @return MultiBmi
    local mods = $.unwrap(formulation);
    local res = std.map(func, mods);

    formulation { params+: {
      modules: res,
    } },


  with_library_dir(library_dir):: {
    // replace a formulation's `library_name` _directory_
    //
    // example:
    // local f = import 'formulation.libsonnet';
    // local known_formulations = import 'known_formulations.libsonnet';
    // known_formulations.cfe_s + f.with_library_dir('/usr/lib')
    //
    library_dir:: library_dir,
  },

  with_variables_names_map(vnm):: {
    // replace `variables_names_map`
    // example:
    // local f = import 'formulation.libsonnet';
    // local known_formulations = import 'known_formulations.libsonnet';
    // known_formulations.cfe_s + f.with_variable_names_map({
    //    water_potential_evaporation_flux: 'EVAPOTRANS',
    // })
    //
    params+: {
      variables_names_map: vnm,
    },
  },

  extend_variables_names_map(vnm):: {
    //  like `with_variables_names_map` however existing mappings are persisted.
    params+: {
      variables_names_map+: vnm,
    },
  },

  with_model_params(model_params):: {
    // replace `model_params`
    params+: {
      model_params: model_params,
    },
  },

  extend_model_params(model_params):: {
    //  like `with_model_params` however existing `model_params` are persisted.
    params+: {
      model_params+: model_params,
    },
  },

  with_init_config(path):: {
    // replace `init_config`
    params+: {
      init_config: path,
    },
  },

  with_init_config_dir(init_config_dir):: {
    // replace `init_config` directory
    local init_config_name = pathlib.basename(super.params.init_config),
    params+: {
      init_config: pathlib.joinPath(init_config_dir, init_config_name),
    },
  },
}
