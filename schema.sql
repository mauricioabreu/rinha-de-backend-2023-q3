CREATE EXTENSION IF NOT EXISTS pg_trgm;

DROP TABLE IF EXISTS pessoas;

CREATE TABLE IF NOT EXISTS pessoas (
    id VARCHAR(36),
    apelido VARCHAR(32) CONSTRAINT apelido_pk PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    nascimento DATE NOT NULL,
    stack VARCHAR(1024),
    term_search VARCHAR(1158) GENERATED ALWAYS AS (LOWER(nome) || ' ' || LOWER(apelido) || ' ' || LOWER(stack)) STORED
);

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_term_search ON PESSOAS USING GIN (term_search gin_trgm_ops);
