 SELECT *
 FROM {{ source('raw', 'source_nyc_motor_vehicle_collision') }}
 LIMIT 10