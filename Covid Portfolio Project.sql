/*
Covid 19 Data Exploration 
Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/

SELECT *
FROM PortfolioProject..CowidDeaths
	WHERE continent is not null 
	ORDER BY 3,4

-- Select Data that we are going to be starting with

SELECT location, 
	date, 
	total_cases, 
	new_cases, 
	total_deaths, 
	population
FROM PortfolioProject..CowidDeaths
ORDER BY 1,2 

-- Looking at Total Cases vs Total Deaths --
-- Shows likelihood of dying if you contract covid in your country --

SELECT location, 
	date, 
	total_cases, 
	total_deaths, 
	(total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject..CowidDeaths
WHERE location like 'Netherlands'
ORDER BY 1,2 

-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

SELECT location, 
	date, 
	total_cases, 
	population, 
	(total_cases/population)*100 as InflectionRate
FROM PortfolioProject..CowidDeaths
WHERE location like 'Netherlands'
ORDER BY 1,2 

-- Countries with Highest Infection Rate compared to Population

SELECT location,  
	MAX(total_cases) as 'MAX Total Cases',
	population,
	MAX((total_cases/population))*100 as PercPopulationInfected
FROM PortfolioProject..CowidDeaths
--WHERE location like 'Netherlands'
GROUP BY location, population
ORDER BY 4 DESC

-- Countries with Highest Death Count per Population

SELECT location,  
	MAX(cast(total_deaths as int)) as 'Total Death Count'
FROM PortfolioProject..CowidDeaths
WHERE continent is not NULL
GROUP BY location
ORDER BY 2 DESC

-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population

SELECT location,  
	MAX(cast(total_deaths as int)) as 'Total Death Count'
FROM PortfolioProject..CowidDeaths
WHERE continent is NULL
GROUP BY location
ORDER BY 2 DESC

SELECT continent,  
	MAX(cast(total_deaths as int)) as 'Total Death Count'
FROM PortfolioProject..CowidDeaths
WHERE continent is not NULL
GROUP BY continent
ORDER BY 2 DESC

-- GLOBAL NUMBERS

SELECT date, 
	SUM(new_cases) as NewCasesTotalperDay,
	SUM(cast(new_deaths as int)) as NewDeathsTotalperDay,
	SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM PortfolioProject..CowidDeaths
WHERE continent is not NULL
GROUP BY date
ORDER BY 4 DESC	

-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	SUM(CONVERT(int, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER by dea.location, dea.date) as RollingPeopleVaccinated
	--, (RollingPeopleVaccinated/dea.population)*100 as Percentage
FROM PortfolioProject..CowidDeaths dea
JOIN PortfolioProject..CowidVaccin vac
	on dea.location = vac.location 
	and dea.date = vac.date
--WHERE dea.location = 'Turkey'
ORDER BY 2,3


-- USE CTE
WITH PopvsVac (Continent, Location, Date, Population, new_vaccinations, RollingPeopleVaccinated)
as (
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	SUM(CONVERT(int, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER by dea.location, dea.date) as RollingPeopleVaccinated
	--, (RollingPeopleVaccinated/dea.population)*100 as Percentage
FROM PortfolioProject..CowidDeaths dea
JOIN PortfolioProject..CowidVaccin vac
	on dea.location = vac.location 
	and dea.date = vac.date
--WHERE dea.location = 'Turkey'
--ORDER BY 2,3 -- it cannot be there
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac

-- Using Temp Table to perform Calculation on Partition By in previous query
DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CowidDeaths dea
Join PortfolioProject..CowidVaccin vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated

-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CowidDeaths dea
Join PortfolioProject..CowidVaccin vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 