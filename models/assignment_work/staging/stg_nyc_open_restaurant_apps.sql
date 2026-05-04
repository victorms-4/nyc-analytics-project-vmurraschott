
SELECT *
FROM (
    SELECT
         objectid
        ,globalid
        ,time_of_submission
        ,restaurant_name
        ,legal_business_name
        ,doing_business_as_dba
        ,food_service_establishment_permit
        ,approved_for_sidewalk_seating
        ,approved_for_roadway_seating
        ,food_service_establishment
        ,healthcompliance_terms
        ,nta
        ,qualify_alcohol
        ,seating_interest_sidewalk
        ,sla_license_type
        ,sla_serial_number
        ,landmark_district_or_building
        ,landmarkdistrict_terms
        ,TRIM(borough) AS borough
        ,building_number
        ,street
        ,CASE
           WHEN UPPER(TRIM(CAST(zip AS STRING))) IN ('N/A', 'NA') THEN NULL
           WHEN UPPER(TRIM(CAST(zip AS STRING))) = 'ANONYMOUS' THEN 'Anonymous'
           WHEN LENGTH(CAST(zip AS STRING)) = 5 THEN CAST(zip AS STRING)
           WHEN LENGTH(CAST(zip AS STRING)) = 9 THEN CAST(zip AS STRING)
           WHEN LENGTH(CAST(zip AS STRING)) = 10 AND REGEXP_CONTAINS(CAST(zip AS STRING), r'^\d{5}-\d{4}')
                THEN CAST(zip AS STRING)
           ELSE NULL
         END AS zip_code
        ,latitude
        ,longitude
        ,bbl
        ,bin
        ,bulding_number
        ,business_address
        ,census_tract
        ,community_board
        ,council_district
        ,roadway_dimensions_area
        ,roadway_dimensions_length
        ,roadway_dimensions_width
        ,sidewalk_dimensions_length
        ,sidewalk_dimensions_width
        ,sidewalk_dimensions_area
        ,CURRENT_TIMESTAMP() AS _stg_loaded_at
        ,ROW_NUMBER() OVER (PARTITION BY objectid, globalid ORDER BY time_of_submission DESC) AS RN
    FROM {{ source('raw', 'source_nyc_open_restaurant_apps') }}
    WHERE objectid IS NOT NULL
        AND globalid IS NOT NULL
        AND time_of_submission IS NOT NULL
    ) remove_dup
WHERE RN = 1