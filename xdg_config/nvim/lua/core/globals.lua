local ok, plenary_reload = pcall(require, "plenary.reload")
local reloader = ok and plenary_reload.reload_module or require

_G.RELOAD = function(...)
  return reloader(...)
end

_G.R = function(name)
  _G.RELOAD(name)
  return require(name)
end
