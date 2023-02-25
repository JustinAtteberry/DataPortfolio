--HEXACO IPIP items (7-point scale):

--Anxiety, Positively Keyed:
--e_anx_1: Often worry about things that turn out to be unimportant
--e_anx_2: Worry about things
--e_anx_3: Get stressed out easily
--e_anx_4: Get upset by unpleasant thoughts that come into my mind
--e_anx_5: Panic easily

--Anxiety, Negatively Keyed:
--e_anx_6: Rarely worry
--e_anx_7: Rarely feel depressed
--e_anx_8: Am not easily disturbed by events
--e_anx_9: Remain calm under pressure
--e_anx_10: Don't worry about things that have already happened

--Grip/Chest strength in kg/F

Select *
From PortfolioProject..PSFAnxiety
order by id

--------------------------------------------------------------------
-- Data Analysis
--------------------------------------------------------------------

-- Count of Sex
Select count(sex) as TotalCount,
count(case when sex = 'male' then sex end) as MaleCount,
count(case when sex = 'female' then sex end) as FemaleCount
from PortfolioProject..PSFAnxiety

-- Count of Ethnicity
Select count(case when ethnicity = 'White/Euro-American' then ethnicity end) as WhiteEuroAmerican,
count(case when ethnicity = 'Hispanic/Latino' then ethnicity end) as HispanicLatino,
count(case when ethnicity = 'Black/African-American' then ethnicity end) as BlackAfricanAmerican,
count(case when ethnicity = 'Asian-American' then ethnicity end) as AsianAmerican,
count(case when ethnicity = 'Pacific Islander' then ethnicity end) as PacificIslander,
count(case when ethnicity = 'Biracial/Other' then ethnicity end) as BiracialOther,
count(ethnicity) as Total
From PortfolioProject..PSFAnxiety

-- Average Age of person tested (total and per sex)
Select format(avg(age), 'n0') as AverageAgeTotal,
format(avg(case when sex = 'male' then age end), 'n0') as AverageMaleAge,
format(avg(case when sex = 'female' then age end), 'n0') as AverageFemaleAge
from PortfolioProject..PSFAnxiety

-- Average Grip and Chest strength (in kg/F) per Sex
Select format(avg(case when sex = 'male' then grip end), 'n2') as AVGMaleGripStr,
format(avg(case when sex = 'male' then chest end), 'n2') as AVGMaleChestStr,
format(avg(case when sex = 'female' then grip end), 'n2') as AVGFemaleGripStr,
format(avg(case when sex = 'female' then chest end), 'n2') as AVGFemaleChestStr
from PortfolioProject..PSFAnxiety

-- Avg strength combined in kg/F (remove null values)
Select id, sex, avg(grip + chest) as AVGCombineStr
from PortfolioProject..PSFAnxiety
where chest is not null
and grip is not null
group by id, sex
order by id

-- Avg strength combined separated by sex
Select format(avg(case when sex = 'male' then grip + chest end), 'n2') as AVGMaleCombineStr,
format(avg(case when sex = 'female' then grip + chest end), 'n2') as AVGFemaleCombineStr
from PortfolioProject..PSFAnxiety

-- Percent Female to Male power? use cte
with cte as (
	Select format(avg(case when sex = 'male' then grip end), 'n2') as AVGMaleGripStr,
	format(avg(case when sex = 'male' then chest end), 'n2') as AVGMaleChestStr,
	format(avg(case when sex = 'female' then grip end), 'n2') as AVGFemaleGripStr,
	format(avg(case when sex = 'female' then chest end), 'n2') as AVGFemaleChestStr
	from PortfolioProject..PSFAnxiety
)
Select *,
format((cast(AVGFemaleGripStr as decimal)/cast(AVGMaleGripStr as decimal)) * 100, 'n2') as FTMGripPercent,
format((cast(AVGFemaleChestStr as decimal)/cast(AVGMaleChestStr as decimal)) * 100, 'n2') as FTMChestPercent
from cte

-- Average of Positively Keyed vs Negatively Keyed in Anxiety
Select id, age, grip, chest, (e_anx_1 + e_anx_2 + e_anx_3 + e_anx_4 + e_anx_5)/5 as AVGPositivelyKeyed, 
(e_anx_6 + e_anx_7 + e_anx_8 + e_anx_9 + e_anx_10)/5 as AVGNegativelyKeyed
From PortfolioProject..PSFAnxiety
Order by id

-- More intuitive approach of Average of Positively Keyed vs Negatively Keyed in Anxiety
with anxPosKeyedAVG as (
	Select id, age, grip, chest, e_anx_1 as COL from PortfolioProject..PSFAnxiety
	union all
	Select id, age, grip, chest, e_anx_2 as COL from PortfolioProject..PSFAnxiety
	union all
	Select id, age, grip, chest, e_anx_3 as COL from PortfolioProject..PSFAnxiety
	union all
	Select id, age, grip, chest, e_anx_4 as COL from PortfolioProject..PSFAnxiety
	union all
	Select id, age, grip, chest, e_anx_5 as COL from PortfolioProject..PSFAnxiety),
anxNegKeyedAVG as (
	Select id, age, grip, chest, e_anx_6 as COL2 from PortfolioProject..PSFAnxiety
	union all
	Select id, age, grip, chest, e_anx_7 as COL2 from PortfolioProject..PSFAnxiety
	union all
	Select id, age, grip, chest, e_anx_8 as COL2 from PortfolioProject..PSFAnxiety
	union all
	Select id, age, grip, chest, e_anx_9 as COL2 from PortfolioProject..PSFAnxiety
	union all
	Select id, age, grip, chest, e_anx_10 as COL2 from PortfolioProject..PSFAnxiety)
Select pos.id, pos.age, pos.grip, pos.chest, AVG(COL) as AVGPositivelyKeyed, AVG(COL2) as AVGNegativelyKeyed
from anxPosKeyedAVG as pos
join anxNegKeyedAVG as neg
on pos.id = neg.id
Group by pos.id, pos.age, pos.grip, pos.chest
order by pos.id

-- Average Strength combined with average pos key and neg key for anxiety separated by sex
with anxPosKeyedAVG as (
	Select id, age, sex, grip, chest, e_anx_1 as COL from PortfolioProject..PSFAnxiety
	union all
	Select id, age, sex, grip, chest, e_anx_2 as COL from PortfolioProject..PSFAnxiety
	union all
	Select id, age, sex, grip, chest, e_anx_3 as COL from PortfolioProject..PSFAnxiety
	union all
	Select id, age, sex, grip, chest, e_anx_4 as COL from PortfolioProject..PSFAnxiety
	union all
	Select id, age, sex, grip, chest, e_anx_5 as COL from PortfolioProject..PSFAnxiety),
anxNegKeyedAVG as (
	Select id, age, sex, grip, chest, e_anx_6 as COL2 from PortfolioProject..PSFAnxiety
	union all
	Select id, age, sex, grip, chest, e_anx_7 as COL2 from PortfolioProject..PSFAnxiety
	union all
	Select id, age, sex, grip, chest, e_anx_8 as COL2 from PortfolioProject..PSFAnxiety
	union all
	Select id, age, sex, grip, chest, e_anx_9 as COL2 from PortfolioProject..PSFAnxiety
	union all
	Select id, age, sex, grip, chest, e_anx_10 as COL2 from PortfolioProject..PSFAnxiety)
Select format(avg(case when pos.sex = 'male' then pos.grip + pos.chest end), 'n2') as AVGMaleCombineStr,
format(avg(case when pos.sex = 'male' then col end), 'n2') as AVGMalePosKey,
format(avg(case when pos.sex = 'male' then col2 end), 'n2') as AVGMaleNegKey,
format(avg(case when pos.sex = 'female' then pos.grip + pos.chest end), 'n2') as AVGFemaleCombineStr,
format(avg(case when pos.sex = 'female' then col end), 'n2') as AVGFemalePosKey,
format(avg(case when pos.sex = 'female' then col2 end), 'n2') as AVGFemaleNegKey
from anxPosKeyedAVG as pos
join anxNegKeyedAVG as neg
on pos.id = neg.id

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- Queries to be used in Jupyter Notebook for correlation analysis

with anxPosKeyedAVG as (
	Select id, age, grip, chest, e_anx_1 as COL from PortfolioProject..PSFAnxiety
	union all
	Select id, age, grip, chest, e_anx_2 as COL from PortfolioProject..PSFAnxiety
	union all
	Select id, age, grip, chest, e_anx_3 as COL from PortfolioProject..PSFAnxiety
	union all
	Select id, age, grip, chest, e_anx_4 as COL from PortfolioProject..PSFAnxiety
	union all
	Select id, age, grip, chest, e_anx_5 as COL from PortfolioProject..PSFAnxiety),
anxNegKeyedAVG as (
	Select id, age, grip, chest, e_anx_6 as COL2 from PortfolioProject..PSFAnxiety
	union all
	Select id, age, grip, chest, e_anx_7 as COL2 from PortfolioProject..PSFAnxiety
	union all
	Select id, age, grip, chest, e_anx_8 as COL2 from PortfolioProject..PSFAnxiety
	union all
	Select id, age, grip, chest, e_anx_9 as COL2 from PortfolioProject..PSFAnxiety
	union all
	Select id, age, grip, chest, e_anx_10 as COL2 from PortfolioProject..PSFAnxiety)
Select pos.age, pos.grip, pos.chest, AVG(COL) as AVGPositivelyKeyed, AVG(COL2) as AVGNegativelyKeyed
from anxPosKeyedAVG as pos
join anxNegKeyedAVG as neg
on pos.id = neg.id
Group by pos.id, pos.age, pos.grip, pos.chest
order by pos.id

Select age, sex, ethnicity, grip, chest, e_anx_1, e_anx_2, e_anx_3, e_anx_4, e_anx_5, e_anx_6, e_anx_7, e_anx_8, e_anx_9, e_anx_10
From PortfolioProject..PSFAnxiety
Order by id