{
  basename(filename)::
    // given a path, return the filename
    // @param filename string
    // @return string
    local split = std.splitLimitR(filename, '/', 1);
    if std.length(split) == 1 then split[0] else split[1],

  dirname(filename)::
    // given a path, return the directory name
    // @param filename string
    // @return string
    local split = std.splitLimitR(filename, '/', 1);
    if std.length(split) == 1 then '' else split[0],

  joinPath(a, b)::
    // join two paths
    // @param a string
    // @param b string
    // @return string
    std.rstripChars(a, '/') + '/' + std.lstripChars(b, '/'),
}
