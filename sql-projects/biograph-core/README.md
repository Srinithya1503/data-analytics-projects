# BioGraph-Core

**A PostgreSQL-based molecular interaction database simulating a real bioinformatics workflow**

---

## What This Project Does

BioGraph-Core models how a bioinformatician would extract protein interaction data from literature (like PubMed abstracts) and structure it into a queryable relational database. The star feature is a **Recursive CTE** that traces entire signaling cascades—essential for pathway analysis in cancer research, drug discovery, and systems biology.

---

## Tech Stack

- **PostgreSQL 12+** (with GIN indexing for full-text search)
- **pgAdmin 4** (database management UI)
- **VS Code** (script editing)

---

## Setup Instructions (Step-by-Step)

### Step 1: Create the Database in pgAdmin4

1. Open **pgAdmin 4** and connect to your PostgreSQL server
2. Right-click on **Databases** → Select **Create** → **Database**
3. Name it: `biograph_core`
4. Click **Save**

### Step 2: Run the Schema Script

1. In pgAdmin, right-click on `biograph_core` → Select **Query Tool**
2. Open **VS Code** and navigate to `sql/01_schema.sql`
3. Copy the entire script
4. Paste it into the pgAdmin Query Tool
5. Click the **Execute** button (⚡ icon or F5)
6. You should see: `CREATE TABLE` messages in the output panel

**What just happened?**  
You created two tables (`entities` and `interactions`) with proper constraints and a specialized GIN index for fast text searching on biological descriptions.

### Step 3: Load Sample Data

1. In the same Query Tool, clear the previous query
2. Open `sql/02_seed_data.sql` in VS Code
3. Copy and paste into pgAdmin
4. Execute (F5)
5. Verify: Run `SELECT COUNT(*) FROM entities;` — you should see 12 rows

### Step 4: Run the Pathway Analysis Query

1. Open `sql/03_analysis_queries.sql` in VS Code
2. Copy the **Recursive CTE Query** (the big one at the top)
3. Paste and execute in pgAdmin
4. You'll see a hierarchical cascade showing how p53 signal propagates through the network

---

## Understanding the Key SQL Concepts

### 1. GIN Index (Generalized Inverted Index)

```sql
CREATE INDEX idx_entity_description_gin ON entities USING GIN (to_tsvector('english', description));
```

**What it does:**  
Imagine you have 10,000 protein descriptions and need to find all mentions of "apoptosis pathway transcription". A regular index would be slow. GIN indexes split text into tokens and create a reverse lookup table—like the index at the back of a textbook. This makes full-text searches **10-100x faster**.

**Real-world use:**  
When mining literature databases (PubMed has 30M+ articles), you need this for substring matching and keyword queries.

---

### 2. WITH RECURSIVE (Recursive Common Table Expression)

```sql
WITH RECURSIVE pathway_cascade AS (
  -- Base case: Starting molecule
  SELECT ...
  UNION ALL
  -- Recursive case: Find next level
  SELECT ... FROM pathway_cascade JOIN interactions ...
)
```

**What it does:**  
Think of it like a chain reaction:
- **Base case**: You start with p53 (depth = 0)
- **Recursive step**: PostgreSQL automatically re-runs the query to find what p53 affects (depth = 1), then what *those* molecules affect (depth = 2), and so on
- **Termination**: Stops when no new rows are found

**Why it matters:**  
In signaling pathways, a mutation in one protein can cascade through 5-10 downstream targets. Recursive CTEs let you trace the entire network in a single query instead of writing nested loops in Python.

---

### 3. JOIN with Direction Awareness

```sql
INNER JOIN interactions i 
  ON (pc.entity_id = i.source_entity_id AND i.interaction_type IN ('activates', 'inhibits'))
```

**Biological context:**  
Molecular interactions have direction:
- p53 **activates** BAX (forward arrow)
- MDM2 **inhibits** p53 (feedback loop)

The query respects this by only following edges where the current entity is the **source**, not the target.

---

## Execution Checklist

- [ ] Database `biograph_core` created in pgAdmin
- [ ] Schema script executed (2 tables created)
- [ ] Seed data loaded (12 entities, 15 interactions)
- [ ] Recursive CTE query executed successfully
- [ ] Output shows pathway depth levels 0 → 1 → 2 → 3

---

## Next Steps (Post-Interview Enhancements)

If you have extra time or want to expand this:

1. **Add a `literature_sources` table** with PubMed IDs to show data provenance
2. **Implement ENUM types** for interaction types instead of VARCHAR
3. **Write a Python script** that parses a real abstract using BioPython and auto-generates INSERT statements
4. **Add graph visualization** using a tool like GraphViz or export to Cytoscape

---

## Common Troubleshooting

**Error: "relation does not exist"**  
→ Make sure you executed `01_schema.sql` first and selected the correct database (`biograph_core`)

**Recursive query returns 0 rows**  
→ Check that your starting entity exists. Try: `SELECT * FROM entities WHERE symbol = 'TP53';`

**GIN index not working**  
→ Verify PostgreSQL version is 12+. Run: `SELECT version();`

---

## Files Overview

| File | Purpose |
|------|---------|
| `sql/01_schema.sql` | Table definitions + indexes |
| `sql/02_seed_data.sql` | Sample molecular interaction data |
| `sql/03_analysis_queries.sql` | Recursive pathway tracing + search demos |
| `data/source_abstract.txt` | Fictional abstract showing data origin |

--- 
**Author:** Built as a portfolio demonstration project  
**Contact:** [gmail](venkatsri1503@gmail.com)
