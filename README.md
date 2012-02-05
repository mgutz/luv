# Luv

Build utility like Rake for [luvit](http://luvit.io)

## Installation

No npm-like utility yet :(

    git clone https://github.com/mgutz/luv.git

    # cp the luv script to your path
    cp luv/bin/luv ~/bin


## Usage

Create a `Luvfile.lua` in your project's root directory.

```lua
local desc = ""

-- Specify task depencencies in 3rd argument.
task("build", "Builds the project.", {"clean"}, function()
  print("build your project here")
end).dependencies({"clean"})

-- All tasks must have `name`, `description` and `action`.
task("clean", "Cleans the project.", function()
  print("cleaning")
end)
```

See all tasks

    luv

Run a task

    luv build

Specify task options.

```lua
-- Encode tasks in the description and `lapp` style
local desc = [[
Creates distribution
  -a,--archive-name (string)  Archive name.
]]
task("dist", desc, {"build"}, function(self)
  print("Creating distribution "..self.args["archive-name"])
end)
```