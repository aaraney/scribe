local datetime = import '../datetime.libsonnet';

local cases = [
  {
    input: '2020-01-02 03:14:26',
    iso8601Datetime: self.input,
    timestamp: 1577934866,
  },
  {
    input: '2006-01-02 15:04:05',
    iso8601Datetime: self.input,
    timestamp: 1136214245,
  },
];

std.map(function(case)
          local dt = datetime.parseDatetime(case.input);
          std.all([
            std.assertEqual(datetime.iso8601Datetime(dt), case.iso8601Datetime),
            std.assertEqual(datetime.timestamp(dt), case.timestamp),
          ]),
        cases)
