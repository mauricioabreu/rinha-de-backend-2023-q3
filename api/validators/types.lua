local M = {}

local custom_validators = require("validators.validators")
local types = require("lapis.validate.types")

M.is_valid_date = types.custom(function(val)
  if not custom_validators.is_valid_date(val) then
    return nil, "invalid date format"
  end
  return true
end)

return M
