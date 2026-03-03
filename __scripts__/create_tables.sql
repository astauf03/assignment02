-- Active: 1769627356538@@172.31.112.109@5432@week03
create schema if not exists septa;
create schema if not exists phl;
create schema if not exists census;

drop table if exists septa.bus_stops;
create table septa.bus_stops (
    stop_id TEXT,
    stop_code TEXT,
    stop_name TEXT,
    stop_desc TEXT,
    stop_lat DOUBLE PRECISION,
    stop_lon DOUBLE PRECISION,
    zone_id TEXT,
    stop_url TEXT,
    location_type INTEGER,
    parent_station TEXT,
    stop_timezone TEXT,
    wheelchair_boarding INTEGER
);

drop table if exists septa.bus_routes;

create table septa.bus_routes (
    route_id TEXT,
    agency_id TEXT,
    route_short_name TEXT,
    route_long_name TEXT,
    route_desc TEXT,
    route_type TEXT,
    route_url TEXT,
    route_color TEXT,
    route_text_color TEXT
);

drop table if exists septa.bus_trips;
create table septa.bus_trips (
    route_id TEXT,
    service_id TEXT,
    trip_id TEXT,
    trip_headsign TEXT,
    trip_short_name TEXT,
    direction_id TEXT,
    block_id TEXT,
    shape_id TEXT,
    wheelchair_accessible INTEGER,
    bikes_allowed INTEGER
);

drop table if exists septa.bus_shapes;
create table septa.bus_shapes (
    shape_id TEXT,
    shape_pt_lat DOUBLE PRECISION,
    shape_pt_lon DOUBLE PRECISION,
    shape_pt_sequence INTEGER,
    shape_dist_traveled DOUBLE PRECISION
);

drop table if exists septa.rail_stops;
create table septa.rail_stops (
    stop_id TEXT,
    stop_name TEXT,
    stop_desc TEXT,
    stop_lat DOUBLE PRECISION,
    stop_lon DOUBLE PRECISION,
    zone_id TEXT,
    stop_url TEXT
);

drop table if exists census.population_2020;
create table census.population_2020 (
    geoid TEXT,
    geoname TEXT,
    total INTEGER
);


create extension if not exists postgis;


/*
COPY septa.bus_stops (stop_id, stop_name, stop_lat, stop_lon, location_type, parent_station, zone_id, wheelchair_boarding)
FROM '/mnt/c/Users/astau/OneDrive/Desktop/cloud-comp/google_bus/stops.txt'
WITH (FORMAT CSV, HEADER TRUE);

COPY septa.bus_routes (route_id, route_short_name, route_long_name, route_type, route_color, route_text_color, route_url)
FROM '/mnt/c/Users/astau/OneDrive/Desktop/cloud-comp/google_bus/routes.txt'
WITH (FORMAT CSV, HEADER TRUE);

COPY septa.bus_shapes (shape_id, shape_pt_lat, shape_pt_lon, shape_pt_sequence)
FROM '/mnt/c/Users/astau/OneDrive/Desktop/cloud-comp/google_bus/shapes.txt'
WITH (FORMAT CSV, HEADER TRUE);

COPY septa.bus_trips (route_id, service_id, trip_id, trip_headsign, block_id, direction_id, shape_id)
FROM '/mnt/c/Users/astau/OneDrive/Desktop/cloud-comp/google_bus/trips.txt'
WITH (FORMAT CSV, HEADER TRUE);

COPY septa.rail_stops (stop_id, stop_name, stop_desc, stop_lat, stop_lon, zone_id, stop_url)
FROM '/mnt/c/Users/astau/OneDrive/Desktop/cloud-comp/stops.txt'
WITH (FORMAT CSV, HEADER TRUE);
*/
