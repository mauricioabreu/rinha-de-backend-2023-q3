local M = {}

local capture_errors_json = require("lapis.application").capture_errors_json

function M.custom_capture_errors_json(status, fn)
  return capture_errors_json({
    fn,
    on_error = function(self)
      return { status = status, json = { errors = self.errors } }
    end
  })
end

return M
