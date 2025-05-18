--
-- PostgreSQL database dump
--

-- Dumped from database version 14.17 (Homebrew)
-- Dumped by pg_dump version 14.17 (Homebrew)

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: johnplough
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.ar_internal_metadata OWNER TO johnplough;

--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: johnplough
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


ALTER TABLE public.schema_migrations OWNER TO johnplough;

--
-- Name: scores; Type: TABLE; Schema: public; Owner: johnplough
--

CREATE TABLE public.scores (
    id bigint NOT NULL,
    value integer,
    user_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.scores OWNER TO johnplough;

--
-- Name: scores_id_seq; Type: SEQUENCE; Schema: public; Owner: johnplough
--

CREATE SEQUENCE public.scores_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.scores_id_seq OWNER TO johnplough;

--
-- Name: scores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: johnplough
--

ALTER SEQUENCE public.scores_id_seq OWNED BY public.scores.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: johnplough
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    username character varying,
    email character varying,
    password_digest character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    google_uid character varying,
    github_uid character varying
);


ALTER TABLE public.users OWNER TO johnplough;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: johnplough
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO johnplough;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: johnplough
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: scores id; Type: DEFAULT; Schema: public; Owner: johnplough
--

ALTER TABLE ONLY public.scores ALTER COLUMN id SET DEFAULT nextval('public.scores_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: johnplough
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: ar_internal_metadata; Type: TABLE DATA; Schema: public; Owner: johnplough
--

COPY public.ar_internal_metadata (key, value, created_at, updated_at) FROM stdin;
environment	development	2025-05-18 18:12:24.925454	2025-05-18 18:12:24.925456
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: johnplough
--

COPY public.schema_migrations (version) FROM stdin;
20250517232946
20250517232947
20250517232948
20250517232949
20250518182127
20250518182128
20250518182129
\.


--
-- Data for Name: scores; Type: TABLE DATA; Schema: public; Owner: johnplough
--

COPY public.scores (id, value, user_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: johnplough
--

COPY public.users (id, username, email, password_digest, created_at, updated_at, google_uid, github_uid) FROM stdin;
\.


--
-- Name: scores_id_seq; Type: SEQUENCE SET; Schema: public; Owner: johnplough
--

SELECT pg_catalog.setval('public.scores_id_seq', 1, false);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: johnplough
--

SELECT pg_catalog.setval('public.users_id_seq', 1, false);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: johnplough
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: johnplough
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: scores scores_pkey; Type: CONSTRAINT; Schema: public; Owner: johnplough
--

ALTER TABLE ONLY public.scores
    ADD CONSTRAINT scores_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: johnplough
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_scores_on_user_id; Type: INDEX; Schema: public; Owner: johnplough
--

CREATE INDEX index_scores_on_user_id ON public.scores USING btree (user_id);


--
-- Name: index_users_on_github_uid; Type: INDEX; Schema: public; Owner: johnplough
--

CREATE UNIQUE INDEX index_users_on_github_uid ON public.users USING btree (github_uid);


--
-- Name: index_users_on_google_uid; Type: INDEX; Schema: public; Owner: johnplough
--

CREATE UNIQUE INDEX index_users_on_google_uid ON public.users USING btree (google_uid);


--
-- Name: scores fk_rails_f5dcd5d06f; Type: FK CONSTRAINT; Schema: public; Owner: johnplough
--

ALTER TABLE ONLY public.scores
    ADD CONSTRAINT fk_rails_f5dcd5d06f FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

