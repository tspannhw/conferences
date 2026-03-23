# Beyond the Prompt: Speaker Notes
## 30-Minute Presentation Guide

**Event:** NYC AI Meetup - Beyond the Prompt: Enterprise AI
**Time Slot:** 6:00 PM - 6:30 PM
**Speaker:** Tim Spann, Principal Field Engineer, Snowflake

---

## TIMING BREAKDOWN

| Section | Duration | Cumulative |
|---------|----------|------------|
| Intro + Problem | 3 min | 3 min |
| AI Data Cloud Vision | 3 min | 6 min |
| Cortex AI Functions | 5 min | 11 min |
| Semantic Views | 5 min | 16 min |
| Cortex Agents | 5 min | 21 min |
| MCP Integration | 3 min | 24 min |
| Putting It Together | 4 min | 28 min |
| Takeaways + Q&A Setup | 2 min | 30 min |

---

## SECTION 1: INTRO + PROBLEM (3 min)

### Key Messages:
- "Everyone has a chatbot. Few have enterprise AI."
- The gap between demo and production
- What enterprises actually need: governance, context, integration

### Transition:
> "Let me show you what Snowflake has built to solve this..."

---

## SECTION 2: AI DATA CLOUD VISION (3 min)

### Key Messages:
- One platform for data AND AI
- No data movement required
- Governance is built-in, not bolted-on

### Visual: Show the architecture diagram
- Data Cloud → Cortex AI → Applications
- Unified governance layer

### Transition:
> "Let's look at the four pillars that make this possible..."

---

## SECTION 3: CORTEX AI FUNCTIONS DEMO (5 min)

### Setup Talk:
> "AI becomes a SQL operator. Let me show you."

### LIVE DEMO:

1. **Sentiment Analysis** (1 min)
```sql
SELECT AI_SENTIMENT('Flight experiencing turbulence, passengers secure');
```
**Talk Point:** "One function call. No ML expertise needed."

2. **Classification** (2 min)
```sql
-- Run the squawk code classification query
```
**Talk Point:** "Zero-shot classification. No training data. No model management."

3. **Entity Extraction** (1 min)
```sql
-- Run the entity extraction on flight report
```
**Talk Point:** "Structured data from unstructured text, at SQL scale."

### Key Message:
> "This runs on YOUR data, with YOUR security policies, at warehouse scale."

### Transition:
> "But AI functions are just primitives. How do we teach AI your business language?"

---

## SECTION 4: SEMANTIC VIEWS DEMO (5 min)

### Problem Setup:
> "When you ask 'What's our revenue?', do you mean gross? Net? ARR? MRR? 
> LLMs don't know YOUR definitions."

### Concept Explanation (1 min):
- Semantic views define business meaning
- Synonyms map user language to data
- Metrics encode calculations

### LIVE DEMO:

1. **Discover Semantic Views** (1 min)
```bash
cortex semantic-views describe DEMO.DEMO.ADSB_FLIGHT_TRACKING
```
**Talk Point:** "Look at these metrics - avg_altitude, total_flights. Business definitions."

2. **Natural Language Query** (2 min)
```bash
cortex analyst query "What is the average altitude of tracked flights?" \
  --view=DEMO.DEMO.ADSB_FLIGHT_TRACKING
```
**Talk Point:** "Natural language in, accurate SQL out. The semantic view ensures correctness."

3. **Show Generated SQL** (1 min)
```sql
SELECT sv.avg_altitude FROM SEMANTIC_VIEW(...) AS sv;
```
**Talk Point:** "No hallucination possible - it's constrained to your defined metrics."

### Transition:
> "Semantic views teach AI your language. But how do we orchestrate complex workflows?"

---

## SECTION 5: CORTEX AGENTS DEMO (5 min)

### Concept Setup:
> "Agents go beyond single queries. They reason, select tools, and take action."

### LIVE DEMO:

1. **Discover Agents** (1 min)
```bash
cortex agents discover
cortex agents describe DEMO.DEMO.AVIATION_WEATHER_AGENT
```
**Talk Point:** "17 agents in this demo database. Each has specialized tools."

2. **Simple Query** (1 min)
> "What's the current flight activity?"

**Talk Point:** "The agent selected the flight tracking semantic view automatically."

3. **Cross-Domain Query** (2 min)
> "Are there any relationships between flight patterns and weather conditions?"

**Talk Point:** "Watch - it's selecting MULTIPLE tools, generating parallel queries."

4. **Show Reasoning** (1 min)
**Talk Point:** "The agent shows its work. You can audit every decision."

### Transition:
> "Now let's connect to the broader ecosystem..."

---

## SECTION 6: MCP INTEGRATION (3 min)

### Concept:
> "MCP is the Model Context Protocol - a universal standard for AI-to-tool communication."

### Show Current MCP Connections:
```bash
cortex mcp list
```

### Explain Integration:
- "This connects Claude, GPT, any LLM to Snowflake"
- "And Snowflake to external tools - Jira, Slack, Google Drive"
- "All with enterprise authentication"

### Demo (if Glean connected):
> "Search Glean for flight tracking documentation"

**Talk Point:** "Enterprise knowledge unified with enterprise data."

---

## SECTION 7: PUTTING IT TOGETHER (4 min)

### Show Streamlit App:
- Open http://localhost:8502
- Walk through tabs briefly
- Execute AI Functions demo
- Show semantic view query
- Generate AI insight

### Architecture Summary:
> "Data layer → Semantic layer → Agent layer → Application layer
> All governed, all audited, all secure."

---

## SECTION 8: TAKEAWAYS + HANDOFF (2 min)

### Five Key Points:
1. **Semantic Views** = AI that understands YOUR business
2. **Cortex Agents** = Reasoning + orchestration + action
3. **MCP Protocol** = Universal tool integration
4. **Cortex Code** = Developer-first experience
5. **Governance built-in** = Security you can trust

### Call to Action:
> "In the workshop that follows, you'll build this yourself. 
> The Vivanti team will guide you through creating your own enterprise AI."

### Resources:
- docs.snowflake.com/cortex
- quickstarts.snowflake.com
- My blog: datainmotion.dev

### Close:
> "Thank you. Let's build enterprise AI that works."

---

## BACKUP CONTENT (If Running Fast)

### Additional Demo: AI Complete
```sql
SELECT AI_COMPLETE('claude-3-5-sonnet', 
    'Summarize flight tracking: ' || total_aircraft::STRING || ' aircraft...')
```

### Show Governance:
```sql
-- All AI calls logged
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY 
WHERE QUERY_TEXT LIKE '%AI_SENTIMENT%' 
LIMIT 5;
```

---

## TROUBLESHOOTING

### If Semantic View Query Fails:
- Fall back to raw SQL with AI functions
- "Same concept, just showing the underlying mechanism"

### If Agent Doesn't Respond:
- Use Cortex Analyst directly
- "The agent would normally orchestrate this, but let me show the raw query"

### If Connection Issues:
```bash
cortex connections set tspann1
```

---

## FILES LOCATION

All demo materials in:
`/Users/tspann/Downloads/code/coco/beyondtheprompt/`

- `presentation.md` - Full slide deck
- `demo_script.md` - Step-by-step demo commands
- `demo_queries.sql` - SQL queries for demos
- `app.py` - Streamlit demo application

### To Start Streamlit:
```bash
cd /Users/tspann/Downloads/code/coco/beyondtheprompt
SNOWFLAKE_CONNECTION_NAME=tspann1 streamlit run app.py --server.port 8502
```
