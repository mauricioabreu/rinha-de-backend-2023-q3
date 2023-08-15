# Start application
start:
    docker compose up

# Stop application
stop:
    docker compose down

# Reload server
reload:
    docker compose exec api lapis build

# Lint lua code
lualint:
    docker compose run --rm api luacheck .
