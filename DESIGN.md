# Design Document

By PANG SEEM YEE

Video overview: <[URL HERE](https://youtu.be/DifJBLdyB1w?si=0OFJs8wzMCp_JDh0)>

## Scope

This database's goal is to maintain data about countries, their passport details, and the visa requirement. It enables users to determine if travel to a destination country requires a visa.
* `Countries`, to store country code and name for identification.
* `Passports` include basic passport information specific to each country like expiration year for adults, or whether it is biometric.
* `Visa`, record whether travel is visa-free or requires a visa to the destination country.

Out of scope:

`Countries`: Attributes like ‘Region’ and ‘Currency’ is not within the table.
`Passports`: Expiration year for kids passport.
`Visa`: Others travel requirement excluded such as visa‑free duration, and the requirement of tourism related fee required prior to entry to the destination country.

## Functional Requirements

This database will support:

* Perform create, read, update, delete records in table Countries, Passports, and Visa.
* Find the country’s passport information given a country code or name.
* Determine if a visa is required for travel given a country code, or passport primary key.
* Join multiple tables to find if the destination country is visa-free.
* Run query to identify if the given country’s passport is biometric.

Database not support:

* Users can’t look up individual passport holder details. Also, the database does not include attributes such as region, and visa-free requirements.


## Representation
Entities are captured in SQLite tables with the following schema.

### Entities

The database includes the following entities:

#### Countries

The `Countries` table includes:

* `id`, this is the unique identifier as an `INTEGER`. It uses the `AUTO_INCREMENT` capability so each new country record receives a sequential value. This column has the `PRIMARY KEY` constraint applied to ensure its uniqueness.
* `code`, a `VARCHAR(3)` column to store three-letter country codes defined in ISO 3166-1.
* `name`, a `VARCHAR(60)` column specifies the country’s name. Given the longest country name in the world is 56 characters, the length of 60 characters ensures sufficient space. `NOT NULL` constraint applied as country name is required. `UNIQUE` constraint applied to avoid duplicated country being recorded.

#### Passports

The `Passports` table includes:

* `id`, this is the unique identifier as an `INTEGER`. It uses the `AUTO_INCREMENT` capability so each new passport record receives a sequential value. This column has the `PRIMARY KEY` constraint applied to ensure its uniqueness.
* `type`, a `VARCHAR(10)` column with a `CHECK` constraint to restrict values to the pre-defined: Regular, Restricted, Official, Diplomatic. The length of 10 characters provides sufficient space to store the longest pre-defined name. `NOT NULL` constraint applied to ensure every passport record specifies one of these valid types.
* `country_id`, an `INTEGER` column that stores the ID of the country associated with the passport, has the `FOREIGN KEY` constraint applied, referencing the `id` column in the `countries` table to ensure data integrity. `NOT NULL` constraint applied to ensure every passport record is linked to a valid country, to prevent incomplete entries.
* `validity_year`, an `INTEGER` column that stores the number of years a passport remains valid from the date of issuance. `NOT NULL` constraint applied to ensure every passport records the validity period, to prevent incomplete entries.
* `biometric`, an ` INTEGER` column with a `CHECK` constraint that indicates whether the passport is biometric. The value of `0` represents false, the passport does not contain biometric features, while the value of `1` represents true, the passport contains biometric features. The `CHECK` constraint ensures data consistency across multiple users by restricting values to only `0` or `1`.

#### Visa

The `Visa` table includes:

* `id`, this is the unique identifier as an `INTEGER`. It uses the `AUTO_INCREMENT` capability so each new visa record receives a sequential value. This column has the `PRIMARY KEY` constraint applied to ensure its uniqueness.
* `passport_id`, an `INTEGER` column that stores the ID of the passport associated with the visa, has the `FOREIGN KEY` constraint applied, referencing the `id` column in the `passports` table to ensure data integrity. `NOT NULL` constraint applied to ensure every visa record is linked to a valid passport, to prevent incomplete entries.
* `from_country_id`, an `INTEGER` column that stores the ID of the country associated with the `passport_id`, representing the passport’s country of issuance. It has the `FOREIGN KEY` constraint applied, referencing the `id` column in the `countries` table to ensure data integrity. `NOT NULL` constraint applied to ensure every visa record is linked to a valid country record, to prevent incomplete entries.
* `to_country_id`, an `INTEGER` column that stores the ID of the destination country. It has the `FOREIGN KEY` constraint applied, referencing the `id` column in the `countries` table to ensure data integrity. `NOT NULL` constraint applied to ensure every visa record is linked to a valid country record, to prevent incomplete entries.
* `visa_free`, an ` INTEGER` column with a `CHECK` constraint that indicates whether the destination country is visa-free. The value of `0` represents false, the destination country is not visa-free, while the value of `1` represents true, the destination country is visa-free. The `CHECK` constraint ensures data consistency across multiple users by restricting values to only `0` or `1`. `NOT NULL` constraint applied to ensure every visa record specifies the visa requirement, to prevent incomplete entries.

### Relationships

The below entity relationship diagram describes the relationships among the entities in the database.

![alt text](FinalProject.png)

# As detailed by the diagram:
* A `Country` can issue `ONE` to `MANY` passport types. Every country can issue at least one passport type under whichever categories such as Regular, Restricted, Official, Diplomatic or etc. Every country has its own passport, which means that every passport is always associated with a specific country. No passport can share across countries, and no passport can exist without a valid country.
* One `Passport` can be associated with `ONE` to `MANY` visa records, depending on the visa requirement across different destination countries. A single passport may be linked to multiple visa records, according to the destination country whether it requires a visa, or visa-free. A visa record cannot exist without a valid passport, and a passport may govern multiple visa records across different destinations.
* One `Visa` is associated with `ONE` passport. Meanwhile, `ONE` passport can be linked to `MANY` visa, each defining the visa requirements for different destination countries. The visa requirement is determined by the combination of the passport’s issuing country `from_country_id` and the destination country `to_country_id`, which always work together as a pair to define whether travel is visa-free or visa-required. In simple way, `ONE` passport can have multiple visa entries, and each visa entry is always defined by a pair of countries (passport’s issuing country `from_country_id` and the destination country `to_country_id`). A visa cannot exist without a valid passport, and both the passport’s issuing country and destination countries must be specified to complete the visa requirement entry. 

## Optimizations

Creating the indexes on common search columns such as `country codes`, `passport types`, and countries that is `visa-free` to travel allow the queries to run more efficiently. At the same time, the view of `"visa_free_countries_for_MYS"` simplifies the query processes by pre-defining the necessary joins and filters to look for countries that is visa-free to travel for Malaysia passport holder.

## Limitations

The `Visa` table is representing only whether it is visa-free or visa required to travel, however, the actual travel regulations are more complex, involving rules such as travel duration, the purpose of the trip, or the tourism related fee required prior to entry to the destination country. These details are not well represented within the current schema. By including attributes such as visa-free entry duration, combine with the travel purpose and entry free requirement, the table would become more usable.
