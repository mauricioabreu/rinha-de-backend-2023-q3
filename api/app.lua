local lapis = require("lapis")
local console = require("lapis.console")
local db = require("lapis.db")
local Model = require("lapis.db.model").Model
local json_params = require("lapis.application").json_params
local types = require("lapis.validate.types")
local custom_types = require("validators.types")
local split = require("pl.utils").split
local uuid = require("uuid")

local app = lapis.Application()

local People = Model:extend("pessoas", {
  constraints = {
    apelido = function(self, value)
      if self:check_unique_constraint("apelido", value) then
        return value .. " already exists"
      end
    end
  }
})

local function repr_person(person)
  person.term_search = nil
  person.stack = split(person.stack, ",")
  return person
end

local person_params = types.params_shape({
  { "apelido",    types.limited_text(32) },
  { "nome",       types.limited_text(100) },
  { "nascimento", custom_types.is_valid_date },
  { "stack",      types.one_of({ types.userdata, types.array_of(types.limited_text(32)) }) }
})

local search_params = types.params_shape({
  { "t", types.limited_text(1024, 1) }
})

app:post("/pessoas", json_params(function(self)
  local params, err = person_params:transform(self.params)
  if err ~= nil then
    if self.params.apelido == nil or self.params.nome == nil then
      return { json = { errors = err }, status = 422 }
    end

    return { json = { errors = err }, status = 400 }
  end

  if type(params.stack) == "userdata" then
    params.stack = {}
  end

  local person, err = People:create({
    id = uuid(),
    apelido = params.apelido,
    nome = params.nome,
    nascimento = params.nascimento,
    stack = table.concat(params.stack, ",")
  })

  if err ~= nil then
    return { json = { errors = err }, status = 422 }
  end

  return {
    layout = false,
    status = 201,
    headers = {
      ["Location"] = "/pessoas/" .. person.id
    }
  }
end))

app:get("/pessoas/:id", function(self)
  local person = People:find(self.params.id)
  if not person then
    return { status = 404, layout = false }
  end
  return { json = repr_person(person) }
end)

app:get("/pessoas", function(self)
  local params, err = search_params:transform(self.params)
  if err ~= nil then
    return { json = { errors = err }, status = 400 }
  end

  local result = db.query(
    "SELECT id, apelido, nome, nascimento, stack FROM pessoas WHERE term_search LIKE ? LIMIT 50",
    "%" .. params.t .. "%"
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
