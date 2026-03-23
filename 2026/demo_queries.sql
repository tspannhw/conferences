-- ============================================================
-- NEXUS-7 // BEYOND THE PROMPT: ENTERPRISE AI
-- DEMO QUERIES // VALIDATED & TESTED
-- Tim Spann | NYC AI Meetup | March 2026
-- ============================================================

-- ============================================================
-- DEMO 1: CORTEX AI FUNCTIONS - NEURAL SQL OPERATORS
-- ============================================================

-- 1A. SENTIMENT ANALYSIS ✓ VALIDATED
SELECT 
    'Flight AA123 experiencing turbulence, passengers secure' as event_description,
    AI_SENTIMENT('Flight AA123 experiencing turbulence, passengers secure') as sentiment_score;

-- 1B. ZERO-SHOT CLASSIFICATION ✓ VALIDATED
SELECT 
    squawk_code,
    description,
    AI_CLASSIFY(
        'Aircraft transmitting squawk code ' || squawk_code || ': ' || description,
        ['normal_operations', 'radio_failure', 'hijack_threat', 'general_emergency']
    ):label::STRING as ai_classification
FROM (
    SELECT '7700' as squawk_code, 'Emergency declared' as description
    UNION ALL SELECT '7600', 'Radio failure indicated'
    UNION ALL SELECT '7500', 'Unlawful interference'
    UNION ALL SELECT '1200', 'VFR standard code'
);

-- 1C. AI SUMMARIZATION (using AI_COMPLETE) ✓ VALIDATED
SELECT AI_COMPLETE(
    'claude-3-5-sonnet',
    'Summarize this in 2-3 sentences: The aircraft, a Boeing 737-800 registration N12345, was operating scheduled passenger flight from New York to Los Angeles. At approximately 35,000 feet over Kansas, the flight crew received multiple warnings indicating hydraulic system anomalies. The captain declared an emergency with ATC and landed safely at Kansas City International Airport.'
) as summary;

-- ============================================================
-- DEMO 2: SEMANTIC VIEW QUERIES ✓ VALIDATED
-- ============================================================

-- 2A. Query semantic view for all metrics
SELECT 
    sv.total_aircraft as "AIRCRAFT", 
    sv.total_flights as "FLIGHTS", 
    sv.avg_altitude as "AVG ALTITUDE", 
    sv.avg_ground_speed as "AVG SPEED"
FROM SEMANTIC_VIEW(DEMO.DEMO.adsb_flight_tracking 
    METRICS total_aircraft, total_flights, avg_altitude, avg_ground_speed) AS sv;

-- 2B. Individual metric query
SELECT sv.total_aircraft 
FROM SEMANTIC_VIEW(DEMO.DEMO.adsb_flight_tracking METRICS total_aircraft) AS sv;

-- CLI equivalent:
-- cortex analyst query "What is the total number of aircraft tracked?" --view=DEMO.DEMO.ADSB_FLIGHT_TRACKING

-- ============================================================
-- DEMO 3: RAW TELEMETRY DATA ✓ VALIDATED
-- ============================================================

-- 3A. Flight tracking summary
SELECT 
    COUNT(DISTINCT PLANEID) as total_aircraft,
    COUNT(DISTINCT FLIGHT) as total_flights,
    ROUND(AVG(TRY_CAST(ALTBARO AS NUMBER))) as avg_altitude_feet,
    ROUND(AVG(TRY_CAST(GS AS NUMBER))) as avg_ground_speed_knots,
    COUNT(*) as total_observations
FROM DEMO.DEMO.ADSB
WHERE SEEN_POS IS NOT NULL;

-- 3B. Sample flight data
SELECT 
    FLIGHT as "CALLSIGN",
    TRY_CAST(ALTBARO AS NUMBER) as "ALTITUDE",
    TRY_CAST(GS AS NUMBER) as "VELOCITY",
    SQUAWK as "TRANSPONDER"
FROM DEMO.DEMO.ADSB
WHERE FLIGHT IS NOT NULL
ORDER BY TRY_CAST(ALTBARO AS NUMBER) DESC NULLS LAST
LIMIT 8;

-- ============================================================
-- DEMO 4: FINANCIAL DATA (CRYPTO MATRIX) ✓ VALIDATED
-- ============================================================

SELECT 
    TIMESTAMP as "DATE",
    ROUND(CLOSE, 2) as "BTC/USD",
    ROUND(HIGH, 2) as "HIGH",
    ROUND(LOW, 2) as "LOW",
    ROUND(((CLOSE - OPEN) / NULLIF(OPEN, 0)) * 100, 2) as "CHANGE_%"
FROM DEMO.DEMO.FINANCIAL
ORDER BY TIMESTAMP DESC
LIMIT 10;

-- ============================================================
-- DEMO 5: AI-GENERATED INSIGHTS (ORACLE) ✓ VALIDATED
-- ============================================================

SELECT 
    AI_COMPLETE(
        'claude-3-5-sonnet',
        'You are NEXUS-7, an advanced aviation AI. Based on this flight tracking telemetry, provide a brief 2-sentence operational insight:
        - Total aircraft in grid: ' || total_aircraft::STRING || '
        - Active flight vectors: ' || total_flights::STRING || '
        - Mean altitude: ' || ROUND(avg_altitude)::STRING || ' feet
        - Mean velocity: ' || ROUND(avg_speed)::STRING || ' knots'
    ) as ai_insight
FROM (
    SELECT 
        COUNT(DISTINCT PLANEID) as total_aircraft,
        COUNT(DISTINCT FLIGHT) as total_flights,
        AVG(TRY_CAST(ALTBARO AS NUMBER)) as avg_altitude,
        AVG(TRY_CAST(GS AS NUMBER)) as avg_speed
    FROM DEMO.DEMO.ADSB
    WHERE SEEN_POS IS NOT NULL
);

-- ============================================================
-- VALIDATION SUMMARY
-- ============================================================
-- ✓ AI_SENTIMENT: Working
-- ✓ AI_CLASSIFY: Working  
-- ✓ AI_COMPLETE: Working (use instead of AI_SUMMARIZE)
-- ✓ SEMANTIC_VIEW: Working
-- ✓ ADSB Flight Data: 26 aircraft, 21 flights, avg 19,137 ft, 330 kts
-- ✓ FINANCIAL Data: BTC historical prices available
-- 
-- Note: AI_SUMMARIZE and AI_EXTRACT not available in this account
-- Use AI_COMPLETE as alternative for summarization tasks
-- ============================================================
