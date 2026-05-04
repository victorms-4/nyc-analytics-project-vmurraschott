WITH all_locations AS (
   -- Get locations from 311 requests
   SELECT DISTINCT
      borough,
      incident_zip as zip_code 
   FROM {{ ref('staging_nyc_311_street_complaints') }}
   WHERE borough IS NOT NULL

   UNION DISTINCT

   -- Get locations from vehicle collisions
   SELECT DISTINCT
       borough,
       zip_code 
   FROM {{ ref('staging_tbl_veh_collision') }}
   WHERE borough IS NOT NULL
),

location_dimension AS (
   SELECT
       {{ dbt_utils.generate_surrogate_key(['borough', 'zip_code']) }} AS location_key,
       borough,
       zip_code
   FROM all_locations
)

SELECT * FROM location_dimension