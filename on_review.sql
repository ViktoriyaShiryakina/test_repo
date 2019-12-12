-- Создаем таблицу bond_description после предварительного редактирования excel-файла

-- Table: public.bond_description

-- DROP TABLE public.bond_description;

CREATE TABLE public.bond_description
(
    "ISIN, RegCode, NRDCode" text COLLATE pg_catalog."default" NOT NULL,
    "FinToolType" text COLLATE pg_catalog."default" NOT NULL,
    "SecurityType" text COLLATE pg_catalog."default",
    "SecurityKind" text COLLATE pg_catalog."default",
    "CouponType" text COLLATE pg_catalog."default",
    "RateTypeNameRus_NRD" text COLLATE pg_catalog."default",
    "CouponTypeName_NRD" text COLLATE pg_catalog."default",
    "HaveOffer" boolean NOT NULL,
    "AmortisedMty" boolean NOT NULL,
    "MaturityGroup" text COLLATE pg_catalog."default",
    "IsConvertible" boolean NOT NULL,
    "ISINCode" text COLLATE pg_catalog."default" NOT NULL,
    "Status" text COLLATE pg_catalog."default",
    "HaveDefault" boolean NOT NULL,
    "IsLombardCBR_NRD" boolean,
    "IsQualified_NRD" boolean,
    "ForMarketBonds_NRD" boolean,
    "MicexList_NRD" text COLLATE pg_catalog."default",
    "Basis" text COLLATE pg_catalog."default",
    "Basis_NRD" text COLLATE pg_catalog."default",
    "Base_Month" smallint NOT NULL,
    "Base_Year" smallint NOT NULL,
    "Coupon_Period_Base_ID" smallint,
    "AccruedintCalcType" boolean NOT NULL,
    "IsGuaranteed" boolean NOT NULL,
    "GuaranteeType" text COLLATE pg_catalog."default",
    "GuaranteeAmount" text COLLATE pg_catalog."default",
    "GuarantVal" bigint,
    "Securitization" text COLLATE pg_catalog."default",
    "CouponPerYear" smallint,
    "Cp_Type_ID" smallint,
    "NumCoupons" smallint,
    "NumCoupons_M" smallint NOT NULL,
    "NumCoupons_NRD" smallint,
    "Country" text COLLATE pg_catalog."default" NOT NULL,
    "FaceFTName" text COLLATE pg_catalog."default" NOT NULL,
    "FaceFTName_M" smallint NOT NULL,
    "FaceFTName_NRD" text COLLATE pg_catalog."default",
    "FaceValue" bigint NOT NULL,
    "FaceValue_M" smallint NOT NULL,
    "FaceValue_NRD" bigint,
    "CurrentFaceValue_NRD" bigint,
    "BorrowerName" text COLLATE pg_catalog."default" NOT NULL,
    "BorrowerOKPO" bigint,
    "BorrowerSector" text COLLATE pg_catalog."default",
    "BorrowerUID" integer NOT NULL,
    "IssuerName" text COLLATE pg_catalog."default" NOT NULL,
    "IssuerName_NRD" text COLLATE pg_catalog."default",
    "IssuerOKPO" bigint,
    "NumGuarantors" smallint NOT NULL,
    "EndMtyDate" date,
    CONSTRAINT bond_description_pkey PRIMARY KEY ("ISIN, RegCode, NRDCode")
)

TABLESPACE pg_default;

ALTER TABLE public.bond_description
    OWNER to postgres;

copy public.bond_description  FROM 'D:\Dta\Data\bond_description_task.csv' DELIMITER ';' CSV HEADER ENCODING 'WIN 1251';

-- Создаем таблицу listing

-- Table: public.listing

-- DROP TABLE public.listing;

CREATE TABLE public.listing
(
    "ID" integer NOT NULL,
    "ISIN" text COLLATE pg_catalog."default" NOT NULL,
    "Platform" text COLLATE pg_catalog."default" NOT NULL,
    "Section" text COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT listing_pkey PRIMARY KEY ("ID")
)

TABLESPACE pg_default;

ALTER TABLE public.listing
    OWNER to postgres;

copy public.listing  FROM 'D:\Dta\Data\listing_task.csv' DELIMITER ';' CSV HEADER ENCODING 'WIN 1251';

-- Создаем  таблицу quotes после предварительного редактирования excel-файла

-- Table: public.quotes

-- DROP TABLE public.quotes;

CREATE TABLE public.quotes
(
    "ID" integer NOT NULL,
    "TIME" date NOT NULL,
    "ACCRUEDINT" text COLLATE pg_catalog."default",
    "ASK" text COLLATE pg_catalog."default",
    "ASK_SIZE" integer,
    "ASK_SIZE_TOTAL" integer,
    "AVGE_PRCE" text COLLATE pg_catalog."default",
    "BID" text COLLATE pg_catalog."default",
    "BID_SIZE" integer,
    "BID_SIZE_TOTAL" integer,
    "BOARDID" text COLLATE pg_catalog."default",
    "BOARDNAME" text COLLATE pg_catalog."default",
    "BUYBACKDATE" date,
    "BUYBACKPRICE" text COLLATE pg_catalog."default",
    "CBR_LOMBARD" text COLLATE pg_catalog."default",
    "CBR_PLEDGE" text COLLATE pg_catalog."default",
    "CLOSE" text COLLATE pg_catalog."default",
    "CPN" text COLLATE pg_catalog."default",
    "CPN_DATE" date,
    "CPN_PERIOD" integer,
    "DEAL_ACC" integer,
    "FACEVALUE" text COLLATE pg_catalog."default",
    "ISIN" text COLLATE pg_catalog."default",
    "ISSUER" text COLLATE pg_catalog."default",
    "ISSUESIZE" bigint,
    "MAT_DATE" date,
    "MPRICE" text COLLATE pg_catalog."default",
    "MPRICE2" text COLLATE pg_catalog."default",
    "SPREAD" text COLLATE pg_catalog."default",
    "VOL_ACC" bigint,
    "Y2O_ASK" text COLLATE pg_catalog."default",
    "Y2O_BID" text COLLATE pg_catalog."default",
    "YIELD_ASK" text COLLATE pg_catalog."default",
    "YIELD_BID" text COLLATE pg_catalog."default"
)

TABLESPACE pg_default;

ALTER TABLE public.quotes
    OWNER to postgres;

copy public.quotes  FROM 'D:\Dta\Data\quotes_task.csv' DELIMITER ';' CSV HEADER ENCODING 'WIN 1251';


-- Соединяем данные о заемщике из таблицы bond_description и данные о площадке из таблицы quotes
-- с данными из таблицы listing (протестить нормально не смог, ноут дико вис)

SELECT public.listing."ID", public.listing."ISIN", public.listing."Platform", public.listing."Section" , 
	   public.bond_description."IssuerName", public.bond_description."IssuerName_NRD", public.bond_description."IssuerOKPO", 
	   public.quotes."BOARDID", public.quotes."BOARDNAME"
FROM ((public.listing
INNER JOIN public.bond_description ON public.listing."ISIN" = public.bond_description."ISIN, RegCode, NRDCode")
INNER JOIN public.quotes ON public.listing."ISIN" = public.quotes."ISIN")
;

-- Задаем ключи для таблиц из нашей БД

ALTER TABLE public.listing
ADD CONSTRAINT listing_pkey PRIMARY KEY ("ISIN")
;

ALTER TABLE public.bond_description
ADD CONSTRAINT bond_description_fkey FOREIGN KEY ("ISIN, RegCode, NRDCode") REFERENCES public.listing ("ISIN")
;

ALTER TABLE public.quotes
ADD CONSTRAINT quotes_fkey FOREIGN KEY ("ISIN") REFERENCES public.listing ("ISIN")
;


-- Заданьице 4. Здесь прям не уверен т.к. не мог проверить из-за того, что БД не грузится

SELECT public.bond_description"IssuerName", public.listing."ISIN", public.quotes."ASK" AS "nun_ratio"
FROM ((public.bond_description
	INNER JOIN public.listing ON public.bond_description."ISIN, RegCode, NRDCode" = public.listing."ISIN")
	INNER JOIN public.quotes ON public.bond_description."ISIN, RegCode, NRDCode" = public.quotes."ISIN")
WHERE public.listing."Platform" LIKE 'Московская%'
	AND public.listing."Section" LIKE 'Основн%'
	AND count ("ASK")
		(WHERE "ASK" = 0) <= 0.1 * count ("ASK") 
;
