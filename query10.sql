WITH 
rail_with_geog AS (
    SELECT
        stop_id,
        stop_name,
        stop_lon,
        stop_lat,
        ST_MakePoint(stop_lon, stop_lat)::geography AS geog
    FROM septa.rail_stops
),
nearest_info AS (
    SELECT
        r.stop_id,
        r.stop_name,
        r.stop_lon,
        r.stop_lat,
        n.name AS neighborhood_name,
        b.stop_name AS bus_stop_name,
        ROUND((ST_Distance(r.geog, b.geog) / 1609.34)::numeric, 2) AS dist_miles,
        degrees(ST_Azimuth(
            r.geog::geometry,
            b.geog::geometry
        )) AS azimuth_deg
    FROM rail_with_geog r
    CROSS JOIN LATERAL (
        SELECT 
            bs.stop_name,
            ST_MakePoint(bs.stop_lon, bs.stop_lat)::geography AS geog
        FROM septa.bus_stops bs
        ORDER BY r.geog <-> ST_MakePoint(bs.stop_lon, bs.stop_lat)::geography
        LIMIT 3
    ) AS b
    LEFT JOIN phl.neighborhoods n
        ON ST_Covers(n.geog, r.geog)
),
aggregated AS (
    SELECT
        stop_id,
        stop_name,
        stop_lon,
        stop_lat,
        neighborhood_name,
        STRING_AGG(
            dist_miles::text || ' miles '
            || CASE
                WHEN azimuth_deg < 22.5 OR azimuth_deg >= 337.5 THEN 'N'
                WHEN azimuth_deg < 67.5 THEN 'NE'
                WHEN azimuth_deg < 112.5 THEN 'E'
                WHEN azimuth_deg < 157.5 THEN 'SE'
                WHEN azimuth_deg < 202.5 THEN 'S'
                WHEN azimuth_deg < 247.5 THEN 'SW'
                WHEN azimuth_deg < 292.5 THEN 'W'
                ELSE 'NW'
            END
            || ' of ' || bus_stop_name,
            ' | ' 
            ORDER BY dist_miles 
        ) AS nearby_buses
    FROM nearest_info
    GROUP BY stop_id, stop_name, stop_lon, stop_lat, neighborhood_name
)
SELECT
    stop_id,
    stop_name,
    'In ' || COALESCE(neighborhood_name, 'Philadelphia') 
    || ' | Nearby bus stops: ' || nearby_buses AS stop_desc,
    stop_lon,
    stop_lat
FROM aggregated
ORDER BY stop_id;

