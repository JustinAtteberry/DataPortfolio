--------------------------------------------------------------------
-- Data Cleaning for PSFAnxiety
--------------------------------------------------------------------
Select *
From PortfolioProject..PSFAnxiety

-- Change Sex from 0 (male) and 1 (female) to male and female

ALTER TABLE PortfolioProject..PSFAnxiety
ALTER COLUMN sex Nvarchar(255);

Update PortfolioProject..PSFAnxiety
SET sex = CASE When sex = '0' then 'male'
	When sex = '1' then 'female'
	Else sex
	END

-- Change Ethnicity from numeric to nvarchar with description

ALTER TABLE PortfolioProject..PSFAnxiety
ALTER COLUMN ethnicity Nvarchar(255);

Update PortfolioProject..PSFAnxiety
SET ethnicity = CASE When ethnicity = '1' then 'White/Euro-American'
	When ethnicity = '2' then 'Hispanic/Latino'
	When ethnicity = '3' then 'Black/African-American'
	When ethnicity = '5' then 'Asian-American'
	When ethnicity = '7' then 'Pacific Islander'
	When ethnicity = '8' then 'Biracial/Other'
	Else ethnicity
	END

--------------------------------------------------------------------
-- Data Cleaning for PSFDependence
--------------------------------------------------------------------
Select *
From PortfolioProject..PSFDependence

-- Change Sex from 0 (male) and 1 (female) to male and female

ALTER TABLE PortfolioProject..PSFDependence
ALTER COLUMN sex Nvarchar(255);

Update PortfolioProject..PSFDependence
SET sex = CASE When sex = '0' then 'male'
	When sex = '1' then 'female'
	Else sex
	END

-- Change Ethnicity from numeric to nvarchar with description

ALTER TABLE PortfolioProject..PSFDependence
ALTER COLUMN ethnicity Nvarchar(255);

Update PortfolioProject..PSFDependence
SET ethnicity = CASE When ethnicity = '1' then 'White/Euro-American'
	When ethnicity = '2' then 'Hispanic/Latino'
	When ethnicity = '3' then 'Black/African-American'
	When ethnicity = '5' then 'Asian-American'
	When ethnicity = '7' then 'Pacific Islander'
	When ethnicity = '8' then 'Biracial/Other'
	Else ethnicity
	END

--------------------------------------------------------------------
-- Data Cleaning for PSFFearfulness
--------------------------------------------------------------------
Select *
From PortfolioProject..PSFFearfulness

-- Change Sex from 0 (male) and 1 (female) to male and female

ALTER TABLE PortfolioProject..PSFFearfulness
ALTER COLUMN sex Nvarchar(255);

Update PortfolioProject..PSFFearfulness
SET sex = CASE When sex = '0' then 'male'
	When sex = '1' then 'female'
	Else sex
	END

-- Change Ethnicity from numeric to nvarchar with description

ALTER TABLE PortfolioProject..PSFFearfulness
ALTER COLUMN ethnicity Nvarchar(255);

Update PortfolioProject..PSFFearfulness
SET ethnicity = CASE When ethnicity = '1' then 'White/Euro-American'
	When ethnicity = '2' then 'Hispanic/Latino'
	When ethnicity = '3' then 'Black/African-American'
	When ethnicity = '5' then 'Asian-American'
	When ethnicity = '7' then 'Pacific Islander'
	When ethnicity = '8' then 'Biracial/Other'
	Else ethnicity
	END

--------------------------------------------------------------------
-- Data Cleaning for PSFSentimentality
--------------------------------------------------------------------
Select *
From PortfolioProject..PSFSentimentality

-- Change Sex from 0 (male) and 1 (female) to male and female

ALTER TABLE PortfolioProject..PSFSentimentality
ALTER COLUMN sex Nvarchar(255);

Update PortfolioProject..PSFSentimentality
SET sex = CASE When sex = '0' then 'male'
	When sex = '1' then 'female'
	Else sex
	END

-- Change Ethnicity from numeric to nvarchar with description

ALTER TABLE PortfolioProject..PSFSentimentality
ALTER COLUMN ethnicity Nvarchar(255);

Update PortfolioProject..PSFSentimentality
SET ethnicity = CASE When ethnicity = '1' then 'White/Euro-American'
	When ethnicity = '2' then 'Hispanic/Latino'
	When ethnicity = '3' then 'Black/African-American'
	When ethnicity = '5' then 'Asian-American'
	When ethnicity = '7' then 'Pacific Islander'
	When ethnicity = '8' then 'Biracial/Other'
	Else ethnicity
	END

-- Delete unknown ethnicity entry to streamline data

Delete
From PortfolioProject..PSFAnxiety
WHERE id = 331

Delete
From PortfolioProject..PSFDependence
WHERE id = 331

Delete
From PortfolioProject..PSFFearfulness
WHERE id = 331

Delete
From PortfolioProject..PSFSentimentality
WHERE id = 331