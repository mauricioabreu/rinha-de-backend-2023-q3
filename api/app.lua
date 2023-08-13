local lapis = require("lapis")
local console = require("lapis.console")
local Model = require("lapis.db.model").Model
local json_params = require("lapis.application").json_params
local capture_errors_json = require("lapis.application").capture_errors_json
local with_params = require("lapis.validate").with_params
local types = require("lapis.validate.types")
local custom_types = require("validators.types")

local app = lapis.Application()

local People = Model:extend("pessoas")

app:post("/", capture_errors_json(json_params(with_params({
  { "apelido",    types.limited_text(256) },
  { "nome",       types.limited_text(100) },
  { "nascimento", custom_types.is_valid_date },
  { "stack",      types.array_of(types.limited_text(32)) }
}, function(self, params)
  -- local person = People:create({
  --   apelido = self.params.apelido,
  --   nome = self.params.nome,
  --   nascimento = self.params.nascimento,
  --   stack = self.params.stack
  -- })
  print("foo")
end))))

app:match("/console", console.make())

app:get("/contagem-pessoas", function()
  return People:count()
end)

return app
