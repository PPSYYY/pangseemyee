-- Represent countries and their code.
CREATE TABLE "countries"(
    "id" INTEGER,
    "code" VARCHAR(3), --codes are three-letter country codes defined in ISO 3166-1
    "name" VARCHAR(60) NOT NULL UNIQUE,
     PRIMARY KEY("id")
);


-- To store the passport informations of a country.
CREATE TABLE "passports"(
    "id" INTEGER,
    "type" VARCHAR(10) NOT NULL CHECK(type IN ('Regular','Restricted','Official','Diplomatic')),
    "country_id" INTEGER NOT NULL,
    "validity_year" INTEGER NOT NULL,
    "biometric" INTEGER CHECK("biometric" IN('0','1')),
    PRIMARY KEY("id"),
    FOREIGN KEY("country_id") REFERENCES "countries"("id")
);


-- To record whether travel to a destination country is visa-free.
CREATE TABLE "visa"(
    "id" INTEGER,
    "passport_id" INTEGER NOT NULL,
    "from_country_id" INTEGER NOT NULL,
    "to_country_id" INTEGER NOT NULL,
    "visa_free" INTEGER NOT NULL CHECK("visa_free" IN('0','1')),
    PRIMARY KEY("id"),
    FOREIGN KEY("passport_id") REFERENCES "passports"("id"),
    FOREIGN KEY("from_country_id") REFERENCES "countries"("id"),
    FOREIGN KEY("to_country_id") REFERENCES "countries"("id")
);


-- Create indexes to speed common searches.
CREATE INDEX "country_code" ON "countries"("code");
CREATE INDEX "passport_type" ON "passports"("type");
CREATE INDEX "visa_free" ON "visa"("from_country_id","to_country_id","visa_free") WHERE "visa_free" = 'T';


-- Create view to simplify query processes.
CREATE VIEW "visa_free_countries_for_MYS" AS
SELECT "name" FROM "countries"
JOIN "visa" ON "countries"."id" = "visa"."to_country_id"
WHERE "from_country_id" =
    (
    SELECT "id" FROM "countries" WHERE "name" = 'Malaysia'
    )
AND "visa_free" = '1';
