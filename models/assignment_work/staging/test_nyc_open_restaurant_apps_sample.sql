 -- Quick test to verify source connection works
 SELECT
     objectid,
     time_of_submission,
     restaurant_name,
     borough
 FROM {{ source('raw', 'source_nyc_open_restaurant_apps') }}
 LIMIT 10