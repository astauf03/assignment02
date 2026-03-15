-- Active: 1769627356538@@172.31.112.109@5432@week03
SELECT 
	p.address AS parcel_address,
	closest_stop.stop_name,
	ROUND(ST_DISTANCE(p.geog, closest_stop.geog)::numeric,2) AS distance
FROM phl.pwd_parcels AS p
CROSS JOIN LATERAL (
	SELECT 
		s.stop_name,
		s.geog
	FROM septa.bus_stops AS s
	ORDER BY p.geog <-> s.geog
	LIMIT 1
) AS closest_stop
ORDER BY distance DESC;