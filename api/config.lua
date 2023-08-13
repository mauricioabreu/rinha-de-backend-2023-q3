local config = require("lapis.config")

config("development", {
  server = "nginx",
  code_cache = "off",
  num_workers = "1",
  postgres = {
    host = "db",
    user = "rinhadebackend",
    password = "rinhadebackend",
    database = "rinhadebackend"
  },
  logging = {
    queries = true,
    requests = true,
  }
})
