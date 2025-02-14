local r = import './formulation.libsonnet';


local noahowp = r.bmi_fortran
                + r.bmi_variant('NoahOWP',
                                'QINSUR',
                                'libsurfacebmi',
                                init_config_file_pattern='NoahOWP_{{id}}.namelist',);
local topmodel = r.bmi_c
                 + r.bmi_variant('TOPMODEL',
                                 'Qout',
                                 'libtopmodelbmi',
                                 init_config_file_pattern='Topmodel_{{id}}.dat',
                                 registration_function='register_bmi_topmodel',);

local sloth = r.bmi_cpp
              + r.bmi_variant('SLOTH',
                              'z',
                              'libslothmodel',
                              init_config_file_pattern='/dev/null');
local cfe = r.bmi_c
            + r.bmi_variant('CFE',
                            'Q_OUT',
                            'libcfebmi',
                            registration_function='register_bmi_cfe');
local cfe_s = cfe + r.with_init_config('CFE_NASH_S_{{id}}.ini');
local cfe_x = cfe + r.with_init_config('CFE_NASH_X_{{id}}.ini');

local sloth_nom_cfe(cfe_variant) =
  local sloth_model_params = {
    'sloth_ice_fraction_schaake(1,double,m,node)': 0.0,
    'sloth_ice_fraction_xinanjiang(1,double,1,node)': 0.0,
    'sloth_smp(1,double,1,node)': 0.0,
  };
  local sloth_mod = sloth + r.with_model_params(sloth_model_params);
  local noahowp_vnm = {
    PRCPNONC: 'APCP_surface',
    Q2: 'atmosphere_air_water~vapor__relative_saturation',
    SFCTMP: 'land_surface_air__temperature',
    UU: 'land_surface_wind__x_component_of_velocity',
    VV: 'land_surface_wind__y_component_of_velocity',
    LWDN: 'land_surface_radiation~incoming~longwave__energy_flux',
    SOLDN: 'land_surface_radiation~incoming~shortwave__energy_flux',
    SFCPRS: 'land_surface_air__pressure',
  };
  local noahowp_mod = noahowp + r.with_variables_names_map(noahowp_vnm);
  local cfe_vnm = {
    water_potential_evaporation_flux: 'EVAPOTRANS',
    atmosphere_water__liquid_equivalent_precipitation_rate: 'QINSUR',
    ice_fraction_schaake: 'sloth_ice_fraction_schaake',
    ice_fraction_xinanjiang: 'sloth_ice_fraction_xinanjiang',
    soil_moisture_profile: 'sloth_smp',
  };
  local cfe_mod = cfe_variant + r.with_variables_names_map(cfe_vnm);
  local modules = [sloth_mod, noahowp_mod, cfe_mod];
  r.MultiBmi(modules=modules, main_output_variable='Q_OUT', model_type_name='SLOTH_NoahOWP_CFE');

local noahowp_topmodel =
  local noahowp_vnm = {
    PRCPNONC: 'APCP_surface',
    Q2: 'atmosphere_air_water~vapor__relative_saturation',
    SFCTMP: 'land_surface_air__temperature',
    UU: 'land_surface_wind__x_component_of_velocity',
    VV: 'land_surface_wind__y_component_of_velocity',
    LWDN: 'land_surface_radiation~incoming~longwave__energy_flux',
    SOLDN: 'land_surface_radiation~incoming~shortwave__energy_flux',
    SFCPRS: 'land_surface_air__pressure',
  };
  local noahowp_mod = noahowp + r.with_variables_names_map(noahowp_vnm);

  local topmodel_vnm = {
    water_potential_evaporation_flux: 'EVAPOTRANS',
    atmosphere_water__liquid_equivalent_precipitation_rate: 'QINSUR',
  };

  local topmodel_mod = topmodel + r.with_variables_names_map(topmodel_vnm);
  local modules = [noahowp_mod, topmodel_mod];
  r.MultiBmi(modules=modules, main_output_variable='Qout', model_type_name='NoahOWP_TOPMODEL');

{
  noahowp:: noahowp,
  topmodel:: topmodel,
  sloth:: sloth,
  cfe:: cfe,
  cfe_s:: cfe_s,
  cfe_x:: cfe_x,

  // multi-bmi canned formulations
  // NOTE: aaraney is there a better separator than '_' to distinguish a
  // specific model variant (e.g. 'cfe_s'). maybe camel case?
  sloth_noahowp_cfe_s:: sloth_nom_cfe(cfe_s),
  sloth_noahowp_cfe_x:: sloth_nom_cfe(cfe_x),
  noahowp_topmodel:: noahowp_topmodel,
}
