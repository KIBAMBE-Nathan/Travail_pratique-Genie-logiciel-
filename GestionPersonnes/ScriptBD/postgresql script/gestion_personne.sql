--
-- PostgreSQL database dump
--

-- Dumped from database version 15.6
-- Dumped by pg_dump version 15.6

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
-- Name: sp_delete_etudiant(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_delete_etudiant(in_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF EXISTS(SELECT * FROM etudiant WHERE id = in_id) THEN
        DELETE FROM etudiant WHERE id = in_id;
    END IF;
END;
$$;


ALTER FUNCTION public.sp_delete_etudiant(in_id integer) OWNER TO postgres;

--
-- Name: sp_delete_telephone(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_delete_telephone(in_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF EXISTS(SELECT * FROM telephone WHERE id = in_id) THEN
        DELETE FROM telephone WHERE id = in_id;
    END IF;
END;
$$;


ALTER FUNCTION public.sp_delete_telephone(in_id integer) OWNER TO postgres;

--
-- Name: sp_insert_etudiant(integer, character varying, character varying, character varying, character, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_insert_etudiant(in_id integer, in_nom character varying, in_postnom character varying, in_prenom character varying, in_sexe character, in_matricule character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NOT EXISTS(SELECT * FROM etudiant WHERE id = in_id) THEN
        INSERT INTO etudiant(id, nom, postnom, prenom, sexe, matricule) 
        VALUES (in_id, in_nom, in_postnom, in_prenom, in_sexe, in_matricule);
    ELSE
        UPDATE etudiant 
        SET nom = in_nom, postnom = in_postnom, prenom = in_prenom, sexe = in_sexe, matricule = in_matricule 
        WHERE id = in_id;
    END IF;
END;
$$;


ALTER FUNCTION public.sp_insert_etudiant(in_id integer, in_nom character varying, in_postnom character varying, in_prenom character varying, in_sexe character, in_matricule character varying) OWNER TO postgres;

--
-- Name: sp_insert_telephone(integer, integer, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_insert_telephone(in_id integer, in_id_proprietaire integer, in_initial character varying, in_numero character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NOT EXISTS(SELECT * FROM telephone WHERE id = in_id) THEN
        INSERT INTO telephone(id, id_proprietaire, initial, numero) 
        VALUES (in_id, in_id_proprietaire, in_initial, in_numero);
    ELSE
        UPDATE telephone 
        SET id_proprietaire = in_id_proprietaire, initial = in_initial, numero = in_numero 
        WHERE id = in_id;
    END IF;
END;
$$;


ALTER FUNCTION public.sp_insert_telephone(in_id integer, in_id_proprietaire integer, in_initial character varying, in_numero character varying) OWNER TO postgres;

--
-- Name: sp_liste_etudiants(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_liste_etudiants() RETURNS TABLE(id integer, nom text, sexe character, idtel integer, numero text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY 
        SELECT e.id, e.nom || ' ' || COALESCE(e.postnom, '') || ' ' || COALESCE(e.prenom, '') AS nom,
    e.sexe, t.id AS idtel, t.initial || t.numero AS numero
    FROM etudiant e
    LEFT OUTER JOIN telephone t
    ON e.id = t.id_proprietaire;
END;
$$;


ALTER FUNCTION public.sp_liste_etudiants() OWNER TO postgres;

--
-- Name: sp_select_etudiant(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_select_etudiant() RETURNS TABLE(id integer, nom character varying, postnom character varying, prenom character varying, sexe character, matricule character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY SELECT id, nom, postnom, prenom, sexe, matricule FROM etudiant ORDER BY nom ASC;
END;
$$;


ALTER FUNCTION public.sp_select_etudiant() OWNER TO postgres;

--
-- Name: sp_select_etudiants(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_select_etudiants(in_id integer) RETURNS TABLE(id integer, nom character varying, postnom character varying, prenom character varying, sexe character, matricule character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY SELECT id, nom, postnom, prenom, sexe, matricule FROM etudiant WHERE id = in_id;
END;
$$;


ALTER FUNCTION public.sp_select_etudiants(in_id integer) OWNER TO postgres;

--
-- Name: sp_select_telephone(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_select_telephone(in_id integer) RETURNS TABLE(id integer, id_proprietaire integer, initial character varying, numero character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY SELECT id, id_proprietaire, initial, numero FROM telephone WHERE id = in_id;
END;
$$;


ALTER FUNCTION public.sp_select_telephone(in_id integer) OWNER TO postgres;

--
-- Name: sp_select_telephones(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_select_telephones() RETURNS TABLE(id integer, id_proprietaire integer, initial character varying, numero character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY SELECT id, id_proprietaire, initial, numero FROM telephone ORDER BY numero ASC;
END;
$$;


ALTER FUNCTION public.sp_select_telephones() OWNER TO postgres;

--
-- Name: sp_select_telephones_personne(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_select_telephones_personne(in_id_personne integer) RETURNS TABLE(id integer, id_proprietaire integer, initial character varying, numero character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY SELECT id, id_proprietaire, initial, numero FROM telephone WHERE id_proprietaire = in_id_personne ORDER BY numero ASC;
END;
$$;


ALTER FUNCTION public.sp_select_telephones_personne(in_id_personne integer) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: adresse; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.adresse (
    id integer NOT NULL,
    quartier character varying(50),
    commune character varying(50),
    ville character varying(50),
    pays character varying(50) NOT NULL
);


ALTER TABLE public.adresse OWNER TO postgres;

--
-- Name: adresse_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.adresse_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.adresse_id_seq OWNER TO postgres;

--
-- Name: adresse_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.adresse_id_seq OWNED BY public.adresse.id;


--
-- Name: domicile; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.domicile (
    id integer NOT NULL,
    id_personne integer NOT NULL,
    id_adresse integer NOT NULL,
    avenue character varying(50),
    numero_avenue integer
);


ALTER TABLE public.domicile OWNER TO postgres;

--
-- Name: domicile_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.domicile_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.domicile_id_seq OWNER TO postgres;

--
-- Name: domicile_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.domicile_id_seq OWNED BY public.domicile.id;


--
-- Name: etudiant; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.etudiant (
    id integer NOT NULL,
    nom character varying(50) NOT NULL,
    postnom character varying(50),
    prenom character varying(50),
    sexe character(1) DEFAULT 'M'::bpchar NOT NULL,
    matricule character varying(20)
);


ALTER TABLE public.etudiant OWNER TO postgres;

--
-- Name: etudiant_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.etudiant_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.etudiant_id_seq OWNER TO postgres;

--
-- Name: etudiant_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.etudiant_id_seq OWNED BY public.etudiant.id;


--
-- Name: telephone; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.telephone (
    id integer NOT NULL,
    id_proprietaire integer NOT NULL,
    initial character varying(4) NOT NULL,
    numero character varying(9) NOT NULL
);


ALTER TABLE public.telephone OWNER TO postgres;

--
-- Name: telephone_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.telephone_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.telephone_id_seq OWNER TO postgres;

--
-- Name: telephone_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.telephone_id_seq OWNED BY public.telephone.id;


--
-- Name: adresse id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adresse ALTER COLUMN id SET DEFAULT nextval('public.adresse_id_seq'::regclass);


--
-- Name: domicile id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.domicile ALTER COLUMN id SET DEFAULT nextval('public.domicile_id_seq'::regclass);


--
-- Name: etudiant id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.etudiant ALTER COLUMN id SET DEFAULT nextval('public.etudiant_id_seq'::regclass);


--
-- Name: telephone id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.telephone ALTER COLUMN id SET DEFAULT nextval('public.telephone_id_seq'::regclass);


--
-- Data for Name: adresse; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.adresse (id, quartier, commune, ville, pays) FROM stdin;
\.


--
-- Data for Name: domicile; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.domicile (id, id_personne, id_adresse, avenue, numero_avenue) FROM stdin;
\.


--
-- Data for Name: etudiant; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.etudiant (id, nom, postnom, prenom, sexe, matricule) FROM stdin;
1	Isamuna	Nkembo	Josue	M	22LIAGELJ253
2	Kibambe	Kabululu	Nathan	M	22LIAGELJ620114
3	Kyakimwa	Ndivito	Milka	F	22LIAGELJ620354
\.


--
-- Data for Name: telephone; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.telephone (id, id_proprietaire, initial, numero) FROM stdin;
1	1	+250	785623146
3	2	+243	985645235
4	3	+243	815790584
5	3	+242	808256231
\.


--
-- Name: adresse_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.adresse_id_seq', 1, false);


--
-- Name: domicile_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.domicile_id_seq', 1, false);


--
-- Name: etudiant_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.etudiant_id_seq', 1, false);


--
-- Name: telephone_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.telephone_id_seq', 1, false);


--
-- Name: adresse adresse_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adresse
    ADD CONSTRAINT adresse_pkey PRIMARY KEY (id);


--
-- Name: domicile domicile_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.domicile
    ADD CONSTRAINT domicile_pkey PRIMARY KEY (id);


--
-- Name: etudiant etudiant_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.etudiant
    ADD CONSTRAINT etudiant_pkey PRIMARY KEY (id);


--
-- Name: telephone telephone_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.telephone
    ADD CONSTRAINT telephone_pkey PRIMARY KEY (id);


--
-- Name: etudiant uk_personne; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.etudiant
    ADD CONSTRAINT uk_personne UNIQUE (nom, postnom, prenom);


--
-- Name: domicile fk_addresse_domicile; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.domicile
    ADD CONSTRAINT fk_addresse_domicile FOREIGN KEY (id_adresse) REFERENCES public.adresse(id);


--
-- Name: domicile fk_personne_domicile; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.domicile
    ADD CONSTRAINT fk_personne_domicile FOREIGN KEY (id_personne) REFERENCES public.etudiant(id);


--
-- Name: telephone fk_personne_telephone; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.telephone
    ADD CONSTRAINT fk_personne_telephone FOREIGN KEY (id_proprietaire) REFERENCES public.etudiant(id);


--
-- PostgreSQL database dump complete
--

