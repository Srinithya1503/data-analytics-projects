-- ============================================================
-- BioGraph-Core Sample Data
-- Source: Simulated extraction from apoptosis pathway literature
-- Focus: p53 tumor suppressor signaling cascade
-- ============================================================

-- ============================================================
-- Insert Entities (Proteins and Genes)
-- ============================================================

INSERT INTO entities (symbol, full_name, entity_type, description, uniprot_id) VALUES
('TP53', 'Tumor Protein P53', 'protein', 'Acts as a tumor suppressor in many tumor types; induces growth arrest or apoptosis depending on the physiological circumstances and cell type. Involved in cell cycle regulation as a trans-activator that acts to negatively regulate cell division by controlling a set of genes required for this process.', 'P04637'),

('MDM2', 'Mouse Double Minute 2 Homolog', 'protein', 'E3 ubiquitin-protein ligase that mediates ubiquitination of p53/TP53, leading to its degradation by the proteasome. Inhibits p53/TP53- and p73/TP73-mediated cell cycle arrest and apoptosis by binding its transcriptional activation domain.', 'Q00987'),

('BAX', 'BCL2 Associated X Protein', 'protein', 'Accelerates programmed cell death by binding to and antagonizing the apoptosis repressor BCL2 or its adenovirus homolog E1B 19 kDa protein. Under stress conditions, undergoes a conformation change that causes translocation to the mitochondrion membrane, leading to the release of cytochrome c.', 'Q07812'),

('PUMA', 'P53 Upregulated Modulator of Apoptosis', 'protein', 'Essential mediator of p53/TP53-dependent and p53/TP53-independent apoptosis. Functions by promoting the translocation of BAX to mitochondria and activation of BAX oligomerization. Blocks the anti-apoptotic action of BCL2.', 'Q9BXH1'),

('CDKN1A', 'Cyclin Dependent Kinase Inhibitor 1A (p21)', 'protein', 'Inhibits the activity of cyclin-CDK2, CDK1, and CDK4/6 complexes, thereby functioning as a regulator of cell cycle progression at G1 and S phase. Mediates the p53/TP53-dependent cell cycle G1 phase arrest in response to DNA damage.', 'P38936'),

('BCL2', 'B-Cell CLL/Lymphoma 2', 'protein', 'Suppresses apoptosis in a variety of cell systems by blocking the mitochondrial release of cytochrome c. Acts as a negative regulator of BAX and BAK-mediated apoptosis. Forms heterodimers with pro-apoptotic proteins such as BAX and BAK.', 'P10415'),

('APAF1', 'Apoptotic Peptidase Activating Factor 1', 'protein', 'Oligomeric Apaf-1 mediates the cytochrome c-dependent autocatalytic activation of pro-caspase-9 (Apaf-3), leading to the activation of caspase-3 and apoptosis. Essential component of the apoptosome.', 'O14727'),

('CASP9', 'Caspase 9', 'protein', 'Initiator caspase involved in the activation cascade of caspases responsible for apoptosis execution. Cleaved by granzyme B and caspase-8, activated in the apoptosome by cytochrome c and APAF1.', 'P55211'),

('CASP3', 'Caspase 3', 'protein', 'Executioner caspase that cleaves and activates other caspases, leading to cellular disassembly. Cleaves various structural proteins, DNA repair enzymes, and cell cycle regulators. Key effector in apoptotic cell death.', 'P42574'),

('CYTC', 'Cytochrome C', 'protein', 'Electron carrier protein that transfers electrons from complex III to complex IV in the mitochondrial respiratory chain. When released into the cytosol, acts as a cofactor for APAF1 in the apoptosome complex to activate caspase-9.', 'P99999'),

('ATM', 'ATM Serine/Threonine Kinase', 'protein', 'Serine/threonine protein kinase that activates checkpoint signaling upon DNA damage. Phosphorylates and activates p53/TP53 in response to DNA double-strand breaks. Central player in the cellular response to DNA damage.', 'Q13315'),

('TNF', 'Tumor Necrosis Factor', 'protein', 'Cytokine that binds to TNFRSF1A and TNFRSF1B. Mainly produced by macrophages and can induce cell death via apoptosis or necroptosis. Also induces inflammation and immune responses. Regulates cell proliferation, differentiation, and survival.', 'P01375');

-- ============================================================
-- Insert Interactions (Directed Edges)
-- ============================================================

INSERT INTO interactions (source_entity_id, target_entity_id, interaction_type, confidence_score, evidence_code, pubmed_id) VALUES
-- DNA damage pathway
((SELECT entity_id FROM entities WHERE symbol = 'ATM'), 
 (SELECT entity_id FROM entities WHERE symbol = 'TP53'), 
 'phosphorylates', 0.95, 'Western Blot', '10673501'),

-- p53 core regulatory loop
((SELECT entity_id FROM entities WHERE symbol = 'TP53'), 
 (SELECT entity_id FROM entities WHERE symbol = 'MDM2'), 
 'activates', 0.92, 'ChIP-Seq', '9006895'),

((SELECT entity_id FROM entities WHERE symbol = 'MDM2'), 
 (SELECT entity_id FROM entities WHERE symbol = 'TP53'), 
 'inhibits', 0.98, 'Co-IP', '8875929'),

-- p53 transcriptional targets
((SELECT entity_id FROM entities WHERE symbol = 'TP53'), 
 (SELECT entity_id FROM entities WHERE symbol = 'BAX'), 
 'activates', 0.94, 'Luciferase Assay', '8493579'),

((SELECT entity_id FROM entities WHERE symbol = 'TP53'), 
 (SELECT entity_id FROM entities WHERE symbol = 'PUMA'), 
 'activates', 0.91, 'RT-qPCR', '11463391'),

((SELECT entity_id FROM entities WHERE symbol = 'TP53'), 
 (SELECT entity_id FROM entities WHERE symbol = 'CDKN1A'), 
 'activates', 0.96, 'ChIP-Seq', '8242752'),

-- Mitochondrial apoptosis cascade
((SELECT entity_id FROM entities WHERE symbol = 'BAX'), 
 (SELECT entity_id FROM entities WHERE symbol = 'CYTC'), 
 'activates', 0.89, 'Immunofluorescence', '9393857'),

((SELECT entity_id FROM entities WHERE symbol = 'PUMA'), 
 (SELECT entity_id FROM entities WHERE symbol = 'BAX'), 
 'activates', 0.87, 'FRET', '15077116'),

((SELECT entity_id FROM entities WHERE symbol = 'BCL2'), 
 (SELECT entity_id FROM entities WHERE symbol = 'BAX'), 
 'inhibits', 0.93, 'Co-IP', '8479518'),

-- Apoptosome formation
((SELECT entity_id FROM entities WHERE symbol = 'CYTC'), 
 (SELECT entity_id FROM entities WHERE symbol = 'APAF1'), 
 'binds_to', 0.97, 'X-ray Crystallography', '9734351'),

((SELECT entity_id FROM entities WHERE symbol = 'APAF1'), 
 (SELECT entity_id FROM entities WHERE symbol = 'CASP9'), 
 'activates', 0.95, 'Caspase Activity Assay', '9006996'),

-- Caspase cascade
((SELECT entity_id FROM entities WHERE symbol = 'CASP9'), 
 (SELECT entity_id FROM entities WHERE symbol = 'CASP3'), 
 'activates', 0.96, 'Western Blot', '9736630'),

-- External apoptosis trigger
((SELECT entity_id FROM entities WHERE symbol = 'TNF'), 
 (SELECT entity_id FROM entities WHERE symbol = 'TP53'), 
 'activates', 0.78, 'Flow Cytometry', '8479177'),

-- Pro-survival antagonism
((SELECT entity_id FROM entities WHERE symbol = 'BCL2'), 
 (SELECT entity_id FROM entities WHERE symbol = 'APAF1'), 
 'inhibits', 0.84, 'Co-IP', '10446119'),

-- Feedback regulation
((SELECT entity_id FROM entities WHERE symbol = 'CASP3'), 
 (SELECT entity_id FROM entities WHERE symbol = 'MDM2'), 
 'activates', 0.72, 'Protease Assay', '10497213');

-- ============================================================
-- Data Verification Queries
-- ============================================================

-- Check entity count
-- Expected: 12 entities
SELECT COUNT(*) AS total_entities FROM entities;

-- Check interaction count
-- Expected: 15 interactions
SELECT COUNT(*) AS total_interactions FROM interactions;

-- Preview sample pathway
-- Show all direct targets of p53
SELECT 
    e1.symbol AS source,
    e2.symbol AS target,
    i.interaction_type,
    i.confidence_score
FROM interactions i
JOIN entities e1 ON i.source_entity_id = e1.entity_id
JOIN entities e2 ON i.target_entity_id = e2.entity_id
WHERE e1.symbol = 'TP53'
ORDER BY i.confidence_score DESC;
