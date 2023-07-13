/*스키마 생성*/

CREATE SCHEMA IF NOT EXISTS "AGENTMASTER"
    AUTHORIZATION postgres;

/*고객*/

CREATE TABLE IF NOT EXISTS "AGENTMASTER"."Customer"
(
    customer_id  varchar(20)     NOT NULL,
    password     varchar(20)     NOT NULL,
    e_mail       text            NOT NULL,
    simul_money  integer         NOT NULL,
    total_return integer         NOT NULL,
    total_range  numeric(10, 2)   NOT NULL,
    CONSTRAINT Customer_pkey PRIMARY KEY (customer_id),
	CONSTRAINT customer_id_between CHECK(customer_id NOT BETWEEN 'ㄱ' AND '힣'),
	CONSTRAINT customer_email_check CHECK (e_mail LIKE '%@%.%')
)
    TABLESPACE pg_default;

ALTER TABLE IF EXISTS "AGENTMASTER"."Customer"
    OWNER to postgres;

/*주식*/


CREATE TABLE IF NOT EXISTS "AGENTMASTER"."Stock"
(
    stock_id   varchar(20)  NOT NULL,
    stock_name varchar(100) NOT NULL,
    field_name varchar(100) NOT NULL,
    CONSTRAINT Stock_pkey PRIMARY KEY (stock_id),
    CONSTRAINT stock_name_unique UNIQUE (stock_name),
	CONSTRAINT stock_id_check CHECK (stock_id LIKE '______'),
    CONSTRAINT field_name_fkey FOREIGN KEY (field_name)
        REFERENCES "AGENTMASTER"."Field" (field_name) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
)
    TABLESPACE pg_default;

ALTER TABLE IF EXISTS "AGENTMASTER"."Stock"
    OWNER to postgres;


/*주식정보*/


CREATE TABLE IF NOT EXISTS "AGENTMASTER"."Stock_info"
(
    stock_id          varchar(20)   NOT NULL,
    stock_date        date          NOT NULL,
    stock_price       integer       NOT NULL,
    diff_from_prevday integer       NOT NULL,
    range             numeric(4, 2) NOT NULL,
    CONSTRAINT Stock_info_pkey PRIMARY KEY (stock_id, stock_date),
    CONSTRAINT stock_id_fk FOREIGN KEY (stock_id)
        REFERENCES "AGENTMASTER"."Stock" (stock_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
)
    TABLESPACE pg_default;

ALTER TABLE IF EXISTS "AGENTMASTER"."Stock_info"
    OWNER to postgres;


/*모의투자*/


CREATE TABLE IF NOT EXISTS "AGENTMASTER"."Simulation"
(
    customer_id    varchar(20)   NOT NULL,
    stock_id       varchar(20)   NOT NULL,
    simul_return   integer       NOT NULL,
    simul_range    NUMERIC(10, 2) NOT NULL,
    simul_holdings integer       NOT NULL,
    CONSTRAINT Simulation_pkey PRIMARY KEY (customer_id, stock_id),
    CONSTRAINT customer_id_fk FOREIGN KEY (customer_id)
        REFERENCES "AGENTMASTER"."Customer" (customer_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT stock_id FOREIGN KEY (stock_id)
        REFERENCES "AGENTMASTER"."Stock" (stock_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
)
    TABLESPACE pg_default;

ALTER TABLE IF EXISTS "AGENTMASTER"."Simulation"
    OWNER to postgres;


/*북마크*/


CREATE TABLE IF NOT EXISTS "AGENTMASTER"."Bookmark"
(
    customer_id varchar(20) NOT NULL,
    stock_id    varchar(20) NOT NULL,
    CONSTRAINT Bookmark_pkey PRIMARY KEY (customer_id, stock_id),
    CONSTRAINT customer_id_fk FOREIGN KEY (customer_id)
        REFERENCES "AGENTMASTER"."Customer" (customer_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT stock_id_fk FOREIGN KEY (stock_id)
        REFERENCES "AGENTMASTER"."Stock" (stock_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
)
    TABLESPACE pg_default;

ALTER TABLE IF EXISTS "AGENTMASTER"."Bookmark"
    OWNER to postgres;
