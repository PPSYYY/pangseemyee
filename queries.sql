-- Find the name of the country with given country code.
SELECT "name" FROM "countries"
WHERE "code" = 'MYS';


-- Find the name of the country given passport validity year.
SELECT "name" FROM "countries"
WHERE "id" IN(
    SELECT "country_id" FROM "passports"
    WHERE "validity_year" = '10'
);


-- Find the name of the countries that are visa-free destinations for a given country name.
SELECT "name" FROM "countries"
JOIN "visa" ON "visa"."to_country_id" = "countries"."id"
WHERE "from_country_id" = (
    SELECT "id" FROM "countries"
    WHERE "name" = 'Malaysia'
)
AND
"visa_free" = '1';


-- Find the visa requirement given an origin and a destination country.
SELECT
"countries_from"."name" AS "from_country",
"countries_to"."name" AS "to_country" ,
"visa_free" FROM "visa"
JOIN "countries" AS "countries_from" ON "visa"."from_country_id" = "countries_from"."id"
JOIN "countries" AS "countries_to" ON "visa"."to_country_id" = "countries_to"."id"

WHERE "from_country_id" = (
    SELECT "id" FROM "countries"
    WHERE "name" = 'Malaysia'
)
AND
"to_country_id" = (
    SELECT "id" FROM "countries"
    WHERE "name" = 'United States'
);


-- Add a new country.
INSERT INTO "countries" ("code","name")
VALUES ("ARG","Argentina");


-- Add a new passport data given country code.
INSERT INTO "passports" ("type","country_id","validity_year","biometric")
VALUES (
    'Regular',
    (SELECT "id" FROM "countries" WHERE "code" = 'TWN'),
    10,
    1);


-- Add a new visa data given country name.
INSERT INTO "visa" ("passport_id","from_country_id","to_country_id","visa_free")
VALUES (
    (SELECT "id" FROM "passports" WHERE "country_id" =
        (
            Select "id" FROM "countries" WHERE "name" = 'Malaysia'
        )
    ),
    (SELECT "id" FROM "countries" WHERE "name" = 'Malaysia'),
    (SELECT "id" FROM "countries" WHERE "name" = 'Taiwan'),
    1
);


-- Update a country name given the country code
UPDATE "countries"
SET "name" = 'Malaysia'
WHERE "code" = 'MYS';


-- Delete a country given the country code
DELETE FROM "countries"
WHERE "code" = 'MYS';
