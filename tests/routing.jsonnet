local routing = import '../routing.libjsonnet';

routing.Routing('/home/austinraney/hf.gpkg', '2020-01-01 00:00', '2020-01-02 00:00') + routing.with_hf_basename('other_hf.gpkg') + routing.with_hf_dir('/something/else')
