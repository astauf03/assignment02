WITH 
shape_lines AS (
    SELECT
        shape_id,
        ST_MakeLine(
            ST_MakePoint(shape_pt_lon, shape_pt_lat)
            ORDER BY shape_pt_sequence
        ) AS geom
    FROM septa.bus_shapes
    GROUP BY shape_id
),
unique_trips AS (
    SELECT DISTINCT shape_id, route_id, trip_headsign
    FROM septa.bus_trips
),
trip_lengths AS (
    SELECT
        t.route_id,
        t.trip_headsign,
        t.shape_id,
        ST_Length(s.geom::geography) AS trip_length,
        ROW_NUMBER() OVER (ORDER BY ST_Length(s.geom::geography) DESC) AS rn
    FROM unique_trips t
    JOIN shape_lines s ON t.shape_id = s.shape_id
)
SELECT
    r.route_short_name,
    tl.trip_headsign,
    ROUND(tl.trip_length::numeric) AS shape_length
FROM trip_lengths tl
JOIN septa.bus_routes r ON tl.route_id = r.route_id
WHERE tl.rn <= 2;