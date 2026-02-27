-- ============================================================
-- BioGraph-Core Schema
-- Purpose: Relational model for molecular interaction networks
-- Author: Systems Biology Database Project
-- ============================================================

-- Drop tables if they exist (for clean re-runs)
DROP TABLE IF EXISTS interactions CASCADE;
DROP TABLE IF EXISTS entities CASCADE;

-- ============================================================
-- Table: entities
-- Stores biological molecules (proteins, genes, small molecules)
-- ============================================================
CREATE TABLE entities (
    entity_id SERIAL PRIMARY KEY,
    symbol VARCHAR(50) NOT NULL UNIQUE,  -- Standard gene symbol (e.g., TP53, MDM2)
    full_name VARCHAR(200),               -- Human-readable name
    entity_type VARCHAR(50) NOT NULL,     -- protein, gene, small_molecule, etc.
    organism VARCHAR(100) DEFAULT 'Homo sapiens',
    description TEXT,                     -- Free-text biological function description
    uniprot_id VARCHAR(20),               -- External database cross-reference
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- Table: interactions
-- Stores directional relationships between entities
-- ============================================================
CREATE TABLE interactions (
    interaction_id SERIAL PRIMARY KEY,
    source_entity_id INTEGER NOT NULL REFERENCES entities(entity_id) ON DELETE CASCADE,
    target_entity_id INTEGER NOT NULL REFERENCES entities(entity_id) ON DELETE CASCADE,
    interaction_type VARCHAR(50) NOT NULL,  -- activates, inhibits, binds_to, phosphorylates
    confidence_score NUMERIC(3,2) CHECK (confidence_score >= 0 AND confidence_score <= 1),
    evidence_code VARCHAR(50),              -- Experimental method (e.g., Y2H, Co-IP)
    pubmed_id VARCHAR(20),                  -- Literature reference
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Prevent self-interactions
    CONSTRAINT no_self_interaction CHECK (source_entity_id != target_entity_id),
    
    -- Prevent duplicate edges
    CONSTRAINT unique_interaction UNIQUE (source_entity_id, target_entity_id, interaction_type)
);

-- ============================================================
-- Indexes for Performance
-- ============================================================

-- B-tree indexes for foreign key joins (automatic but explicit here for clarity)
CREATE INDEX idx_interactions_source ON interactions(source_entity_id);
CREATE INDEX idx_interactions_target ON interactions(target_entity_id);

-- Composite index for pathway queries (find all interactions of a given type from a source)
CREATE INDEX idx_interactions_source_type ON interactions(source_entity_id, interaction_type);

-- GIN index for full-text search on entity descriptions
-- This is the "elite" indexing technique for literature mining
CREATE INDEX idx_entity_description_gin ON entities 
USING GIN (to_tsvector('english', description));

-- ============================================================
-- Comments for Database Documentation
-- ============================================================
COMMENT ON TABLE entities IS 'Biological molecules extracted from literature and databases';
COMMENT ON TABLE interactions IS 'Directed edges representing molecular relationships';
COMMENT ON COLUMN interactions.confidence_score IS 'Numeric confidence [0-1] based on experimental evidence';
COMMENT ON INDEX idx_entity_description_gin IS 'Full-text search index for keyword queries on biological function';