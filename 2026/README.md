# NEXUS-7 // Beyond the Prompt: Enterprise AI

**NYC AI Meetup | March 2026 | Tim Spann**

A Blade Runner-themed demonstration of Snowflake's Enterprise AI capabilities.

## Quick Start

```bash
# Setup environment
./manage.sh setup

# Start the demo
./manage.sh start

# Open browser
open http://localhost:8509
```

## Architecture

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           NEXUS-7 ARCHITECTURE                              │
│                     "More Human Than Human" // 2026                         │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                              PRESENTATION LAYER                             │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                    Streamlit Dashboard (app.py)                      │   │
│  │  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐  │   │
│  │  │  NEXUS   │ │    AI    │ │ SEMANTIC │ │  MULTI-  │ │  ORACLE  │  │   │
│  │  │   CORE   │ │  CORTEX  │ │   GRID   │ │  VERSE   │ │          │  │   │
│  │  └──────────┘ └──────────┘ └──────────┘ └──────────┘ └──────────┘  │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
└───────────────────────────────────┬─────────────────────────────────────────┘
                                    │
                                    │ Key-Pair Auth (RSA)
                                    ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                           SNOWFLAKE DATA CLOUD                              │
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                        CORTEX AI FUNCTIONS                           │   │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐               │   │
│  │  │ AI_SENTIMENT │  │  AI_CLASSIFY │  │ AI_COMPLETE  │               │   │
│  │  │              │  │              │  │              │               │   │
│  │  │ Analyze text │  │ Categorize   │  │ LLM calls    │               │   │
│  │  │ sentiment    │  │ with labels  │  │ (Claude)     │               │   │
│  │  └──────────────┘  └──────────────┘  └──────────────┘               │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                          SEMANTIC VIEWS                              │   │
│  │  ┌───────────────────────────────────────────────────────────────┐  │   │
│  │  │              DEMO.DEMO.adsb_flight_tracking                   │  │   │
│  │  │                                                               │  │   │
│  │  │  Dimensions:                    Metrics:                      │  │   │
│  │  │  • flight_id                    • total_aircraft              │  │   │
│  │  │  • aircraft_type                • total_flights               │  │   │
│  │  │  • squawk_code                  • avg_altitude                │  │   │
│  │  │                                 • avg_ground_speed            │  │   │
│  │  └───────────────────────────────────────────────────────────────┘  │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                           DATA TABLES                                │   │
│  │  ┌─────────────────────────┐  ┌─────────────────────────────────┐   │   │
│  │  │      DEMO.DEMO.ADSB     │  │      DEMO.DEMO.FINANCIAL        │   │   │
│  │  │                         │  │                                 │   │   │
│  │  │  • PLANEID              │  │  • TIMESTAMP                    │   │   │
│  │  │  • FLIGHT               │  │  • CLOSE                        │   │   │
│  │  │  • ALTBARO              │  │  • VOLUME                       │   │   │
│  │  │  • GS (ground speed)    │  │                                 │   │   │
│  │  │  • SQUAWK               │  │                                 │   │   │
│  │  │  • SEEN_POS             │  │                                 │   │   │
│  │  └─────────────────────────┘  └─────────────────────────────────┘   │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                        CORTEX AGENTS (35+)                          │   │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐                  │   │
│  │  │   Agent 1   │  │   Agent 2   │  │   Agent N   │                  │   │
│  │  │  + Tools    │  │  + Tools    │  │  + Tools    │                  │   │
│  │  │  + Memory   │  │  + Memory   │  │  + Memory   │                  │   │
│  │  └─────────────┘  └─────────────┘  └─────────────┘                  │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────────────┘


┌─────────────────────────────────────────────────────────────────────────────┐
│                            DATA FLOW DIAGRAM                                │
└─────────────────────────────────────────────────────────────────────────────┘

  User Input          Streamlit            Snowflake              Result
      │                   │                    │                    │
      │   "Analyze        │                    │                    │
      │   sentiment"      │                    │                    │
      │──────────────────►│                    │                    │
      │                   │  AI_SENTIMENT()    │                    │
      │                   │───────────────────►│                    │
      │                   │                    │  Process in        │
      │                   │                    │  Snowflake         │
      │                   │    JSON Result     │◄───────────────────│
      │                   │◄───────────────────│                    │
      │   Display         │                    │                    │
      │◄──────────────────│                    │                    │
      │                   │                    │                    │


┌─────────────────────────────────────────────────────────────────────────────┐
│                         SEMANTIC VIEW WORKFLOW                              │
└─────────────────────────────────────────────────────────────────────────────┘

  Business Question         Semantic View              Raw SQL
        │                        │                        │
        │  "How many            │                        │
        │   aircraft?"          │                        │
        │───────────────────────►                        │
        │                        │  SELECT sv.total_     │
        │                        │  aircraft FROM        │
        │                        │  SEMANTIC_VIEW(...)   │
        │                        │───────────────────────►
        │                        │                        │
        │                        │      26 aircraft      │
        │                        │◄───────────────────────│
        │       26               │                        │
        │◄───────────────────────│                        │


┌─────────────────────────────────────────────────────────────────────────────┐
│                         AUTHENTICATION FLOW                                 │
└─────────────────────────────────────────────────────────────────────────────┘

  ┌─────────────────┐      ┌─────────────────┐      ┌─────────────────┐
  │                 │      │                 │      │                 │
  │  Private Key    │─────►│  DER Encoding   │─────►│   Snowflake     │
  │  (.p8 file)     │      │  (PKCS8)        │      │   JWT Auth      │
  │                 │      │                 │      │                 │
  └─────────────────┘      └─────────────────┘      └─────────────────┘
         │
         │ ~/.snowflake/keys/snowflake_private_key.p8
         │
         ▼
  ┌─────────────────────────────────────────────────────────────────┐
  │  cryptography.hazmat.primitives.serialization                   │
  │  load_pem_private_key() -> private_bytes(DER, PKCS8)           │
  └─────────────────────────────────────────────────────────────────┘
```

## Project Structure

```
beyondtheprompt/
├── app.py              # Streamlit dashboard (Blade Runner themed)
├── manage.sh           # Management script (start/stop/logs/status)
├── validate.py         # Full validation suite
├── pyproject.toml      # UV dependencies
├── demo_queries.sql    # Sample SQL queries for demo
├── presentation.md     # 30-minute slide deck
├── tests/
│   └── test_app.py     # Pytest test suite
├── .gitignore          # Git ignore patterns
└── README.md           # This file
```

## Management Commands

```bash
./manage.sh setup      # Initialize UV environment
./manage.sh start      # Start Streamlit on port 8509
./manage.sh stop       # Stop the application
./manage.sh restart    # Restart the application
./manage.sh status     # Check if running
./manage.sh logs       # View application logs
./manage.sh validate   # Run validation suite
./manage.sh test       # Run pytest tests
```

## Demo Features

### Tab 1: NEXUS CORE
- Live telemetry from ADS-B flight data
- Architecture overview

### Tab 2: AI CORTEX
- **AI_SENTIMENT**: Analyze text sentiment
- **AI_CLASSIFY**: Categorize aviation squawk codes
- **AI_COMPLETE**: LLM text generation (Claude)

### Tab 3: SEMANTIC GRID
- Query semantic views using business language
- Compare with raw SQL queries

### Tab 4: MULTI-VERSE
- Cross-domain data: Flights + Financial
- Live charts and visualizations

### Tab 5: ORACLE
- AI-powered insights from combined data

## Configuration

### Snowflake Connection
- Account: `SFSENORTHAMERICA-TSPANN-AWS1`
- User: `kafkaguy`
- Auth: Key-pair (RSA)
- Key: `~/.snowflake/keys/snowflake_private_key.p8`
- Warehouse: `INGEST`
- Database: `DEMO`
- Schema: `DEMO`

### Data Sources
- **DEMO.DEMO.ADSB**: Aircraft tracking data
- **DEMO.DEMO.FINANCIAL**: Cryptocurrency prices
- **DEMO.DEMO.adsb_flight_tracking**: Semantic view

## Testing

```bash
# Run all tests
./manage.sh test

# Run validation
./manage.sh validate

# Manual pytest
uv run pytest tests/ -v
```

## Requirements

- Python 3.11+
- UV package manager
- Snowflake account with Cortex AI enabled
- RSA private key for authentication

## Author

**Tim Spann** | @PaaSDev | NYC AI Meetup March 2026

---

*"More Human Than Human"* — Tyrell Corporation
