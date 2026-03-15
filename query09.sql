SELECT bg.geoid
FROM census.blockgroups_2020 AS bg
JOIN phl.pwd_parcels AS pp
    ON ST_Within(pp.geog::geometry, bg.geog::geometry)
WHERE pp.address ILIKE '%210%34TH%';