--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


--
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: admissions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE admissions (
    id integer NOT NULL,
    patient_id integer,
    bed character varying(255),
    ward character varying(255),
    diagnosis_1 character varying(255),
    diagnosis_2 character varying(255),
    meds character varying(255),
    weight_admission double precision,
    weight_discharge double precision,
    date timestamp without time zone,
    discharge_date timestamp without time zone,
    discharge_status character varying(255),
    comments character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    provider_id integer
);


--
-- Name: admissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE admissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: admissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE admissions_id_seq OWNED BY admissions.id;


--
-- Name: diagnoses; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE diagnoses (
    id integer NOT NULL,
    name character varying(255),
    label character varying(255),
    synonyms character varying(255),
    comments character varying(255),
    show_visits boolean,
    sort_order integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    with_comment boolean
);


--
-- Name: diagnoses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE diagnoses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: diagnoses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE diagnoses_id_seq OWNED BY diagnoses.id;


--
-- Name: drug_preps; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE drug_preps (
    id integer NOT NULL,
    drug_id integer,
    xform character varying(255),
    strength character varying(255),
    mult double precision,
    quantity character varying(255),
    buy_price double precision,
    stock double precision,
    synonyms character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: drug_preps_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE drug_preps_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: drug_preps_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE drug_preps_id_seq OWNED BY drug_preps.id;


--
-- Name: drugs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE drugs (
    id integer NOT NULL,
    name character varying(255),
    drug_class character varying(255),
    drug_subclass character varying(255),
    synonyms character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: drugs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE drugs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: drugs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE drugs_id_seq OWNED BY drugs.id;


--
-- Name: icd9s; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE icd9s (
    id integer NOT NULL,
    icd9 character varying(255),
    mod character varying(255),
    description character varying(255),
    short_descr character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: icd9s_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE icd9s_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: icd9s_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE icd9s_id_seq OWNED BY icd9s.id;


--
-- Name: immunizations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE immunizations (
    id integer NOT NULL,
    patient_id integer,
    bcg date,
    opv1 date,
    opv2 date,
    opv3 date,
    opv4 date,
    dpt1 date,
    dpt2 date,
    dpt3 date,
    dpt4 date,
    tt1 date,
    tt2 date,
    tt3 date,
    tt4 date,
    hepb1 date,
    hepb2 date,
    hepb3 date,
    hepb4 date,
    measles1 date,
    measles2 date,
    mmr1 date,
    mmr2 date,
    hib1 date,
    hib2 date,
    hib3 date,
    hib4 date,
    mening date,
    pneumo date,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    provider_id integer
);


--
-- Name: immunizations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE immunizations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: immunizations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE immunizations_id_seq OWNED BY immunizations.id;


--
-- Name: lab_groups; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE lab_groups (
    id integer NOT NULL,
    name character varying(255),
    abbrev character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: lab_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE lab_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: lab_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE lab_groups_id_seq OWNED BY lab_groups.id;


--
-- Name: lab_requests; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE lab_requests (
    id integer NOT NULL,
    provider_id integer,
    patient_id integer,
    comments character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    date timestamp without time zone
);


--
-- Name: lab_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE lab_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: lab_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE lab_requests_id_seq OWNED BY lab_requests.id;


--
-- Name: lab_results; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE lab_results (
    id integer NOT NULL,
    lab_request_id integer,
    lab_service_id integer,
    result character varying(255),
    date timestamp without time zone,
    status character varying(255),
    abnormal boolean,
    panic boolean,
    comments character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: lab_results_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE lab_results_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: lab_results_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE lab_results_id_seq OWNED BY lab_results.id;


--
-- Name: lab_services; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE lab_services (
    id integer NOT NULL,
    name character varying(255),
    abbrev character varying(255),
    unit character varying(255),
    normal_range character varying(255),
    lab_group_id integer,
    cost double precision,
    comments character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: lab_services_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE lab_services_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: lab_services_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE lab_services_id_seq OWNED BY lab_services.id;


--
-- Name: labs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE labs (
    id integer NOT NULL,
    patient_id integer,
    categories character varying(255),
    date timestamp without time zone,
    wbc integer,
    neut integer,
    lymph integer,
    bands integer,
    eos integer,
    hct integer,
    retic double precision,
    esr integer,
    platelets integer,
    malaria_smear character varying(255),
    csf_rbc integer,
    csf_wbc integer,
    csf_lymph integer,
    csf_neut integer,
    csf_protein integer,
    csf_glucose character varying(255),
    csf_culture character varying(255),
    blood_glucose integer,
    urinalysis character varying(255),
    bili double precision,
    hiv_screen character varying(255),
    hiv_antigen character varying(255),
    wb character varying(255),
    mantoux character varying(255),
    hb_elect character varying(255),
    other character varying(255),
    creat double precision,
    cd4 integer,
    cd4pct integer,
    amylase integer,
    sgpt integer,
    sgot integer,
    hbsag boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    provider_id integer,
    comment_hct character varying(255),
    comment_cd4 character varying(255)
);


--
-- Name: labs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE labs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: labs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE labs_id_seq OWNED BY labs.id;


--
-- Name: patients; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE patients (
    id integer NOT NULL,
    first_name character varying(255),
    last_name character varying(255),
    other_names character varying(255),
    birth_date timestamp without time zone,
    death_date date,
    birth_date_exact boolean,
    ident character varying(255),
    sex character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    residence character varying(255),
    phone character varying(255),
    caregiver character varying(255),
    hiv_status character varying(255),
    maternal_hiv_status character varying(255),
    allergies character varying(255),
    hemoglobin_type character varying(255),
    comments character varying(255)
);


--
-- Name: patients_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE patients_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: patients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE patients_id_seq OWNED BY patients.id;


--
-- Name: photos; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE photos (
    id integer NOT NULL,
    patient_id integer,
    date timestamp without time zone,
    comments character varying(255),
    content_type character varying(255),
    name_string character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: photos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE photos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: photos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE photos_id_seq OWNED BY photos.id;


--
-- Name: physicals; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE physicals (
    id integer NOT NULL,
    name character varying(255),
    label character varying(255),
    synonyms character varying(255),
    comments character varying(255),
    sort_order integer,
    show_visits boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    with_comment boolean
);


--
-- Name: physicals_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE physicals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: physicals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE physicals_id_seq OWNED BY physicals.id;


--
-- Name: pictures; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE pictures (
    id integer NOT NULL,
    patient_id integer,
    comment character varying(255),
    name character varying(255),
    content_type character varying(255),
    date timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: pictures_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pictures_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pictures_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pictures_id_seq OWNED BY pictures.id;


--
-- Name: prescription_items; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE prescription_items (
    id integer NOT NULL,
    drug character varying(255),
    prescription_id integer,
    dose character varying(255),
    unit character varying(255),
    route character varying(255),
    "interval" integer,
    use_liquid boolean,
    liquid integer,
    duration integer,
    other_description character varying(255),
    other_instructions character varying(255),
    filled boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: prescription_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE prescription_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: prescription_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE prescription_items_id_seq OWNED BY prescription_items.id;


--
-- Name: prescriptions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE prescriptions (
    id integer NOT NULL,
    patient_id integer,
    provider_id integer,
    date timestamp without time zone,
    filled boolean,
    confirmed boolean,
    void boolean,
    weight double precision,
    height double precision,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: prescriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE prescriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: prescriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE prescriptions_id_seq OWNED BY prescriptions.id;


--
-- Name: problems; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE problems (
    id integer NOT NULL,
    description character varying(255),
    date timestamp without time zone,
    resolved timestamp without time zone,
    patient_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: problems_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE problems_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: problems_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE problems_id_seq OWNED BY problems.id;


--
-- Name: providers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE providers (
    id integer NOT NULL,
    last_name character varying(255),
    first_name character varying(255),
    other_names character varying(255),
    ident character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: providers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE providers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: providers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE providers_id_seq OWNED BY providers.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: symptoms; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE symptoms (
    id integer NOT NULL,
    name character varying(255),
    label character varying(255),
    synonyms character varying(255),
    comments character varying(255),
    show_visits boolean,
    sort_order integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    with_comment boolean
);


--
-- Name: symptoms_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE symptoms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: symptoms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE symptoms_id_seq OWNED BY symptoms.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying(255) DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying(255) DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying(255),
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying(255),
    last_sign_in_ip character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    username character varying(255),
    name character varying(255),
    full_name character varying(255),
    time_zone character varying(255)
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: visits; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE visits (
    id integer NOT NULL,
    patient_id integer,
    date timestamp without time zone,
    next_visit timestamp without time zone,
    dx character varying(255),
    dx2 character varying(255),
    comments character varying(255),
    weight double precision,
    height double precision,
    head_circ double precision,
    meds character varying(255),
    newdx boolean,
    newpt boolean,
    adm boolean,
    sbp integer,
    dbp integer,
    scheduled boolean,
    provider_id integer,
    hiv_stage character varying(255),
    arv_status character varying(255),
    anti_tb_status character varying(255),
    reg_zidovudine boolean,
    reg_stavudine boolean,
    reg_lamivudine boolean,
    reg_didanosine boolean,
    reg_nevirapine boolean,
    reg_efavirenz boolean,
    reg_kaletra boolean,
    hpi text,
    temperature double precision,
    development text,
    assessment text,
    plan text,
    mid_arm_circ double precision,
    resp_rate integer,
    heart_rate integer,
    phys_exam text,
    diet_breast boolean,
    diet_breastmilk_substitute boolean,
    diet_pap boolean,
    diet_solids boolean,
    assessment_stable boolean,
    assessment_opportunistic_infection boolean,
    assessment_drug_toxicity boolean,
    assessment_non_adherence boolean,
    arv_missed integer,
    arv_missed_week integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    arv_regimen character varying(255),
    symptoms hstore,
    physical hstore,
    diagnoses hstore,
    other_symptoms character varying(255)
);


--
-- Name: visits_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE visits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: visits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE visits_id_seq OWNED BY visits.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY admissions ALTER COLUMN id SET DEFAULT nextval('admissions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY diagnoses ALTER COLUMN id SET DEFAULT nextval('diagnoses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY drug_preps ALTER COLUMN id SET DEFAULT nextval('drug_preps_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY drugs ALTER COLUMN id SET DEFAULT nextval('drugs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY icd9s ALTER COLUMN id SET DEFAULT nextval('icd9s_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY immunizations ALTER COLUMN id SET DEFAULT nextval('immunizations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY lab_groups ALTER COLUMN id SET DEFAULT nextval('lab_groups_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY lab_requests ALTER COLUMN id SET DEFAULT nextval('lab_requests_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY lab_results ALTER COLUMN id SET DEFAULT nextval('lab_results_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY lab_services ALTER COLUMN id SET DEFAULT nextval('lab_services_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY labs ALTER COLUMN id SET DEFAULT nextval('labs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY patients ALTER COLUMN id SET DEFAULT nextval('patients_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY photos ALTER COLUMN id SET DEFAULT nextval('photos_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY physicals ALTER COLUMN id SET DEFAULT nextval('physicals_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pictures ALTER COLUMN id SET DEFAULT nextval('pictures_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY prescription_items ALTER COLUMN id SET DEFAULT nextval('prescription_items_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY prescriptions ALTER COLUMN id SET DEFAULT nextval('prescriptions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY problems ALTER COLUMN id SET DEFAULT nextval('problems_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY providers ALTER COLUMN id SET DEFAULT nextval('providers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY symptoms ALTER COLUMN id SET DEFAULT nextval('symptoms_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY visits ALTER COLUMN id SET DEFAULT nextval('visits_id_seq'::regclass);


--
-- Name: admissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY admissions
    ADD CONSTRAINT admissions_pkey PRIMARY KEY (id);


--
-- Name: diagnoses_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY diagnoses
    ADD CONSTRAINT diagnoses_pkey PRIMARY KEY (id);


--
-- Name: drug_preps_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY drug_preps
    ADD CONSTRAINT drug_preps_pkey PRIMARY KEY (id);


--
-- Name: drugs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY drugs
    ADD CONSTRAINT drugs_pkey PRIMARY KEY (id);


--
-- Name: icd9s_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY icd9s
    ADD CONSTRAINT icd9s_pkey PRIMARY KEY (id);


--
-- Name: immunizations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY immunizations
    ADD CONSTRAINT immunizations_pkey PRIMARY KEY (id);


--
-- Name: lab_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY lab_groups
    ADD CONSTRAINT lab_groups_pkey PRIMARY KEY (id);


--
-- Name: lab_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY lab_requests
    ADD CONSTRAINT lab_requests_pkey PRIMARY KEY (id);


--
-- Name: lab_results_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY lab_results
    ADD CONSTRAINT lab_results_pkey PRIMARY KEY (id);


--
-- Name: lab_services_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY lab_services
    ADD CONSTRAINT lab_services_pkey PRIMARY KEY (id);


--
-- Name: labs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY labs
    ADD CONSTRAINT labs_pkey PRIMARY KEY (id);


--
-- Name: patients_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY patients
    ADD CONSTRAINT patients_pkey PRIMARY KEY (id);


--
-- Name: photos_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY photos
    ADD CONSTRAINT photos_pkey PRIMARY KEY (id);


--
-- Name: physicals_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY physicals
    ADD CONSTRAINT physicals_pkey PRIMARY KEY (id);


--
-- Name: pictures_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY pictures
    ADD CONSTRAINT pictures_pkey PRIMARY KEY (id);


--
-- Name: prescription_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY prescription_items
    ADD CONSTRAINT prescription_items_pkey PRIMARY KEY (id);


--
-- Name: prescriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY prescriptions
    ADD CONSTRAINT prescriptions_pkey PRIMARY KEY (id);


--
-- Name: problems_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY problems
    ADD CONSTRAINT problems_pkey PRIMARY KEY (id);


--
-- Name: providers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY providers
    ADD CONSTRAINT providers_pkey PRIMARY KEY (id);


--
-- Name: symptoms_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY symptoms
    ADD CONSTRAINT symptoms_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: visits_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY visits
    ADD CONSTRAINT visits_pkey PRIMARY KEY (id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: visits_diagnoses; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX visits_diagnoses ON visits USING gin (diagnoses);


--
-- Name: visits_exam; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX visits_exam ON visits USING gin (physical);


--
-- Name: visits_symptoms; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX visits_symptoms ON visits USING gin (symptoms);


--
-- PostgreSQL database dump complete
--

INSERT INTO schema_migrations (version) VALUES ('20121201135352');

INSERT INTO schema_migrations (version) VALUES ('20121203104957');

INSERT INTO schema_migrations (version) VALUES ('20121203133041');

INSERT INTO schema_migrations (version) VALUES ('20121204191536');

INSERT INTO schema_migrations (version) VALUES ('20121204220422');

INSERT INTO schema_migrations (version) VALUES ('20121205085247');

INSERT INTO schema_migrations (version) VALUES ('20121205085332');

INSERT INTO schema_migrations (version) VALUES ('20121205085538');

INSERT INTO schema_migrations (version) VALUES ('20121205085802');

INSERT INTO schema_migrations (version) VALUES ('20121205090007');

INSERT INTO schema_migrations (version) VALUES ('20121205090537');

INSERT INTO schema_migrations (version) VALUES ('20121205091114');

INSERT INTO schema_migrations (version) VALUES ('20121205092423');

INSERT INTO schema_migrations (version) VALUES ('20121205093010');

INSERT INTO schema_migrations (version) VALUES ('20121205154359');

INSERT INTO schema_migrations (version) VALUES ('20121205162315');

INSERT INTO schema_migrations (version) VALUES ('20121205182645');

INSERT INTO schema_migrations (version) VALUES ('20121206132646');

INSERT INTO schema_migrations (version) VALUES ('20121206163057');

INSERT INTO schema_migrations (version) VALUES ('20121207150245');

INSERT INTO schema_migrations (version) VALUES ('20121209073113');

INSERT INTO schema_migrations (version) VALUES ('20121209074229');

INSERT INTO schema_migrations (version) VALUES ('20121211131634');

INSERT INTO schema_migrations (version) VALUES ('20121211132334');

INSERT INTO schema_migrations (version) VALUES ('20121211152638');

INSERT INTO schema_migrations (version) VALUES ('20121212051045');

INSERT INTO schema_migrations (version) VALUES ('20121212071856');

INSERT INTO schema_migrations (version) VALUES ('20121212083226');

INSERT INTO schema_migrations (version) VALUES ('20121212091418');

INSERT INTO schema_migrations (version) VALUES ('20121212222403');

INSERT INTO schema_migrations (version) VALUES ('20121213091234');

INSERT INTO schema_migrations (version) VALUES ('20121213110012');

INSERT INTO schema_migrations (version) VALUES ('20121216130832');

INSERT INTO schema_migrations (version) VALUES ('20121219111138');

INSERT INTO schema_migrations (version) VALUES ('20121219124115');

INSERT INTO schema_migrations (version) VALUES ('20121222123656');

INSERT INTO schema_migrations (version) VALUES ('20121230204531');

INSERT INTO schema_migrations (version) VALUES ('20130110205707');

INSERT INTO schema_migrations (version) VALUES ('20130112135236');

INSERT INTO schema_migrations (version) VALUES ('20130112140006');

INSERT INTO schema_migrations (version) VALUES ('20130112140625');

INSERT INTO schema_migrations (version) VALUES ('20130112143206');

INSERT INTO schema_migrations (version) VALUES ('20130112144119');

INSERT INTO schema_migrations (version) VALUES ('20130114100245');

INSERT INTO schema_migrations (version) VALUES ('20130114214045');

INSERT INTO schema_migrations (version) VALUES ('20130117105806');

INSERT INTO schema_migrations (version) VALUES ('20130117121405');

INSERT INTO schema_migrations (version) VALUES ('20130117133934');

INSERT INTO schema_migrations (version) VALUES ('20130117141312');

INSERT INTO schema_migrations (version) VALUES ('20130117192402');

INSERT INTO schema_migrations (version) VALUES ('20130118073230');

INSERT INTO schema_migrations (version) VALUES ('20130119121943');

INSERT INTO schema_migrations (version) VALUES ('20130119125621');

INSERT INTO schema_migrations (version) VALUES ('20130119170135');

INSERT INTO schema_migrations (version) VALUES ('20130119170958');

INSERT INTO schema_migrations (version) VALUES ('20130119171053');

INSERT INTO schema_migrations (version) VALUES ('20130119195813');

INSERT INTO schema_migrations (version) VALUES ('20130119210742');

INSERT INTO schema_migrations (version) VALUES ('20130120135959');

INSERT INTO schema_migrations (version) VALUES ('20130120192230');

INSERT INTO schema_migrations (version) VALUES ('20130122130641');