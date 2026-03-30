{
  objectReplace(obj, new)::
    // replace key-value pairs in `obj` using `new`.
    // keys in `new` not in `obj` will not be present in the output.
    // inheritance operators (e.g. `+:`) are respected.
    //
    // example:
    // local x = { a: { still: "here" }, b: { im: "gone" }, c: 3 };
    // local y = { a+: { merged: "in" }, b: "replaced", z: "not here" };
    // objectReplace(x, y)
    //
    // @param obj object
    // @param new object
    // @return object
    local dropMissing(acc, key) =
      if !std.objectHas(obj, key)
      then std.objectRemoveKey(acc, key)
      else acc;
    
    local subset = std.foldl(dropMissing, std.objectFields(new), new);
    obj + subset,
}
