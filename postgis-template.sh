#!/bin/bash
set -e

# Create database
echo "Creating database edf"
psql --dbname=$POSTGRES_DB --username=$POSTGRES_USER <<-'EOSQL'
	CREATE USER edf;
	CREATE DATABASE edf;
EOSQL

# Load extensions
echo "Loading PostGIS extensions into edf"
psql --dbname=$POSTGRES_DB --username=$POSTGRES_USER <<-'EOSQL'
	CREATE EXTENSION postgis;
	CREATE EXTENSION postgis_topology;
	CREATE EXTENSION postgis_sfcgal;
EOSQL

# Load shapefiles
echo "Loading shapefiles into edf"
shp2pgsql -I -s 4326 /data/NotPreferredDistributionCircuits.shp npDistCircuits | psql -d $POSTGRES_DB -U $POSTGRES_USER -w
shp2pgsql -I -s 4326 /data/PreferredDistributionCircuits.shp pDistCircuits | psql -d $POSTGRES_DB -U $POSTGRES_USER -w
shp2pgsql -I -s 4326 /data/SubTransmissionCircuits.shp sTransCircuits | psql -d $POSTGRES_DB -U $POSTGRES_USER -w
shp2pgsql -I -s 4326 /data/TransmissionCircuits.shp TransCircuits | psql -d $POSTGRES_DB -U $POSTGRES_USER -w