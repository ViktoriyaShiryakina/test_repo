-- К заданию 1
-- Переделываем все 3 документа в формат csv и создаем таблицы в postgresql
-- скрипт для таблицы listing_task

DROP TABLE IF EXISTS public.listing_task;

CREATE TABLE public.listing_task
(
    "ID" integer NOT NULL,
    "ISIN" text NOT NULL,
    "PLATFORM" text NOT NULL,
    "SECTION" text NOT NULL,
    CONSTRAINT listing_task_pkey PRIMARY KEY ("ID")
)

TABLESPACE pg_default;

ALTER TABLE public.listing_task
    OWNER to postgres;
	
--Создание таблицы public.quotes_task:

DROP TABLE IF EXISTS public.quotes_task;

CREATE TABLE public.quotes_task
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

ALTER TABLE public.quotes_task
    OWNER to postgres;

-- Создание таблицы public.bond_description_task

DROP TABLE IF EXISTS public.bond_description_task;

CREATE TABLE public.bond_description_task
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
    CONSTRAINT bond_description_task_pkey PRIMARY KEY ("ISIN_REGCODE_NRDCODE")
)

TABLESPACE pg_default;

ALTER TABLE public.bond_description_task
    OWNER to postgres;

-- Импортируем данные из файла csv в postgresql (таблица listing_task)
\copy public.listing_task  FROM 'C:\Users\USER\Desktop\IT для финансистов\ДЗ №1\Data\Облигации\listing_task.csv' 
DELIMITER ';' CSV HEADER;
-- Импортируем данные из файла csv в postgresql (таблица bond_description_task)
\copy public.bond_description_task  FROM 'C:\Users\USER\Desktop\IT для финансистов\ДЗ №1\Data\Облигации\bond_description_task.csv' 
DELIMITER ';' CSV HEADER;
-- Импортируем данные из файла csv в postgresql (таблица quotes_task)
\copy public.quotes_task  FROM 'C:\Users\USER\Desktop\IT для финансистов\ДЗ №1\Data\Облигации\quotes_task.csv' 
DELIMITER ';' CSV HEADER;
--Замечание: в процессе импорта данных будет неоднократно требоваться поменять форматы определенных столбцов в csv-файле.

-- Комментарий: 
-- А какой именно был порядок изменения формата столбцов. Не зная этого, мне сложно воспроизвести импорт данных, будут ошибки из-за несоответствия импортируемых данных форматам полей.

--Удаление лишних столбцов из таблицы public.bond_description_task (тех, которые были скрыты в изначальном файле excel):
ALTER TABLE public.bond_description_task
DROP COLUMN "ISLOMBARDCBR_NRD", 
DROP COLUMN "ISQUALIFIED_NRD",
DROP COLUMN "FORMARKETBONDS_NRD",
DROP COLUMN "MICEXLIST_NRD",
DROP COLUMN "BASIS",
DROP COLUMN "BASIS_NRD",
DROP COLUMN "BASE_MONTH",
DROP COLUMN "BASE_YEAR",
DROP COLUMN "COUPON_PERIOD_BASE_ID",
DROP COLUMN "ACCRUEDINTCALCTYPE",
DROP COLUMN "ISGUARANTEED",
DROP COLUMN "GUARANTVAL",
DROP COLUMN "SECURITIZATION",
DROP COLUMN "COUPONPERYEAR",
DROP COLUMN "CP_TYPE_ID", 
DROP COLUMN "NUMCOUPONS",
DROP COLUMN "NUMCOUPONS_M",
DROP COLUMN "NUMCOUPONS_NRD",
DROP COLUMN "COUNTRY",
DROP COLUMN "FACEFTNAME", 
DROP COLUMN "FACEFTNAME_M", 
DROP COLUMN "FACEFTNAME_NRD", 
DROP COLUMN "FACEVALUE", 
DROP COLUMN "FACEVALUE_M", 
DROP COLUMN "FACEVALUE_NRD", 
DROP COLUMN "CURRENTFACEVALUE_NRD";

--К заданию 2.
--Добавляем в таблицу listing_task полей с кодами-сылками на таблицу bond_description_task и quotes_task:
ALTER TABLE listing_task ADD COLUMN "ISSUER_NAME" text, 
ADD COLUMN "ISSUER_NAME_NRD" text, 
ADD COLUMN "ISSUER_OKPO" integer, 
ADD COLUMN "BOARDID" text, 
ADD COLUMN "BOARDNAME" text,

--заполнение полей с кодами-ссылками на таблицу bond_description_task:
update listing_task
set("ISSUER_NAME","ISSUER_NAME_NRD","ISSUER_OKPO")=(SELECT "ISSUER_NAME","ISSUER_NAME_NRD","ISSUER_OKPO"
									 from bond_description_task
									 where listing_task."ISIN"=bond_description_task."ISIN_CODE");
-- Создаем новую таблицу, чтобы связать данные для добавления в таблицу listing_task полей из таблицы quotes_task:
DROP TABLE IF EXISTS public.exchange;

CREATE TABLE public.exchange
(
    exchange_order bigint NOT NULL,
    "ID" bigint NOT NULL,
    "BOARDID" text COLLATE pg_catalog."default",
    "BOARDNAME" text COLLATE pg_catalog."default"
)

TABLESPACE pg_default;

ALTER TABLE public.exchange
    OWNER to postgres;

--вынесение данных в новую таблицу exchange из таблицы quotes_task:
insert into exchange select count(*) over (order by "ID", "BOARDID","BOARDNAME") as exchange_order,
"ID", "BOARDID","BOARDNAME"
from (select distinct "ID", "BOARDID","BOARDNAME"
from quotes_task)
 as my_select;
 
--заполнение полей с кодами-ссылками на новую таблицу exchange
update listing_task
set("BOARDID","BOARDNAME")=(SELECT "BOARDID","BOARDNAME"
									 from exchange
									 where listing_task."ID"=exchange."ID");
--К ЗАДАНИЮ 3.
--Присваиваем первичный ключ таблице exchange:
ALTER TABLE exchange ADD PRIMARY KEY ("exchange_order");

-- присвоение полю ограничение внешнего ключа
ALTER TABLE public.listing_task
ADD CONSTRAINT fr_key_1 FOREIGN KEY ("exchange_order") REFERENCES public.exchange ("exchange_order");

-- Комментарий:
-- Эмм... А как же связь между quotes и listing? 

--К ЗАДАНИЮ 4 (написано только начало кода)
select "ISIN", count ("TIME") as day_missed
from quotes_task
where "BOARDNAME"='ЦК - Режим основных торгов' and "ASK"=0
group by "ISIN";

-- Комментарий:
-- Нужно дописывать. :)

