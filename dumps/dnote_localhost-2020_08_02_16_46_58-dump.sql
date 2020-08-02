--
-- PostgreSQL database dump
--

-- Dumped from database version 11.8
-- Dumped by pg_dump version 12.3

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
-- Name: public; Type: SCHEMA; Schema: -; Owner: dnote
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO dnote;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: dnote
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- Name: note_tsv_trigger(); Type: FUNCTION; Schema: public; Owner: dnote
--

CREATE FUNCTION public.note_tsv_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
  new.tsv := setweight(to_tsvector('english_nostop', new.body), 'A');
  return new;
end
$$;


ALTER FUNCTION public.note_tsv_trigger() OWNER TO dnote;

--
-- Name: english_nostop; Type: TEXT SEARCH DICTIONARY; Schema: public; Owner: dnote
--

CREATE TEXT SEARCH DICTIONARY public.english_nostop (
    TEMPLATE = pg_catalog.snowball,
    language = 'english' );


ALTER TEXT SEARCH DICTIONARY public.english_nostop OWNER TO dnote;

--
-- Name: english_nostop; Type: TEXT SEARCH CONFIGURATION; Schema: public; Owner: dnote
--

CREATE TEXT SEARCH CONFIGURATION public.english_nostop (
    PARSER = pg_catalog."default" );

ALTER TEXT SEARCH CONFIGURATION public.english_nostop
    ADD MAPPING FOR asciiword WITH public.english_nostop;

ALTER TEXT SEARCH CONFIGURATION public.english_nostop
    ADD MAPPING FOR word WITH public.english_nostop;

ALTER TEXT SEARCH CONFIGURATION public.english_nostop
    ADD MAPPING FOR numword WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.english_nostop
    ADD MAPPING FOR email WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.english_nostop
    ADD MAPPING FOR url WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.english_nostop
    ADD MAPPING FOR host WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.english_nostop
    ADD MAPPING FOR sfloat WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.english_nostop
    ADD MAPPING FOR version WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.english_nostop
    ADD MAPPING FOR hword_numpart WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.english_nostop
    ADD MAPPING FOR hword_part WITH public.english_nostop;

ALTER TEXT SEARCH CONFIGURATION public.english_nostop
    ADD MAPPING FOR hword_asciipart WITH public.english_nostop;

ALTER TEXT SEARCH CONFIGURATION public.english_nostop
    ADD MAPPING FOR numhword WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.english_nostop
    ADD MAPPING FOR asciihword WITH public.english_nostop;

ALTER TEXT SEARCH CONFIGURATION public.english_nostop
    ADD MAPPING FOR hword WITH public.english_nostop;

ALTER TEXT SEARCH CONFIGURATION public.english_nostop
    ADD MAPPING FOR url_path WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.english_nostop
    ADD MAPPING FOR file WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.english_nostop
    ADD MAPPING FOR "float" WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.english_nostop
    ADD MAPPING FOR "int" WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.english_nostop
    ADD MAPPING FOR uint WITH simple;


ALTER TEXT SEARCH CONFIGURATION public.english_nostop OWNER TO dnote;

SET default_tablespace = '';

--
-- Name: accounts; Type: TABLE; Schema: public; Owner: dnote
--

CREATE TABLE public.accounts (
    id integer NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone,
    user_id integer,
    email text,
    email_verified boolean DEFAULT false,
    password text
);


ALTER TABLE public.accounts OWNER TO dnote;

--
-- Name: accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: dnote
--

CREATE SEQUENCE public.accounts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.accounts_id_seq OWNER TO dnote;

--
-- Name: accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dnote
--

ALTER SEQUENCE public.accounts_id_seq OWNED BY public.accounts.id;


--
-- Name: books; Type: TABLE; Schema: public; Owner: dnote
--

CREATE TABLE public.books (
    id integer NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone,
    uuid uuid DEFAULT public.uuid_generate_v4(),
    user_id integer,
    label text,
    added_on bigint,
    edited_on bigint,
    usn integer,
    deleted boolean DEFAULT false,
    encrypted boolean DEFAULT false
);


ALTER TABLE public.books OWNER TO dnote;

--
-- Name: books_id_seq; Type: SEQUENCE; Schema: public; Owner: dnote
--

CREATE SEQUENCE public.books_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.books_id_seq OWNER TO dnote;

--
-- Name: books_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dnote
--

ALTER SEQUENCE public.books_id_seq OWNED BY public.books.id;


--
-- Name: email_preferences; Type: TABLE; Schema: public; Owner: dnote
--

CREATE TABLE public.email_preferences (
    id integer NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone,
    user_id integer,
    inactive_reminder boolean DEFAULT false,
    product_update boolean DEFAULT true
);


ALTER TABLE public.email_preferences OWNER TO dnote;

--
-- Name: email_preferences_id_seq; Type: SEQUENCE; Schema: public; Owner: dnote
--

CREATE SEQUENCE public.email_preferences_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.email_preferences_id_seq OWNER TO dnote;

--
-- Name: email_preferences_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dnote
--

ALTER SEQUENCE public.email_preferences_id_seq OWNED BY public.email_preferences.id;


--
-- Name: migrations; Type: TABLE; Schema: public; Owner: dnote
--

CREATE TABLE public.migrations (
    id text NOT NULL,
    applied_at timestamp with time zone
);


ALTER TABLE public.migrations OWNER TO dnote;

--
-- Name: notes; Type: TABLE; Schema: public; Owner: dnote
--

CREATE TABLE public.notes (
    id integer NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone,
    uuid uuid DEFAULT public.uuid_generate_v4(),
    user_id integer,
    book_uuid uuid,
    body text,
    added_on bigint,
    edited_on bigint,
    tsv tsvector,
    public boolean DEFAULT false,
    usn integer,
    deleted boolean DEFAULT false,
    encrypted boolean DEFAULT false,
    client text
);


ALTER TABLE public.notes OWNER TO dnote;

--
-- Name: notes_id_seq; Type: SEQUENCE; Schema: public; Owner: dnote
--

CREATE SEQUENCE public.notes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.notes_id_seq OWNER TO dnote;

--
-- Name: notes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dnote
--

ALTER SEQUENCE public.notes_id_seq OWNED BY public.notes.id;


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: dnote
--

CREATE TABLE public.notifications (
    id integer NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone,
    type text,
    user_id integer
);


ALTER TABLE public.notifications OWNER TO dnote;

--
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: dnote
--

CREATE SEQUENCE public.notifications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.notifications_id_seq OWNER TO dnote;

--
-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dnote
--

ALTER SEQUENCE public.notifications_id_seq OWNED BY public.notifications.id;


--
-- Name: sessions; Type: TABLE; Schema: public; Owner: dnote
--

CREATE TABLE public.sessions (
    id integer NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone,
    user_id integer,
    key text,
    last_used_at timestamp with time zone,
    expires_at timestamp with time zone
);


ALTER TABLE public.sessions OWNER TO dnote;

--
-- Name: sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: dnote
--

CREATE SEQUENCE public.sessions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sessions_id_seq OWNER TO dnote;

--
-- Name: sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dnote
--

ALTER SEQUENCE public.sessions_id_seq OWNED BY public.sessions.id;


--
-- Name: tokens; Type: TABLE; Schema: public; Owner: dnote
--

CREATE TABLE public.tokens (
    id integer NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone,
    user_id integer,
    value text,
    type text,
    used_at timestamp with time zone
);


ALTER TABLE public.tokens OWNER TO dnote;

--
-- Name: tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: dnote
--

CREATE SEQUENCE public.tokens_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tokens_id_seq OWNER TO dnote;

--
-- Name: tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dnote
--

ALTER SEQUENCE public.tokens_id_seq OWNED BY public.tokens.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: dnote
--

CREATE TABLE public.users (
    id integer NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone,
    uuid uuid DEFAULT public.uuid_generate_v4(),
    last_login_at timestamp with time zone,
    max_usn integer DEFAULT 0,
    cloud boolean DEFAULT false
);


ALTER TABLE public.users OWNER TO dnote;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: dnote
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO dnote;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dnote
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: accounts id; Type: DEFAULT; Schema: public; Owner: dnote
--

ALTER TABLE ONLY public.accounts ALTER COLUMN id SET DEFAULT nextval('public.accounts_id_seq'::regclass);


--
-- Name: books id; Type: DEFAULT; Schema: public; Owner: dnote
--

ALTER TABLE ONLY public.books ALTER COLUMN id SET DEFAULT nextval('public.books_id_seq'::regclass);


--
-- Name: email_preferences id; Type: DEFAULT; Schema: public; Owner: dnote
--

ALTER TABLE ONLY public.email_preferences ALTER COLUMN id SET DEFAULT nextval('public.email_preferences_id_seq'::regclass);


--
-- Name: notes id; Type: DEFAULT; Schema: public; Owner: dnote
--

ALTER TABLE ONLY public.notes ALTER COLUMN id SET DEFAULT nextval('public.notes_id_seq'::regclass);


--
-- Name: notifications id; Type: DEFAULT; Schema: public; Owner: dnote
--

ALTER TABLE ONLY public.notifications ALTER COLUMN id SET DEFAULT nextval('public.notifications_id_seq'::regclass);


--
-- Name: sessions id; Type: DEFAULT; Schema: public; Owner: dnote
--

ALTER TABLE ONLY public.sessions ALTER COLUMN id SET DEFAULT nextval('public.sessions_id_seq'::regclass);


--
-- Name: tokens id; Type: DEFAULT; Schema: public; Owner: dnote
--

ALTER TABLE ONLY public.tokens ALTER COLUMN id SET DEFAULT nextval('public.tokens_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: dnote
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: accounts; Type: TABLE DATA; Schema: public; Owner: dnote
--

COPY public.accounts (id, created_at, updated_at, user_id, email, email_verified, password) FROM stdin;
1	2020-08-01 11:04:23.617788+00	2020-08-01 11:04:23.617788+00	1	martapancaldi@rentalcars.com	f	$2a$10$9XpCiYze5t54/zQfLNRjFuNCiz8zMfo9c/5O8QsIEY3tRyepQcT7.
2	2020-08-01 11:04:47.411812+00	2020-08-01 11:12:42.356916+00	2	marta.panc@gmail.com	f	$2a$10$fwL6G0GidWMPcOgIvd8fJuz/Fq1bK3DYt.SYA.sGwPczCoTtvS7Fi
\.


--
-- Data for Name: books; Type: TABLE DATA; Schema: public; Owner: dnote
--

COPY public.books (id, created_at, updated_at, uuid, user_id, label, added_on, edited_on, usn, deleted, encrypted) FROM stdin;
1	2020-08-01 11:32:54.008244+00	2020-08-01 11:32:54.008244+00	4c82db61-f85b-4b95-b72e-2e7a659a530f	2	Dnote	1596281574008219200	0	1	f	f
2	2020-08-01 11:35:44.972072+00	2020-08-01 11:35:44.972072+00	64fe87ac-add4-4b8e-8958-f8b41713756b	2	Java	1596281744972049600	0	4	f	f
3	2020-08-01 11:51:28.281757+00	2020-08-01 11:51:28.281757+00	60e5de44-85c6-4a5e-9a32-beb40ea35ab4	2	Sublime	1596282688281727700	0	7	f	f
4	2020-08-01 14:13:22.904601+00	2020-08-01 14:13:22.904601+00	3985c761-78f5-4abc-8bf3-cbf70724064f	2	PragmaticProgrammer	1596291202904575000	0	10	f	f
5	2020-08-01 18:27:00.595278+00	2020-08-01 18:27:00.595278+00	390c68a4-869d-4a03-bacd-438c05f0d0c4	2	Docker	1596306420595246000	0	14	f	f
6	2020-08-01 19:21:37.892502+00	2020-08-01 19:21:37.892502+00	d4621919-8bf7-446f-aba6-13052f5479fd	2	AWS	1596309697892481300	0	21	f	f
\.


--
-- Data for Name: email_preferences; Type: TABLE DATA; Schema: public; Owner: dnote
--

COPY public.email_preferences (id, created_at, updated_at, user_id, inactive_reminder, product_update) FROM stdin;
1	2020-08-01 11:04:23.640484+00	2020-08-01 11:04:23.640484+00	1	f	t
2	2020-08-01 11:04:47.414689+00	2020-08-01 11:13:17.942058+00	2	t	t
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: public; Owner: dnote
--

COPY public.migrations (id, applied_at) FROM stdin;
20190819115834-full-text-search.sql	2020-08-01 11:02:06.154557+00
20191028103522-create-weekly-repetition.sql	2020-08-01 11:02:06.160116+00
20191225185502-populate-digest-version.sql	2020-08-01 11:02:06.161482+00
20191226093447-add-digest-id-primary-key.sql	2020-08-01 11:02:06.162649+00
20191226105659-use-id-in-digest-notes-joining-table.sql	2020-08-01 11:02:06.163849+00
20191226152111-delete-outdated-digests.sql	2020-08-01 11:02:06.16513+00
20200522170529-remove-billing-columns.sql	2020-08-01 11:02:06.166869+00
\.


--
-- Data for Name: notes; Type: TABLE DATA; Schema: public; Owner: dnote
--

COPY public.notes (id, created_at, updated_at, uuid, user_id, book_uuid, body, added_on, edited_on, tsv, public, usn, deleted, encrypted, client) FROM stdin;
1	2020-08-01 11:32:54.03512+00	2020-08-01 11:34:11.532086+00	1a76caf8-5c83-47bd-91b9-130dee3d783b	2	4c82db61-f85b-4b95-b72e-2e7a659a530f	**Docker:**\n\nhttps://github.com/dnote/dnote/blob/master/host/docker/README.md\n\ncurl https://raw.githubusercontent.com/dnote/dnote/master/host/docker/docker-compose.yml > docker-compose.yml\n\nChange localhost port if needed (e.g. 3004:3000)\ndocker-compose pull\ndocker-compose up -d\n\n**Install CLI:**\nhttps://github.com/dnote/dnote#installation\n\n**Config:**\nedit ~/.dnote/dnoterc\ne.g.:\n\teditor: nano\n\tapiEndpoint: http://localhost:3004/api\n\n\n~ dnote login\n	1596281574035085700	1596281651532053900	'/.dnote/dnoterc':34A '/dnote/dnote#installation':31A '/dnote/dnote/blob/master/host/docker/readme.md':4A '/dnote/dnote/master/host/docker/docker-compose.yml':8A '3000':17A '3004':16A '3004/api':40A 'apiendpoint':38A 'chang':10A 'cli':28A 'compos':20A,24A 'config':32A 'curl':5A 'd':26A 'dnote':41A 'docker':1A,19A,23A 'docker-compos':18A,22A 'docker-compose.yml':9A 'e.g':15A,35A 'edit':33A 'editor':36A 'github.com':3A,30A 'github.com/dnote/dnote#installation':29A 'github.com/dnote/dnote/blob/master/host/docker/readme.md':2A 'if':13A 'instal':27A 'localhost':11A,39A 'login':42A 'nano':37A 'need':14A 'port':12A 'pull':21A 'raw.githubusercontent.com':7A 'raw.githubusercontent.com/dnote/dnote/master/host/docker/docker-compose.yml':6A 'up':25A	f	3	f	f	cli
2	2020-08-01 11:35:44.988766+00	2020-08-01 11:35:44.988766+00	c1ffdf7a-5c07-4cb6-901d-35c34480afed	2	64fe87ac-add4-4b8e-8958-f8b41713756b	CONSIDER A BUILDER WHEN FACED WITH MANY CONSTRUCTOR PARAMETERS\n	1596281744988734500	0	'a':2A 'builder':3A 'consid':1A 'constructor':8A 'face':5A 'mani':7A 'paramet':9A 'when':4A 'with':6A	f	5	f	f	cli
3	2020-08-01 11:36:53.937519+00	2020-08-01 11:36:53.937519+00	1c36fb8f-bcc6-4baf-95ce-1b8b797877a4	2	64fe87ac-add4-4b8e-8958-f8b41713756b	ENFORCE THE SINGLETON PROPERTY WITH A PRIVATE CONSTRUCTOR OR AN ENUM TYPE\n	1596281813937482400	0	'a':6A 'an':10A 'constructor':8A 'enforc':1A 'enum':11A 'or':9A 'privat':7A 'properti':4A 'singleton':3A 'the':2A 'type':12A 'with':5A	f	6	f	f	cli
5	2020-08-01 12:19:12.670958+00	2020-08-01 12:19:12.670958+00	8768635c-5630-42cb-969a-1b38ec06e323	2	4c82db61-f85b-4b95-b72e-2e7a659a530f	Tried adding "subl" as editor (after enabling Sublime to open from CLI command, `subl`) but the CLI fails with "Empty note" error.\nSublime opens the temporary note and you can edit and save it, but Dnote doesn't recognise it.\n	1596284352670867500	0	'ad':2A 'after':6A 'and':28A,32A 'as':4A 'but':15A,35A 'can':30A 'cli':12A,17A 'command':13A 'dnote':36A 'doesn':37A 'edit':31A 'editor':5A 'empti':20A 'enabl':7A 'error':22A 'fail':18A 'from':11A 'it':34A,40A 'note':21A,27A 'open':10A,24A 'recognis':39A 'save':33A 'subl':3A,14A 'sublim':8A,23A 't':38A 'temporari':26A 'the':16A,25A 'to':9A 'tri':1A 'with':19A 'you':29A	f	9	f	f	cli
12	2020-08-01 19:21:37.87823+00	2020-08-01 19:22:27.191408+00	b03a8b1a-bd12-4f63-9222-1a5d01654ecb	2	d4621919-8bf7-446f-aba6-13052f5479fd	## EC2 vs Elastic Beanstalk\n\n#### EC2\n\nEC2 is Amazon's service that allows you to create a server (AWS calls these instances) in the AWS cloud. You pay by the hour and only what you use. You can do whatever you want with this instance as well as launch n number of instances.\n\n#### Elastic Beanstalk\nElastic Beanstalk is one layer of abstraction away from the EC2 layer. Elastic Beanstalk will setup an "environment" for you that can contain a number of EC2 instances, an optional database, as well as a few other AWS components such as a Elastic Load Balancer, Auto-Scaling Group, Security Group. Then Elastic Beanstalk will manage these items for you whenever you want to update your software running in AWS. Elastic Beanstalk doesn't add any cost on top of these resources that it creates for you. If you have 10 hours of EC2 usage, then all you pay is 10 compute hours.ø\n\n	1596309697878193800	1596309747191371600	'10':145A,155A 'a':16A,78A,89A,96A 'abstract':61A 'add':129A 'all':151A 'allow':12A 'amazon':8A 'an':71A,83A 'and':31A 'ani':130A 'as':45A,47A,86A,88A,95A 'auto':101A 'auto-sc':100A 'aw':18A,24A,92A,124A 'away':62A 'balanc':99A 'beanstalk':4A,54A,56A,68A,108A,126A 'by':28A 'call':19A 'can':37A,76A 'cloud':25A 'compon':93A 'comput':156A 'contain':77A 'cost':131A 'creat':15A,139A 'databas':85A 'do':38A 'doesn':127A 'ec2':1A,5A,6A,65A,81A,148A 'elast':3A,53A,55A,67A,97A,107A,125A 'environ':72A 'few':90A 'for':73A,113A,140A 'from':63A 'group':103A,105A 'have':144A 'hour':30A,146A,157A 'if':142A 'in':22A,123A 'instanc':21A,44A,52A,82A 'is':7A,57A,154A 'it':138A 'item':112A 'launch':48A 'layer':59A,66A 'load':98A 'manag':110A 'n':49A 'number':50A,79A 'of':51A,60A,80A,134A,147A 'on':132A 'one':58A 'onli':32A 'option':84A 'other':91A 'pay':27A,153A 'resourc':136A 'run':122A 's':9A 'scale':102A 'secur':104A 'server':17A 'servic':10A 'setup':70A 'softwar':121A 'such':94A 't':128A 'that':11A,75A,137A 'the':23A,29A,64A 'then':106A,150A 'these':20A,111A,135A 'this':43A 'to':14A,118A 'top':133A 'updat':119A 'usag':149A 'use':35A 'vs':2A 'want':41A,117A 'well':46A,87A 'what':33A 'whatev':39A 'whenev':115A 'will':69A,109A 'with':42A 'you':13A,26A,34A,36A,40A,74A,114A,116A,141A,143A,152A 'your':120A 'ø':158A	f	23	f	f	cli
4	2020-08-01 11:51:28.304392+00	2020-08-01 19:23:10.160099+00	feeab350-a5ef-46c9-a948-b117696a2699	2	60e5de44-85c6-4a5e-9a32-beb40ea35ab4	### Open Sublime Text from CL (MacOS)\n\n- Test subl from your ST installation:\n\nFirst, navigate to a small folder in Terminal that you want ST to open and enter the following command:\n\n```/Applications/Sublime\\ Text.app/Contents/SharedSupport/bin/subl .```\n\n- Check ".bash_profile" (or .zshrc)\n\n```\nexport PATH=/bin:/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin:$PATH\nexport EDITOR='subl -w'\n```\n\nThe first line sets the location where you want Terminal to look for binaries on your machine, I'm going to store my symbolic link in the /usr/local/bin directory - I guess you could store it anywhere provided you've notified Terminal where to look for binaries.\n\nThe second line is OPTIONAL and just sets Sublime Text as the default editor. The flag -w has been added and you can find out more about flags by going to the Sublime Text docs: ST3 subl or ST2 subl\n\n- Create a symbolic link to Sublime Text:\n\nNow in your chosen path (I used /usr/local/bin) you enter the following command:\n\n```ln -s /Applications/Sublime\\ Text.app/Contents/SharedSupport/bin/subl /usr/local/bin/subl```\n\nThe /Applications/Sublime\\ Text.app/Contents/SharedSupport/bin/subl being EXACTLY the same location as what you entered and verified as working in STEP 1 above. The /usr/local/bin/subl being the location of where you want the symbolic link to be located - needs to be one of your PATH locations from STEP 2 above.\n\nNow when you navigate to a folder or file that you want to open in Sublime Text you now just enter subl followed by the name of the file or . to open the current working directory.\n	1596282688304354400	1596309790160066000	'/applications/sublime':32A,161A,167A '/bin':43A '/contents/sharedsupport/bin/subl':35A,164A,170A '/sbin':44A '/usr/bin':45A '/usr/local/bin':47A,80A,153A '/usr/local/bin/subl':165A,189A '/usr/local/sbin':46A '1':186A '2':213A 'a':16A,140A,220A 'about':125A 'abov':187A,214A 'ad':118A 'and':27A,104A,119A,180A 'anywher':88A 'as':109A,176A,182A 'bash':37A 'be':171A,190A,201A,205A 'been':117A 'binari':66A,98A 'by':127A,238A 'can':121A 'check':36A 'chosen':149A 'cl':5A 'command':31A,158A 'could':85A 'creat':139A 'current':248A 'default':111A 'directori':81A,250A 'doc':133A 'editor':50A,112A 'enter':28A,155A,179A,235A 'exact':172A 'export':41A,49A 'file':223A,243A 'find':122A 'first':13A,54A 'flag':114A,126A 'folder':18A,221A 'follow':30A,157A,237A 'for':65A,97A 'from':4A,9A,211A 'go':72A,128A 'guess':83A 'has':116A 'i':70A,82A,151A 'in':19A,78A,147A,184A,229A 'instal':12A 'is':102A 'it':87A 'just':105A,234A 'line':55A,101A 'link':77A,142A,199A 'ln':159A 'locat':58A,175A,192A,202A,210A 'look':64A,96A 'm':71A 'machin':69A 'maco':6A 'more':124A 'my':75A 'name':240A 'navig':14A,218A 'need':203A 'notifi':92A 'now':146A,215A,233A 'of':193A,207A,241A 'on':67A 'one':206A 'open':1A,26A,228A,246A 'option':103A 'or':39A,136A,222A,244A 'out':123A 'path':42A,48A,150A,209A 'profil':38A 'provid':89A 's':160A 'same':174A 'second':100A 'set':56A,106A 'small':17A 'st':11A,24A 'st2':137A 'st3':134A 'step':185A,212A 'store':74A,86A 'subl':8A,51A,135A,138A,236A 'sublim':2A,107A,131A,144A,230A 'symbol':76A,141A,198A 'termin':20A,62A,93A 'test':7A 'text':3A,108A,132A,145A,231A 'text.app':34A,163A,169A 'text.app/contents/sharedsupport/bin/subl':33A,162A,168A 'that':21A,224A 'the':29A,53A,57A,79A,99A,110A,113A,130A,156A,166A,173A,188A,191A,197A,239A,242A,247A 'to':15A,25A,63A,73A,95A,129A,143A,200A,204A,219A,227A,245A 'use':152A 've':91A 'verifi':181A 'w':52A,115A 'want':23A,61A,196A,226A 'what':177A 'when':216A 'where':59A,94A,194A 'work':183A,249A 'you':22A,60A,84A,90A,120A,154A,178A,195A,217A,225A,232A 'your':10A,68A,148A,208A 'zshrc':40A	f	24	f	f	cli
6	2020-08-01 14:13:22.927856+00	2020-08-01 15:02:32.802959+00	835f07fc-c5e9-4bd3-bb0f-8b3a44df6e77	2	3985c761-78f5-4abc-8bf3-cbf70724064f	Kaizen - progress through small steps\n\n**1. It's your life**\n Close to the top of any careers where you have control. We can do anything we want. Be proactive and change what you don't like.\n\n**2. The cat ate my source code**\nTake responsibility. If you made a mistake, don't provide excuses but options/solutions\n\n**3. Software entropy**\nBroken window creates a precedent of neglectedness. In case of "fire", try your best not to do harm to existing things (firefighters in the house).\n\n**4. Stone soup and boiled frogs**\nEasier to ask forgiveness than permission. Start-up fatigue. People find it easier to join an ongoing success.\nLeaving increasing broken windows is like boiling a frog slowly.\n\n**5. Good enough software**\n10000 chips, 1 in 10000 is defective, here's the 10 faulty ones. Write software that is "good enough" for your users, i.e. meet user's requirements and involve users to determine whether the software is good enough.\nGreat software today is preferable to the fantasy of perfect software tomorrow - but involve users in the trade-off.\nKnow when to stop, or the painter will become lost in his painting.\n\n(1) wait to get all the bugs out (2) have complex software and accept some bugs or (3) opt for simpler software with fewer defects?\nTrap of feature bloat\n\n**6. Your knowledge portfolio**\nAn investment in knowledge always pays out the best interest\nThe early bird might get the worm, but what happens to the early worm?\nKnowledge and experience are *expiring assets*\nSet learning goals. Take any question you don't know the answer for as an opportunity to learn.	1596291202927825200	1596294152802930600	'1':6A,126A,195A '10':134A '10000':124A,128A '2':37A,203A '3':57A,212A '4':85A '5':120A '6':224A 'a':49A,63A,117A 'accept':208A 'all':199A 'alway':232A 'an':107A,228A,272A 'and':30A,88A,151A,207A,253A 'ani':16A,262A 'answer':269A 'anyth':25A 'are':255A 'as':271A 'ask':93A 'asset':257A 'ate':40A 'be':28A 'becom':190A 'best':73A,236A 'bird':240A 'bloat':223A 'boil':89A,116A 'broken':60A,112A 'bug':201A,210A 'but':55A,174A,245A 'can':23A 'career':17A 'case':68A 'cat':39A 'chang':31A 'chip':125A 'close':11A 'code':43A 'complex':205A 'control':21A 'creat':62A 'defect':130A,219A 'determin':155A 'do':24A,76A 'don':34A,51A,265A 'earli':239A,250A 'easier':91A,104A 'enough':122A,142A,161A 'entropi':59A 'excus':54A 'exist':79A 'experi':254A 'expir':256A 'fantasi':169A 'fatigu':100A 'faulti':135A 'featur':222A 'fewer':218A 'find':102A 'fire':70A 'firefight':81A 'for':143A,214A,270A 'forgiv':94A 'frog':90A,118A 'get':198A,242A 'goal':260A 'good':121A,141A,160A 'great':162A 'happen':247A 'harm':77A 'have':20A,204A 'here':131A 'his':193A 'hous':84A 'i.e':146A 'if':46A 'in':67A,82A,127A,177A,192A,230A 'increas':111A 'interest':237A 'invest':229A 'involv':152A,175A 'is':114A,129A,140A,159A,165A 'it':7A,103A 'join':106A 'kaizen':1A 'know':182A,267A 'knowledg':226A,231A,252A 'learn':259A,275A 'leav':110A 'life':10A 'like':36A,115A 'lost':191A 'made':48A 'meet':147A 'might':241A 'mistak':50A 'my':41A 'neglected':66A 'not':74A 'of':15A,65A,69A,170A,221A 'off':181A 'one':136A 'ongo':108A 'opportun':273A 'opt':213A 'options/solutions':56A 'or':186A,211A 'out':202A,234A 'paint':194A 'painter':188A 'pay':233A 'peopl':101A 'perfect':171A 'permiss':96A 'portfolio':227A 'preced':64A 'prefer':166A 'proactiv':29A 'progress':2A 'provid':53A 'question':263A 'requir':150A 'respons':45A 's':8A,132A,149A 'set':258A 'simpler':215A 'slowli':119A 'small':4A 'softwar':58A,123A,138A,158A,163A,172A,206A,216A 'some':209A 'soup':87A 'sourc':42A 'start':98A 'start-up':97A 'step':5A 'stone':86A 'stop':185A 'success':109A 't':35A,52A,266A 'take':44A,261A 'than':95A 'that':139A 'the':13A,38A,83A,133A,157A,168A,178A,187A,200A,235A,238A,243A,249A,268A 'thing':80A 'through':3A 'to':12A,75A,78A,92A,105A,154A,167A,184A,197A,248A,274A 'today':164A 'tomorrow':173A 'top':14A 'trade':180A 'trade-off':179A 'trap':220A 'tri':71A 'up':99A 'user':145A,148A,153A,176A 'wait':196A 'want':27A 'we':22A,26A 'what':32A,246A 'when':183A 'where':18A 'whether':156A 'will':189A 'window':61A,113A 'with':217A 'worm':244A,251A 'write':137A 'you':19A,33A,47A,264A 'your':9A,72A,144A,225A	f	13	f	f	web
7	2020-08-01 18:27:00.623482+00	2020-08-01 18:27:00.623482+00	0ad42a88-f586-4389-bde5-52e7ea014ee8	2	390c68a4-869d-4a03-bacd-438c05f0d0c4	**Terminology**\n\nImages - The blueprints of our application which form the basis of containers. In the demo above, we used the docker pull command to download the busybox image.\nContainers - Created from Docker images and run the actual application. We create a container using docker run which we did using the busybox image that we downloaded. A list of running containers can be seen using the docker ps command.\nDocker Daemon - The background service running on the host that manages building, running and distributing Docker containers. The daemon is the process that runs in the operating system which clients talk to.\nDocker Client - The command line tool that allows the user to interact with the daemon. More generally, there can be other forms of clients too - such as Kitematic which provide a GUI to the users.\nDocker Hub - A registry of Docker images. You can think of the registry as a directory of all available Docker images. If required, one can host their own Docker registries and can use them for pulling images.\n	1596306420623438800	0	'a':41A,56A,131A,138A,150A 'abov':17A 'actual':37A 'all':153A 'allow':108A 'and':34A,82A,166A 'applic':7A,38A 'as':127A,149A 'avail':154A 'background':72A 'basi':11A 'be':62A,120A 'blueprint':4A 'build':80A 'busybox':27A,51A 'can':61A,119A,144A,160A,167A 'client':98A,102A,124A 'command':23A,68A,104A 'contain':13A,29A,42A,60A,85A 'creat':30A,40A 'daemon':70A,87A,115A 'demo':16A 'did':48A 'directori':151A 'distribut':83A 'docker':21A,32A,44A,66A,69A,84A,101A,136A,141A,155A,164A 'download':25A,55A 'for':170A 'form':9A,122A 'from':31A 'general':117A 'gui':132A 'host':77A,161A 'hub':137A 'if':157A 'imag':2A,28A,33A,52A,142A,156A,172A 'in':14A,93A 'interact':112A 'is':88A 'kitemat':128A 'line':105A 'list':57A 'manag':79A 'more':116A 'of':5A,12A,58A,123A,140A,146A,152A 'on':75A 'one':159A 'oper':95A 'other':121A 'our':6A 'own':163A 'process':90A 'provid':130A 'ps':67A 'pull':22A,171A 'registri':139A,148A,165A 'requir':158A 'run':35A,45A,59A,74A,81A,92A 'seen':63A 'servic':73A 'such':126A 'system':96A 'talk':99A 'terminolog':1A 'that':53A,78A,91A,107A 'the':3A,10A,15A,20A,26A,36A,50A,65A,71A,76A,86A,89A,94A,103A,109A,114A,134A,147A 'their':162A 'them':169A 'there':118A 'think':145A 'to':24A,100A,111A,133A 'too':125A 'tool':106A 'use':19A,43A,49A,64A,168A 'user':110A,135A 'we':18A,39A,47A,54A 'which':8A,46A,97A,129A 'with':113A 'you':143A	f	15	f	f	cli
8	2020-08-01 18:35:43.273583+00	2020-08-01 18:36:30.450971+00	ce8d9407-efdc-4f99-a7ba-ed67f2c0256c	2	390c68a4-869d-4a03-bacd-438c05f0d0c4	**Serve static website**\n\nThe image that we are going to use is a single-page website that I've already created for the purpose of this demo and hosted on the registry - prakhar1989/static-site. We can download and run the image directly in one go using docker run. As noted above, the --rm flag automatically removes the container when it exits.\n\n```$ docker run --rm prakhar1989/static-site```\nSince the image doesn't exist locally, the client will first fetch the image from the registry and then run the image. If all goes well, you should see a Nginx is running... message in your terminal. Okay now that the server is running, how to see the website? What port is it running on? And more importantly, how do we access the container directly from our host machine? Hit Ctrl+C to stop the container.\n\nWell, in this case, the client is not exposing any ports so we need to re-run the docker run command to publish ports. While we're at it, we should also find a way so that our terminal is not attached to the running container. This way, you can happily close your terminal and keep the container running. This is called detached mode.\n\n```\n$ docker run -d -P --name static-site prakhar1989/static-site\ne61d12292d69556eabe2a44c16cbd54486b2527e2ce4f95438e504afb7b02810\n```\nIn the above command, -d will detach our terminal, -P will publish all exposed ports to random ports and finally --name corresponds to a name we want to give. Now we can see the ports by running the docker port [CONTAINER] command\n\n```$ docker port static-site```\n80/tcp -> 0.0.0.0:32769\n443/tcp -> 0.0.0.0:32768\nYou can open http://localhost:32769 in your browser.\n	1596306943273544100	1596306990450947400	'0.0.0.0':265A,268A '32768':269A '32769':266A,274A '443/tcp':267A '80/tcp':264A 'a':13A,95A,176A,240A 'abov':51A,219A 'access':127A 'all':89A,229A 'alreadi':21A 'also':174A 'and':29A,38A,83A,121A,197A,235A 'ani':151A 'are':8A 'as':49A 'at':170A 'attach':184A 'automat':55A 'browser':277A 'by':252A 'c':137A 'call':204A 'can':36A,192A,248A,271A 'case':145A 'client':74A,147A 'close':194A 'command':163A,220A,258A 'contain':58A,129A,141A,188A,200A,257A 'correspond':238A 'creat':22A 'ctrl':136A 'd':209A,221A 'demo':28A 'detach':205A,223A 'direct':42A,130A 'do':125A 'docker':47A,62A,161A,207A,255A,259A 'doesn':69A 'download':37A 'e61d12292d69556eabe2a44c16cbd54486b2527e2ce4f95438e504afb7b02810':216A 'exist':71A 'exit':61A 'expos':150A,230A 'fetch':77A 'final':236A 'find':175A 'first':76A 'flag':54A 'for':23A 'from':80A,131A 'give':245A 'go':9A,45A 'goe':90A 'happili':193A 'hit':135A 'host':30A,133A 'how':110A,124A 'i':19A 'if':88A 'imag':5A,41A,68A,79A,87A 'import':123A 'in':43A,100A,143A,217A,275A 'is':12A,97A,108A,117A,148A,182A,203A 'it':60A,118A,171A 'keep':198A 'local':72A 'localhost':273A 'machin':134A 'messag':99A 'mode':206A 'more':122A 'name':211A,237A,241A 'need':155A 'nginx':96A 'not':149A,183A 'note':50A 'now':104A,246A 'of':26A 'okay':103A 'on':31A,120A 'one':44A 'open':272A 'our':132A,180A,224A 'p':210A,226A 'page':16A 'port':116A,152A,166A,231A,234A,251A,256A,260A 'prakhar1989/static-site':34A,65A,215A 'publish':165A,228A 'purpos':25A 'random':233A 're':158A,169A 're-run':157A 'registri':33A,82A 'remov':56A 'rm':53A,64A 'run':39A,48A,63A,85A,98A,109A,119A,159A,162A,187A,201A,208A,253A 'see':94A,112A,249A 'serv':1A 'server':107A 'should':93A,173A 'sinc':66A 'singl':15A 'single-pag':14A 'site':214A,263A 'so':153A,178A 'static':2A,213A,262A 'static-sit':212A,261A 'stop':139A 't':70A 'termin':102A,181A,196A,225A 'that':6A,18A,105A,179A 'the':4A,24A,32A,40A,52A,57A,67A,73A,78A,81A,86A,106A,113A,128A,140A,146A,160A,186A,199A,218A,250A,254A 'then':84A 'this':27A,144A,189A,202A 'to':10A,111A,138A,156A,164A,185A,232A,239A,244A 'use':11A,46A 've':20A 'want':243A 'way':177A,190A 'we':7A,35A,126A,154A,168A,172A,242A,247A 'websit':3A,17A,114A 'well':91A,142A 'what':115A 'when':59A 'while':167A 'will':75A,222A,227A 'you':92A,191A,270A 'your':101A,195A,276A	f	17	f	f	cli
9	2020-08-01 18:40:23.79062+00	2020-08-01 18:40:23.79062+00	25d5e6fd-aea9-43a4-a210-322f6a5f23bb	2	390c68a4-869d-4a03-bacd-438c05f0d0c4	**See container's exposed ports**\n\n```\ndocker port <container-name|container-id>\n```\n	1596307223790573900	0	'contain':2A,9A,12A 'container-id':11A 'container-nam':8A 'docker':6A 'expos':4A 'id':13A 'name':10A 'port':5A,7A 's':3A 'see':1A	f	18	f	f	cli
10	2020-08-01 19:04:02.843055+00	2020-08-01 19:04:02.843055+00	771444f6-ba81-41f6-83fd-89ba354bd05b	2	390c68a4-869d-4a03-bacd-438c05f0d0c4	**Dockerfile**\n\nA Dockerfile is a simple text file that contains a list of commands that the Docker client calls while creating an image. It's a simple way to automate the image creation process. The best part is that the commands you write in a Dockerfile are almost identical to their equivalent Linux commands. This means you don't really have to learn new syntax to create your own dockerfiles.\n	1596308642843018600	0	'a':2A,5A,11A,26A,45A 'almost':48A 'an':22A 'are':47A 'autom':30A 'best':36A 'call':19A 'client':18A 'command':14A,41A,54A 'contain':10A 'creat':21A,67A 'creation':33A 'docker':17A 'dockerfil':1A,3A,46A,70A 'don':58A 'equival':52A 'file':8A 'have':61A 'ident':49A 'imag':23A,32A 'in':44A 'is':4A,38A 'it':24A 'learn':63A 'linux':53A 'list':12A 'mean':56A 'new':64A 'of':13A 'own':69A 'part':37A 'process':34A 'realli':60A 's':25A 'simpl':6A,27A 'syntax':65A 't':59A 'text':7A 'that':9A,15A,39A 'the':16A,31A,35A,40A 'their':51A 'this':55A 'to':29A,50A,62A,66A 'way':28A 'while':20A 'write':43A 'you':42A,57A 'your':68A	f	19	f	f	cli
11	2020-08-01 19:13:10.573289+00	2020-08-01 19:13:10.573289+00	7c4d9cdf-42d8-477b-927f-d41fb0f62ff4	2	390c68a4-869d-4a03-bacd-438c05f0d0c4	# Running site locally\n\n```\ncd flask-app \ngit:(master) ✗ docker build -t pancaldim/catnip .  \ndocker run -p 5005:5005 pancaldim/catnip\n```\n\nDo not forget the -p or the port won't be exposed.\n\n\n	1596309190573253000	0	'5005':17A,18A 'app':7A 'be':30A 'build':11A 'cd':4A 'do':20A 'docker':10A,14A 'expos':31A 'flask':6A 'flask-app':5A 'forget':22A 'git':8A 'local':3A 'master':9A 'not':21A 'or':25A 'p':16A,24A 'pancaldim/catnip':13A,19A 'port':27A 'run':1A,15A 'site':2A 't':12A,29A 'the':23A,26A 'won':28A	f	20	f	f	cli
\.


--
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: dnote
--

COPY public.notifications (id, created_at, updated_at, type, user_id) FROM stdin;
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: dnote
--

COPY public.sessions (id, created_at, updated_at, user_id, key, last_used_at, expires_at) FROM stdin;
4	2020-08-01 11:14:19.332842+00	2020-08-01 11:14:19.332842+00	2	py/+vkvDrHdKHSs6nnLrV+NNXRbNUfBn52kdyoCN34U=	2020-08-01 11:14:19.332554+00	2020-11-09 11:14:19.332565+00
5	2020-08-01 11:24:54.478729+00	2020-08-01 11:24:54.478729+00	2	xgwtrPHJCFQqznptdXzmlL6AAFFHR4tdzITKX3FLtMg=	2020-08-01 11:24:54.478454+00	2020-11-09 11:24:54.478465+00
\.


--
-- Data for Name: tokens; Type: TABLE DATA; Schema: public; Owner: dnote
--

COPY public.tokens (id, created_at, updated_at, user_id, value, type, used_at) FROM stdin;
1	2020-08-01 11:04:23.626428+00	2020-08-01 11:04:23.626428+00	1	FdTeCh90XVVkcJLwvgs6cg==	email_preference	\N
2	2020-08-01 11:04:47.414069+00	2020-08-01 11:04:47.414069+00	2	9AXc4W03gPQSrBFdUleesQ==	email_preference	\N
3	2020-08-01 11:12:47.631284+00	2020-08-01 11:12:47.631284+00	2	IhEhbP8JctRFoOHBWfivsg==	email_verification	\N
4	2020-08-01 11:13:30.617754+00	2020-08-01 11:13:30.617754+00	2	7Diq8rnk6eYuGdbPk7USyA==	email_verification	\N
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: dnote
--

COPY public.users (id, created_at, updated_at, uuid, last_login_at, max_usn, cloud) FROM stdin;
1	2020-08-01 11:04:23.601508+00	2020-08-01 11:04:23.744025+00	617a42d5-f3ee-4022-8d21-29a77c28b46b	2020-08-01 11:04:23.743877+00	0	t
2	2020-08-01 11:04:47.408898+00	2020-08-01 22:39:56.674212+00	63af5e0d-a542-46f4-a247-78b67be797f6	2020-08-01 22:39:56.672484+00	24	t
\.


--
-- Name: accounts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dnote
--

SELECT pg_catalog.setval('public.accounts_id_seq', 2, true);


--
-- Name: books_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dnote
--

SELECT pg_catalog.setval('public.books_id_seq', 6, true);


--
-- Name: email_preferences_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dnote
--

SELECT pg_catalog.setval('public.email_preferences_id_seq', 2, true);


--
-- Name: notes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dnote
--

SELECT pg_catalog.setval('public.notes_id_seq', 12, true);


--
-- Name: notifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dnote
--

SELECT pg_catalog.setval('public.notifications_id_seq', 1, false);


--
-- Name: sessions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dnote
--

SELECT pg_catalog.setval('public.sessions_id_seq', 5, true);


--
-- Name: tokens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dnote
--

SELECT pg_catalog.setval('public.tokens_id_seq', 4, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dnote
--

SELECT pg_catalog.setval('public.users_id_seq', 2, true);


--
-- Name: accounts accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: dnote
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (id);


--
-- Name: books books_pkey; Type: CONSTRAINT; Schema: public; Owner: dnote
--

ALTER TABLE ONLY public.books
    ADD CONSTRAINT books_pkey PRIMARY KEY (id);


--
-- Name: email_preferences email_preferences_pkey; Type: CONSTRAINT; Schema: public; Owner: dnote
--

ALTER TABLE ONLY public.email_preferences
    ADD CONSTRAINT email_preferences_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: dnote
--

ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: notes notes_pkey; Type: CONSTRAINT; Schema: public; Owner: dnote
--

ALTER TABLE ONLY public.notes
    ADD CONSTRAINT notes_pkey PRIMARY KEY (id);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: dnote
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: dnote
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: tokens tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: dnote
--

ALTER TABLE ONLY public.tokens
    ADD CONSTRAINT tokens_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: dnote
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: idx_accounts_user_id; Type: INDEX; Schema: public; Owner: dnote
--

CREATE INDEX idx_accounts_user_id ON public.accounts USING btree (user_id);


--
-- Name: idx_books_label; Type: INDEX; Schema: public; Owner: dnote
--

CREATE INDEX idx_books_label ON public.books USING btree (label);


--
-- Name: idx_books_user_id; Type: INDEX; Schema: public; Owner: dnote
--

CREATE INDEX idx_books_user_id ON public.books USING btree (user_id);


--
-- Name: idx_books_usn; Type: INDEX; Schema: public; Owner: dnote
--

CREATE INDEX idx_books_usn ON public.books USING btree (usn);


--
-- Name: idx_books_uuid; Type: INDEX; Schema: public; Owner: dnote
--

CREATE INDEX idx_books_uuid ON public.books USING btree (uuid);


--
-- Name: idx_email_preferences_user_id; Type: INDEX; Schema: public; Owner: dnote
--

CREATE INDEX idx_email_preferences_user_id ON public.email_preferences USING btree (user_id);


--
-- Name: idx_notes_book_uuid; Type: INDEX; Schema: public; Owner: dnote
--

CREATE INDEX idx_notes_book_uuid ON public.notes USING btree (book_uuid);


--
-- Name: idx_notes_client; Type: INDEX; Schema: public; Owner: dnote
--

CREATE INDEX idx_notes_client ON public.notes USING btree (client);


--
-- Name: idx_notes_tsv; Type: INDEX; Schema: public; Owner: dnote
--

CREATE INDEX idx_notes_tsv ON public.notes USING gin (tsv);


--
-- Name: idx_notes_user_id; Type: INDEX; Schema: public; Owner: dnote
--

CREATE INDEX idx_notes_user_id ON public.notes USING btree (user_id);


--
-- Name: idx_notes_usn; Type: INDEX; Schema: public; Owner: dnote
--

CREATE INDEX idx_notes_usn ON public.notes USING btree (usn);


--
-- Name: idx_notes_uuid; Type: INDEX; Schema: public; Owner: dnote
--

CREATE INDEX idx_notes_uuid ON public.notes USING btree (uuid);


--
-- Name: idx_notifications_user_id; Type: INDEX; Schema: public; Owner: dnote
--

CREATE INDEX idx_notifications_user_id ON public.notifications USING btree (user_id);


--
-- Name: idx_sessions_key; Type: INDEX; Schema: public; Owner: dnote
--

CREATE INDEX idx_sessions_key ON public.sessions USING btree (key);


--
-- Name: idx_sessions_user_id; Type: INDEX; Schema: public; Owner: dnote
--

CREATE INDEX idx_sessions_user_id ON public.sessions USING btree (user_id);


--
-- Name: idx_tokens_user_id; Type: INDEX; Schema: public; Owner: dnote
--

CREATE INDEX idx_tokens_user_id ON public.tokens USING btree (user_id);


--
-- Name: idx_tokens_value; Type: INDEX; Schema: public; Owner: dnote
--

CREATE INDEX idx_tokens_value ON public.tokens USING btree (value);


--
-- Name: idx_users_uuid; Type: INDEX; Schema: public; Owner: dnote
--

CREATE INDEX idx_users_uuid ON public.users USING btree (uuid);


--
-- Name: notes tsvectorupdate; Type: TRIGGER; Schema: public; Owner: dnote
--

CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE ON public.notes FOR EACH ROW EXECUTE PROCEDURE public.note_tsv_trigger();


--
-- PostgreSQL database dump complete
--

