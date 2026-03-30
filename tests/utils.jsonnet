local utils = import '../utils.libsonnet';

local x = { a: { still: 'here' }, b: { im: 'gone' }, c: 3 };
local y = { a+: { merged: 'in' }, b: 'replaced', z: 'not here' };
{
  old: x,
  new: utils.objectReplace(x, y),
}
