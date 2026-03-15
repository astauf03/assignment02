WITH penn_campus AS (
    SELECT ST_Union(geog::geometry) AS geog
    FROM phl.pwd_parcels
    WHERE owner1 LIKE '%UNIV%PENN%'
		OR owner2 LIKE '%UNIV%PENN%'
		OR owner1 LIKE '%TRUSTEE%PENN%'
)
SELECT COUNT(*) AS count_block_groups
FROM census.blockgroups_2020 AS bg
JOIN penn_campus AS pc
ON ST_Within(bg.geog::geometry, pc.geog);

