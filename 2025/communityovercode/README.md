````

CREATE OR REPLACE ICEBERG TABLE traveladvisories (
  title VARCHAR,
  link VARCHAR,
  description VARCHAR,
  published VARCHAR,
  author VARCHAR,
  category VARCHAR
)
EXTERNAL_VOLUME = 'TRANSCOM_TSPANNICEBERG_EXTVOL'
CATALOG = 'SNOWFLAKE'
BASE_LOCATION = 'traveladvisories/';
PARTITION BY (category);


create or replace ICEBERG TABLE DEMO.DEMO.AQ (
	DATEOBSERVED STRING,
	HOUROBSERVED STRING,
	LOCALTIMEZONE STRING,
	REPORTINGAREA STRING,
	STATECODE STRING,
	LATITUDE DECIMAL(7, 3),
	LONGITUDE DECIMAL(7, 3),
	PARAMETERNAME STRING,
	AQI DECIMAL(2, 0),
	CATEGORYNUMBER STRING,
	CATEGORYNAME STRING,
	TS STRING,
	UUID STRING,
	AQITMP DECIMAL(2, 0)
)COMMENT='The table contains records of air quality measurements. Each record includes details about the location, time, and type of measurement, as well as the measured air quality index and other relevant parameters.'

 EXTERNAL_VOLUME = 'TRANSCOM_TSPANNICEBERG_EXTVOL'
 CATALOG = 'SNOWFLAKE'
 BASE_LOCATION = 'airquality/';


CREATE OR REPLACE ICEBERG TABLE SENSORS
(
    uuid           VARCHAR,
    amplitude100   FLOAT,
    amplitude500   FLOAT,
    amplitude1000  FLOAT,
    lownoise       FLOAT,
    midnoise       FLOAT,
    highnoise      FLOAT,
    amps           FLOAT,
    ipaddress      VARCHAR,
    host           VARCHAR,
    host_name      VARCHAR,
    macaddress     VARCHAR,
    systemtime     TIMESTAMP_LTZ,
    endtime        FLOAT,
    runtime        FLOAT,
    starttime      TIMESTAMP_NTZ,
    cpu            FLOAT,
    cpu_temp       VARCHAR,
    diskusage      VARCHAR,
    memory         FLOAT,
    id             VARCHAR,
    temperature    VARCHAR,
    adjtemp        VARCHAR,
    adjtempf       VARCHAR,
    temperaturef   VARCHAR,
    pressure       FLOAT,
    humidity       FLOAT,
    lux            FLOAT,
    proximity      INTEGER,
    oxidising      FLOAT,
    reducing       FLOAT,
    nh3            FLOAT,
    gasKO          VARCHAR,
    pm25           INTEGER,
    pm1            INTEGER,
    pm10           INTEGER,
    pm1atmos       INTEGER,
    pm25atmos      INTEGER,
    pm10atmos      INTEGER,
    pmper1l03      INTEGER,
    pmper1l05      INTEGER,
    pmper1l1       INTEGER,
    pmper1l25      INTEGER,
    pmper1l5       INTEGER,
    pmper1l10      INTEGER
)
EXTERNAL_VOLUME = 'TRANSCOM_TSPANNICEBERG_EXTVOL'
CATALOG = 'SNOWFLAKE'
BASE_LOCATION = 'sensors/';




create or replace ICEBERG TABLE DEMO.DEMO.FLIGHT_DATA_ICEBERG (
	RCTIMESTAMP STRING,
	UUID STRING,
	CREATEDDATE STRING,
	ICAO24 STRING,
	CALLSIGN STRING,
	FIRSTSEEN STRING,
	LASTSEEN STRING,
	ESTDEPARTUREAIRPORT STRING,
	ESTARRIVALAIRPORT STRING,
	ESTDEPARTUREAIRPORTHORIZDISTANCE STRING,
	ESTARRIVALAIRPORTHORIZDISTANCE STRING,
	ESTDEPARTUREAIRPORTVERTDISTANCE STRING,
	ESTARRIVALAIRPORTVERTDISTANCE STRING,
	ARRIVALAIRPORTCANDIDATESCOUNT STRING,
	DEPARTUREAIRPORTCANDIDATESCOUNT STRING,
	AIRPORT STRING,
	DATAURL STRING,
	PLANEURL STRING,
	PLAINDETAILSURL STRING,
	AIRCRAFTMODE STRING,
	AIRCRAFTTYPE STRING,
	AIRCRAFTMANUFACTURER STRING,
	AIRCRAFTURLPHOTO STRING,
	AIRCRAFTURLPHOTOTHUMB STRING,
	AIRCRAFTOWNERCOUNTRY STRING,
	AIRCRAFTREGISTEREDOWNER STRING,
	AIRCRAFTICAOTYPE STRING,
	AIRCRAFTREGISTRATION STRING
)COMMENT='The table contains records of flight data, specifically aircraft movements, tracked by unique identifiers. Each record includes details about the flight''s estimated departure and arrival airports, as well as estimated distances and airport candidates. The records cover various aspects of flight operations, including estimated arrival and departure times.'

 EXTERNAL_VOLUME = 'TRANSCOM_TSPANNICEBERG_EXTVOL'
 CATALOG = 'SNOWFLAKE'
 BASE_LOCATION = 'flightdata/';


````


### Architectures

![Transit](https://github.com/tspannhw/transit-ridership/blob/main/images/diagram.png)


![x](https://github.com/tspannhw/mta-snowpipe-streaming/raw/main/images/icymta5.png)


### References

* https://github.com/tspannhw/transit-ridership
* https://github.com/tspannhw/airqualitydata
* https://github.com/tspannhw/mta-snowpipe-streaming
* https://github.com/tspannhw/TrafficAI
* https://github.com/tspannhw/TrafficAI/blob/main/trafficai2.md


### Data Sources

* https://www.flightaware.com/adsb/stats/user/TimothySpann#stats-180330
* https://console.streamnative.cloud/topic/dashboard



![ApacheNiFi](https://private-user-images.githubusercontent.com/18673814/454066290-1dae718f-1c8f-449e-bbc4-9bf6d84474df.gif?jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NTczNDY3MDcsIm5iZiI6MTc1NzM0NjQwNywicGF0aCI6Ii8xODY3MzgxNC80NTQwNjYyOTAtMWRhZTcxOGYtMWM4Zi00NDllLWJiYzQtOWJmNmQ4NDQ3NGRmLmdpZj9YLUFtei1BbGdvcml0aG09QVdTNC1ITUFDLVNIQTI1NiZYLUFtei1DcmVkZW50aWFsPUFLSUFWQ09EWUxTQTUzUFFLNFpBJTJGMjAyNTA5MDglMkZ1cy1lYXN0LTElMkZzMyUyRmF3czRfcmVxdWVzdCZYLUFtei1EYXRlPTIwMjUwOTA4VDE1NDY0N1omWC1BbXotRXhwaXJlcz0zMDAmWC1BbXotU2lnbmF0dXJlPTQ3YWU3Y2NiY2MyMGMxMzU0ODQyZjZmMTcwNDFkYTljMDM3Mzc1ZjdiZTNjNTRkOTZmNmRlZjhiOGE5MmViNjImWC1BbXotU2lnbmVkSGVhZGVycz1ob3N0In0.Rh-7SrEb9ZjWE5i7kVUYctdj2163jKkNVwiWzTCBcPM)

