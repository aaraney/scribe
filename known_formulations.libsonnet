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

local cfe3 = r.bmi_c
             + r.bmi_variant('CFE',
                             'discharge_m',
                             'libcfebmi',
                             registration_function='register_bmi_cfe');
local cfe3_s = cfe3 + r.with_init_config('CFE3_S_{{id}}.cf3');
local cfe3_x = cfe3 + r.with_init_config('CFE3_X_{{id}}.cf3');

local sacsma = r.bmi_fortran
               + r.bmi_variant('SacSMA',
                               'tci',
                               'libsacbmi',
                               init_config_file_pattern='SacSma_{{id}}.namelist');

local snow17 = r.bmi_fortran
               + r.bmi_variant('Snow17',
                               'raim',
                               'libsnow17bmi',
                               init_config_file_pattern='Snow17_{{id}}.namelist');

local casam = r.bmi_cpp
              + r.bmi_variant('LGAR',
                              'total_discharge',
                              'liblasambmi',
                              init_config_file_pattern='Casam_{{id}}.ini');

local pet = r.bmi_c + r.bmi_variant('PET',
                                    'water_potential_evaporation_flux',
                                    'libpetbmi',
                                    init_config_file_pattern='PET_{{id}}.ini',
                                    registration_function='register_bmi_pet',);

local sloth_nom_cfe(cfe_variant) =
  local sloth_model_params = {
    'sloth_ice_fraction_schaake(1,double,m,node)': 0.0,
    'sloth_ice_fraction_xinanjiang(1,double,1,node)': 0.0,
    'sloth_smp(1,double,1,node)': 0.0,
  };
  local sloth_mod = sloth + r.with_model_params(sloth_model_params);
  local noahowp_vnm = {
    PRCPNONC: 'atmosphere_water__liquid_equivalent_precipitation_rate',
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
    PRCPNONC: 'atmosphere_water__liquid_equivalent_precipitation_rate',
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

local noahowp_cfe3(cfe3_variant) =
  local noahowp_vnm = {
    PRCPNONC: 'atmosphere_water__liquid_equivalent_precipitation_rate',
    Q2: 'atmosphere_air_water~vapor__relative_saturation',
    SFCTMP: 'land_surface_air__temperature',
    UU: 'land_surface_wind__x_component_of_velocity',
    VV: 'land_surface_wind__y_component_of_velocity',
    LWDN: 'land_surface_radiation~incoming~longwave__energy_flux',
    SOLDN: 'land_surface_radiation~incoming~shortwave__energy_flux',
    SFCPRS: 'land_surface_air__pressure',
  };
  local noahowp_mod = noahowp + r.with_variables_names_map(noahowp_vnm);
  local cfe3_vnm = {
    et_potential_m: 'EVAPOTRANS',
    rainfall_depth_m: 'QINSUR',
  };
  local cfe3_mod = cfe3_variant + r.with_variables_names_map(cfe3_vnm);
  local modules = [noahowp_mod, cfe3_mod];
  r.MultiBmi(modules=modules, main_output_variable='discharge_m', model_type_name='NoahOWP_CFE3');

local pet_snow17_sacsma =
  local snow17_vnm = {
    precip: 'atmosphere_water__liquid_equivalent_precipitation_rate',
    tair: 'land_surface_air__temperature',
  };
  local snow17_mod = snow17 + r.with_variables_names_map(snow17_vnm);

  local sacsma_vnm = {
    pet: 'water_potential_evaporation_flux',
    precip: 'raim',
    tair: 'land_surface_air__temperature',
  };
  local sacsma_mod = sacsma + r.with_variables_names_map(sacsma_vnm);

  local modules = [pet, snow17_mod, sacsma_mod];
  r.MultiBmi(modules=modules, main_output_variable='tci', model_type_name='PET_Snow17_Sacsma');

local sloth_pet_casam =
  // use constant for casam's 'soil_temperature_profile' from sloth
  local sloth_model_params = {
    'soil_temperature_profile(1,double,K,node)': 275.15,
  };
  local sloth_mod = sloth + r.with_model_params(sloth_model_params);

  local casam_vnm = {
    precipitation_rate: 'atmosphere_water__rainfall_volume_flux',  // csdms: APCP_surface
    potential_evapotranspiration_rate: 'water_potential_evaporation_flux',  // PET
  };
  local casam_mod = casam + r.with_variables_names_map(casam_vnm);

  local modules = [sloth_mod, pet, casam_mod];
  r.MultiBmi(modules=modules, main_output_variable='total_discharge', model_type_name='Sloth_Pet_Casam');

local sloth_nom_casam =
  local sloth_model_params = {
    'soil_temperature_profile(1,double,K,node)': 275.15,
  };
  local sloth_mod = sloth + r.with_model_params(sloth_model_params);

  local noahowp_vnm = {
    PRCPNONC: 'atmosphere_water__liquid_equivalent_precipitation_rate',
    Q2: 'atmosphere_air_water~vapor__relative_saturation',
    SFCTMP: 'land_surface_air__temperature',
    UU: 'land_surface_wind__x_component_of_velocity',
    VV: 'land_surface_wind__y_component_of_velocity',
    LWDN: 'land_surface_radiation~incoming~longwave__energy_flux',
    SOLDN: 'land_surface_radiation~incoming~shortwave__energy_flux',
    SFCPRS: 'land_surface_air__pressure',
  };
  local noahowp_mod = noahowp + r.with_variables_names_map(noahowp_vnm);

  local casam_vnm = {
    precipitation_rate: 'QINSUR',
    potential_evapotranspiration_rate: 'EVAPOTRANS',
  };
  local casam_mod = casam + r.with_variables_names_map(casam_vnm);

  local modules = [sloth_mod, noahowp_mod, casam_mod];
  r.MultiBmi(modules=modules, main_output_variable='total_discharge', model_type_name='Sloth_NoahOWP_Casam');

{
  noahowp:: noahowp,
  topmodel:: topmodel,
  sloth:: sloth,
  cfe:: cfe,
  cfe_s:: cfe_s,
  cfe_x:: cfe_x,
  cfe3:: cfe3,
  cfe3_s:: cfe3_s,
  cfe3_x:: cfe3_x,

  // multi-bmi canned formulations
  // NOTE: aaraney is there a better separator than '_' to distinguish a
  // specific model variant (e.g. 'cfe_s'). maybe camel case?
  sloth_noahowp_cfe_s:: sloth_nom_cfe(cfe_s),
  sloth_noahowp_cfe_x:: sloth_nom_cfe(cfe_x),
  noahowp_cfe3_s:: noahowp_cfe3(cfe3_s),
  noahowp_cfe3_x:: noahowp_cfe3(cfe3_x),
  noahowp_topmodel:: noahowp_topmodel,
  pet_snow17_sacsma:: pet_snow17_sacsma,
  sloth_pet_casam:: sloth_pet_casam,
  sloth_noahowp_casam:: sloth_nom_casam,
  sacsma:: sacsma,
  snow17:: snow17,
  casam:: casam,
  pet:: pet,
}
