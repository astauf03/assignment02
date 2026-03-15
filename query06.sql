SELECT
    n.name AS neighborhood_name,
    COUNT(*) FILTER (WHERE bs.wheelchair_boarding = 1) AS num_bus_stops_accessible,
    COUNT(*) FILTER (WHERE bs.wheelchair_boarding = 2) AS num_bus_stops_inaccessible,
    ROUND(
        COUNT(*) FILTER (WHERE bs.wheelchair_boarding = 1)::numeric
        / NULLIF(COUNT(*) FILTER (WHERE bs.wheelchair_boarding IN (1, 2)), 0)
    , 2) AS accessibility_metric
FROM phl.neighborhoods n
JOIN septa.bus_stops bs 
    ON ST_Covers(n.geog, ST_MakePoint(bs.stop_lon, bs.stop_lat)::geography)
GROUP BY n.name
ORDER BY accessibility_metric DESC
LIMIT 5;