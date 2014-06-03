local _ = require "lib/underscore/lib/underscore"
local Class = require "lib/hump/class"

local Loader = Class{
    init = function(self, engine)
       self.engine = engine
    end
}

function Loader:loadBoard(data)
    self.engine:clear()

    _.each(data.entities, function(entityData)
        self.engine.createEntity(entityData)
    end)
end
