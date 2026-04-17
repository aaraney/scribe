// local known_formulations = import '../known_formulations.libsonnet';
local formulation = import '../formulation.libsonnet';

// formulation.
// exchange_variables_names_map
local vnm = {
  still: 'here',
  a: 'old_a',
  b: 'old_b',
  c: 'old_c',
};
local old_formulation = formulation.bmi_c
                        + formulation.bmi_variant(
                          'TestFormulation',
                          'some_output',
                          'libtestbmi'
                        )
                        + formulation.with_variables_names_map(vnm);

local new_vnm = {
  a: 'new_a',
  b: 'new_b',
  c: 'new_c',
};

local empty_formulation = formulation.bmi_c
                          + formulation.bmi_variant(
                            'TestFormulation',
                            'some_output',
                            'libtestbmi'
                          );

local new_formulation = formulation.exchange_variables_names_map(old_formulation, new_vnm);
local new_empty_formulation = formulation.exchange_variables_names_map(empty_formulation, new_vnm);
{
  old: old_formulation.params.variables_names_map,
  new: new_formulation.params.variables_names_map,
  still_empty: std.assertEqual(
    !std.objectHas(empty_formulation.params, 'variables_names_map'),
    !std.objectHas(new_empty_formulation.params, 'variables_names_map'),
  ),
}
