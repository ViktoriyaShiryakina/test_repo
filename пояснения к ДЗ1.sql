-- ЗАДАНИЕ 1
-- Переделываем все 3 документа в формат csv и создаем таблицы в postgresql
-- скрипт для таблицы listing

DROP TABLE IF EXISTS public.listing;

CREATE TABLE public.listing
(
    "ID" integer NOT NULL,
    "ISIN" text NOT NULL,
    "PLATFORM" text NOT NULL,
    "SECTION" text NOT NULL,
    CONSTRAINT listing_pkey PRIMARY KEY ("ID")
)

TABLESPACE pg_default;

ALTER TABLE public.listing
    OWNER to postgres;
	
--Создание таблицы public.quotes:

DROP TABLE IF EXISTS public.quotes;

CREATE TABLE public.quotes
(
    "ID" integer NOT NULL,
    "TIME" date NOT NULL,
    "ACCRUEDINT" real,
    "ASK" real,
    "ASK_SIZE" integer,
    "ASK_SIZE_TOTAL" integer,
    "AVGE_PRCE" numeric,
    "BID" real,
    "BID_SIZE" integer,
    "BID_SIZE_TOTAL" integer,
    "BOARDID" text,
    "BOARDNAME" text,
    "BUYBACKDATE" date,
    "BUYBACKPRICE" numeric,
    "CBR_LOMBARD" real,
    "CBR_PLEDGE" real,
    "CLOSE" numeric,
    "CPN" real,
    "CPN_DATE" date,
    "CPN_PERIOD" integer,
    "DEAL_ACC" integer,
    "FACEVALUE" numeric,
    "ISIN" text,
    "ISSUER" text,
    "ISSUESIZE" numeric,
    "MAT_DATE" date,
    "MPRICE" numeric,
    "MPRICE2" numeric,
    "SPREAD" real,
    "VOL_ACC" numeric,
    "Y2O_ASK" real,
    "Y2O_BID" real,
    "YIELD_ASK" real,
    "YIELD_BID" real
)

TABLESPACE pg_default;

ALTER TABLE public.quotes
    OWNER to postgres;

-- Создание таблицы public.bond_description

DROP TABLE IF EXISTS public.bond_description;

CREATE TABLE public.bond_description
(
    "ISIN_REGCODE_NRDCODE" text NOT NULL,
    "FIN_TOOL_TYPE" text NOT NULL,
    "SECURITY_TYPE" text ,
    "SECURITY_KIND" text,
    "COUPON_TYPE" text,
    "RATE_TYPE_NAME_RUS_NRD",
    "COUPON_TYPE_NAME_NRD" text,
    "HAVE_OFFER" boolean NOT NULL,
    "AMORTISED_MTY" boolean NOT NULL,
    "MATURITY_GROUP" text COLLATE,
    "IS_CONVERTIBLE" boolean NOT NULL,
    "ISIN_CODE" text NOT NULL,
    "STATUS" text NOT NULL,
    "HAVE_DEFAULT" boolean NOT NULL,
    "ISLOMBARDCBR_NRD" boolean,
    "ISQUALIFIED_NRD" boolean, 
    "FORMARKETBONDS_NRD" boolean,
    "MICEXLIST_NRD" text,
    "BASIS" text,
    "BASIS_NRD" text, 
    "BASE_MONTH" text,
    "BASE_YEAR" text,
    "COUPON_PERIOD_BASE_ID" integer,
    "ACCRUEDINTCALCTYPE" boolean NOT NULL,
    "ISGUARANTEED" boolean NOT NULL,
    "GUARANTEE_TYPE" text,
    "GUARANTEE_AMOUNT" text,
    "GUARANTVAL" numeric,
    "SECURITIZATION" text,
    "COUPONPERYEAR" integer,
    "CP_TYPE_ID" smallint,
    "NUMCOUPONS" smallint,
    "NUMCOUPONS_M" smallint NOT NULL,
    "NUMCOUPONS_NRD" smallint,
    "COUNTRY" char NOT NULL,
    "FACEFTNAME" char NOT NULL,
    "FACEFTNAME_M" smallint NOT NULL,
    "FACEFTNAME_NRD" char,
    "FACEVALUE" real NOT NULL,
    "FACEVALUE_M" smallint NOT NULL,
    "FACEVALUE_NRD" real,
    "CURRENTFACEVALUE_NRD" real,
    "BORROWER_NAME" text NOT NULL,
    "BORROWER_OKPO" integer,
    "BORROWER_SECTOR" text,
    "BORROWER_UID" integer NOT NULL,
    "ISSUER_NAME" text NOT NULL,
    "ISSUER_NAME_NRD" text,
    "ISSUER_OKPO" integer,
    "NUM_GUARANTORS" smallint NOT NULL,
    "END_MTY_DATE" date,
    CONSTRAINT bond_description_pkey PRIMARY KEY ("ISIN_REGCODE_NRDCODE")
)

TABLESPACE pg_default;

ALTER TABLE public.bond_description
    OWNER to postgres;

-- Импортируем данные из файла csv в postgresql (таблица listing)
\copy public.listing FROM 'C:\Users\USER\Desktop\IT для финансистов\ДЗ1_NEW\listing.csv' DELIMITER ';' CSV HEADER;

-- Импортируем данные из файла csv в postgresql (таблица bond_description)
-- предварительно нужно переделать формат данных в полях HAVEOFFER и AMORTISEDMTY в формат "число" в Ms Excel, а в 133 строке вообще сделать это вручную, заменить на 0.
\copy public.bond_description FROM 'C:\Users\USER\Desktop\IT для финансистов\ДЗ1_NEW\bond_description.csv' DELIMITER ';' CSV HEADER;

-- Импортируем данные из файла csv в postgresql (таблица quotes). Предварительно нужно переделать поля TIME и BUYBACKDATE в форма "Дата" в Ms Excel;
\copy public.quotes FROM 'C:\Users\USER\Desktop\IT для финансистов\ДЗ1_NEW\quotes.csv' DELIMITER ';' CSV HEADER;

--ЗАДАНИЕ 2.
--Добавляем в таблицу listing поля с кодами-сылками на таблицу bond_description и quotes:
ALTER TABLE listing ADD COLUMN "ISSUER_NAME" text, 
ADD COLUMN "ISSUER_NAME_NRD" text, 
ADD COLUMN "ISSUER_OKPO" integer, 
ADD COLUMN "BOARDID" text, 
ADD COLUMN "BOARDNAME" text;

--заполнение полей с кодами-ссылками на таблицу bond_description:
update listing_task
set("ISSUER_NAME","ISSUER_NAME_NRD","ISSUER_OKPO")=(SELECT "ISSUER_NAME","ISSUER_NAME_NRD","ISSUER_OKPO"
									 from bond_description_task
									 where listing_task."ISIN"=bond_description_task."ISIN_CODE");
									 
--Представленный ниже способ занимает у меня очень долгое время (попросту не грузит), и поэтому лучше идти в обход через вынесение данных в отдельную таблицу:
update listing 
set ("BOARDID", "BOARDNAME")=(select distinct "BOARDID","BOARDNAME" from quotes where listing."ID"=quotes."ID";

-- Создаем новую таблицу, чтобы связать данные для добавления в таблицу listing полей из таблицы quotes:
DROP TABLE IF EXISTS public.board_info;

CREATE TABLE public.board_info
(
    "ID" bigint NOT NULL,
    "BOARDID" text,
    "BOARDNAME" text,
    CONSTRAINT board_info_pkey PRIMARY KEY ("ID")
)

TABLESPACE pg_default;

ALTER TABLE public.board_info
    OWNER to postgres;

--вынесение данных в новую таблицу boardinfo из таблицы quotes:
insert into board_info
select distinct "ID", "BOARDID","BOARDNAME"
from quotes;
 
--заполнение полей с кодами-ссылками на новую таблицу boardinfo
update listing
set("BOARDID","BOARDNAME")=(SELECT "BOARDID","BOARDNAME"
									 from board_info
									 where listing."ID"=board_info."ID");
									 
--ЗАДАНИЕ 3.
--Чтобы связать таблицы quotes и listing через внешний ключ, нужно сначала внести в поле ID таблицы listing,которое является для нее первичным ключом,
недостающие значения из таблицы quotes:
--НО! Предварительно снимаем требование null с полей ISIN,PLATFORM и SECTION в таблице listing:
insert into listing ("ID", "ISIN", "BOARDID", "BOARDNAME")
select distinct quotes."ID", quotes."ISIN", quotes."BOARDID", quotes."BOARDNAME"
from quotes left join listing on quotes."ID"=listing."ID"
where listing."ID" is null;

--Затем присваиваем внешний ключ:
ALTER TABLE quotes
ADD CONSTRAINT fr_key_1 FOREIGN KEY ("ID") REFERENCES listing ("ID");

-- Теперь, для того, чтобы связать таблицы listing и bond_description, нужно в таблице bond_description создать поле ID (по этому полю будем связывать эти таблицы):
alter table bond_description
add column "ID" integer;

-- Импортируем в это поле значения ID из таблицы listing:
UPDATE bond_description
SET "ID"=listing."ID"
FROM listing
WHERE bond_description."ISIN, REGCODE, NRDCODE"=listing."ISIN";

-- Присваиваем внешний ключ для таблицы bond_description:
ALTER TABLE bond_description
ADD CONSTRAINT fr_key_1 FOREIGN KEY ("ID") REFERENCES listing ("ID");


--ЗАДАНИЕ 4 
with quotes_1 as (
-- считаем, сколько всего было наблюдений за бумагами, удовлетворяющих условию торговли на МБ в режиме основных торгов 
	select listing."ISIN", listing."ISSUER_NAME", count (quotes."TIME") as gen_obs
	from quotes inner join listing
	on listing."ID"=quotes."ID"
	where listing."SECTION"=' Основной' and listing."PLATFORM"='Московская Биржа '
	group by listing."ISIN", listing."ISSUER_NAME"
), quotes_2 as (
--считаем кол-во дней, когда котировка ASK не существовала или была бы равна 0 среди тех облигаций, которые торгуются на МБ в режиме основных торгов
	select listing."ISIN", listing."ISSUER_NAME", count (quotes."TIME") as day_missed
	from quotes inner join listing
	on listing."ID"=quotes."ID"
	where listing."SECTION"=' Основной' and listing."PLATFORM"='Московская Биржа '
	and (quotes."ASK" is not null and quotes."ASK">0)
	group by listing."ISIN", listing."ISSUER_NAME")
select quotes_2."ISIN",
quotes_2."ISSUER_NAME",
(quotes_2.day_missed::real / quotes_1.gen_obs::real) as nun_ratio
from quotes_1 inner join quotes_2 
on quotes_1."ISIN"=quotes_2."ISIN"
where (quotes_2.day_missed::real / quotes_1.gen_obs::real)>0.9;



