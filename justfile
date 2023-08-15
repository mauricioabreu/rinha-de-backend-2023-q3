# Run application DEV
drun:
    docker compose -f docker-compose-dev.yml up

# Reload server
reload:
    docker compose exec api lapis build

# Lint lua code
lualint:
    docker compose run --rm api luacheck .
