CREATE EXTENSION IF NOT EXISTS pg_trgm;

CREATE TABLE IF NOT EXISTS pessoas (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    apelido VARCHAR(32) UNIQUE NOT NULL,
    nome VARCHAR(100) NOT NULL,
    nascimento DATE NOT NULL,
    stack VARCHAR(1024),
    term_search VARCHAR(1158) GENERATED ALWAYS AS (LOWER(nome) || ' ' || LOWER(apelido) || ' ' || LOWER(stack)) STORED
);

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_term_search ON PESSOAS USING GIN (term_search gin_trgm_ops);
