# Snowflake Cortex AI 
### March 24, 2026

---

## Architecture Overview

```
+===================================================================================+
|                         USER INTERFACES                                           |
|    Snowsight Workspaces (Cmd+K)          Cortex Code CLI (`cortex`)               |
+===================================================================================+
                                    |
                        Natural Language Questions
                                    v
+===================================================================================+
|                     CORTEX AGENTS (Orchestration Layer)                           |
|                                                                                   |
|    +------------------------+  +------------------------+  +--------------------+ |
|    |    CORTEX ANALYST      |  |    CORTEX SEARCH       |  |    CUSTOM TOOLS    | |
|    |    (text-to-sql)       |  |    (semantic search)   |  |    (funcs/procs)   | |
|    |                        |  |                        |  |                    | |
|    |  Structured data:      |  |  Unstructured data:    |  |  Any Snowflake     | |
|    |  "Total AUM?"          |  |  "What are 401k rules?"|  |  function you      | |
|    |  "Assets by state?"    |  |  "RMD requirements?"   |  |  define            | |
|    +----------+-------------+  +----------+-------------+  +--------------------+ |
+===================================================================================+
                |                           |
                v                           v
+===================================================================================+
|                       BUSINESS DEFINITION LAYER                                   |
|                                                                                   |
|  +--------------------------------------+  +----------------------------------+   |
|  |  SEMANTIC VIEWS                      |  |  SEARCH SERVICES                 |   |
|  |                                      |  |                                  |   |
|  |  TABLES / FACTS / DIMENSIONS         |  |  ON <column> / ATTRIBUTES        |   |
|  |                                      |  |  TARGET_LAG / WAREHOUSE          |   |
|  |  PLANS_SEMANTIC_VIEW                 |  |                                  |   |
|  |  ACTIVITY_SEMANTIC_VIEW              |  |  KB_SEARCH                       |   |
|  |  SUPPORT_SEMANTIC_VIEW               |  |  TICKET_SEARCH                   |   |
|  +--------------------------------------+  +----------------------------------+   |
+===================================================================================+
                |                           |
                v                           v
+===================================================================================+
|                          SNOWFLAKE DATA LAYER                                     |
|                                                                                   |
|  _RETIREMENT   _PARTICIPANT   SUPPORT   KNOWLEDGE                                 |
|  _PLANS (10)       _ACTIVITY (15)     _TICKETS (8)   _BASE (8)                    |
|                                                                                   |
|  + 225 existing tables, 35+ semantic views, 11 search services, 18 agents         |
+===================================================================================+
         |                                         |
         v                                         v
+------------------+                    +---------------------+
| CORTEX CODE CLI  |                    | SNOWFLAKE CLI       |
| (`cortex`)       |                    | (`snow cortex`)     |
| connections,     |                    | complete, sentiment,|
| search, analyst, |                    | summarize, translate|
| agents, mcp,     |                    | extract-answer,     |
| skill            |                    | search              |
+------------------+                    +---------------------+
```

> Full-size diagrams available in `assets/` directory:
> `architecture.txt`, `data_flow.txt`, `rag_pattern.txt`,
> `semantic_view_structure.txt`, `agent_specification.txt`, `cli_comparison.txt`

---

## Demo Data: Financial Services

| Table | Description | Rows |
|-------|-------------|------|
| `RETIREMENT_PLANS` | 401(k), 403(b), HSA, IRA, 457(b), Pension plans | 10 |
| `PARTICIPANT_ACTIVITY` | Contributions, withdrawals, rollovers, transfers | 15 |
| `SUPPORT_TICKETS` | Participant service requests and resolutions | 8 |
| `KNOWLEDGE_BASE` | Policy documents, FAQs, regulatory guides | 8 |

**Plus existing DEMO.DEMO data**: 2.7M NYC traffic records, air quality, MTA transit, 6M+ stock values, weather, and 35+ semantic views.

---

# Section 1: Cortex Analyst
## Natural Language to SQL

---

## What is Cortex Analyst?

- Translates **natural language questions** into **SQL queries**
- Uses **Semantic Views** to understand business context
- Returns **accurate, governed results** - not hallucinated data
- Available in **Snowsight**, **Cortex Code**, and via **SQL API**

**Key Insight**: The semantic model is what makes Analyst accurate. It defines what your data *means*, not just what columns exist.

---

## Demo: Cortex Analyst in Action

### Questions to Ask:

1. **"What is our total AUM across all active plans?"**
   -- Routes to `PLANS_SEMANTIC_VIEW`

2. **"Show me assets by plan type"**
   -- GROUP BY on PLAN_TYPE with aggregations

3. **"Which channels do participants prefer for transactions?"**
   -- Routes to `ACTIVITY_SEMANTIC_VIEW`

4. **"What are the recent contribution trends?"**
   -- Activity analysis by type and date

```sql
-- What Analyst generates:
SELECT PLAN_TYPE, SUM(TOTAL_ASSETS) AS TOTAL_ASSETS,
       SUM(PARTICIPANT_COUNT) AS TOTAL_PARTICIPANTS
FROM DEMO.DEMO.RETIREMENT_PLANS
WHERE PLAN_STATUS = 'Active'
GROUP BY PLAN_TYPE ORDER BY TOTAL_ASSETS DESC;
```

---

## Cortex Analyst via CLI

```bash
# Cortex Code CLI -- query via Cortex Analyst
cortex analyst query "total AUM by plan type" --view=DEMO.DEMO.PLANS_SEMANTIC_VIEW



---

# Section 2: Semantic Views
## The Foundation for AI-Powered Analytics

---

## What are Semantic Views?

Semantic Views define **business meaning** over physical tables using the
`TABLES`, `FACTS`, `DIMENSIONS`, and `COMMENT` syntax:

| Component | Purpose | Example |
|-----------|---------|---------|
| **TABLES** | Source table declarations | `DEMO.DEMO.RETIREMENT_PLANS` |
| **DIMENSIONS** | Categorical attributes | `plan_type`, `state`, `channel` |
| **FACTS** | Numeric measures | `total_assets`, `amount`, `satisfaction_score` |
| **COMMENT** | Business descriptions | Human-readable docs on each element |

---

## Creating a Semantic View

```sql
-- Correct Snowflake semantic view syntax:
CREATE OR REPLACE SEMANTIC VIEW DEMO.DEMO.PLANS_SEMANTIC_VIEW
  TABLES (
    DEMO.DEMO.VOYA_RETIREMENT_PLANS
      COMMENT='Voya retirement plan data including assets and participants'
  )
  FACTS (
    VOYA_RETIREMENT_PLANS.TOTAL_ASSETS AS TOTAL_ASSETS
      COMMENT='Total assets under management in USD',
    VOYA_RETIREMENT_PLANS.PARTICIPANT_COUNT AS PARTICIPANT_COUNT
      COMMENT='Number of active participants',
    VOYA_RETIREMENT_PLANS.AVG_BALANCE AS AVG_BALANCE
      COMMENT='Average participant balance in USD'
  )
  DIMENSIONS (
    VOYA_RETIREMENT_PLANS.PLAN_ID AS PLAN_ID
      COMMENT='Unique plan identifier',
    VOYA_RETIREMENT_PLANS.PLAN_NAME AS PLAN_NAME
      COMMENT='Full plan name',
    VOYA_RETIREMENT_PLANS.PLAN_TYPE AS PLAN_TYPE
      COMMENT='Type: 401K, 403B, HSA, IRA, 457B, PENSION',
    VOYA_RETIREMENT_PLANS.EMPLOYER_NAME AS EMPLOYER_NAME
      COMMENT='Sponsoring employer',
    VOYA_RETIREMENT_PLANS.PLAN_STATUS AS PLAN_STATUS
      COMMENT='Active or Inactive',
    VOYA_RETIREMENT_PLANS.STATE AS STATE
      COMMENT='US state',
    VOYA_RETIREMENT_PLANS.INCEPTION_DATE AS INCEPTION_DATE
      COMMENT='Plan start date'
  )
  COMMENT='Semantic model for Voya retirement plan analytics';
```

---

## Semantic Views in DEMO.DEMO

35 semantic views already available covering:

- **Transportation**: TRAFFIC, MTA, TRANSPORTATIONCOM, TRANSITRIDERSHIPNEWYORK
- **Environmental**: AIRQUALITY, SV_AQ, WEATHER
- **Financial**: FINANCIAL, FINANCIAL_TRADE_DATA, BROADRIDGE_CAPITAL_MARKETS
- **IoT/Sensors**: THERMAL_SENSOR_SEMANTIC_VIEW, SENSEHAT_ANALYTICS
- **Aviation**: AIR_ANALYTICS, SVADSBAIRCRAFT, ADSB_FLIGHT_TRACKING

---

# Section 3: Cortex Search
## Semantic Search over Unstructured Data

---

## What is Cortex Search?

- **Semantic search** over text data (not keyword matching)
- Automatic **embedding generation** and **indexing**
- Supports **attribute filtering** for targeted results
- Enables **RAG** (Retrieval Augmented Generation) patterns
- **Auto-refreshes** as source data changes

---

## Creating a Search Service

```sql
CREATE OR REPLACE CORTEX SEARCH SERVICE DEMO.DEMO.KB_SEARCH
  ON CONTENT
  ATTRIBUTES TITLE, CATEGORY, DOC_TYPE
  WAREHOUSE = INGEST
  TARGET_LAG = '1 hour'
AS (
    SELECT DOC_ID, TITLE, CONTENT, CATEGORY, DOC_TYPE
    FROM DEMO.DEMO.KNOWLEDGE_BASE
    WHERE CONTENT IS NOT NULL
);
```

---

## Searching via Snowflake CLI

```bash
# Search using `snow cortex search`

snow cortex search "i cannot login" --service TICKET_SEARCH --columns SEARCH_TEXT --limit 5 --connection tspann1 --database DEMO --schema DEMO

snow cortex search "required minimum distribution rules" --service KB_SEARCH --columns TITLE --columns CONTENT --limit 5 --connection tspann1 --database DEMO --schema DEMO



# Search with JSON output
snow cortex search "401k contribution limits" --service KB_SEARCH --columns TITLE --columns CONTENT --limit 5 --connection tspann1 --database DEMO --schema DEMO --format JSON

```

---

## RAG Pattern: Search + LLM

```sql
-- Step 1: Retrieve relevant context
WITH context AS (
    SELECT SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
        'DEMO.DEMO.KB_SEARCH',
        '{"query": "401k contribution limits 2026",
          "columns": ["TITLE","CONTENT"], "limit": 2}'
    ) AS results
)
-- Step 2: Generate answer using context
SELECT SNOWFLAKE.CORTEX.COMPLETE(
    'claude-3-5-sonnet',
    CONCAT('Answer using ONLY this context:\n',
           results, '\nQ: What are the 2026 limits?')
) AS answer FROM context;
```

---

## Existing Search Services

| Service | Data Source | Use Case |
|---------|-----------|----------|
| `TRAFFICIMAGESEARCH` | Traffic camera AI descriptions | Find traffic conditions |
| `AIRQUALITY_SRVC` | Air quality measurements | Environmental queries |
| `MTASEARCH` | MTA bus transit data | Transit stop searches |
| `NYC_ALERTS_SEARCH` | Transit/weather alerts | Service disruptions |
| `TRANSCOMS` | TRANSCOM events | Regional transportation |

---

# Section 4: Cortex Agents
## Intelligent Multi-Tool Orchestration

---

## What are Cortex Agents?

Agents **automatically route** questions to the right tool:

```
                              User Question
                                    |
                                    v
                    +-------------------------------+
                    |         CORTEX AGENT          |
                    |    (RETIREMENT_AGENT)         |
                    |                               |
                    |  instructions: define persona |
                    |  models: "auto" (LLM picks)   |
                    +------+--------+--------+------+
                           |        |        |
            +--------------+   +----+   +----+--------------+
            |                  |        |                    |
            v                  v        v                    |
  +------------------+ +------------------+ +------------------+
  | CORTEX ANALYST   | | CORTEX SEARCH    | | CUSTOM TOOLS     |
  | (text-to-sql)    | | (semantic search)| | (funcs/procs)    |
  |                  | |                  | |                  |
  | Structured data  | | Unstructured     | | Any Snowflake    |
  | via semantic     | | text via vector  | | function or      |
  | views --> SQL    | | embeddings       | | stored procedure |
  +------------------+ +------------------+ +------------------+
```

- **No routing code needed** - the LLM decides
- Combines **structured** and **unstructured** data
- Can use **multiple tools** per question
- Available in **SQL**, **Snowsight**, and **Cortex Code**

---

## Creating the Voya Agent

```sql
-- Correct agent creation syntax:
CREATE OR REPLACE AGENT DEMO.DEMO.RETIREMENT_AGENT
FROM SPECIFICATION $$
{
  "models": {"orchestration": "auto"},
  "instructions": {
    "orchestration": "You are a Financial Retirement Plan Assistant.",
    "response": "Be concise. Format monetary values with dollar signs."
  },
  "tools": [
    {"tool_spec": {"type": "cortex_analyst_text_to_sql",
                   "name": "voya_plans_analyst",
                   "description": "Query retirement plan data"}},
    {"tool_spec": {"type": "cortex_analyst_text_to_sql",
                   "name": "voya_activity_analyst",
                   "description": "Query participant transactions"}},
    {"tool_spec": {"type": "cortex_search",
                   "name": "voya_kb_search",
                   "description": "Search knowledge base"}}
  ],
  "tool_resources": {
    "voya_plans_analyst": {
      "semantic_view": "DEMO.DEMO.PLANS_SEMANTIC_VIEW"},
    "voya_activity_analyst": {
      "semantic_view": "DEMO.DEMO.ACTIVITY_SEMANTIC_VIEW"},
    "voya_kb_search": {
      "cortex_search_service": "DEMO.DEMO.KB_SEARCH"}
  }
}
$$;
```

---

## Agent Demo: Multi-Tool Queries

| Question | Tools Used |
|----------|-----------|
| "What is our total AUM?" | Analyst (Plans) |
| "What are 2026 401k limits?" | Search (KB) |
| "Which plans need attention and what are the rules?" | Analyst + Search |
| "Find similar resolved tickets for a login issue" | Search (Tickets) |
| "How many participants and what's the average CSAT?" | Analyst (Plans + Tickets) |

```sql
SELECT SNOWFLAKE.CORTEX.AGENT(
    'DEMO.DEMO.RETIREMENT_AGENT',
    'What is our total AUM and how many open tickets do we have?'
) AS response;
```

---

# Section 5: Cortex Code
## AI-Driven Development Assistant

---

## Two Tools, Two Purposes

### Cortex Code CLI (`cortex`) -- Interactive AI Assistant
```bash
# Install
curl -LsS https://ai.snowflake.com/static/cc-scripts/install.sh | sh

# Key commands
cortex connections list
cortex analyst query "total AUM" --view=DEMO.DEMO.PLANS_SEMANTIC_VIEW
cortex agents list
cortex agents describe DEMO.DEMO.RETIREMENT_AGENT
cortex search object "retirement"
cortex search docs "semantic view"
cortex mcp add snowflake_demo "snowflake://<tspann1>/DEMO/DEMO" -t http
```

### Snowflake CLI (`snow cortex`) -- Direct AI Function Calls
```bash
# Install
pip install snowflake-cli

# Key commands
snow cortex complete "Explain 401k limits" --model claude-3-5-sonnet
snow cortex sentiment "I love the new mobile app"
snow cortex summarize "The SECURE 2.0 Act introduced..."
snow cortex translate "Your contribution was processed" --to es
snow cortex extract-answer "What is the RMD age?" "RMDs begin at age 73..."
```

---

## Cortex Code in Snowsight

- Open **Projects > Workspaces**
- Click **Cortex Code** icon or press `Cmd+K` / `Ctrl+K`
- Ask questions in natural language
- Review generated SQL in the diff view
- Accept changes to apply to your worksheet

### Snowsight-Specific Features
- **Context Awareness**: Knows which file/notebook you're viewing
- **Change Review**: Visual diff before applying changes
- **SQL & Python**: Works in both SQL worksheets and notebooks
- **Admin Tasks**: Account administration and governance queries

---

## MCP Server Integration

```bash
# Add a Snowflake MCP server to Cortex Code CLI
cortex mcp add snowflake_demo \
  "snowflake://<tspann1>/DEMO/DEMO" -t http

# Verify
cortex mcp list
cortex mcp get snowflake_demo

# Enables within Cortex Code sessions:
# - Direct SQL execution (execute_snowflake_sql_query)
# - Cortex Search queries (cortex_search)
# - Cortex Analyst queries (cortex_analyst)
```

---

## Key Takeaways

1. **Cortex Analyst** turns natural language into governed SQL via semantic views
2. **Semantic Views** are the foundation -- define business meaning once, use everywhere
3. **Cortex Search** enables semantic search and RAG over unstructured data
4. **Cortex Agents** orchestrate multiple tools for complex, multi-domain questions
5. **Cortex Code** brings AI-assisted development to Snowsight and your terminal
6. **`snow cortex`** provides direct CLI access to sentiment, summarize, translate, and more

**All within Snowflake's governance boundary -- your data never leaves.**

---

## Resources

- [Cortex Code CLI](https://docs.snowflake.com/en/user-guide/cortex-code/cortex-code-cli)
- [Snowflake AI and ML](https://docs.snowflake.com/en/guides-overview-ai-features)
- [Getting Started with Cortex AI](https://www.snowflake.com/en/developers/guides/getting-started-with-snowflake-cortex-ai/)
- [Supply Chain Agent Guide](https://www.snowflake.com/en/developers/guides/snowflake-agentic-ai-in-supply-chain/)
- [Streamlit Agent Skills](https://www.snowflake.com/en/developers/guides/build-streamlit-apps-with-agent-skills/)
- Demo SQL: `DEMO.DEMO` schema on your Snowflake account
