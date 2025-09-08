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






![ApacheNiFi](https://private-user-images.githubusercontent.com/18673814/454066290-1dae718f-1c8f-449e-bbc4-9bf6d84474df.gif?jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NTczNDY3MDcsIm5iZiI6MTc1NzM0NjQwNywicGF0aCI6Ii8xODY3MzgxNC80NTQwNjYyOTAtMWRhZTcxOGYtMWM4Zi00NDllLWJiYzQtOWJmNmQ4NDQ3NGRmLmdpZj9YLUFtei1BbGdvcml0aG09QVdTNC1ITUFDLVNIQTI1NiZYLUFtei1DcmVkZW50aWFsPUFLSUFWQ09EWUxTQTUzUFFLNFpBJTJGMjAyNTA5MDglMkZ1cy1lYXN0LTElMkZzMyUyRmF3czRfcmVxdWVzdCZYLUFtei1EYXRlPTIwMjUwOTA4VDE1NDY0N1omWC1BbXotRXhwaXJlcz0zMDAmWC1BbXotU2lnbmF0dXJlPTQ3YWU3Y2NiY2MyMGMxMzU0ODQyZjZmMTcwNDFkYTljMDM3Mzc1ZjdiZTNjNTRkOTZmNmRlZjhiOGE5MmViNjImWC1BbXotU2lnbmVkSGVhZGVycz1ob3N0In0.Rh-7SrEb9ZjWE5i7kVUYctdj2163jKkNVwiWzTCBcPM)

