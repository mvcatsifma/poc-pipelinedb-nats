CREATE FOREIGN TABLE products_stream
  (product_id VARCHAR(255))
  SERVER pipelinedb;

CREATE VIEW cv_products_count with (ACTION = 'materialize')
AS
SELECT count(*)
FROM products_stream;

CREATE OR REPLACE FUNCTION after_products_count_update()
  RETURNS TRIGGER AS
$$
BEGIN
--   TODO: publish to NATS
  RETURN NEW;
END;
$$
  LANGUAGE plpgsql;

CREATE VIEW t_products_count
  WITH (action = transform, outputfunc=after_products_count_update)
AS
SELECT (new).count
FROM output_of('cv_products_count');

INSERT INTO products_stream
VALUES (uuid_in(md5(random()::text || clock_timestamp()::text)::cstring));
INSERT INTO products_stream
VALUES (uuid_in(md5(random()::text || clock_timestamp()::text)::cstring));
INSERT INTO products_stream
VALUES (uuid_in(md5(random()::text || clock_timestamp()::text)::cstring));
INSERT INTO products_stream
VALUES (uuid_in(md5(random()::text || clock_timestamp()::text)::cstring));
INSERT INTO products_stream
VALUES (uuid_in(md5(random()::text || clock_timestamp()::text)::cstring));
INSERT INTO products_stream
VALUES (uuid_in(md5(random()::text || clock_timestamp()::text)::cstring));

SELECT *
FROM cv_products_count;
