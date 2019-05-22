-- complain if script is sourced in psql, rather than via CREATE EXTENSION
\echo Use "CREATE EXTENSION nats" to load this file. \quit

CREATE FUNCTION nats_status()
    RETURNS text
AS 'MODULE_PATHNAME', 'nats_status'
LANGUAGE C IMMUTABLE ;