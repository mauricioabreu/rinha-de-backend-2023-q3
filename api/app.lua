local lapis = require("lapis")
local console = require("lapis.console")
local Model = require("lapis.db.model").Model
local json_params = require("lapis.application").json_params
local capture_errors_json = require("exception").custom_capture_errors_json
local with_params = require("lapis.validate").with_params
local types = require("lapis.validate.types")
local to_json = require("lapis.util").to_json
local custom_types = require("validators.types")

local app = lapis.Application()

local People = Model:extend("pessoas")

app:post("/pessoas", capture_errors_json(422, json_params(with_params({
  { "apelido",    types.limited_text(256) },
  { "nome",       types.limited_text(100) },
  { "nascimento", custom_types.is_valid_date },
  { "stack",      types.array_of(types.limited_text(32)) }
}, function(_, params)
  local person = People:create({
    apelido = params.apelido,
    nome = params.nome,
    nascimento = params.nascimento,
    stack = to_json(params.stack)
  })

  return { layout = false, status = 201, headers = { "Location: /" .. person.id } }
end))))

app:get("/pessoas/:id", function(self)
  local person = People:find(self.params.id)
  if not person then
    return { status = 404, layout = false }
  end
  return { json = person }
end)

app:match("/console", console.make())

app:get("/contagem-pessoas", function()
  return tostring(People:count()), { layout = false, status = 200 }
end)

return app
