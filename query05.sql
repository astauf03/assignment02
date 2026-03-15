/*
 Rate neighborhoods by their bus stop accessibility for wheelchairs. Use OpenDataPhilly's neighborhood dataset along with an appropriate dataset from the Septa GTFS bus feed. Use the GTFS documentation for help. Use some creativity in the metric you devise in rating neighborhoods.

NOTE: There is no automated test for this question, as there's no one right answer. With urban data analysis, this is frequently the case.

Discuss your accessibility metric and how you arrived at it below:

Description:
*/

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
ORDER BY accessibility_metric DESC;