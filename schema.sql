CREATE EXTENSION IF NOT EXISTS pg_trgm;

CREATE TABLE IF NOT EXISTS pessoas (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    apelido VARCHAR(32) UNIQUE NOT NULL,
    nome VARCHAR(100) NOT NULL,
    nascimento DATE NOT NULL,
    stack JSONB NULL
);

CREATE INDEX idx_gist_trgm_apelido ON pessoas USING GIST (apelido gist_trgm_ops);
CREATE INDEX idx_gist_trgm_nome ON pessoas USING GIST (nome gist_trgm_ops);
CREATE INDEX idx_gist_trgm_stack ON pessoas USING GIST ((stack::text) gist_trgm_ops);
