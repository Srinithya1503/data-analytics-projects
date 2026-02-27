-- ============================================================
-- 0. Indexes for Performance and Scalability
-- ============================================================

CREATE INDEX IF NOT EXISTS idx_interactions_source
ON interactions(source_entity_id);

CREATE INDEX IF NOT EXISTS idx_interactions_target
ON interactions(target_entity_id);

CREATE INDEX IF NOT EXISTS idx_interactions_type
ON interactions(interaction_type);

CREATE INDEX IF NOT EXISTS idx_interactions_confidence
ON interactions(confidence_score);

CREATE INDEX IF NOT EXISTS idx_entities_description_fts
ON entities
USING GIN (to_tsvector('english', description));

-- ============================================================
-- 1. Recursive Pathway Traversal from TP53
-- ============================================================

WITH RECURSIVE pathway_cascade AS (
    -- Anchor node
    SELECT 
        e.entity_id,
        e.symbol,
        e.symbol::TEXT AS pathway,
        0 AS depth,
        ARRAY[e.entity_id] AS visited_ids
    FROM entities e
    WHERE e.symbol = 'TP53'

    UNION ALL

    -- Recursive traversal
    SELECT
        t.entity_id,
        t.symbol,
        pc.pathway || ' -[' || i.interaction_type || ']-> ' || t.symbol,
        pc.depth + 1,
        pc.visited_ids || t.entity_id
    FROM pathway_cascade pc
    JOIN interactions i
        ON pc.entity_id = i.source_entity_id
    JOIN entities t
        ON i.target_entity_id = t.entity_id
    WHERE pc.depth < 5
      AND NOT (t.entity_id = ANY(pc.visited_ids))
      AND i.interaction_type IN ('activates', 'inhibits', 'phosphorylates')
)
SELECT depth, symbol, pathway
FROM pathway_cascade
ORDER BY depth, symbol;

-- ============================================================
-- 2. Apoptosis-Related Entity Discovery
-- ============================================================

SELECT 
    symbol,
    full_name,
    ts_rank(
        to_tsvector('english', description),
        q
    ) AS relevance
FROM entities,
     to_tsquery('english', 'apoptosis | apoptotic') q
WHERE to_tsvector('english', description) @@ q
ORDER BY relevance DESC;

-- ============================================================
-- 3. Network Topology Metrics
-- ============================================================

SELECT
    e.symbol,
    COUNT(DISTINCT CASE
        WHEN i.source_entity_id = e.entity_id
        THEN i.target_entity_id
    END) AS out_degree,
    COUNT(DISTINCT CASE
        WHEN i.target_entity_id = e.entity_id
        THEN i.source_entity_id
    END) AS in_degree,
    COUNT(DISTINCT i.source_entity_id)
      + COUNT(DISTINCT i.target_entity_id) AS total_degree
FROM entities e
LEFT JOIN interactions i
  ON e.entity_id IN (i.source_entity_id, i.target_entity_id)
GROUP BY e.symbol
ORDER BY total_degree DESC;

-- ============================================================
-- 4. Interaction Type Distribution
-- ============================================================

SELECT 
    interaction_type,
    COUNT(*) AS count,
    ROUND(AVG(confidence_score), 3) AS avg_confidence,
    ROUND(STDDEV(confidence_score), 3) AS confidence_variance
FROM interactions
GROUP BY interaction_type
ORDER BY count DESC;

-- ============================================================
-- 5. Feedback Loop Detection
-- ============================================================

SELECT DISTINCT
    e1.symbol AS protein_a,
    e2.symbol AS protein_b,
    i1.interaction_type AS forward_interaction,
    i2.interaction_type AS reverse_interaction,
    ROUND(i1.confidence_score + i2.confidence_score, 3) AS total_confidence,
    CASE
        WHEN i1.interaction_type = i2.interaction_type
        THEN 'symmetric'
        ELSE 'regulatory'
    END AS loop_type
FROM interactions i1
JOIN interactions i2
  ON i1.source_entity_id = i2.target_entity_id
 AND i1.target_entity_id = i2.source_entity_id
JOIN entities e1 ON i1.source_entity_id = e1.entity_id
JOIN entities e2 ON i1.target_entity_id = e2.entity_id
WHERE i1.source_entity_id < i2.source_entity_id
ORDER BY total_confidence DESC;

-- ============================================================
-- 6. Confidence-Weighted Pathway Scoring
-- ============================================================

WITH RECURSIVE confidence_paths AS (
    -- Anchor
    SELECT 
        e.entity_id,
        e.symbol::TEXT AS pathway,
        0 AS depth,
        0.0::NUMERIC AS log_confidence,
        ARRAY[e.entity_id] AS visited_ids
    FROM entities e
    WHERE e.symbol = 'TP53'

    UNION ALL

    -- Recursive confidence propagation
    SELECT
        t.entity_id,
        cp.pathway || ' -[' || i.interaction_type || ']-> ' || t.symbol,
        cp.depth + 1,
        cp.log_confidence + LN(i.confidence_score),
        cp.visited_ids || t.entity_id
    FROM confidence_paths cp
    JOIN interactions i ON cp.entity_id = i.source_entity_id
    JOIN entities t ON i.target_entity_id = t.entity_id
    WHERE cp.depth < 5
      AND NOT (t.entity_id = ANY(cp.visited_ids))
)
SELECT
    pathway,
    depth,
    ROUND(EXP(log_confidence), 6) AS pathway_confidence
FROM confidence_paths
WHERE depth > 0
ORDER BY pathway_confidence DESC;

-- ============================================================
-- 7. Graph Export Query (pgAdmin 4 Compatible)
-- ============================================================

SELECT 
    e1.symbol AS source,
    e2.symbol AS target,
    i.interaction_type AS edge_type,
    i.confidence_score AS weight,
    'directed' AS graph_type
FROM interactions i
JOIN entities e1 ON i.source_entity_id = e1.entity_id
JOIN entities e2 ON i.target_entity_id = e2.entity_id;
