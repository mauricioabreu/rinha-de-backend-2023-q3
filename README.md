# Rinha de Backend - 2023 Q3

## O que é?

Essa é uma aplicação web HTTP criada para participar do [Rinha de Backend](https://github.com/zanfranceschi/rinha-de-backend-2023-q3)

## Stack

* [Lapis/OpenResty](https://leafo.net/lapis/) - lapis é um framework HTTP direcionado para Lua e Moonscript. Para esse projeto eu usei Lua, uma linguagem brasileira 🇧🇷
* [PostgreSQL](https://www.postgresql.org/) - banco de dados relacional
* [NGINX](https://www.nginx.com/) - servidor HTTP, proxy reverso e cache

## Como rodar?

Para rodar os comandos disponíveis, você precisa ter o [just](https://github.com/casey/just) instalado.

```bash
$ just -l

Available recipes:
    lualint # Lint lua code
    reload  # Reload server
    start   # Start application
    stop    # Stop application
```

Para rodar a aplicação, use `just start` e para parar a aplicação, use `just stop`.
