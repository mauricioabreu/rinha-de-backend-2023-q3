local config = require("lapis.config")

config({ "development", "production" }, {
  port = 80,
  server = "nginx",
  postgres = {
    host = "db",
    user = "rinhadebackend",
    password = "rinhadebackend",
    database = "rinhadebackend"
  }
})

config("development", {
  num_workers = "1",
  code_cache = "off",
  logging = {
    queries = true,
    requests = true,
  }
})

config("production", {
  num_workers = "4",
  code_cache = "on",
  logging = {
    queries = false,
    requests = false,
  }
})
