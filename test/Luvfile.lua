-- Depends on clean.
task("build", "Builds the project", {"clean"}, function()
  print("building")
end)

task("clean", "Cleans the project", function()
  print("cleaning")
end)

-- Tasks options are encoded in the description and parsed by lapp
local desc = [[
Creates distribution
  -a,--archive-name (string)  Archive name.
]]
task("dist", desc, {"build"}, function(self)
  print("Creating distribution "..self.args["archive-name"])
end)
