# Start application
start:
    docker compose up

# Stop application
stop:
    docker compose down

# Reload server
reload:
    docker compose exec api1 lapis build
    docker compose exec api2 lapis build

# Lint lua code
lualint:
   docker run -v $(pwd):/app ghcr.io/lunarmodules/luacheck:latest /app

# Run load testing
loadtest:
    docker run --rm -i grafana/k6 run - <load-testing/script.js
