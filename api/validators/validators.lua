local M = {}

local function is_valid_date_format(date_str)
  return date_str:match("^(%d%d%d%d)-(%d%d)-(%d%d)$")
end

local function validate_data(year, month, day)
  year, month, day = tonumber(year), tonumber(month), tonumber(day)

  if month < 1 or month > 12 then return false end
  if day < 1 or day > 31 then return false end

  local days_in_month = {
    31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31
  }

  if month == 2 and ((year % 4 == 0 and year % 100 ~= 0) or year % 400 == 0) then
    days_in_month[2] = 29
  end

  return day <= days_in_month[month]
end

function M.is_valid_date(date)
  local year, month, day = is_valid_date_format(date)
  if year and month and day then
    return validate_data(year, month, day)
  end
  return false
end

return M
