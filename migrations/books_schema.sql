--
-- PostgreSQL database dump
--

\restrict ELOr5Ldx02aWij9bDIdJIPxCtYLK9UxglsxkeqLhUlnp0G5ieLPgpLx8dknoHL3

-- Dumped from database version 18.1
-- Dumped by pg_dump version 18.1

-- Started on 2025-11-24 22:13:11

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
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
-- TOC entry 220 (class 1259 OID 16390)
-- Name: books; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.books (
    book_id integer NOT NULL,
    title character varying(500) NOT NULL,
    price numeric(10,2),
    genre character varying(100),
    stock_quantity integer DEFAULT 0,
    last_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.books OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16389)
-- Name: books_book_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.books_book_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.books_book_id_seq OWNER TO postgres;

--
-- TOC entry 4930 (class 0 OID 0)
-- Dependencies: 219
-- Name: books_book_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.books_book_id_seq OWNED BY public.books.book_id;


--
-- TOC entry 222 (class 1259 OID 24603)
-- Name: books_processed; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.books_processed (
    processed_id integer NOT NULL,
    book_id integer NOT NULL,
    title character varying(500) NOT NULL,
    original_price numeric(10,2),
    rounded_price numeric(10,1),
    genre character varying(100),
    price_category text,
    processed_at timestamp with time zone DEFAULT now(),
    CONSTRAINT books_processed_price_category_check CHECK ((price_category = ANY (ARRAY['budget'::text, 'premium'::text])))
);


ALTER TABLE public.books_processed OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 24602)
-- Name: books_processed_processed_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.books_processed_processed_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.books_processed_processed_id_seq OWNER TO postgres;

--
-- TOC entry 4931 (class 0 OID 0)
-- Dependencies: 221
-- Name: books_processed_processed_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.books_processed_processed_id_seq OWNED BY public.books_processed.processed_id;


--
-- TOC entry 4760 (class 2604 OID 16393)
-- Name: books book_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.books ALTER COLUMN book_id SET DEFAULT nextval('public.books_book_id_seq'::regclass);


--
-- TOC entry 4763 (class 2604 OID 24606)
-- Name: books_processed processed_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.books_processed ALTER COLUMN processed_id SET DEFAULT nextval('public.books_processed_processed_id_seq'::regclass);


--
-- TOC entry 4922 (class 0 OID 16390)
-- Dependencies: 220
-- Data for Name: books; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.books (book_id, title, price, genre, stock_quantity, last_updated) FROM stdin;
11	Мандрівник між зірками	245.50	фантастика	12	2025-11-23 20:30:58.17599+02
12	Смак дикої кави	320.00	кулінарія	5	2025-11-23 20:30:58.17599+02
13	Таємниці старого міста	780.99	детектив	8	2025-11-23 20:30:58.17599+02
14	Анатомія спокою	210.75	психологія	3	2025-11-23 20:30:58.17599+02
15	Архітектори майбутнього	505.40	наука	20	2025-01-22 16:35:00+02
16	Шепіт забутих долин	690.10	пригоди	1	2025-01-22 16:35:00+02
\.


--
-- TOC entry 4924 (class 0 OID 24603)
-- Dependencies: 222
-- Data for Name: books_processed; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.books_processed (processed_id, book_id, title, original_price, rounded_price, genre, price_category, processed_at) FROM stdin;
\.


--
-- TOC entry 4932 (class 0 OID 0)
-- Dependencies: 219
-- Name: books_book_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.books_book_id_seq', 16, true);


--
-- TOC entry 4933 (class 0 OID 0)
-- Dependencies: 221
-- Name: books_processed_processed_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.books_processed_processed_id_seq', 75, true);


--
-- TOC entry 4767 (class 2606 OID 16401)
-- Name: books books_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.books
    ADD CONSTRAINT books_pkey PRIMARY KEY (book_id);


--
-- TOC entry 4772 (class 2606 OID 24614)
-- Name: books_processed books_processed_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.books_processed
    ADD CONSTRAINT books_processed_pkey PRIMARY KEY (processed_id);


--
-- TOC entry 4768 (class 1259 OID 24577)
-- Name: idx_books_genre; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_books_genre ON public.books USING btree (genre) WITH (deduplicate_items='true');


--
-- TOC entry 4769 (class 1259 OID 24578)
-- Name: idx_books_last_updated ; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "idx_books_last_updated " ON public.books USING btree (last_updated) WITH (deduplicate_items='true');


--
-- TOC entry 4770 (class 1259 OID 24579)
-- Name: idx_books_price_range ; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "idx_books_price_range " ON public.books USING btree (price) WITH (deduplicate_items='true');


--
-- TOC entry 4773 (class 2606 OID 24615)
-- Name: books_processed processed_book_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.books_processed
    ADD CONSTRAINT processed_book_fk FOREIGN KEY (book_id) REFERENCES public.books(book_id) ON DELETE CASCADE;


-- Completed on 2025-11-24 22:13:12

--
-- PostgreSQL database dump complete
--

\unrestrict ELOr5Ldx02aWij9bDIdJIPxCtYLK9UxglsxkeqLhUlnp0G5ieLPgpLx8dknoHL3

