select flight, planeid, concat(latitude, ',', longitude) as latlong,
        nic, squawk, tisb, altgeom, altbaro, 
(ST_DISTANCE(ST_MAKEPOINT(longitude,latitude), 
             ST_MAKEPOINT(-93.2781,44.9705 ))/1609) 
             as distanceinmiles,
             TO_CHAR(TO_TIMESTAMP(ts), 'YYYY-MM-DD HH24:MI:SS') as currTime
from planes
where latitude is not null and longitude is not null
and trim(latitude) != '' and trim(longitude) != '' and 
distanceinmiles <= 100
  ORDER BY distanceinmiles ASC, ts desc 
     LIMIT 250;
