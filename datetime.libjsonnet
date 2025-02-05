local daysInMonth = [
  // number of days in each month in a non-leap year.
  31,
  28,
  31,
  30,
  31,
  30,
  31,
  31,
  30,
  31,
  30,
  31,
];

{
  parseDatetime(dt)::
    // parse naive UTC time in ISO Format (e.g. '2020-01-01')
    // parse naive UTC time in ISO Format (e.g. '2020-01-01 00:00')
    // parse naive UTC time in ISO Format (e.g. '2020-01-01 00:00:00')
    // @param dt string
    // @return { year: int, month: int, day: int, hour: int, minute: int, second: int }
    assert std.length(dt) >= std.length('2020-01-01');
    assert std.length(dt) <= std.length('2020-01-01 00:00:00');
    local parse(start, len) =
      local sub = std.substr(dt, start, len);
      std.parseInt(sub);

    local maybeParse(start, len) =
      if std.length(dt) >= start + len then
        parse(start, len)
      else 0;

    local year = parse(0, 4);
    local month = parse(5, 2);
    local day = parse(8, 2);
    local hour = maybeParse(11, 2);
    local minute = maybeParse(14, 2);
    local second = maybeParse(17, 2);
    { year: year, month: month, day: day, hour: hour, minute: minute, second: second },

  timestamp(datetime_object)::
    // return seconds since unix epoch
    // @param datetime_object { year: int, month: int, day: int, hour: int, minute: int, second: int }
    // @return int
    local year = datetime_object.year;
    local month = datetime_object.month;
    local day = datetime_object.day;
    local hour = datetime_object.hour;
    local minute = datetime_object.minute;
    local second = datetime_object.second;

    // do not support prior to epoch
    assert year >= 1970;
    local secondsSinceEpoch = std.foldl(
      function(left, right)
        local daysInYear = if self.isLeap(right) then 366 else 365;
        left + (daysInYear * 24 * 60 * 60)
      ,
      // range is inclusive
      std.range(1970, year - 1),
      0
    );

    // days in months prior (slice is inclusive)
    local secondsElapsedInCurrentYear =
      local daysThisYear = std.sum(daysInMonth[:month - 1])
                           // days in current month (excluding current day)
                           + (day - 1)
                           // add a day if this is a leap year
                           + if self.isLeap(year) && month > 2 then 1 else 0;
      daysThisYear * 24 * 60 * 60;

    local secondsToday = (hour * 60 * 60) + (minute * 60) + second;
    local total_seconds = secondsSinceEpoch + secondsElapsedInCurrentYear + secondsToday;
    total_seconds,

  isLeap(year)::
    // return if year a leap year
    // @param year int
    // @return boolean
    (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0),
}
