--
-- PostgreSQL database dump
--

-- Dumped from database version 12.3 (Ubuntu 12.3-1.pgdg18.04+1)
-- Dumped by pg_dump version 12.3 (Ubuntu 12.3-1.pgdg18.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: evercam-server; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA "evercam-server";


--
-- Name: evercam_db; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA evercam_db;


--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA public;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_stat_statements IS 'track execution statistics of all SQL statements executed';


--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';


--
-- Name: camera_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.camera_status AS ENUM (
    'online',
    'offline',
    'project_finished',
    'on_hold',
    'waiting',
    'under_maintenance'
);


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: access_rights; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.access_rights (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    token_id integer,
    "right" text NOT NULL,
    camera_id integer,
    grantor_id integer,
    status integer DEFAULT 1 NOT NULL,
    snapshot_id integer,
    account_id integer,
    scope character varying(100),
    user_id integer
);


--
-- Name: access_rights_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.access_rights_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: access_rights_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.access_rights_id_seq OWNED BY public.access_rights.id;


--
-- Name: sq_access_tokens; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sq_access_tokens
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: access_tokens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.access_tokens (
    id integer DEFAULT nextval('public.sq_access_tokens'::regclass) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone,
    is_revoked boolean NOT NULL,
    user_id integer,
    client_id integer,
    request text NOT NULL,
    refresh text,
    grantor_id integer
);


--
-- Name: add_ons_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.add_ons_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ar_internal_metadata_remove; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata_remove (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: archives; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.archives (
    id integer NOT NULL,
    camera_id integer NOT NULL,
    exid text NOT NULL,
    title text NOT NULL,
    from_date timestamp with time zone NOT NULL,
    to_date timestamp with time zone NOT NULL,
    status integer NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    requested_by integer NOT NULL,
    embed_time boolean,
    public boolean,
    frames integer DEFAULT 0,
    url character varying(255),
    file_name character varying(255),
    type character varying(255),
    error_message text
);


--
-- Name: archive_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.archive_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: archive_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.archive_id_seq OWNED BY public.archives.id;


--
-- Name: batteries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.batteries (
    id bigint NOT NULL,
    name character varying(255),
    source_url character varying(255),
    active boolean DEFAULT true NOT NULL,
    user_id bigint,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: batteries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.batteries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: batteries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.batteries_id_seq OWNED BY public.batteries.id;


--
-- Name: battery_readings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.battery_readings (
    id bigint NOT NULL,
    pid character varying(255),
    fw character varying(255),
    serial_no character varying(255),
    voltage integer,
    i_value integer,
    vpv_value integer,
    ppv_value integer,
    cs_value integer,
    err_value integer,
    h19_value integer,
    h20_value integer,
    h21_value integer,
    h22_value integer,
    h23_value integer,
    datetime character varying(255),
    battery_id integer,
    il_value integer,
    mppt_value integer,
    load_value character varying(255),
    p_value integer,
    consumed_amphours integer,
    soc_value integer,
    time_to_go integer,
    alarm character varying(255),
    relay character varying(255),
    ar_value integer,
    bmv_value integer,
    h1_value integer,
    h2_value integer,
    h3_value integer,
    h4_value integer,
    h5_value integer,
    h6_value integer,
    h7_value integer,
    h8_value integer,
    h9_value integer,
    h10_value integer,
    h11_value integer,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: battery_readings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.battery_readings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: battery_readings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.battery_readings_id_seq OWNED BY public.battery_readings.id;


--
-- Name: camera_activities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.camera_activities (
    id integer NOT NULL,
    camera_id integer NOT NULL,
    access_token_id integer,
    action text NOT NULL,
    done_at timestamp with time zone NOT NULL,
    ip inet,
    extra json,
    camera_exid text,
    name text,
    user_id integer
);


--
-- Name: camera_activities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.camera_activities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: camera_activities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.camera_activities_id_seq OWNED BY public.camera_activities.id;


--
-- Name: camera_share_requests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.camera_share_requests (
    id integer NOT NULL,
    camera_id integer NOT NULL,
    user_id integer NOT NULL,
    key character varying(100) NOT NULL,
    email character varying(250) NOT NULL,
    status integer NOT NULL,
    rights character varying(1000) NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    message text
);


--
-- Name: camera_share_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.camera_share_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: camera_share_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.camera_share_requests_id_seq OWNED BY public.camera_share_requests.id;


--
-- Name: camera_shares; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.camera_shares (
    id integer NOT NULL,
    camera_id integer NOT NULL,
    user_id integer NOT NULL,
    sharer_id integer,
    kind character varying(50) NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    message text
);


--
-- Name: camera_shares_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.camera_shares_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: camera_shares_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.camera_shares_id_seq OWNED BY public.camera_shares.id;


--
-- Name: sq_streams; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sq_streams
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cameras; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cameras (
    id integer DEFAULT nextval('public.sq_streams'::regclass) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    exid text NOT NULL,
    owner_id integer NOT NULL,
    is_public boolean NOT NULL,
    config json NOT NULL,
    name text NOT NULL,
    last_polled_at timestamp with time zone DEFAULT now(),
    is_online boolean,
    timezone text,
    last_online_at timestamp with time zone DEFAULT now(),
    location public.geography(Point,4326),
    mac_address macaddr,
    model_id integer,
    discoverable boolean DEFAULT false NOT NULL,
    thumbnail_url text,
    is_online_email_owner_notification boolean DEFAULT false NOT NULL,
    alert_emails text,
    offline_reason character varying(255),
    project_id bigint,
    location_detailed json,
    status public.camera_status DEFAULT 'online'::public.camera_status NOT NULL
);


--
-- Name: cloud_recordings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cloud_recordings (
    id integer NOT NULL,
    camera_id integer NOT NULL,
    frequency integer NOT NULL,
    storage_duration integer NOT NULL,
    schedule json,
    status text
);


--
-- Name: cloud_recordings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.cloud_recordings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cloud_recordings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.cloud_recordings_id_seq OWNED BY public.cloud_recordings.id;


--
-- Name: companies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.companies_id_seq
    START WITH 2484
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: companies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.companies (
    id bigint DEFAULT nextval('public.companies_id_seq'::regclass) NOT NULL,
    exid character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    website character varying(255),
    size integer DEFAULT 0,
    session_count integer DEFAULT 0,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    linkedin_url text
);


--
-- Name: compares_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.compares_id_seq
    START WITH 35
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: compares; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.compares (
    id integer DEFAULT nextval('public.compares_id_seq'::regclass) NOT NULL,
    exid character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    before_date timestamp without time zone NOT NULL,
    after_date timestamp without time zone NOT NULL,
    embed_code character varying(255) NOT NULL,
    camera_id integer NOT NULL,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    create_animation boolean DEFAULT false,
    status integer DEFAULT 0 NOT NULL,
    requested_by integer NOT NULL,
    public boolean DEFAULT true
);


--
-- Name: sq_countries; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sq_countries
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: countries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.countries (
    id integer DEFAULT nextval('public.sq_countries'::regclass) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    iso3166_a2 text NOT NULL,
    name text NOT NULL
);


--
-- Name: meta_datas; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.meta_datas (
    id integer NOT NULL,
    user_id integer,
    camera_id integer,
    action text NOT NULL,
    process_id integer,
    extra json,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: meta_datas_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.meta_datas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: meta_datas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.meta_datas_id_seq OWNED BY public.meta_datas.id;


--
-- Name: overlays_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.overlays_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: overlays; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.overlays (
    id bigint DEFAULT nextval('public.overlays_id_seq'::regclass) NOT NULL,
    project_id bigint NOT NULL,
    path character varying(255) NOT NULL,
    sw_bounds public.geography,
    ne_bounds public.geography
);


--
-- Name: projects_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.projects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: projects; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.projects (
    id bigint DEFAULT nextval('public.projects_id_seq'::regclass) NOT NULL,
    user_id bigint NOT NULL,
    exid character varying(255) NOT NULL,
    name character varying(255),
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp without time zone
);


--
-- Name: sims; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sims (
    id bigint NOT NULL,
    number character varying(255),
    name character varying(255),
    addon character varying(255),
    allowance character varying(255),
    volume_used character varying(255),
    sim_provider character varying(255),
    yesterday_volume_used character varying(255),
    percentage_used double precision,
    remaning_days character varying(255),
    last_log_reading_at timestamp(0) without time zone,
    last_bill_date character varying(255),
    last_sms character varying(255),
    last_sms_date character varying(255),
    sms_since_last_bill integer,
    status character varying(255),
    user_id integer,
    three_user_id integer,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: sims_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sims_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sims_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sims_id_seq OWNED BY public.sims.id;


--
-- Name: sms_messages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sms_messages (
    id bigint NOT NULL,
    "to" character varying(255),
    "from" character varying(255),
    message_id character varying(255),
    status character varying(255),
    text character varying(255),
    type character varying(255),
    user_id integer,
    delivery_datetime timestamp(0) without time zone,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: sms_messages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sms_messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sms_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sms_messages_id_seq OWNED BY public.sms_messages.id;


--
-- Name: snapmail_cameras; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.snapmail_cameras (
    id integer NOT NULL,
    snapmail_id integer NOT NULL,
    camera_id integer NOT NULL,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: snapmail_cameras_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.snapmail_cameras_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: snapmail_cameras_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.snapmail_cameras_id_seq OWNED BY public.snapmail_cameras.id;


--
-- Name: snapmails; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.snapmails (
    id integer NOT NULL,
    exid character varying(255) NOT NULL,
    subject text NOT NULL,
    recipients text,
    message text,
    notify_days character varying(255),
    notify_time character varying(255) NOT NULL,
    is_public boolean DEFAULT false NOT NULL,
    user_id integer,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    timezone text,
    is_paused boolean DEFAULT false NOT NULL
);


--
-- Name: snapmails_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.snapmails_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: snapmails_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.snapmails_id_seq OWNED BY public.snapmails.id;


--
-- Name: snapshot_extractors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.snapshot_extractors (
    id integer NOT NULL,
    camera_id integer NOT NULL,
    from_date timestamp with time zone NOT NULL,
    to_date timestamp with time zone NOT NULL,
    "interval" integer NOT NULL,
    schedule json NOT NULL,
    status integer DEFAULT 0 NOT NULL,
    notes text,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone,
    requestor text,
    inject_to_cr boolean DEFAULT false,
    create_mp4 boolean DEFAULT false,
    jpegs_to_dropbox boolean DEFAULT false
);


--
-- Name: snapshot_extractors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.snapshot_extractors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: snapshot_extractors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.snapshot_extractors_id_seq OWNED BY public.snapshot_extractors.id;


--
-- Name: sq_access_tokens_streams_rights; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sq_access_tokens_streams_rights
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sq_clients; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sq_clients
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sq_devices; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sq_devices
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sq_firmwares; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sq_firmwares
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sq_users; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sq_users
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sq_vendors; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sq_vendors
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: storage_servers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.storage_servers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: storage_servers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_servers (
    id bigint DEFAULT nextval('public.storage_servers_id_seq'::regclass) NOT NULL,
    server_name character varying(255) NOT NULL,
    start_datetime timestamp(0) without time zone,
    stop_datetime timestamp(0) without time zone,
    ip character varying(255) NOT NULL,
    port integer NOT NULL,
    weed_type character varying(255) NOT NULL,
    weed_attribute character varying(255) NOT NULL,
    weed_files character varying(255) NOT NULL,
    weed_name character varying(255) NOT NULL,
    weed_mode character varying(255) DEFAULT 'R'::character varying NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    app_list character varying(255) NOT NULL
);


--
-- Name: timelapse_recordings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.timelapse_recordings (
    id integer NOT NULL,
    camera_id integer NOT NULL,
    frequency integer NOT NULL,
    storage_duration integer,
    schedule json,
    status character varying(255) NOT NULL,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: timelapse_recordings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.timelapse_recordings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: timelapse_recordings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.timelapse_recordings_id_seq OWNED BY public.timelapse_recordings.id;


--
-- Name: timelapses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.timelapses (
    id integer NOT NULL,
    camera_id integer NOT NULL,
    exid character varying(255) NOT NULL,
    title character varying(255) NOT NULL,
    frequency integer NOT NULL,
    snapshot_count integer DEFAULT 0,
    resolution character varying(255),
    status integer NOT NULL,
    date_always boolean DEFAULT false,
    from_datetime timestamp without time zone,
    time_always boolean DEFAULT false,
    to_datetime timestamp without time zone,
    watermark_logo text,
    watermark_position character varying(255),
    recreate_hls boolean DEFAULT false,
    start_recreate_hls boolean DEFAULT false,
    hls_created boolean DEFAULT false,
    last_snapshot_at timestamp without time zone,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    user_id integer NOT NULL,
    extra json
);


--
-- Name: timelapses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.timelapses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: timelapses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.timelapses_id_seq OWNED BY public.timelapses.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id integer DEFAULT nextval('public.sq_users'::regclass) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    firstname text NOT NULL,
    lastname text NOT NULL,
    username text NOT NULL,
    password text NOT NULL,
    country_id integer,
    confirmed_at timestamp with time zone,
    email text NOT NULL,
    reset_token text,
    token_expires_at timestamp without time zone,
    api_id text,
    api_key text,
    is_admin boolean DEFAULT false NOT NULL,
    stripe_customer_id text,
    billing_id text,
    last_login_at timestamp with time zone,
    vat_number text,
    payment_method integer DEFAULT 0,
    insight_id text,
    encrypted_password character varying DEFAULT ''::character varying,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    telegram_username character varying(255),
    referral_url character varying(255),
    company_id bigint,
    linkedin_url text,
    twitter_url text,
    telephone character varying(255)
);


--
-- Name: vendor_models; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.vendor_models (
    id integer DEFAULT nextval('public.sq_firmwares'::regclass) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    vendor_id integer NOT NULL,
    name text NOT NULL,
    config json,
    exid text DEFAULT ''::text NOT NULL,
    jpg_url text DEFAULT ''::text NOT NULL,
    h264_url text DEFAULT ''::text,
    mjpg_url text DEFAULT ''::text,
    shape text DEFAULT ''::text,
    resolution text DEFAULT ''::text,
    official_url text DEFAULT ''::text,
    audio_url text DEFAULT ''::text,
    more_info text DEFAULT ''::text,
    poe boolean DEFAULT false NOT NULL,
    wifi boolean DEFAULT false NOT NULL,
    onvif boolean DEFAULT false NOT NULL,
    psia boolean DEFAULT false NOT NULL,
    ptz boolean DEFAULT false NOT NULL,
    infrared boolean DEFAULT false NOT NULL,
    varifocal boolean DEFAULT false NOT NULL,
    sd_card boolean DEFAULT false NOT NULL,
    upnp boolean DEFAULT false NOT NULL,
    audio_io boolean DEFAULT false NOT NULL,
    discontinued boolean DEFAULT false NOT NULL,
    username text,
    password text,
    channel integer,
    mpeg4_url character varying DEFAULT ''::character varying,
    mobile_url character varying DEFAULT ''::character varying,
    lowres_url character varying DEFAULT ''::character varying,
    auth_type character varying(255) DEFAULT 'basic'::character varying NOT NULL
);


--
-- Name: vendors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.vendors (
    id integer DEFAULT nextval('public.sq_vendors'::regclass) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    exid text NOT NULL,
    known_macs text[] NOT NULL,
    name text NOT NULL,
    playback_url character varying(255)
);


--
-- Name: access_rights id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.access_rights ALTER COLUMN id SET DEFAULT nextval('public.access_rights_id_seq'::regclass);


--
-- Name: archives id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.archives ALTER COLUMN id SET DEFAULT nextval('public.archive_id_seq'::regclass);


--
-- Name: batteries id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.batteries ALTER COLUMN id SET DEFAULT nextval('public.batteries_id_seq'::regclass);


--
-- Name: battery_readings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.battery_readings ALTER COLUMN id SET DEFAULT nextval('public.battery_readings_id_seq'::regclass);


--
-- Name: camera_activities id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.camera_activities ALTER COLUMN id SET DEFAULT nextval('public.camera_activities_id_seq'::regclass);


--
-- Name: camera_share_requests id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.camera_share_requests ALTER COLUMN id SET DEFAULT nextval('public.camera_share_requests_id_seq'::regclass);


--
-- Name: camera_shares id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.camera_shares ALTER COLUMN id SET DEFAULT nextval('public.camera_shares_id_seq'::regclass);


--
-- Name: cloud_recordings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cloud_recordings ALTER COLUMN id SET DEFAULT nextval('public.cloud_recordings_id_seq'::regclass);


--
-- Name: meta_datas id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.meta_datas ALTER COLUMN id SET DEFAULT nextval('public.meta_datas_id_seq'::regclass);


--
-- Name: sims id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sims ALTER COLUMN id SET DEFAULT nextval('public.sims_id_seq'::regclass);


--
-- Name: sms_messages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sms_messages ALTER COLUMN id SET DEFAULT nextval('public.sms_messages_id_seq'::regclass);


--
-- Name: snapmail_cameras id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.snapmail_cameras ALTER COLUMN id SET DEFAULT nextval('public.snapmail_cameras_id_seq'::regclass);


--
-- Name: snapmails id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.snapmails ALTER COLUMN id SET DEFAULT nextval('public.snapmails_id_seq'::regclass);


--
-- Name: snapshot_extractors id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.snapshot_extractors ALTER COLUMN id SET DEFAULT nextval('public.snapshot_extractors_id_seq'::regclass);


--
-- Name: timelapse_recordings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.timelapse_recordings ALTER COLUMN id SET DEFAULT nextval('public.timelapse_recordings_id_seq'::regclass);


--
-- Name: timelapses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.timelapses ALTER COLUMN id SET DEFAULT nextval('public.timelapses_id_seq'::regclass);


--
-- Name: access_rights access_rights_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.access_rights
    ADD CONSTRAINT access_rights_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata_remove ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata_remove
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: archives archives_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.archives
    ADD CONSTRAINT archives_pkey PRIMARY KEY (id);


--
-- Name: batteries batteries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.batteries
    ADD CONSTRAINT batteries_pkey PRIMARY KEY (id);


--
-- Name: battery_readings battery_readings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.battery_readings
    ADD CONSTRAINT battery_readings_pkey PRIMARY KEY (id);


--
-- Name: camera_share_requests camera_share_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.camera_share_requests
    ADD CONSTRAINT camera_share_requests_pkey PRIMARY KEY (id);


--
-- Name: camera_shares camera_shares_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.camera_shares
    ADD CONSTRAINT camera_shares_pkey PRIMARY KEY (id);


--
-- Name: cloud_recordings cloud_recordings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cloud_recordings
    ADD CONSTRAINT cloud_recordings_pkey PRIMARY KEY (id);


--
-- Name: companies companies_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_pkey PRIMARY KEY (id);


--
-- Name: compares compares_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.compares
    ADD CONSTRAINT compares_pkey PRIMARY KEY (id);


--
-- Name: meta_datas meta_datas_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.meta_datas
    ADD CONSTRAINT meta_datas_pkey PRIMARY KEY (id);


--
-- Name: overlays overlays_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.overlays
    ADD CONSTRAINT overlays_pkey PRIMARY KEY (id);


--
-- Name: access_tokens pk_access_tokens; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.access_tokens
    ADD CONSTRAINT pk_access_tokens PRIMARY KEY (id);


--
-- Name: countries pk_countries; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT pk_countries PRIMARY KEY (id);


--
-- Name: vendor_models pk_firmwares; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vendor_models
    ADD CONSTRAINT pk_firmwares PRIMARY KEY (id);


--
-- Name: cameras pk_streams; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cameras
    ADD CONSTRAINT pk_streams PRIMARY KEY (id);


--
-- Name: users pk_users; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT pk_users PRIMARY KEY (id);


--
-- Name: vendors pk_vendors; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vendors
    ADD CONSTRAINT pk_vendors PRIMARY KEY (id);


--
-- Name: projects projects_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sims sims_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sims
    ADD CONSTRAINT sims_pkey PRIMARY KEY (id);


--
-- Name: sms_messages sms_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sms_messages
    ADD CONSTRAINT sms_messages_pkey PRIMARY KEY (id);


--
-- Name: snapmail_cameras snapmail_cameras_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.snapmail_cameras
    ADD CONSTRAINT snapmail_cameras_pkey PRIMARY KEY (id);


--
-- Name: snapmails snapmails_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.snapmails
    ADD CONSTRAINT snapmails_pkey PRIMARY KEY (id);


--
-- Name: snapshot_extractors snapshot_extractors_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.snapshot_extractors
    ADD CONSTRAINT snapshot_extractors_pkey PRIMARY KEY (id);


--
-- Name: storage_servers storage_servers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.storage_servers
    ADD CONSTRAINT storage_servers_pkey PRIMARY KEY (id);


--
-- Name: timelapse_recordings timelapse_recordings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.timelapse_recordings
    ADD CONSTRAINT timelapse_recordings_pkey PRIMARY KEY (id);


--
-- Name: timelapses timelapses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.timelapses
    ADD CONSTRAINT timelapses_pkey PRIMARY KEY (id);


--
-- Name: access_rights_camera_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX access_rights_camera_id_index ON public.access_rights USING btree (camera_id);


--
-- Name: access_rights_token_id_camera_id_right_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX access_rights_token_id_camera_id_right_index ON public.access_rights USING btree (token_id, camera_id, "right");


--
-- Name: access_rights_token_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX access_rights_token_id_index ON public.access_rights USING btree (token_id);


--
-- Name: camera_activities_camera_id_done_at_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX camera_activities_camera_id_done_at_index ON public.camera_activities USING btree (camera_id, done_at);


--
-- Name: camera_share_requests_camera_id_email_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX camera_share_requests_camera_id_email_index ON public.camera_share_requests USING btree (camera_id, email);


--
-- Name: camera_share_requests_camera_id_email_status_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX camera_share_requests_camera_id_email_status_index ON public.camera_share_requests USING btree (camera_id, email, status) WHERE (status = '-1'::integer);


--
-- Name: camera_share_requests_key_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX camera_share_requests_key_index ON public.camera_share_requests USING btree (key);


--
-- Name: camera_shares_camera_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX camera_shares_camera_id_index ON public.camera_shares USING btree (camera_id);


--
-- Name: camera_shares_camera_id_user_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX camera_shares_camera_id_user_id_index ON public.camera_shares USING btree (camera_id, user_id);


--
-- Name: camera_shares_user_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX camera_shares_user_id_index ON public.camera_shares USING btree (user_id);


--
-- Name: cameras_exid_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX cameras_exid_index ON public.cameras USING btree (exid);


--
-- Name: cameras_mac_address_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX cameras_mac_address_index ON public.cameras USING btree (mac_address);


--
-- Name: cloud_recordings_camera_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX cloud_recordings_camera_id_index ON public.cloud_recordings USING btree (camera_id);


--
-- Name: companies_exid_unique_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX companies_exid_unique_index ON public.companies USING btree (exid);


--
-- Name: compare_exid_unique_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX compare_exid_unique_index ON public.compares USING btree (exid);


--
-- Name: country_code_unique_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX country_code_unique_index ON public.countries USING btree (iso3166_a2);


--
-- Name: exid_unique_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX exid_unique_index ON public.snapmails USING btree (exid);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- Name: ix_access_tokens_grantee_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_access_tokens_grantee_id ON public.access_tokens USING btree (client_id);


--
-- Name: ix_access_tokens_grantor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_access_tokens_grantor_id ON public.access_tokens USING btree (user_id);


--
-- Name: ix_firmwares_vendor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_firmwares_vendor_id ON public.vendor_models USING btree (vendor_id);


--
-- Name: ix_streams_owner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_streams_owner_id ON public.cameras USING btree (owner_id);


--
-- Name: ix_users_country_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_users_country_id ON public.users USING btree (country_id);


--
-- Name: project_exid_unique_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX project_exid_unique_index ON public.projects USING btree (exid);


--
-- Name: snapemail_camera_id_unique_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX snapemail_camera_id_unique_index ON public.snapmail_cameras USING btree (snapmail_id, camera_id);


--
-- Name: timelapse_exid_unique_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX timelapse_exid_unique_index ON public.timelapses USING btree (exid);


--
-- Name: user_email_unique_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX user_email_unique_index ON public.users USING btree (email);


--
-- Name: user_username_unique_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX user_username_unique_index ON public.users USING btree (username);


--
-- Name: access_rights access_rights_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.access_rights
    ADD CONSTRAINT access_rights_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.users(id);


--
-- Name: access_rights access_rights_camera_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.access_rights
    ADD CONSTRAINT access_rights_camera_id_fkey FOREIGN KEY (camera_id) REFERENCES public.cameras(id);


--
-- Name: access_rights access_rights_grantor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.access_rights
    ADD CONSTRAINT access_rights_grantor_id_fkey FOREIGN KEY (grantor_id) REFERENCES public.users(id);


--
-- Name: access_rights access_rights_token_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.access_rights
    ADD CONSTRAINT access_rights_token_id_fkey FOREIGN KEY (token_id) REFERENCES public.access_tokens(id);


--
-- Name: access_rights access_rights_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.access_rights
    ADD CONSTRAINT access_rights_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: access_tokens access_tokens_grantor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.access_tokens
    ADD CONSTRAINT access_tokens_grantor_id_fkey FOREIGN KEY (grantor_id) REFERENCES public.users(id);


--
-- Name: access_tokens access_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.access_tokens
    ADD CONSTRAINT access_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: archives archives_camera_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.archives
    ADD CONSTRAINT archives_camera_id_fkey FOREIGN KEY (camera_id) REFERENCES public.cameras(id);


--
-- Name: archives archives_requested_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.archives
    ADD CONSTRAINT archives_requested_by_fkey FOREIGN KEY (requested_by) REFERENCES public.users(id);


--
-- Name: batteries batteries_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.batteries
    ADD CONSTRAINT batteries_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: camera_share_requests camera_share_requests_camera_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.camera_share_requests
    ADD CONSTRAINT camera_share_requests_camera_id_fkey FOREIGN KEY (camera_id) REFERENCES public.cameras(id);


--
-- Name: camera_share_requests camera_share_requests_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.camera_share_requests
    ADD CONSTRAINT camera_share_requests_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: camera_shares camera_shares_camera_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.camera_shares
    ADD CONSTRAINT camera_shares_camera_id_fkey FOREIGN KEY (camera_id) REFERENCES public.cameras(id);


--
-- Name: camera_shares camera_shares_sharer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.camera_shares
    ADD CONSTRAINT camera_shares_sharer_id_fkey FOREIGN KEY (sharer_id) REFERENCES public.users(id);


--
-- Name: camera_shares camera_shares_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.camera_shares
    ADD CONSTRAINT camera_shares_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: cameras cameras_model_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cameras
    ADD CONSTRAINT cameras_model_id_fkey FOREIGN KEY (model_id) REFERENCES public.vendor_models(id);


--
-- Name: cameras cameras_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cameras
    ADD CONSTRAINT cameras_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES public.users(id);


--
-- Name: cloud_recordings cloud_recordings_camera_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cloud_recordings
    ADD CONSTRAINT cloud_recordings_camera_id_fkey FOREIGN KEY (camera_id) REFERENCES public.cameras(id);


--
-- Name: compares compares_camera_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.compares
    ADD CONSTRAINT compares_camera_id_fkey FOREIGN KEY (camera_id) REFERENCES public.cameras(id);


--
-- Name: compares compares_requested_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.compares
    ADD CONSTRAINT compares_requested_by_fkey FOREIGN KEY (requested_by) REFERENCES public.users(id);


--
-- Name: meta_datas meta_datas_camera_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.meta_datas
    ADD CONSTRAINT meta_datas_camera_id_fkey FOREIGN KEY (camera_id) REFERENCES public.cameras(id);


--
-- Name: meta_datas meta_datas_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.meta_datas
    ADD CONSTRAINT meta_datas_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: overlays overlays_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.overlays
    ADD CONSTRAINT overlays_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id);


--
-- Name: projects projects_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: snapmail_cameras snapmail_cameras_camera_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.snapmail_cameras
    ADD CONSTRAINT snapmail_cameras_camera_id_fkey FOREIGN KEY (camera_id) REFERENCES public.cameras(id);


--
-- Name: snapmail_cameras snapmail_cameras_snapmail_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.snapmail_cameras
    ADD CONSTRAINT snapmail_cameras_snapmail_id_fkey FOREIGN KEY (snapmail_id) REFERENCES public.snapmails(id);


--
-- Name: snapmails snapmails_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.snapmails
    ADD CONSTRAINT snapmails_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: snapshot_extractors snapshot_extractors_camera_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.snapshot_extractors
    ADD CONSTRAINT snapshot_extractors_camera_id_fkey FOREIGN KEY (camera_id) REFERENCES public.cameras(id);


--
-- Name: timelapses timelapses_camera_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.timelapses
    ADD CONSTRAINT timelapses_camera_id_fkey FOREIGN KEY (camera_id) REFERENCES public.cameras(id);


--
-- Name: timelapses timelapses_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.timelapses
    ADD CONSTRAINT timelapses_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: users users_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id);


--
-- Name: users users_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_country_id_fkey FOREIGN KEY (country_id) REFERENCES public.countries(id);


--
-- Name: vendor_models vendor_models_vendor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vendor_models
    ADD CONSTRAINT vendor_models_vendor_id_fkey FOREIGN KEY (vendor_id) REFERENCES public.vendors(id);


--
-- PostgreSQL database dump complete
--

INSERT INTO public."schema_migrations" (version) VALUES (20150622102645), (20150629144629), (20150629183319), (20160616160229), (20160712101523), (20160720125939), (20160727112052), (20160830055709), (20161202114834), (20161202115000), (20161213162000), (20161219130300), (20161221070146), (20161221070226), (20170103162400), (20170112110000), (20170213140200), (20170222114100), (20170414141100), (20170419105000), (20171009070501), (20171213120725), (20171220062816), (20171222101825), (20180102124912), (20180122051210), (20180130103936), (20180411104000), (20180416121600), (20180420054301), (20180502103548), (20180807101800), (20180903164300), (20181015164800), (20181026105300), (20181212064300), (20190222055829), (20190319122534), (20190325065956), (20190325091759), (20190403104055), (20190408055219), (20190408065515), (20190411045328), (20190509054930), (20190509094537), (20190801064946), (20190821113740), (20200120071213), (20200330113203), (20200402105613), (20200509072705), (20200514064538), (20200520122231), (20200603101249), (20200610114236), (20200611081048), (20200611091050), (20200611111803);

