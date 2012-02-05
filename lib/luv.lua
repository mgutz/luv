local tasks = {}

local lapp = require("../support/lapp")
local fs = require("fs")
local path = require("path")
local os = require("os")
local table = require("table")
local string = require("string")
local util = require("./util")

--[[
A build task object.

name - The name of the task.
description - The description with optional options encoded in `lapp` style.
action - The action to take.
--]]
function Task(name, description, action)
  local self = {
    name = name,
    description = description,
    action = action,
    invoked = false
  }

  if #util.split(description, "\n") > 1 then
    self.hasOptions = true
  end

  return self
end


_G.task = function(name, description, ...)
  local arg = {n=select('#',...),...}
  local dependencies = nil
  local action

  if #arg == 1 then
    action = arg[1]
  elseif #arg == 2 then
    dependencies = arg[1]
    action = arg[2]
  end

  local t = Task(name, description, action)
  t.dependencies = dependencies
  tasks[name] = t
  return t
end


_G.invoke = function(name)
  local t = tasks[name]
  if not t.invoked then
    if t.hasOptions then
      t.args = lapp(process.argv, t.description)
    end

    if t.dependencies then
      for k, v in ipairs(t.dependencies) do
        invoke(v)
      end
    end

    t.action(t)
    t.invoked = true
  end
end


function detectLuvdir(dir)
  if fs.existsSync(path.join(dir, "Luvfile.lua")) then return dir end
  parent = path.normalize(path.join(dir, '..'))
  if parent ~= dir then
    return detectLuvDir(parent)
  else
    return nil
  end
end


function usage()
  print("usage: luv TASK [task_options]")
  print("\nTasks:")
  for task,_ in util.sortedPairs(tasks) do
    local firstLine = util.split(tasks[task].description, "\n")[1]
    print(string.format("%-12s  %s", task, firstLine))
  end
end


function run()
  local argv = process.argv
  local cwd = process.cwd()
  local dir = detectLuvdir(cwd)

  if not dir then
    print("`Luvfile.lua` file not found in "..cwd)
  elseif #argv > 0 then
    require(dir.."/Luvfile")
    invoke(argv[1])
  else
    --fs.chdir("dir")
    require(dir.."/Luvfile")
    usage()
  end
end

return {run = run}
