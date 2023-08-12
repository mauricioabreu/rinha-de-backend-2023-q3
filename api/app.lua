local lapis = require("lapis")
local json_params = require("lapis.application").json_params

local app = lapis.Application()

app:post("/", json_params(function(self)
  return self.params
end))

return app
