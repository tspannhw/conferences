https://main.dssconf.pl/

November 20, 2025

https://www.linkedin.com/feed/update/urn:li:activity:7395490782805159936/

<img width="1200" height="1200" alt="image" src="https://github.com/user-attachments/assets/4f50b3d0-4b94-4b64-a12a-93c675ab6e87" />



SQL

````


select * FROM DEMO.DEMO.NYCTRAFFICIMAGES
order by ending desc;

   SELECT AI_COMPLETE('claude-4-sonnet', 
    'Analyze this traffic image and describe what you see. Respond in JSON only, do not include the word json or preinformation.',
    TO_FILE('@TRAFFIC', 'trimg.64185c08-0ef9-4771-9143-8b78a3d44852689a8c3b-281b-484a-ac5c-104653d6aabb.jpg'));


CREATE OR REPLACE PROCEDURE "ANALYZETRAFFICIMAGE"("IMAGE_NAME" VARCHAR, "FILENAME" VARCHAR, "UUID" VARCHAR)
RETURNS OBJECT
LANGUAGE SQL
EXECUTE AS OWNER
AS '
DECLARE
  result VARIANT;
BEGIN
   ALTER STAGE TRAFFIC REFRESH; 
    
   SELECT AI_COMPLETE(''claude-4-sonnet'', 
    ''Analyze this traffic image and describe what you see. Respond in JSON only, do not include the word json or preinformation'',
    TO_FILE(''@TRAFFIC'', :IMAGE_NAME)) INTO :result;

   INSERT INTO DEMO.DEMO.RAWNYCTRAFFICIMAGES 
   (json_data, filename, uuid)
   SELECT PARSE_JSON(:result ) as json_data, :filename, :uuid;
    
   RETURN result;
EXCEPTION
    WHEN OTHER THEN
        RETURN ''Error: '' || SQLSTATE || '' - ''|| SQLERRM;   
END;
';



select * from DEMO.DEMO.RAWNYCTRAFFICIMAGES
where filename = 'trimg.96485b06-955a-42c5-a831-fe3e6a30e20f76866f53-b971-454c-b7ce-f1bf9818a66a.jpg';

NYSDOT-4616417

{
  "infrastructure": {
    "buildings": "Urban commercial/residential buildings lining the street",
    "crosswalks": "Zebra striped pedestrian crossings visible",
    "flags": "American flags visible on buildings",
    "sidewalks": "Wide sidewalks with pedestrian activity"
  },
  "location": "Facing South Red",
  "pedestrians": "Multiple people visible on sidewalks and crosswalks",
  "scene_description": "Urban intersection with heavy traffic congestion",
  "timestamp": "Nov 12 2025 01:55:51 PM",
  "traffic_conditions": "Heavy congestion with vehicles stopped or moving slowly",
  "traffic_flow": "Vehicles appear to be in stop-and-go traffic pattern",
  "vehicles": {
    "buses": "Multiple city buses visible, including yellow and white buses",
    "cars": "Several passenger vehicles including dark colored sedans and SUVs",
    "trucks": "Commercial vehicles present in traffic"
  },
  "weather_lighting": "Overcast conditions with daylight visibility"
}

````


References

https://medium.com/@tim.spann_50517/populating-an-open-lakehouse-with-codeless-data-streams-9395a30a2d4f

