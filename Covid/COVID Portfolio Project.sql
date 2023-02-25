Select *
From PortfolioProject..CovidDeaths
Order by 3,4

Select *
From PortfolioProject..CovidVaccinations
Order by 3,4

-- Select Data that we are going to be using

Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
order by 1,2

-- Looking at Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid by country
Select Location, date, total_cases, total_deaths, ((total_deaths/total_cases) * 100) as DeathPercentage
From PortfolioProject..CovidDeaths
order by 1,2

-- Looking at Total Cases vs Total Deaths in the United States

Select Location, date, total_cases, total_deaths, ((total_deaths/total_cases) * 100) as DeathPercentage
From PortfolioProject..CovidDeaths
where location like '%states%'
order by date

-- Looking at the Total Cases vs Population in the United States
-- Shows what percentage of population got Covid
Select Location, date, population, total_cases,  ((total_cases/population) * 100) as ContractionPercentage
From PortfolioProject..CovidDeaths
where location like '%states%'
order by date

-- Looking at Countries with Highest Infection Rate compared to Population

Select Location, population, MAX(total_cases) as HighestCaseCount, MAX((total_cases/population)) * 100 as PercentPopInfected
From PortfolioProject..CovidDeaths
--where total_cases is not null
--and population is not null
group by location, population
order by PercentPopInfected desc

-- Showing Countries with the Highest Death Count per Population
-- Total Deaths is nvarchar(255), need to cast as int
Select Location, continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
where continent is not null
group by location, continent
order by TotalDeathCount desc

-- Showing Continents with the Highest Death Count per Population

Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
where continent is null
group by location
order by TotalDeathCount desc

------------------------------------------------------------------------------
-- GLOBAL NUMBERS

Select SUM(new_cases) as TotalCases, SUM(cast(new_deaths as int)) as TotalDeaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where continent is not null


-- Looking at Total Population vs Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location, dea.date) as RollingVaccCount
--(RollingVaccCount/population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3



-- USE CTE
with PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingVaccCount)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location, dea.date) as RollingVaccCount
--(RollingVaccCount/population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *, (RollingVaccCount/population)*100
from PopvsVac



-- TEMP TABLE
drop table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingVaccCount numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location, dea.date) as RollingVaccCount
--(RollingVaccCount/population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select *, (RollingVaccCount/population)*100
from #PercentPopulationVaccinated