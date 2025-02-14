local cfe_s = {
  CFE: [
    {
      init: 4.0499999999999998,
      max: 21.940000000000001,
      min: 0,
      name: 'b',
    },
    {
      init: 3.3799999999999998e-06,
      max: 0.00072599999999999997,
      min: 0,
      name: 'satdk',
    },
    {
      init: 0.35499999999999998,
      max: 0.995,
      min: 0,
      name: 'satpsi',
    },
    {
      init: 0.01,
      max: 1,
      min: 0,
      name: 'slope',
    },
    {
      init: 0.439,
      max: 0.69999999999999996,
      min: 0.20554,
      name: 'maxsmc',
    },
    {
      init: 0.066000000000000003,
      max: 0.13800000000000001,
      min: 0,
      name: 'wltsmc',
    },
    {
      init: 0.016,
      max: 0.25,
      min: 0.01,
      name: 'max_gw_storage',
    },
    {
      init: 2.4530847540782534e-06,
      max: 3.9424395070986912e-06,
      min: 1.6266115088728495e-06,
      name: 'Cgw',
    },
    {
      init: 6,
      max: 8,
      min: 1,
      name: 'expon',
    },
    {
      init: 0.33000000000000002,
      max: 1,
      min: 0.10000000000000001,
      name: 'alpha_fc',
    },
    {
      init: 0.029999999999999999,
      max: 1,
      min: 0,
      name: 'Kn',
    },
    {
      init: 0.01,
      max: 1,
      min: 0,
      name: 'Klf',
    },
    {
      init: 0.002,
      max: 0.0050000000000000001,
      min: 0.001,
      name: 'Kinf_nash_surface',
    },
    {
      init: 0.001,
      max: 0.02,
      min: 0,
      name: 'retention_depth_nash_surface',
    },
    {
      init: 3,
      max: 4,
      min: 0.10000000000000001,
      name: 'refkdt',
    },
  ],
};
local cfe_x = {
  CFE: [
    {
      init: 4.0499999999999998,
      max: 21.940000000000001,
      min: 0,
      name: 'b',
    },
    {
      init: 3.3799999999999998e-06,
      max: 0.00072599999999999997,
      min: 0,
      name: 'satdk',
    },
    {
      init: 0.35499999999999998,
      max: 0.995,
      min: 0,
      name: 'satpsi',
    },
    {
      init: 0.01,
      max: 1,
      min: 0,
      name: 'slope',
    },
    {
      init: 0.439,
      max: 0.69999999999999996,
      min: 0.20554,
      name: 'maxsmc',
    },
    {
      init: 0.066000000000000003,
      max: 0.13800000000000001,
      min: 0,
      name: 'wltsmc',
    },
    {
      init: 0.016,
      max: 0.25,
      min: 0.01,
      name: 'max_gw_storage',
    },
    {
      init: 2.4530847540782534e-06,
      max: 3.9424395070986912e-06,
      min: 1.6266115088728495e-06,
      name: 'Cgw',
    },
    {
      init: 6,
      max: 8,
      min: 1,
      name: 'expon',
    },
    {
      init: 0.33000000000000002,
      max: 1,
      min: 0.10000000000000001,
      name: 'alpha_fc',
    },
    {
      init: 0.029999999999999999,
      max: 1,
      min: 0,
      name: 'Kn',
    },
    {
      init: 0.01,
      max: 1,
      min: 0,
      name: 'Klf',
    },
    {
      init: 0.002,
      max: 0.0050000000000000001,
      min: 0.001,
      name: 'Kinf_nash_surface',
    },
    {
      init: 0.001,
      max: 0.02,
      min: 0,
      name: 'retention_depth_nash_surface',
    },
    {
      init: 0.001,
      max: 0.017000000000000001,
      min: 0.001,
      name: 'a_Xinanjiang_inflection_point_parameter',
    },
    {
      init: 0.5,
      max: 1,
      min: 0,
      name: 'b_Xinanjiang_shape_parameter',
    },
    {
      init: 3,
      max: 6.04,
      min: 0,
      name: 'x_Xinanjiang_shape_parameter',
    },
  ],
};
local noahowp = {
  NoahOWP: [
    {
      init: 2.5,
      max: 4,
      min: 1,
      name: 'MFSNO',
    },
    {
      init: 1,
      max: 1,
      min: 0.69999999999999996,
      name: 'SCAMAX',
    },
    {
      init: 50,
      max: 100,
      min: 0.10000000000000001,
      name: 'RSURF_SNOW',
    },
    {
      init: 1,
      max: 5,
      min: 0.17999999999999999,
      name: 'CWP',
    },
    {
      init: 50,
      max: 80,
      min: 0,
      name: 'VCMX25',
    },
    {
      init: 9,
      max: 12.6,
      min: 3.6000000000000001,
      name: 'MP',
    },
  ],
};
local topmodel = {
  TOPMODEL: [
    {
      init: 0.032000000000000001,
      max: 0.20000000000000001,
      min: 0.001,
      name: 'szm',
    },
    {
      init: 0.002,
      max: 0.040000000000000001,
      min: 0.001,
      name: 'sr0',
    },
    {
      init: 0.050000000000000003,
      max: 1,
      min: 0.001,
      name: 'srmax',
    },
    {
      init: 50,
      max: 100,
      min: 0.001,
      name: 'td',
    },
    {
      init: 5,
      max: 8,
      min: -8,
      name: 't0',
    },
    {
      init: 3600,
      max: 4000,
      min: 100,
      name: 'chv',
    },
    {
      init: 1000,
      max: 4000,
      min: 10,
      name: 'rv',
    },
  ],
};

{
  cfe_s: cfe_s,
  cfe_x: cfe_x,
  noahowp: noahowp,
  topmodel: topmodel,
}
