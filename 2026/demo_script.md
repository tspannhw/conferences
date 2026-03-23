# Beyond the Prompt: Live Demo Script
## Enterprise AI with Snowflake Cortex

**Duration:** ~15 minutes
**Presenter:** Tim Spann

---

## Pre-Demo Setup (Before Presentation)

```bash
# Ensure Cortex Code is connected
cortex connections list
cortex connections set tspann1

# Verify semantic views are discoverable
cortex semantic-views discover

# Verify agents are available
cortex agents discover
```

---

## Demo 1: Cortex AI Functions (3 minutes)

### Talking Point:
> "Let's start with the foundation - AI functions embedded directly in SQL. No separate AI system, no data movement."

### Live Commands:

```sql
-- 1. Basic AI sentiment on flight data
SELECT 
    'Flight AA123 experiencing turbulence, passengers secure' as event_description,
    AI_SENTIMENT('Flight AA123 experiencing turbulence, passengers secure') as sentiment_score;
```

```sql
-- 2. AI classification of emergency squawk codes
SELECT 
    squawk_code,
    AI_CLASSIFY(
        'Squawk code ' || squawk_code || ' detected from aircraft',
        ['normal_operations', 'radio_failure_7600', 'hijack_7500', 'emergency_7700']
    ) as classification
FROM (
    SELECT '7700' as squawk_code
    UNION ALL SELECT '7600'
    UNION ALL SELECT '1200'
);
```

```sql
-- 3. Entity extraction from flight reports
SELECT AI_EXTRACT(
    'United Flight UA456 departing JFK at 14:30 bound for LAX reported engine issue. Captain John Smith declared emergency.',
    {'entities': ['flight_number', 'airports', 'times', 'people', 'issues']}
) as extracted_entities;
```

### Key Message:
> "AI is now a SQL operator - runs at scale, governed by your existing security policies."

---

## Demo 2: Semantic Views - Natural Language to SQL (4 minutes)

### Talking Point:
> "Raw tables don't speak business language. Semantic views bridge that gap."

### Live Commands:

```bash
# Show what semantic views exist
cortex semantic-views list --database DEMO --limit=5
```

```bash
# Describe the flight tracking semantic view
cortex semantic-views describe DEMO.DEMO.ADSB_FLIGHT_TRACKING
```

### Cortex Analyst Query:

```bash
# Natural language query against semantic view
cortex analyst query "What is the average altitude and speed of all flights?" \
  --view=DEMO.DEMO.ADSB_FLIGHT_TRACKING
```

```bash
# More complex query
cortex analyst query "How many distinct aircraft have we tracked?" \
  --view=DEMO.DEMO.ADSB_FLIGHT_TRACKING
```

```bash
# Financial domain  
cortex analyst query "What was the highest Bitcoin price recorded?" \
  --view=DEMO.DEMO.FINANCIAL
```

### Key Message:
> "The semantic view knows that 'altitude' means AVG_ALTITUDE metric, not the raw column. Business users don't need to know SQL."

---

## Demo 3: Cortex Agents - Multi-Tool Orchestration (5 minutes)

### Talking Point:
> "Agents go beyond single queries - they reason, select tools, and take action."

### Show Available Agents:

```bash
# Discover agents
cortex agents discover
```

```bash
# Describe the aviation weather agent
cortex agents describe DEMO.DEMO.AVIATION_WEATHER_AGENT
```

### Agent Interaction (via Cortex Code natural conversation):

**Demo Conversation Flow:**

1. Start with simple domain query:
```
"What's the current air quality status?"
```

2. Cross-domain query:
```
"Are there any flights operating in areas with poor air quality?"
```

3. Complex reasoning:
```
"Compare flight activity patterns with weather conditions"
```

### Key Message:
> "The agent selected the right tools, generated the queries, and synthesized results - no prompt engineering required."

---

## Demo 4: MCP Integration (3 minutes)

### Talking Point:
> "MCP connects any tool to your AI. Snowflake becomes the hub of enterprise intelligence."

### Show MCP Capabilities:

```bash
# Show how MCP servers can be added
cortex mcp list  # Show current MCP servers
```

### Glean Integration Demo (if connected):

```
"Search Glean for documentation about flight tracking systems"
```

### Key Message:
> "With MCP, your AI can search Slack, query Jira, read Google Drive - all while keeping Snowflake as the secure data foundation."

---

## Demo 5: Putting It All Together (2 minutes)

### Talking Point:
> "Let's combine everything into a real enterprise workflow."

### Unified Query:

```
"Give me a comprehensive analysis:
1. How many flights are we tracking right now?
2. What's the average altitude?
3. Are there any emergency squawk codes?
4. What's the current Bitcoin price for context?"
```

### Show the Result:
- Agent orchestrates multiple semantic views
- AI functions analyze the data
- Unified response with business context

---

## Closing Demo Points

### Summary Slide Talking Points:

1. **Cortex AI Functions** - AI as SQL operators
2. **Semantic Views** - Business meaning for AI
3. **Cortex Agents** - Reasoning + tools + action
4. **MCP Protocol** - Universal integration
5. **Cortex Code** - Developer experience

### Final Command (Optional):

```bash
# Show the power of discovery
cortex semantic-views search "financial" --account
cortex agents search "monitoring" --account
```

---

## Troubleshooting Quick Fixes

### If semantic view query fails:
```bash
# Verify the view exists
cortex semantic-views describe DEMO.DEMO.ADSB_FLIGHT_TRACKING
```

### If agent doesn't respond:
```bash
# Check agent status
cortex agents list --database DEMO
```

### If connection issues:
```bash
cortex connections list
cortex connections set tspann1
```

---

## Backup Demo Queries (If Primary Fails)

```sql
-- Direct SQL query to show data exists
SELECT COUNT(*) as flight_count,
       AVG(altitude_barometric) as avg_altitude
FROM DEMO.DEMO.ADSB;
```

```sql
-- Show semantic view in action via SQL
SELECT * FROM DEMO.DEMO.ADSB_FLIGHT_TRACKING LIMIT 10;
```
