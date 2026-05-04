 SELECT
     unique_key,
     created_date,
     complaint_type,
     borough
 FROM {{ source('raw', 'source_nyc_311_streetcomplaints') }}
 LIMIT 10