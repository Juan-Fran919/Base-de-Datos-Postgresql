--
-- PostgreSQL database dump
--

-- Dumped from database version 14.2 (Debian 14.2-1.pgdg110+1)
-- Dumped by pg_dump version 14.2

-- Started on 2022-03-29 06:42:24 UTC

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 5 (class 2615 OID 16410)
-- Name: comercial; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA comercial;


ALTER SCHEMA comercial OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 209 (class 1259 OID 16414)
-- Name: compra_boleta; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.compra_boleta (
    nacionalidad_comprador character varying,
    num_pasaporte_comprador character varying,
    nombre_comprador character varying,
    edad_comprador integer,
    precio_boleta double precision,
    fecha_partido timestamp without time zone,
    nombre_equipo_1 character varying,
    nombre_equipo_2 character varying,
    boleta_comprador boolean,
    fecha_compra date
);


ALTER TABLE comercial.compra_boleta OWNER TO postgres;

--
-- TOC entry 210 (class 1259 OID 16428)
-- Name: cantidad_boletas_partido; Type: VIEW; Schema: comercial; Owner: postgres
--

CREATE VIEW comercial.cantidad_boletas_partido AS
 SELECT (((compra_boleta.nombre_equipo_1)::text || '_'::text) || (compra_boleta.nombre_equipo_2)::text) AS partido,
    count(*) AS cant_boletas
   FROM comercial.compra_boleta
  GROUP BY (((compra_boleta.nombre_equipo_1)::text || '_'::text) || (compra_boleta.nombre_equipo_2)::text);


ALTER TABLE comercial.cantidad_boletas_partido OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 16432)
-- Name: intercambio; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.intercambio (
    fecha_intercambio timestamp without time zone,
    id_intercambio character varying,
    id_venta_boleta character varying,
    num_pasaporte_comprador character varying
);


ALTER TABLE comercial.intercambio OWNER TO postgres;

--
-- TOC entry 213 (class 1259 OID 16449)
-- Name: dinero_boletas_qatar_transferida; Type: VIEW; Schema: comercial; Owner: postgres
--

CREATE VIEW comercial.dinero_boletas_qatar_transferida AS
 SELECT sum(c_1.precio_boleta) AS suma_de_precio_compras
   FROM (comercial.compra_boleta c_1
     JOIN comercial.intercambio c_2 ON ((((c_1.num_pasaporte_comprador)::text = (c_2.num_pasaporte_comprador)::text) AND (((c_1.nombre_equipo_1)::text = 'Qatar'::text) OR ((c_1.nombre_equipo_2)::text = 'Qatar'::text)))));


ALTER TABLE comercial.dinero_boletas_qatar_transferida OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 24576)
-- Name: partidos_latam; Type: VIEW; Schema: comercial; Owner: postgres
--

CREATE VIEW comercial.partidos_latam AS
 SELECT compra_boleta.nacionalidad_comprador,
    compra_boleta.num_pasaporte_comprador,
    compra_boleta.nombre_comprador,
    compra_boleta.edad_comprador,
    compra_boleta.precio_boleta,
    compra_boleta.fecha_partido,
    compra_boleta.nombre_equipo_1,
    compra_boleta.nombre_equipo_2,
    compra_boleta.boleta_comprador,
    compra_boleta.fecha_compra
   FROM comercial.compra_boleta
  WHERE (((compra_boleta.nombre_equipo_1)::text = 'Equipo de latino america'::text) OR ((compra_boleta.nombre_equipo_2)::text = 'Equipo de latino america'::text));


ALTER TABLE comercial.partidos_latam OWNER TO postgres;

--
-- TOC entry 212 (class 1259 OID 16441)
-- Name: personas_final_transferida; Type: VIEW; Schema: comercial; Owner: postgres
--

CREATE VIEW comercial.personas_final_transferida AS
 SELECT c_1.num_pasaporte_comprador
   FROM (comercial.compra_boleta c_1
     JOIN comercial.intercambio c_2 ON ((((c_1.num_pasaporte_comprador)::text = (c_2.num_pasaporte_comprador)::text) AND (c_1.precio_boleta > (5000.0)::double precision))));


ALTER TABLE comercial.personas_final_transferida OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 24580)
-- Name: precio_joven; Type: VIEW; Schema: comercial; Owner: postgres
--

CREATE VIEW comercial.precio_joven AS
 SELECT compra_boleta.num_pasaporte_comprador
   FROM comercial.compra_boleta
  WHERE ((compra_boleta.edad_comprador < 30) AND (compra_boleta.precio_boleta > (1000.0)::double precision));


ALTER TABLE comercial.precio_joven OWNER TO postgres;

--
-- TOC entry 3334 (class 0 OID 16414)
-- Dependencies: 209
-- Data for Name: compra_boleta; Type: TABLE DATA; Schema: comercial; Owner: postgres
--

COPY comercial.compra_boleta (nacionalidad_comprador, num_pasaporte_comprador, nombre_comprador, edad_comprador, precio_boleta, fecha_partido, nombre_equipo_1, nombre_equipo_2, boleta_comprador, fecha_compra) FROM stdin;
Mexicana	G39040681	Juan Francisco	23	6000.5	2022-11-11 14:00:00	México	Qatar	t	\N
Alemana	G39040682	Miguel Emenht	30	1000.5	2022-11-11 14:00:00	Alemania	Qatar	f	\N
Argentina	G39040683	Alex Galindo	43	9000.5	2022-11-11 14:00:00	México	Argentina	f	\N
Americana	G39040684	Jude Loreto	29	8000.5	2022-11-11 14:00:00	México	Qatar	t	\N
Japonesa	G39040685	Kin Son	41	2000.5	2022-12-20 14:00:00	EUA	Qatar	f	\N
\.


--
-- TOC entry 3335 (class 0 OID 16432)
-- Dependencies: 211
-- Data for Name: intercambio; Type: TABLE DATA; Schema: comercial; Owner: postgres
--

COPY comercial.intercambio (fecha_intercambio, id_intercambio, id_venta_boleta, num_pasaporte_comprador) FROM stdin;
2022-11-24 09:00:00	f-43	v-43	G39040681
2022-12-30 10:00:00	f-44	v-44	G39040682
2022-12-20 14:00:00	f-45	v-45	G39040683
2022-12-13 14:00:00	f-46	v-46	G39040686
2022-11-11 17:00:00	f-47	v-47	G39040689
\.


-- Completed on 2022-03-29 06:42:25 UTC

--
-- PostgreSQL database dump complete
--

