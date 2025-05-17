DROP TABLE IF EXISTS Denials CASCADE;
DROP TABLE IF EXISTS Co_Races CASCADE;
DROP TABLE IF EXISTS Races CASCADE;
DROP TABLE IF EXISTS Application CASCADE;
DROP TABLE IF EXISTS Location CASCADE;
DROP TABLE IF EXISTS COUNTY CASCADE;
DROP TABLE IF EXISTS STATE CASCADE;
DROP TABLE IF EXISTS MSAMD CASCADE;
DROP TABLE IF EXISTS NULL_VALUES CASCADE;
DROP TABLE IF EXISTS Race CASCADE;
DROP TABLE IF EXISTS Ethnicity CASCADE;
DROP TABLE IF EXISTS Sex CASCADE;
DROP TABLE IF EXISTS PropertyType CASCADE;
DROP TABLE IF EXISTS OwnerOccupancy CASCADE;
DROP TABLE IF EXISTS Agency CASCADE;
DROP TABLE IF EXISTS PurchaserType CASCADE;
DROP TABLE IF EXISTS LienStatus CASCADE;
DROP TABLE IF EXISTS LoanType CASCADE;
DROP TABLE IF EXISTS LoanPurpose CASCADE;
DROP TABLE IF EXISTS Preapproval CASCADE;
DROP TABLE IF EXISTS ActionTaken CASCADE;
DROP TABLE IF EXISTS DenialReason CASCADE;
DROP TABLE IF EXISTS HOEPAStatus CASCADE;

-- === Original Dataset ===
CREATE TABLE Preliminary(
    as_of_year text,
    respondent_id text,
    agency_name text,
    agency_abbr text,
    agency_code text,
    loan_type_name text,
    loan_type text,
    property_type_name text,
    property_type int,
    loan_purpose_name text,
    loan_purpose text,
    owner_occupancy_name text,
    owner_occupancy text,
    loan_amount_000s text,
    preapproval_name text,
    preapproval text,
    action_taken_name text,
    action_taken text,
    msamd_name text,
    msamd text,
    state_name text,
    state_abbr text,
    state_code text,
    county_name text,
    county_code text,
    census_tract_number text,
    applicant_ethnicity_name text,
    applicant_ethnicity text,
    co_applicant_ethnicity_name text,
    co_applicant_ethnicity text,
    applicant_race_name_1 text,
    applicant_race_1 text,
    applicant_race_name_2 text,
    applicant_race_2 text,
    applicant_race_name_3 text,
    applicant_race_3 text,
    applicant_race_name_4 text,
    applicant_race_4 text,
    applicant_race_name_5 text,
    applicant_race_5 text,
    co_applicant_race_name_1 text,
    co_applicant_race_1 text,
    co_applicant_race_name_2 text,
    co_applicant_race_2 text,
    co_applicant_race_name_3 text,
    co_applicant_race_3 text,
    co_applicant_race_name_4 text,
    co_applicant_race_4 text,
    co_applicant_race_name_5 text,
    co_applicant_race_5 text,
    applicant_sex_name text,
    applicant_sex text,
    co_applicant_sex_name text,
    co_applicant_sex text,
    applicant_income_000s text,
    purchaser_type_name text,
    purchaser_type text,
    denial_reason_name_1 text,
    denial_reason_1 text,
    denial_reason_name_2 text,
    denial_reason_2 text,
    denial_reason_name_3 text,
    denial_reason_3 text,
    rate_spread text,
    hoepa_status_name text,
    hoepa_status text,
    lien_status_name text,
    lien_status text,
    edit_status_name text,
    edit_status text,
    sequence_number text,
    population text,
    minority_population text,
    hud_median_family_income text,
    tract_to_msamd_income text,
    number_of_owner_occupied_units text,
    number_of_1_to_4_family_units text,
    application_date_indicator text
);

-- Assume data has been copied from CSV to preliminary table

alter table preliminary add column ID serial;
alter table preliminary add constraint preliminary_primarykey primary key (ID);


-- === Lookup Tables ===

CREATE TABLE NULL_VALUES(
    edit_status TEXT,
    edit_status_name TEXT,
    sequence_number TEXT,
    application_date_indicator TEXT
);

INSERT INTO NULL_VALUES(edit_status, edit_status_name, sequence_number, application_date_indicator) VALUES
    (NULL, NULL, NULL, NULL);

CREATE TABLE Race(
    race_num INT PRIMARY KEY,
    race_name TEXT
);

INSERT INTO Race (race_num, race_name) VALUES
    (1, 'American Indian or Alaska Native'),
    (2, 'Asian'),
    (3, 'Black or African American'),
    (4, 'Native Hawaiian or Other Pacific Islander'),
    (5, 'White'),
    (6, 'Information not provided by applicant in mail, Internet, or telephone application'),
    (7, 'Not applicable'),
    (8, 'No co-applicant');

CREATE TABLE Ethnicity(
    ethnicity_num INT PRIMARY KEY,
    ethnicity_name TEXT
);

INSERT INTO Ethnicity(ethnicity_num, ethnicity_name) VALUES
    (1, 'Hispanic or Latino'),
    (2, 'Not Hispanic or Latino'),
    (3, 'Information not provided by applicant in mail, Internet, or telephone application'),
    (4, 'Not applicable'),
    (5, 'No co-applicant');

CREATE TABLE Sex(
    sex_num INT PRIMARY KEY,
    sex_name TEXT
);

INSERT INTO Sex(sex_num, sex_name) VALUES
    (1, 'Male'),
    (2, 'Female'),
    (3, 'Information not provided by applicant in mail, Internet, or telephone application'),
    (4, 'Not applicable'),
    (5, 'No co-applicant');

CREATE TABLE PropertyType(
    property_type INT PRIMARY KEY,
    property_type_name TEXT
);

INSERT INTO PropertyType(property_type, property_type_name) VALUES
    (1, 'One to four-family (other than manufactured housing)'),
    (2, 'Manufactured housing'),
    (3, 'Multifamily');

CREATE TABLE OwnerOccupancy(
    owner_occupancy INT PRIMARY KEY,
    owner_occupancy_name TEXT
);

INSERT INTO OwnerOccupancy(owner_occupancy, owner_occupancy_name) VALUES
    (1, 'Owner-occupied as a principal dwelling'),
    (2, 'Not owner-occupied'),
    (3, 'Not applicable');

CREATE TABLE Agency(
    agency_code INT PRIMARY KEY,
    agency_name TEXT,
    agency_abbr TEXT
);

INSERT INTO Agency(agency_code, agency_name, agency_abbr) VALUES
    (1,'Office of the Comptroller of the Currency', 'OCC'),
    (2, 'Federal Reserve System', 'FRS'),
    (3, 'Federal Deposit Insurance Corporation', 'FDIC'),
    (5, 'National Credit Union Administration', 'NCUA'),
    (7, 'Department of Housing and Urban Development', 'HUD'),
    (9, 'Consumer Financial Protection Bureau', 'CFPB');


CREATE TABLE PurchaserType(
    purchaser_type INT PRIMARY KEY,
    purchaser_type_name TEXT
);

INSERT INTO PurchaserType(purchaser_type, purchaser_type_name) VALUES
    (0, 'Loan was not originated or was not sold in calendar year covered by register'),
    (1, 'Fannie Mae (FNMA)'),
    (2, 'Ginnie Mae (GNMA)'),
    (3, 'Freddie Mac (FHLMC)'),
    (4, 'Farmer Mac (FAMC)'),
    (5, 'Private securitization'),
    (6, 'Commercial bank, savings bank or savings association'),
    (7, 'Life insurance company, credit union, mortgage bank, or finance company'),
    (8, 'Affiliate institution'),
    (9, 'Other type of purchaser');

CREATE TABLE LienStatus(
    lien_status INT PRIMARY KEY,
    lien_status_name TEXT
);

INSERT INTO LienStatus(lien_status, lien_status_name) VALUES
    (1,'Secured by a first lien'),
    (2,'Secured by a subordinate lien'),
    (3,'Not secured by a lien'),
    (4,'Not applicable (purchased loans)');

CREATE TABLE LoanType(
    loan_type INT PRIMARY KEY,
    loan_type_name TEXT
);

INSERT INTO LoanType(loan_type, loan_type_name) VALUES
    (1, 'Conventional (any loan other than FHA, VA, FSA, or RHS loans)'),
    (2,'FHA-insured (Federal Housing Administration)'),
    (3,'VA-guaranteed (Veterans Administration)'),
    (4,'FSA/RHS (Farm Service Agency or Rural Housing Service)');

CREATE TABLE LoanPurpose(
    loan_purpose INT PRIMARY KEY,
    loan_purpose_name TEXT
);

INSERT INTO LoanPurpose(loan_purpose, loan_purpose_name) VALUES
    (1,'Home purchase'),
    (2,'Home improvement'),
    (3,'Refinancing');

CREATE TABLE Preapproval(
    preapproval INT PRIMARY KEY,
    preapproval_name TEXT
);

INSERT INTO Preapproval(preapproval, preapproval_name) VALUES
    (1,'Preapproval was requested'),
    (2,'Preapproval was not requested'),
    (3,'Not applicable');

CREATE TABLE ActionTaken(
    action_taken INT PRIMARY KEY,
    action_taken_name TEXT
);

INSERT INTO ActionTaken(action_taken, action_taken_name) VALUES
    (1,'Loan originated'),
    (2,'Application approved but not accepted'),
    (3,'Application denied by financial institution'),
    (4,'Application withdrawn by applicant'),
    (5,'File closed for incompleteness'),
    (6,'Loan purchased by the institution'),
    (7,'Preapproval request denied by financial institution'),
    (8,'Preapproval request approved but not accepted (optional reporting)');

CREATE TABLE DenialReason(
    denial_reason INT PRIMARY KEY,
    denial_reason_name TEXT
);

INSERT INTO DenialReason(denial_reason, denial_reason_name) VALUES
    (1, 'Debt-to-income ratio'),
    (2, 'Employment history'),
    (3, 'Credit history'),
    (4, 'Collateral'),
    (5, 'Insufficient cash (downpayment, closing costs)'),
    (6, 'Unverifiable information'),
    (7, 'Credit application incomplete'),
    (8, 'Mortgage insurance denied'),
    (9, 'Other');

CREATE TABLE HOEPAStatus(
    hoepa_status INT PRIMARY KEY,
    hoepa_status_name TEXT
);

INSERT INTO HOEPAStatus(hoepa_status, hoepa_status_name) VALUES
    (1,'HOEPA loan'),
    (2, 'Not a HOEPA loan');

-- === Location Related Tables ===

CREATE TABLE STATE(
    state_code INT PRIMARY KEY,
    state_name TEXT,
    state_abbr TEXT
);

INSERT INTO STATE(state_code, state_name, state_abbr) VALUES
    (34, 'New Jersey', 'NJ');

CREATE TABLE COUNTY(
    county_code INT PRIMARY KEY,
    state_code INT,
    county_name TEXT,
    FOREIGN KEY (state_code) REFERENCES STATE(state_code)
);

INSERT INTO COUNTY(county_code, state_code, county_name) VALUES
    (7, 34, 'Camden County'),
    (9, 34, 'Cape May County'),
    (25, 34, 'Monmouth County'),
    (3, 34, 'Bergen County'),
    (29, 34, 'Ocean County'),
    (5, 34, 'Burlington County'),
    (35, 34, 'Somerset County'),
    (13, 34, 'Essex County'),
    (15, 34, 'Gloucester County'),
    (23, 34, 'Middlesex County'),
    (21, 34, 'Mercer County'),
    (17, 34, 'Hudson County'),
    (27, 34, 'Morris County'),
    (1, 34, 'Atlantic County'),
    (37, 34, 'Sussex County'),
    (31, 34, 'Passaic County'),
    (39, 34, 'Union County'),
    (11, 34, 'Cumberland County'),
    (41, 34, 'Warren County'),
    (19, 34, 'Hunterdon County'),
    (33, 34, 'Salem County');

CREATE TABLE MSAMD(
    msamd INT PRIMARY KEY,
    msamd_name TEXT
);

INSERT INTO MSAMD(msamd, msamd_name) VALUES
    (15804, 'Camden - NJ'),
    (36140, 'Ocean City - NJ'),
    (35614, 'New York, Jersey City, White Plains - NY, NJ'),
    (35084, 'Newark - NJ, PA'),
    (45940, 'Trenton - NJ'),
    (12100, 'Atlantic City, Hammonton - NJ'),
    (47220, 'Vineland, Bridgeton - NJ'),
    (10900, 'Allentown, Bethlehem, Easton - PA, NJ'),
    (48864, 'Wilmington - DE, MD, NJ'),
    (35620, ''),
    (37980, '');

CREATE TABLE Location(
    location_ID SERIAL PRIMARY KEY,
    county_code INT,
    msamd INT,
    state_code INT,
    census_tract_number NUMERIC(10,2),
    population INT,
    minority_population NUMERIC(10,2),
    hud_median_family_income INT,
    tract_to_msamd_income NUMERIC(10,2),
    number_of_owner_occupied_units INT,
    number_of_1_to_4_family_units INT,
    FOREIGN KEY (county_code) REFERENCES COUNTY(county_code),
    FOREIGN KEY (state_code) REFERENCES STATE(state_code),
    FOREIGN KEY (msamd) REFERENCES MSAMD(msamd),
    UNIQUE (county_code, msamd, state_code, census_tract_number, population, minority_population, hud_median_family_income, tract_to_msamd_income, number_of_owner_occupied_units, number_of_1_to_4_family_units)
);


INSERT INTO Location (
    state_code, county_code, msamd, census_tract_number, population,
    minority_population, hud_median_family_income, tract_to_msamd_income,
    number_of_owner_occupied_units, number_of_1_to_4_family_units
)
SELECT DISTINCT
    CAST(NULLIF(p.state_code, '') AS INT),
    CAST(NULLIF(p.county_code, '') AS INT),
    CAST(NULLIF(p.msamd, '') AS INT),
    CAST(NULLIF(p.census_tract_number, '') AS NUMERIC(10,2)),
    CAST(NULLIF(p.population, '') AS INT),
    CAST(NULLIF(p.minority_population, '') AS NUMERIC(10,2)),
    CAST(NULLIF(p.hud_median_family_income, '') AS INT),
    CAST(NULLIF(p.tract_to_msamd_income, '') AS NUMERIC(10,2)),
    CAST(NULLIF(p.number_of_owner_occupied_units, '') AS INT),
    CAST(NULLIF(p.number_of_1_to_4_family_units, '') AS INT)
FROM preliminary p
WHERE
    p.state_code IS NOT NULL AND p.state_code != '' AND
    p.county_code IS NOT NULL AND p.county_code != '' AND
    p.msamd IS NOT NULL AND p.msamd != '' AND
    p.census_tract_number IS NOT NULL AND p.census_tract_number != '' AND
    p.population IS NOT NULL AND p.population != '' AND
    p.minority_population IS NOT NULL AND p.minority_population != '' AND
    p.hud_median_family_income IS NOT NULL AND p.hud_median_family_income != '' AND
    p.tract_to_msamd_income IS NOT NULL AND p.tract_to_msamd_income != '' AND
    p.number_of_owner_occupied_units IS NOT NULL AND p.number_of_owner_occupied_units != '' AND
    p.number_of_1_to_4_family_units IS NOT NULL AND p.number_of_1_to_4_family_units != ''
ON CONFLICT ON CONSTRAINT location_county_code_msamd_state_code_census_tract_number_p_key DO NOTHING;


-- === Main Application Table ===

CREATE TABLE Application(
    ID INT PRIMARY KEY,
    as_of_year INT,
    respondent_id TEXT,
    agency_code INT,
    loan_type INT,
    loan_purpose INT,
    loan_amount_000s INT,
    preapproval INT,
    action_taken INT,
    property_type INT,
    owner_occupancy INT,
    applicant_ethnicity INT,
    applicant_sex INT,
    applicant_income_000s INT,
    co_applicant_ethnicity INT,
    co_applicant_sex INT,
    purchaser_type INT,
    rate_spread NUMERIC(10,2),
    hoepa_status INT,
    lien_status INT,
    location_ID INT,
    FOREIGN KEY (location_ID) REFERENCES Location(location_ID),
    FOREIGN KEY (agency_code) REFERENCES Agency(agency_code),
    FOREIGN KEY (loan_type) REFERENCES LoanType(loan_type),
    FOREIGN KEY (loan_purpose) REFERENCES LoanPurpose(loan_purpose),
    FOREIGN KEY (preapproval) REFERENCES Preapproval(preapproval),
    FOREIGN KEY (action_taken) REFERENCES ActionTaken(action_taken),
    FOREIGN KEY (property_type) REFERENCES PropertyType(property_type),
    FOREIGN KEY (owner_occupancy) REFERENCES OwnerOccupancy(owner_occupancy),
    FOREIGN KEY (applicant_ethnicity) REFERENCES Ethnicity(ethnicity_num),
    FOREIGN KEY (applicant_sex) REFERENCES Sex(sex_num),
    FOREIGN KEY (co_applicant_ethnicity) REFERENCES Ethnicity(ethnicity_num),
    FOREIGN KEY (co_applicant_sex) REFERENCES Sex(sex_num),
    FOREIGN KEY (purchaser_type) REFERENCES PurchaserType(purchaser_type),
    FOREIGN KEY (hoepa_status) REFERENCES HOEPAStatus(hoepa_status),
    FOREIGN KEY (lien_status) REFERENCES LienStatus(lien_status)
);



INSERT INTO Application (
    ID, as_of_year, respondent_id, agency_code, loan_type, loan_purpose, 
    loan_amount_000s, preapproval, action_taken, property_type, owner_occupancy, 
    applicant_ethnicity, applicant_sex, applicant_income_000s, 
    co_applicant_ethnicity, co_applicant_sex, purchaser_type, 
    rate_spread, hoepa_status, lien_status, location_ID
)
SELECT 
    p.ID, 
    CAST(p.as_of_year AS INT), 
    p.respondent_id, 
    CAST(p.agency_code AS INT), 
    CAST(p.loan_type AS INT), 
    CAST(p.loan_purpose AS INT), 
    CAST(p.loan_amount_000s AS INT), 
    CAST(p.preapproval AS INT), 
    CAST(p.action_taken AS INT), 
    p.property_type, 
    CAST(p.owner_occupancy AS INT),
    CAST(p.applicant_ethnicity AS INT), 
    CAST(p.applicant_sex AS INT), 
    CAST(p.applicant_income_000s AS INT),
    CAST(p.co_applicant_ethnicity AS INT), 
    CAST(p.co_applicant_sex AS INT), 
    CAST(p.purchaser_type AS INT), 
    CAST(p.rate_spread AS NUMERIC(10,2)), 
    CAST(p.hoepa_status AS INT), 
    CAST(p.lien_status AS INT), 
    loc.location_ID
FROM preliminary p
JOIN Location loc ON
    loc.msamd IS NOT DISTINCT FROM CAST(p.msamd AS INT) AND
    loc.state_code IS NOT DISTINCT FROM CAST(p.state_code AS INT) AND
    loc.county_code IS NOT DISTINCT FROM CAST(p.county_code AS INT) AND
    loc.census_tract_number IS NOT DISTINCT FROM CAST(p.census_tract_number AS NUMERIC(10,2)) AND
    loc.population IS NOT DISTINCT FROM CAST(p.population AS INT) AND
    loc.minority_population IS NOT DISTINCT FROM CAST(p.minority_population AS NUMERIC(10,2)) AND
    loc.hud_median_family_income IS NOT DISTINCT FROM CAST(p.hud_median_family_income AS INT) AND
    loc.tract_to_msamd_income IS NOT DISTINCT FROM CAST(p.tract_to_msamd_income AS NUMERIC(10,2)) AND
    loc.number_of_owner_occupied_units IS NOT DISTINCT FROM CAST(p.number_of_owner_occupied_units AS INT) AND
    loc.number_of_1_to_4_family_units IS NOT DISTINCT FROM CAST(p.number_of_1_to_4_family_units AS INT)
WHERE 
    p.ID IS NOT NULL AND
    p.state_code IS NOT NULL AND TRIM(p.state_code) != '' AND
    p.county_code IS NOT NULL AND TRIM(p.county_code) != '' AND
    p.msamd IS NOT NULL AND TRIM(p.msamd) != '' AND
    p.census_tract_number IS NOT NULL AND TRIM(p.census_tract_number) != '' AND
    p.population IS NOT NULL AND TRIM(p.population) != '' AND
    p.minority_population IS NOT NULL AND TRIM(p.minority_population) != '' AND
    p.hud_median_family_income IS NOT NULL AND TRIM(p.hud_median_family_income) != '' AND
    p.tract_to_msamd_income IS NOT NULL AND TRIM(p.tract_to_msamd_income) != '' AND
    p.number_of_owner_occupied_units IS NOT NULL AND TRIM(p.number_of_owner_occupied_units) != '' AND
    p.number_of_1_to_4_family_units IS NOT NULL AND TRIM(p.number_of_1_to_4_family_units) != '' AND
    p.rate_spread IS NOT NULL AND TRIM(p.rate_spread) != '' AND
    p.applicant_income_000s IS NOT NULL AND TRIM(p.applicant_income_000s) != '';






-- === Tables for Repeating Groups (1NF) ===

CREATE TABLE Races(
    id INT,
    race_num INT,
    num_of_race INT, -- Sequence (1, 2, 3, 4, 5)
    CONSTRAINT Races_PK PRIMARY KEY (id, num_of_race), -- Composite Primary Key
    FOREIGN KEY (id) REFERENCES preliminary(ID),      -- Link to the main application
    FOREIGN KEY (race_num) REFERENCES Race(race_num)   -- Link to the Race lookup table
);

INSERT INTO Races(id, race_num, num_of_race)
    SELECT id, CAST(applicant_race_1 AS INT), 1 FROM preliminary
    WHERE applicant_race_1 IS NOT NULL AND applicant_race_1 != '' AND CAST(applicant_race_1 AS INT) IN (SELECT race_num from Race)
    AND id IN (SELECT ID FROM preliminary);

INSERT INTO Races(id, race_num, num_of_race)
    SELECT id, CAST(applicant_race_2 AS INT), 2 FROM preliminary
    WHERE applicant_race_2 IS NOT NULL AND applicant_race_2 != '' AND CAST(applicant_race_2 AS INT) IN (SELECT race_num from Race)
    AND id IN (SELECT ID FROM preliminary);

INSERT INTO Races(id, race_num, num_of_race)
    SELECT id, CAST(applicant_race_3 AS INT), 3 FROM preliminary
    WHERE applicant_race_3 IS NOT NULL AND applicant_race_3 != '' AND CAST(applicant_race_3 AS INT) IN (SELECT race_num from Race)
    AND id IN (SELECT ID FROM preliminary);

INSERT INTO Races(id, race_num, num_of_race)
    SELECT id, CAST(applicant_race_4 AS INT), 4 FROM preliminary
    WHERE applicant_race_4 IS NOT NULL AND applicant_race_4 != '' AND CAST(applicant_race_4 AS INT) IN (SELECT race_num from Race)
    AND id IN (SELECT ID FROM preliminary);

INSERT INTO Races(id, race_num, num_of_race)
    SELECT id, CAST(applicant_race_5 AS INT), 5 FROM preliminary
    WHERE applicant_race_5 IS NOT NULL AND applicant_race_5 != '' AND CAST(applicant_race_5 AS INT) IN (SELECT race_num from Race)
    AND id IN (SELECT ID FROM preliminary);


CREATE TABLE Co_Races(
    id INT,
    co_race_num INT,
    co_num_race INT, -- Sequence (1, 2, 3, 4, 5)
    CONSTRAINT Co_Races_PK PRIMARY KEY (id, co_num_race), -- Composite Primary Key
    FOREIGN KEY (id) REFERENCES preliminary(ID),         -- Link to the main application
    FOREIGN KEY (co_race_num) REFERENCES Race(race_num)  -- Link to the Race lookup table
);

INSERT INTO Co_Races(id, co_race_num, co_num_race)
    SELECT id, CAST(co_applicant_race_1 AS INT), 1 FROM preliminary
    WHERE co_applicant_race_1 IS NOT NULL AND co_applicant_race_1 != '' AND CAST(co_applicant_race_1 AS INT) IN (SELECT race_num from Race)
    AND id IN (SELECT ID FROM preliminary);

INSERT INTO Co_Races(id, co_race_num, co_num_race)
    SELECT id, CAST(co_applicant_race_2 AS INT), 2 FROM preliminary
    WHERE co_applicant_race_2 IS NOT NULL AND co_applicant_race_2 != '' AND CAST(co_applicant_race_2 AS INT) IN (SELECT race_num from Race)
    AND id IN (SELECT ID FROM preliminary);

INSERT INTO Co_Races(id, co_race_num, co_num_race)
    SELECT id, CAST(co_applicant_race_3 AS INT), 3 FROM preliminary
    WHERE co_applicant_race_3 IS NOT NULL AND co_applicant_race_3 != '' AND CAST(co_applicant_race_3 AS INT) IN (SELECT race_num from Race)
    AND id IN (SELECT ID FROM preliminary);

INSERT INTO Co_Races(id, co_race_num, co_num_race)
    SELECT id, CAST(co_applicant_race_4 AS INT), 4 FROM preliminary
    WHERE co_applicant_race_4 IS NOT NULL AND co_applicant_race_4 != '' AND CAST(co_applicant_race_4 AS INT) IN (SELECT race_num from Race)
    AND id IN (SELECT ID FROM preliminary);

INSERT INTO Co_Races(id, co_race_num, co_num_race)
    SELECT id, CAST(co_applicant_race_5 AS INT), 5 FROM preliminary
    WHERE co_applicant_race_5 IS NOT NULL AND co_applicant_race_5 != '' AND CAST(co_applicant_race_5 AS INT) IN (SELECT race_num from Race)
    AND id IN (SELECT ID FROM preliminary);


CREATE TABLE Denials(
    id INT,
    denial_reason INT,
    denial_num INT, -- Sequence (1, 2, 3)
    CONSTRAINT Denials_PK PRIMARY KEY (id, denial_num),           -- Composite Primary Key
    FOREIGN KEY (id) REFERENCES preliminary(ID),                  -- Link to the main application
    FOREIGN KEY (denial_reason) REFERENCES DenialReason(denial_reason) -- Link to the DenialReason lookup table
);

INSERT INTO Denials(id, denial_reason, denial_num)
    SELECT id, CAST(denial_reason_1 AS INT), 1 FROM preliminary
    WHERE denial_reason_1 IS NOT NULL AND denial_reason_1 != '' AND CAST(denial_reason_1 AS INT) IN (SELECT denial_reason from DenialReason)
    AND id IN (SELECT ID FROM preliminary);

INSERT INTO Denials(id, denial_reason, denial_num)
    SELECT id, CAST(denial_reason_2 AS INT), 2 FROM preliminary
    WHERE denial_reason_2 IS NOT NULL AND denial_reason_2 != '' AND CAST(denial_reason_2 AS INT) IN (SELECT denial_reason from DenialReason)
    AND id IN (SELECT ID FROM preliminary);

INSERT INTO Denials(id, denial_reason, denial_num)
    SELECT id, CAST(denial_reason_3 AS INT), 3 FROM preliminary
    WHERE denial_reason_3 IS NOT NULL AND denial_reason_3 != '' AND CAST(denial_reason_3 AS INT) IN (SELECT denial_reason from DenialReason)
    AND id IN (SELECT ID FROM preliminary);


-- === Conversion To Original Table ===
CREATE TABLE FINAL AS
SELECT
    a.as_of_year::TEXT AS as_of_year,
    a.respondent_id::TEXT AS respondent_id,

    ag.agency_name::TEXT AS agency_name,
    ag.agency_abbr::TEXT AS agency_abbr,
    a.agency_code::TEXT AS agency_code,

    lt.loan_type_name::TEXT AS loan_type_name,
    a.loan_type::TEXT AS loan_type,

    pt.property_type_name::TEXT AS property_type_name,
    a.property_type::TEXT AS property_type,

    lp.loan_purpose_name::TEXT AS loan_purpose_name,
    a.loan_purpose::TEXT AS loan_purpose,

    oo.owner_occupancy_name::TEXT AS owner_occupancy_name,
    a.owner_occupancy::TEXT AS owner_occupancy,

    a.loan_amount_000s::TEXT AS loan_amount_000s,

    pr.preapproval_name::TEXT AS preapproval_name,
    a.preapproval::TEXT AS preapproval,

    at.action_taken_name::TEXT AS action_taken_name,
    a.action_taken::TEXT AS action_taken,

    ms.msamd_name::TEXT AS msamd_name,
    loc.msamd::TEXT AS msamd,

    st.state_name::TEXT AS state_name,
    st.state_abbr::TEXT AS state_abbr,
    loc.state_code::TEXT AS state_code,

    co.county_name::TEXT AS county_name,
    loc.county_code::TEXT AS county_code,

    loc.census_tract_number::TEXT AS census_tract_number,

    app_eth.ethnicity_name::TEXT AS applicant_ethnicity_name,
    a.applicant_ethnicity::TEXT AS applicant_ethnicity,

    co_eth.ethnicity_name::TEXT AS co_applicant_ethnicity_name,
    a.co_applicant_ethnicity::TEXT AS co_applicant_ethnicity,

    MAX(CASE WHEN r.num_of_race = 1 THEN r_lookup.race_name END)::TEXT AS applicant_race_name_1,
    MAX(CASE WHEN r.num_of_race = 1 THEN r.race_num END)::TEXT AS applicant_race_1,
    MAX(CASE WHEN r.num_of_race = 2 THEN r_lookup.race_name END)::TEXT AS applicant_race_name_2,
    MAX(CASE WHEN r.num_of_race = 2 THEN r.race_num END)::TEXT AS applicant_race_2,
    MAX(CASE WHEN r.num_of_race = 3 THEN r_lookup.race_name END)::TEXT AS applicant_race_name_3,
    MAX(CASE WHEN r.num_of_race = 3 THEN r.race_num END)::TEXT AS applicant_race_3,
    MAX(CASE WHEN r.num_of_race = 4 THEN r_lookup.race_name END)::TEXT AS applicant_race_name_4,
    MAX(CASE WHEN r.num_of_race = 4 THEN r.race_num END)::TEXT AS applicant_race_4,
    MAX(CASE WHEN r.num_of_race = 5 THEN r_lookup.race_name END)::TEXT AS applicant_race_name_5,
    MAX(CASE WHEN r.num_of_race = 5 THEN r.race_num END)::TEXT AS applicant_race_5,

    MAX(CASE WHEN cr.co_num_race = 1 THEN cr_lookup.race_name END)::TEXT AS co_applicant_race_name_1,
    MAX(CASE WHEN cr.co_num_race = 1 THEN cr.co_race_num END)::TEXT AS co_applicant_race_1,
    MAX(CASE WHEN cr.co_num_race = 2 THEN cr_lookup.race_name END)::TEXT AS co_applicant_race_name_2,
    MAX(CASE WHEN cr.co_num_race = 2 THEN cr.co_race_num END)::TEXT AS co_applicant_race_2,
    MAX(CASE WHEN cr.co_num_race = 3 THEN cr_lookup.race_name END)::TEXT AS co_applicant_race_name_3,
    MAX(CASE WHEN cr.co_num_race = 3 THEN cr.co_race_num END)::TEXT AS co_applicant_race_3,
    MAX(CASE WHEN cr.co_num_race = 4 THEN cr_lookup.race_name END)::TEXT AS co_applicant_race_name_4,
    MAX(CASE WHEN cr.co_num_race = 4 THEN cr.co_race_num END)::TEXT AS co_applicant_race_4,
    MAX(CASE WHEN cr.co_num_race = 5 THEN cr_lookup.race_name END)::TEXT AS co_applicant_race_name_5,
    MAX(CASE WHEN cr.co_num_race = 5 THEN cr.co_race_num END)::TEXT AS co_applicant_race_5,

    app_sex.sex_name::TEXT AS applicant_sex_name,
    a.applicant_sex::TEXT AS applicant_sex,

    co_sex.sex_name::TEXT AS co_applicant_sex_name,
    a.co_applicant_sex::TEXT AS co_applicant_sex,

    a.applicant_income_000s::TEXT AS applicant_income_000s,

    pcht.purchaser_type_name::TEXT AS purchaser_type_name,
    a.purchaser_type::TEXT AS purchaser_type,

    MAX(CASE WHEN d.denial_num = 1 THEN dr_lookup.denial_reason_name END)::TEXT AS denial_reason_name_1,
    MAX(CASE WHEN d.denial_num = 1 THEN d.denial_reason END)::TEXT AS denial_reason_1,
    MAX(CASE WHEN d.denial_num = 2 THEN dr_lookup.denial_reason_name END)::TEXT AS denial_reason_name_2,
    MAX(CASE WHEN d.denial_num = 2 THEN d.denial_reason END)::TEXT AS denial_reason_2,
    MAX(CASE WHEN d.denial_num = 3 THEN dr_lookup.denial_reason_name END)::TEXT AS denial_reason_name_3,
    MAX(CASE WHEN d.denial_num = 3 THEN d.denial_reason END)::TEXT AS denial_reason_3,

    a.rate_spread::TEXT AS rate_spread,

    hs.hoepa_status_name::TEXT AS hoepa_status_name,
    a.hoepa_status::TEXT AS hoepa_status,

    ls.lien_status_name::TEXT AS lien_status_name,
    a.lien_status::TEXT AS lien_status,

    NULL::TEXT AS edit_status_name,
    NULL::TEXT AS edit_status,
    NULL::TEXT AS sequence_number,

    loc.population::TEXT AS population,
    loc.minority_population::TEXT AS minority_population,
    loc.hud_median_family_income::TEXT AS hud_median_family_income,
    loc.tract_to_msamd_income::TEXT AS tract_to_msamd_income,
    loc.number_of_owner_occupied_units::TEXT AS number_of_owner_occupied_units,
    loc.number_of_1_to_4_family_units::TEXT AS number_of_1_to_4_family_units,

    NULL::TEXT AS application_date_indicator

FROM
    Application a
    LEFT JOIN Agency ag ON a.agency_code = ag.agency_code
    LEFT JOIN LoanType lt ON a.loan_type = lt.loan_type
    LEFT JOIN PropertyType pt ON a.property_type = pt.property_type
    LEFT JOIN LoanPurpose lp ON a.loan_purpose = lp.loan_purpose
    LEFT JOIN OwnerOccupancy oo ON a.owner_occupancy = oo.owner_occupancy
    LEFT JOIN Preapproval pr ON a.preapproval = pr.preapproval
    LEFT JOIN ActionTaken at ON a.action_taken = at.action_taken
    LEFT JOIN Ethnicity app_eth ON a.applicant_ethnicity = app_eth.ethnicity_num
    LEFT JOIN Ethnicity co_eth ON a.co_applicant_ethnicity = co_eth.ethnicity_num
    LEFT JOIN Sex app_sex ON a.applicant_sex = app_sex.sex_num
    LEFT JOIN Sex co_sex ON a.co_applicant_sex = co_sex.sex_num
    LEFT JOIN PurchaserType pcht ON a.purchaser_type = pcht.purchaser_type
    LEFT JOIN HOEPAStatus hs ON a.hoepa_status = hs.hoepa_status
    LEFT JOIN LienStatus ls ON a.lien_status = ls.lien_status
    LEFT JOIN Location loc ON a.location_ID = loc.location_ID
    LEFT JOIN MSAMD ms ON loc.msamd = ms.msamd
    LEFT JOIN STATE st ON loc.state_code = st.state_code
    LEFT JOIN COUNTY co ON loc.county_code = co.county_code
    LEFT JOIN Races r ON a.ID = r.id
    LEFT JOIN Race r_lookup ON r.race_num = r_lookup.race_num
    LEFT JOIN Co_Races cr ON a.ID = cr.id
    LEFT JOIN Race cr_lookup ON cr.co_race_num = cr_lookup.race_num
    LEFT JOIN Denials d ON a.ID = d.id
    LEFT JOIN DenialReason dr_lookup ON d.denial_reason = dr_lookup.denial_reason

GROUP BY
    a.ID,
    a.as_of_year, a.respondent_id, ag.agency_name, ag.agency_abbr, a.agency_code,
    lt.loan_type_name, a.loan_type, pt.property_type_name, a.property_type,
    lp.loan_purpose_name, a.loan_purpose, oo.owner_occupancy_name, a.owner_occupancy,
    a.loan_amount_000s, pr.preapproval_name, a.preapproval, at.action_taken_name, a.action_taken,
    ms.msamd_name, loc.msamd, st.state_name, st.state_abbr, loc.state_code,
    co.county_name, loc.county_code, loc.census_tract_number,
    app_eth.ethnicity_name, a.applicant_ethnicity, co_eth.ethnicity_name, a.co_applicant_ethnicity,
    app_sex.sex_name, a.applicant_sex, co_sex.sex_name, a.co_applicant_sex,
    a.applicant_income_000s, pcht.purchaser_type_name, a.purchaser_type,
    a.rate_spread, hs.hoepa_status_name, a.hoepa_status, ls.lien_status_name, a.lien_status,
    loc.population, loc.minority_population, loc.hud_median_family_income,
    loc.tract_to_msamd_income, loc.number_of_owner_occupied_units, loc.number_of_1_to_4_family_units

ORDER BY
    a.ID;

SELECT * FROM Denials;
SELECT * FROM Co_Races;
SELECT * FROM Races;
SELECT * FROM Application;
SELECT * FROM Location;
SELECT * FROM COUNTY;
SELECT * FROM STATE;
SELECT * FROM MSAMD;
SELECT * FROM NULL_VALUES;
SELECT * FROM Race;
SELECT * FROM Ethnicity;
SELECT * FROM Sex;
SELECT * FROM PropertyType;
SELECT * FROM OwnerOccupancy;
SELECT * FROM Agency;
SELECT * FROM PurchaserType;
SELECT * FROM LienStatus; 
SELECT * FROM LoanType;
SELECT * FROM LoanPurpose; 
SELECT * FROM Preapproval;
SELECT * FROM ActionTaken;
SELECT * FROM DenialReason;
SELECT * FROM HOEPAStatus;
SELECT * FROM FINAL;

INSERT INTO FINAL (
    as_of_year,             
    respondent_id          
    -- Only specifying 2 columns
) VALUES (
    '2024',                
    'RespABC',             
    'Unexpected Value'  -- 3 values, greater than specified columns
);

INSERT FINAL (as_of_year, respondent_id) VALUES ('2024', 'Resp999'); --syntax error

INSERT INTO FINAL
SELECT
    a.as_of_year::TEXT,
    ag.agency_name::TEXT 
FROM Application a; --ag table does not exist yet, haven't referenced agency as ag yet