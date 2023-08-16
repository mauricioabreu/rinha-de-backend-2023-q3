local lapis = require("lapis")
local console = require("lapis.console")
local db = require("lapis.db")
local Model = require("lapis.db.model").Model
local json_params = require("lapis.application").json_params
local capture_errors_json = require("exception").custom_capture_errors_json
local with_params = require("lapis.validate").with_params
local types = require("lapis.validate.types")
local custom_types = require("validators.types")
local split = require("pl.utils").split

local app = lapis.Application()

local People = Model:extend("pessoas")

local function repr_person(person)
  person.term_search = nil
  person.stack = split(person.stack, ",")
  return person
end

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
    stack = table.concat(params.stack, ",")
  })

  return { layout = false, status = 201, headers = { "Location: /" .. person.id } }
end))))

app:get("/pessoas/:id", function(self)
  local person = People:find(self.params.id)
  if not person then
    return { status = 404, layout = false }
  end
  return { json = repr_person(person) }
end)

app:get("/pessoas", function(self)
  local term = self.params.t
  local result = db.query(
    "SELECT * FROM pessoas WHERE TO_TSQUERY('TERM_SEARCH', ?) @@ TERM_SEARCH LIMIT 50",
    term
  )

  local people = {}
  for _, person in ipairs(result) do
    table.insert(people, repr_person(person))
  end

  return { json = people }
end)

app:get("/contagem-pessoas", function()
  return tostring(People:count()), { layout = false, status = 200 }
end)

app:match("/console", console.make())

return app
