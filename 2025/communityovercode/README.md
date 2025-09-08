````

CREATE OR REPLACE ICEBERG TABLE traveladvisories (
  title VARCHAR,
  link VARCHAR,
  description VARCHAR,
  published DATE,
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


````


### Architectures

![Transit](https://github.com/tspannhw/transit-ridership/blob/main/images/diagram.png)


![x](https://github.com/tspannhw/mta-snowpipe-streaming/raw/main/images/icymta5.png)


### References

* https://github.com/tspannhw/transit-ridership
* https://github.com/tspannhw/airqualitydata
* https://github.com/tspannhw/mta-snowpipe-streaming
* https://github.com/tspannhw/TrafficAI
