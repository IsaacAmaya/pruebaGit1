--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.3
-- Dumped by pg_dump version 9.6.3

-- Started on 2017-09-12 14:45:15

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 1 (class 3079 OID 12469)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2455 (class 0 OID 0)
-- Dependencies: 1
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- TOC entry 191 (class 1259 OID 16483)
-- Name: idcargo; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE idcargo
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE idcargo OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 192 (class 1259 OID 16485)
-- Name: cargo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE cargo (
    idcargo bigint DEFAULT nextval('idcargo'::regclass) NOT NULL,
    nombre character varying(80),
    descripcion text,
    sueldo double precision,
    estatus integer
);


ALTER TABLE cargo OWNER TO postgres;

--
-- TOC entry 203 (class 1259 OID 16644)
-- Name: idcompra; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE idcompra
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE idcompra OWNER TO postgres;

--
-- TOC entry 204 (class 1259 OID 16646)
-- Name: compra; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE compra (
    idcompra bigint DEFAULT nextval('idcompra'::regclass) NOT NULL,
    idproveedor bigint,
    numerofactura character varying(50),
    fecha date,
    descripcion text,
    montofactura double precision,
    estatus integer
);


ALTER TABLE compra OWNER TO postgres;

--
-- TOC entry 205 (class 1259 OID 16658)
-- Name: idcompramaterial; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE idcompramaterial
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE idcompramaterial OWNER TO postgres;

--
-- TOC entry 206 (class 1259 OID 16660)
-- Name: compramaterial; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE compramaterial (
    idcompramaterial bigint DEFAULT nextval('idcompramaterial'::regclass) NOT NULL,
    idcompra bigint,
    idmaterial bigint,
    cantidad double precision,
    costounitario double precision,
    costototal double precision
);


ALTER TABLE compramaterial OWNER TO postgres;

--
-- TOC entry 201 (class 1259 OID 16540)
-- Name: idcuadrilla; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE idcuadrilla
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE idcuadrilla OWNER TO postgres;

--
-- TOC entry 202 (class 1259 OID 16542)
-- Name: cuadrilla; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE cuadrilla (
    idcuadrilla bigint DEFAULT nextval('idcuadrilla'::regclass) NOT NULL,
    nombre character varying(100),
    apodo character varying(50),
    descripcion text,
    estatus integer,
    idtrabajador bigint
);


ALTER TABLE cuadrilla OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 16714)
-- Name: iddetalleetapa; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE iddetalleetapa
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE iddetalleetapa OWNER TO postgres;

--
-- TOC entry 212 (class 1259 OID 16716)
-- Name: detalleetapa; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE detalleetapa (
    iddetalleetapa bigint DEFAULT nextval('iddetalleetapa'::regclass) NOT NULL,
    idetapa bigint,
    idsubetapa bigint,
    estatus integer
);


ALTER TABLE detalleetapa OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 73754)
-- Name: iddetalleinspeccion; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE iddetalleinspeccion
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE iddetalleinspeccion OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 73741)
-- Name: detalleinspeccion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE detalleinspeccion (
    iddetalleinspeccion bigint DEFAULT nextval('iddetalleinspeccion'::regclass) NOT NULL,
    idinspeccion bigint,
    ubicacion character varying(100)
);


ALTER TABLE detalleinspeccion OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 49152)
-- Name: iddetallesolicitud; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE iddetallesolicitud
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE iddetallesolicitud OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 41015)
-- Name: detallesolicitud; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE detallesolicitud (
    iddetallesolicitud bigint DEFAULT nextval('iddetallesolicitud'::regclass) NOT NULL,
    idsolicitudmaterial bigint,
    idmaterial bigint,
    cantidad double precision
);


ALTER TABLE detallesolicitud OWNER TO postgres;

--
-- TOC entry 195 (class 1259 OID 16507)
-- Name: idetapa; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE idetapa
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE idetapa OWNER TO postgres;

--
-- TOC entry 196 (class 1259 OID 16509)
-- Name: etapa; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE etapa (
    idetapa bigint DEFAULT nextval('idetapa'::regclass) NOT NULL,
    nombre character varying(100),
    descripcion text,
    porcentaje double precision,
    tiempoestimado integer,
    estatus integer
);


ALTER TABLE etapa OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 73751)
-- Name: idinspeccion; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE idinspeccion
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE idinspeccion OWNER TO postgres;

--
-- TOC entry 194 (class 1259 OID 16498)
-- Name: idmaterial; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE idmaterial
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE idmaterial OWNER TO postgres;

--
-- TOC entry 213 (class 1259 OID 16731)
-- Name: idmaterialporobra; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE idmaterialporobra
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE idmaterialporobra OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 16854)
-- Name: idobra; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE idobra
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE idobra OWNER TO postgres;

--
-- TOC entry 185 (class 1259 OID 16385)
-- Name: idpersona; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE idpersona
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE idpersona OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 73738)
-- Name: idprecio; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE idprecio
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE idprecio OWNER TO postgres;

--
-- TOC entry 189 (class 1259 OID 16437)
-- Name: idproveedor; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE idproveedor
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE idproveedor OWNER TO postgres;

--
-- TOC entry 188 (class 1259 OID 16419)
-- Name: idproyecto; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE idproyecto
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE idproyecto OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 57344)
-- Name: idsalidamaterial; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE idsalidamaterial
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE idsalidamaterial OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 41030)
-- Name: idsolicitudmaterial; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE idsolicitudmaterial
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE idsolicitudmaterial OWNER TO postgres;

--
-- TOC entry 209 (class 1259 OID 16703)
-- Name: idsubetapa; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE idsubetapa
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE idsubetapa OWNER TO postgres;

--
-- TOC entry 197 (class 1259 OID 16519)
-- Name: idtipoobra; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE idtipoobra
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE idtipoobra OWNER TO postgres;

--
-- TOC entry 199 (class 1259 OID 16531)
-- Name: idtrabajador; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE idtrabajador
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE idtrabajador OWNER TO postgres;

--
-- TOC entry 207 (class 1259 OID 16666)
-- Name: idtrabajadorcuadrilla; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE idtrabajadorcuadrilla
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE idtrabajadorcuadrilla OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 65536)
-- Name: inspeccion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE inspeccion (
    idinspeccion bigint DEFAULT nextval('idinspeccion'::regclass) NOT NULL,
    idproyecto bigint,
    idobra bigint,
    iddetalleetapa bigint,
    fechainspeccion date,
    observacion text,
    estatus bigint,
    idcuadrilla bigint,
    porcentaje integer,
    porcentajegeneral integer
);


ALTER TABLE inspeccion OWNER TO postgres;

--
-- TOC entry 193 (class 1259 OID 16495)
-- Name: material; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE material (
    idmaterial bigint DEFAULT nextval('idmaterial'::regclass) NOT NULL,
    nombre character varying(200),
    marca character varying(200),
    descripcion text,
    estatus integer,
    existencia double precision
);


ALTER TABLE material OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 16733)
-- Name: materialporobra; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE materialporobra (
    idmaterialporobra bigint DEFAULT nextval('idmaterialporobra'::regclass) NOT NULL,
    idmaterial bigint,
    iddetalleetapa bigint,
    cantidadestimada integer,
    estatus integer,
    idtipoobra bigint
);


ALTER TABLE materialporobra OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 16856)
-- Name: obra; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE obra (
    idobra bigint DEFAULT nextval('idobra'::regclass) NOT NULL,
    idproyecto bigint,
    idtipoobra bigint,
    nombre character varying(100),
    descripcion text,
    porcentaje double precision,
    fechainicio date,
    fechafinestimada date,
    fechafin date,
    estatus integer,
    lote character varying(30)
);


ALTER TABLE obra OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 24596)
-- Name: permisos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE permisos (
    idusuario bigint NOT NULL,
    modulo character varying(20) NOT NULL,
    incluir boolean,
    editar boolean,
    eliminar boolean,
    consultar boolean
);


ALTER TABLE permisos OWNER TO postgres;

--
-- TOC entry 186 (class 1259 OID 16387)
-- Name: persona; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE persona (
    idpersona bigint DEFAULT nextval('idpersona'::regclass) NOT NULL,
    nombre character varying(100) NOT NULL,
    apellido character varying(100) NOT NULL,
    cedula bigint NOT NULL,
    direccion character varying(300) NOT NULL,
    telefonomovil character varying(15),
    telefonohabitacion character varying(15),
    estatus integer DEFAULT 0,
    estadocivil integer DEFAULT 1,
    genero integer DEFAULT 1,
    email character varying(40),
    fechanacimiento date NOT NULL,
    CONSTRAINT cedula CHECK ((cedula > 0))
);


ALTER TABLE persona OWNER TO postgres;

--
-- TOC entry 2456 (class 0 OID 0)
-- Dependencies: 186
-- Name: COLUMN persona.estatus; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN persona.estatus IS '0 activo, 1 inactivo';


--
-- TOC entry 2457 (class 0 OID 0)
-- Dependencies: 186
-- Name: COLUMN persona.estadocivil; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN persona.estadocivil IS '1 = soltero
2 = Casado
3 = Divorciado
4 = Viudo';


--
-- TOC entry 2458 (class 0 OID 0)
-- Dependencies: 186
-- Name: COLUMN persona.genero; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN persona.genero IS '1 = masculino
2 = femenino';


--
-- TOC entry 225 (class 1259 OID 73728)
-- Name: precio; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE precio (
    idproyecto bigint,
    idtipoobra bigint,
    iddetalleetapa bigint,
    costo double precision,
    idprecio bigint DEFAULT nextval('idprecio'::regclass) NOT NULL
);


ALTER TABLE precio OWNER TO postgres;

--
-- TOC entry 190 (class 1259 OID 16439)
-- Name: proveedor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE proveedor (
    idproveedor bigint DEFAULT nextval('idproveedor'::regclass) NOT NULL,
    nombre character varying(100) NOT NULL,
    rif character varying(15) NOT NULL,
    direccion character varying(300) NOT NULL,
    descripcion text NOT NULL,
    estatus integer DEFAULT 0,
    telefono character varying(15)
);


ALTER TABLE proveedor OWNER TO postgres;

--
-- TOC entry 2459 (class 0 OID 0)
-- Dependencies: 190
-- Name: COLUMN proveedor.estatus; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN proveedor.estatus IS 'estatus 0 = activo
estatus 1 = inactivo';


--
-- TOC entry 187 (class 1259 OID 16416)
-- Name: proyecto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE proyecto (
    idproyecto bigint DEFAULT nextval('idproyecto'::regclass) NOT NULL,
    nombre character varying(100) NOT NULL,
    direccion character varying(500) NOT NULL,
    fechainicio date NOT NULL,
    fechafinestimada date NOT NULL,
    fechafin date,
    descripcion text,
    estatus integer DEFAULT 0,
    coordenadas character varying(200),
    presupuesto double precision DEFAULT 0
);


ALTER TABLE proyecto OWNER TO postgres;

--
-- TOC entry 2460 (class 0 OID 0)
-- Dependencies: 187
-- Name: COLUMN proyecto.estatus; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN proyecto.estatus IS 'estatus = 0 en ejecucion
estatus = 1 culminado
estatus = 2 paralizado';


--
-- TOC entry 219 (class 1259 OID 40985)
-- Name: solicitudmaterial; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE solicitudmaterial (
    idsolicitudmaterial bigint DEFAULT nextval('idsolicitudmaterial'::regclass) NOT NULL,
    fechasolicitud date,
    idobra bigint,
    idsubetapa bigint,
    idtrabajador bigint,
    fechaprocesada date,
    estatus integer,
    placa character varying(10),
    marca character varying(100),
    modelo character varying(100),
    chofer character varying(200),
    fechadespacho date,
    retiradopor character varying(200),
    observacion text
);


ALTER TABLE solicitudmaterial OWNER TO postgres;

--
-- TOC entry 210 (class 1259 OID 16705)
-- Name: subetapa; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE subetapa (
    idsubetapa bigint DEFAULT nextval('idsubetapa'::regclass) NOT NULL,
    nombre character varying(50),
    descripcion text,
    porcentaje double precision,
    tiempoestimado integer,
    estatus integer
);


ALTER TABLE subetapa OWNER TO postgres;

--
-- TOC entry 198 (class 1259 OID 16521)
-- Name: tipoobra; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE tipoobra (
    idtipoobra bigint DEFAULT nextval('idtipoobra'::regclass) NOT NULL,
    nombre character varying(100),
    descripcion text,
    montomanoobra double precision,
    montoobra double precision,
    estatus integer
);


ALTER TABLE tipoobra OWNER TO postgres;

--
-- TOC entry 200 (class 1259 OID 16533)
-- Name: trabajador; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE trabajador (
    idtrabajador bigint DEFAULT nextval('idtrabajador'::regclass) NOT NULL,
    idpersona bigint,
    idcargo bigint,
    apodo character varying(50),
    pantalon character varying(5),
    camisa character varying(5),
    botas character varying(5),
    tiposangre character varying(10),
    lumbosacra character varying(50),
    fechaingreso date,
    cantidadhijo integer,
    estatus integer
);


ALTER TABLE trabajador OWNER TO postgres;

--
-- TOC entry 208 (class 1259 OID 16668)
-- Name: trabajadorcuadrilla; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE trabajadorcuadrilla (
    idtrabajadorcuadrilla bigint DEFAULT nextval('idtrabajadorcuadrilla'::regclass) NOT NULL,
    idcuadrilla bigint NOT NULL,
    idtrabajador bigint NOT NULL,
    estatus integer
);


ALTER TABLE trabajadorcuadrilla OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 24576)
-- Name: usuarios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE usuarios (
    idusuario bigint NOT NULL,
    idpersona bigint,
    usuario character varying(50),
    clave character varying(128),
    estatus integer DEFAULT 0,
    fecharegistro timestamp(6) without time zone DEFAULT now()
);


ALTER TABLE usuarios OWNER TO postgres;

--
-- TOC entry 2263 (class 2606 OID 16606)
-- Name: cargo cargo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY cargo
    ADD CONSTRAINT cargo_pkey PRIMARY KEY (idcargo);


--
-- TOC entry 2275 (class 2606 OID 16657)
-- Name: compra compra_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY compra
    ADD CONSTRAINT compra_pkey PRIMARY KEY (idcompra);


--
-- TOC entry 2277 (class 2606 OID 16665)
-- Name: compramaterial compramaterial_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY compramaterial
    ADD CONSTRAINT compramaterial_pkey PRIMARY KEY (idcompramaterial);


--
-- TOC entry 2273 (class 2606 OID 16675)
-- Name: cuadrilla cuadrilla_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY cuadrilla
    ADD CONSTRAINT cuadrilla_pkey PRIMARY KEY (idcuadrilla);


--
-- TOC entry 2283 (class 2606 OID 16720)
-- Name: detalleetapa detalleetapa_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY detalleetapa
    ADD CONSTRAINT detalleetapa_pkey PRIMARY KEY (iddetalleetapa);


--
-- TOC entry 2305 (class 2606 OID 73745)
-- Name: detalleinspeccion detalleinspeccion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY detalleinspeccion
    ADD CONSTRAINT detalleinspeccion_pkey PRIMARY KEY (iddetalleinspeccion);


--
-- TOC entry 2299 (class 2606 OID 41019)
-- Name: detallesolicitud detallesolicitud_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY detallesolicitud
    ADD CONSTRAINT detallesolicitud_pkey PRIMARY KEY (iddetallesolicitud);


--
-- TOC entry 2267 (class 2606 OID 16550)
-- Name: etapa etapa_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY etapa
    ADD CONSTRAINT etapa_pkey PRIMARY KEY (idetapa);


--
-- TOC entry 2301 (class 2606 OID 65543)
-- Name: inspeccion inspeccion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY inspeccion
    ADD CONSTRAINT inspeccion_pkey PRIMARY KEY (idinspeccion);


--
-- TOC entry 2265 (class 2606 OID 16740)
-- Name: material material_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY material
    ADD CONSTRAINT material_pkey PRIMARY KEY (idmaterial);


--
-- TOC entry 2285 (class 2606 OID 16738)
-- Name: materialporobra materialporobra_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY materialporobra
    ADD CONSTRAINT materialporobra_pkey PRIMARY KEY (idmaterialporobra);


--
-- TOC entry 2287 (class 2606 OID 16861)
-- Name: obra obra_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY obra
    ADD CONSTRAINT obra_pkey PRIMARY KEY (idobra);


--
-- TOC entry 2295 (class 2606 OID 24600)
-- Name: permisos permisos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY permisos
    ADD CONSTRAINT permisos_pkey PRIMARY KEY (idusuario, modulo);


--
-- TOC entry 2255 (class 2606 OID 16398)
-- Name: persona persona_cedula_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY persona
    ADD CONSTRAINT persona_cedula_key UNIQUE (cedula);


--
-- TOC entry 2257 (class 2606 OID 16396)
-- Name: persona persona_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY persona
    ADD CONSTRAINT persona_pkey PRIMARY KEY (idpersona);


--
-- TOC entry 2279 (class 2606 OID 16673)
-- Name: trabajadorcuadrilla personacuadrilla_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY trabajadorcuadrilla
    ADD CONSTRAINT personacuadrilla_pkey PRIMARY KEY (idtrabajadorcuadrilla);


--
-- TOC entry 2303 (class 2606 OID 73737)
-- Name: precio precio_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY precio
    ADD CONSTRAINT precio_pkey PRIMARY KEY (idprecio);


--
-- TOC entry 2261 (class 2606 OID 16444)
-- Name: proveedor proveedor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY proveedor
    ADD CONSTRAINT proveedor_pkey PRIMARY KEY (idproveedor);


--
-- TOC entry 2259 (class 2606 OID 16436)
-- Name: proyecto proyecto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY proyecto
    ADD CONSTRAINT proyecto_pkey PRIMARY KEY (idproyecto);


--
-- TOC entry 2297 (class 2606 OID 40989)
-- Name: solicitudmaterial solicitudmaterial_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY solicitudmaterial
    ADD CONSTRAINT solicitudmaterial_pkey PRIMARY KEY (idsolicitudmaterial);


--
-- TOC entry 2281 (class 2606 OID 16713)
-- Name: subetapa subetapa_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY subetapa
    ADD CONSTRAINT subetapa_pkey PRIMARY KEY (idsubetapa);


--
-- TOC entry 2269 (class 2606 OID 16837)
-- Name: tipoobra tipoobra_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tipoobra
    ADD CONSTRAINT tipoobra_pkey PRIMARY KEY (idtipoobra);


--
-- TOC entry 2271 (class 2606 OID 16682)
-- Name: trabajador trabajador_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY trabajador
    ADD CONSTRAINT trabajador_pkey PRIMARY KEY (idtrabajador);


--
-- TOC entry 2289 (class 2606 OID 24584)
-- Name: usuarios usuarios_idpersona_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY usuarios
    ADD CONSTRAINT usuarios_idpersona_key UNIQUE (idpersona);


--
-- TOC entry 2291 (class 2606 OID 24582)
-- Name: usuarios usuarios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (idusuario);


--
-- TOC entry 2293 (class 2606 OID 24595)
-- Name: usuarios usuarios_usuario_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY usuarios
    ADD CONSTRAINT usuarios_usuario_key UNIQUE (usuario);


--
-- TOC entry 2331 (class 2606 OID 73746)
-- Name: detalleinspeccion detalleinspeccion_idinspeccion_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY detalleinspeccion
    ADD CONSTRAINT detalleinspeccion_idinspeccion_fkey FOREIGN KEY (idinspeccion) REFERENCES inspeccion(idinspeccion);


--
-- TOC entry 2324 (class 2606 OID 41025)
-- Name: detallesolicitud detallesolicitud_idmaterial_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY detallesolicitud
    ADD CONSTRAINT detallesolicitud_idmaterial_fkey FOREIGN KEY (idmaterial) REFERENCES material(idmaterial);


--
-- TOC entry 2325 (class 2606 OID 49155)
-- Name: detallesolicitud detallesolicitud_idsolicitudmaterial_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY detallesolicitud
    ADD CONSTRAINT detallesolicitud_idsolicitudmaterial_fkey FOREIGN KEY (idsolicitudmaterial) REFERENCES solicitudmaterial(idsolicitudmaterial) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2307 (class 2606 OID 16806)
-- Name: trabajador idcargo; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY trabajador
    ADD CONSTRAINT idcargo FOREIGN KEY (idcargo) REFERENCES cargo(idcargo);


--
-- TOC entry 2310 (class 2606 OID 16826)
-- Name: compramaterial idcompra; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY compramaterial
    ADD CONSTRAINT idcompra FOREIGN KEY (idcompra) REFERENCES compra(idcompra);


--
-- TOC entry 2312 (class 2606 OID 32792)
-- Name: trabajadorcuadrilla idcuadrilla; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY trabajadorcuadrilla
    ADD CONSTRAINT idcuadrilla FOREIGN KEY (idcuadrilla) REFERENCES cuadrilla(idcuadrilla) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2317 (class 2606 OID 16746)
-- Name: materialporobra iddetalleetapa; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY materialporobra
    ADD CONSTRAINT iddetalleetapa FOREIGN KEY (iddetalleetapa) REFERENCES detalleetapa(iddetalleetapa);


--
-- TOC entry 2314 (class 2606 OID 40960)
-- Name: detalleetapa idetapa; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY detalleetapa
    ADD CONSTRAINT idetapa FOREIGN KEY (idetapa) REFERENCES etapa(idetapa) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2316 (class 2606 OID 16741)
-- Name: materialporobra idmaterial; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY materialporobra
    ADD CONSTRAINT idmaterial FOREIGN KEY (idmaterial) REFERENCES material(idmaterial);


--
-- TOC entry 2311 (class 2606 OID 16831)
-- Name: compramaterial idmaterial; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY compramaterial
    ADD CONSTRAINT idmaterial FOREIGN KEY (idmaterial) REFERENCES material(idmaterial);


--
-- TOC entry 2306 (class 2606 OID 16801)
-- Name: trabajador idpersona; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY trabajador
    ADD CONSTRAINT idpersona FOREIGN KEY (idpersona) REFERENCES persona(idpersona);


--
-- TOC entry 2309 (class 2606 OID 16821)
-- Name: compra idproveedor; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY compra
    ADD CONSTRAINT idproveedor FOREIGN KEY (idproveedor) REFERENCES proveedor(idproveedor);


--
-- TOC entry 2319 (class 2606 OID 16865)
-- Name: obra idproyecto; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY obra
    ADD CONSTRAINT idproyecto FOREIGN KEY (idproyecto) REFERENCES proyecto(idproyecto);


--
-- TOC entry 2315 (class 2606 OID 40965)
-- Name: detalleetapa idsubetapa; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY detalleetapa
    ADD CONSTRAINT idsubetapa FOREIGN KEY (idsubetapa) REFERENCES subetapa(idsubetapa) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2318 (class 2606 OID 16838)
-- Name: materialporobra idtipoobra; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY materialporobra
    ADD CONSTRAINT idtipoobra FOREIGN KEY (idtipoobra) REFERENCES tipoobra(idtipoobra);


--
-- TOC entry 2320 (class 2606 OID 16870)
-- Name: obra idtipoobra; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY obra
    ADD CONSTRAINT idtipoobra FOREIGN KEY (idtipoobra) REFERENCES tipoobra(idtipoobra);


--
-- TOC entry 2308 (class 2606 OID 16882)
-- Name: cuadrilla idtrabajador; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY cuadrilla
    ADD CONSTRAINT idtrabajador FOREIGN KEY (idtrabajador) REFERENCES trabajador(idtrabajador);


--
-- TOC entry 2313 (class 2606 OID 32797)
-- Name: trabajadorcuadrilla idtrabajador; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY trabajadorcuadrilla
    ADD CONSTRAINT idtrabajador FOREIGN KEY (idtrabajador) REFERENCES trabajador(idtrabajador) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2329 (class 2606 OID 65559)
-- Name: inspeccion inspeccion_idcuadrilla_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY inspeccion
    ADD CONSTRAINT inspeccion_idcuadrilla_fkey FOREIGN KEY (idcuadrilla) REFERENCES cuadrilla(idcuadrilla);


--
-- TOC entry 2328 (class 2606 OID 65554)
-- Name: inspeccion inspeccion_iddetalleetapa_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY inspeccion
    ADD CONSTRAINT inspeccion_iddetalleetapa_fkey FOREIGN KEY (iddetalleetapa) REFERENCES detalleetapa(iddetalleetapa);


--
-- TOC entry 2327 (class 2606 OID 65549)
-- Name: inspeccion inspeccion_idobra_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY inspeccion
    ADD CONSTRAINT inspeccion_idobra_fkey FOREIGN KEY (idobra) REFERENCES obra(idobra);


--
-- TOC entry 2326 (class 2606 OID 65544)
-- Name: inspeccion inspeccion_idproyecto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY inspeccion
    ADD CONSTRAINT inspeccion_idproyecto_fkey FOREIGN KEY (idproyecto) REFERENCES proyecto(idproyecto);


--
-- TOC entry 2330 (class 2606 OID 73731)
-- Name: precio precio_idproyecto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY precio
    ADD CONSTRAINT precio_idproyecto_fkey FOREIGN KEY (idproyecto) REFERENCES proyecto(idproyecto);


--
-- TOC entry 2321 (class 2606 OID 40995)
-- Name: solicitudmaterial solicitudmaterial_idobra_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY solicitudmaterial
    ADD CONSTRAINT solicitudmaterial_idobra_fkey FOREIGN KEY (idobra) REFERENCES obra(idobra);


--
-- TOC entry 2322 (class 2606 OID 41000)
-- Name: solicitudmaterial solicitudmaterial_idsubetapa_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY solicitudmaterial
    ADD CONSTRAINT solicitudmaterial_idsubetapa_fkey FOREIGN KEY (idsubetapa) REFERENCES subetapa(idsubetapa);


--
-- TOC entry 2323 (class 2606 OID 41005)
-- Name: solicitudmaterial solicitudmaterial_idtrabajador_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY solicitudmaterial
    ADD CONSTRAINT solicitudmaterial_idtrabajador_fkey FOREIGN KEY (idtrabajador) REFERENCES trabajador(idtrabajador);


-- Completed on 2017-09-12 14:45:18

--
-- PostgreSQL database dump complete
--

