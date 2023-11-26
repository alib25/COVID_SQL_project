/* 
COVID-19 DATA EXPLORATION
*/ 

/*
SELECT *
FROM coviddeaths
ORDER  BY 3,4;

SELECT *
FROM covidvaccinations
WHERE continent is not null
ORDER BY 3,4;
*/
-- Select Data that we are going to be using 

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM coviddeaths
WHERE continent is not null
ORDER BY 1,2;

-- Looking at Total Cases vs Total Deaths
-- Shows the likelihood of death if an individual contracts COVID, based on your country 
SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM coviddeaths
WHERE location like '%states%'
AND continent is not null
ORDER BY 1,2;

-- Looking at Total Cases vs Population 
SELECT Location, date, population, total_cases, (total_cases/population)*100 AS PercentPopulationInfected
FROM coviddeaths
WHERE location like '%states%'
AND continent is not null
ORDER BY 1,2;

-- Looking at Countries with the Highest Infection Rate compared to Population
SELECT Location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 AS PercentPopulationInfected
FROM coviddeaths
-- WHERE location like '%states%'
WHERE continent is not null
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC;


-- Showing continents with Highest Death Count per population

SELECT continent, MAX(cast(Total_deaths AS int)) AS TotalDeathCount
FROM coviddeaths
-- WHERE location like '%states%'
WHERE continent is null
GROUP BY continent
ORDER BY TotalDeathCount DESC;

-- Exploring based on continent 
-- Showing continents with the highest death count per population
SELECT continent, MAX(cast(total_deaths AS int)) AS TotalDeathCount
FROM coviddeaths
-- WHERE location like '%states%'
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount DESC;


-- Global Numbers 

SELECT date, SUM(new_cases) AS total_cases, SUM(cast(new_deaths AS int)) AS total_deaths, SUM(cast(New_deaths as INT)/SUM(New_Caes)*100 
AS DeathPercentage
FROM coviddeaths
-- WHERE location like '%states%'
WHERE continent is not null
GROUP BY date
ORDER BY 1,2;

-- Total Population versus Vaccinations
-- Show Percentage of population that has receieved at least one dose of the COVID vaccine 

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by by dea.location ORDER BY dea.location, dea.Date) 
AS RollingPeopleVaccinated--, (RollingPeopleVaccinated/population)*100
FROM coviddeaths dea
JOIN covidvaccinations vac
	ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent is not null
ORDER by 2,3;


-- Using CTE to perform Calculation on Partition By in previous query 

WITH PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by by dea.location ORDER BY dea.location, dea.Date) 
AS RollingPeopleVaccinated--, (RollingPeopleVaccinated/population)*100
FROM coviddeaths dea
JOIN covidvaccinations vac
	ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent is not null
-- ORDER by 2,3;
)
SELECT *, (RollingPeopleVaccinated/Population)*100
FROM PopvsVac

-- Using Temp Table to perform Calculation on Partition By in previous query 
 
 DROP Table if exists #PercentPopulationVaccinated
 CREATE Table #PercentPopulationVaccinated
 (
 Continent nvarchar(255),
 Location nvarchar(255),
 Date datetime,
 Population numeric,
 New_vaccinations numeric,
 RollingPeopleVaccinated numeric
 )
 
 INSERT into #PercentPopulationVaccinated
 SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by by dea.location ORDER BY dea.location, dea.Date) 
AS RollingPeopleVaccinated--, (RollingPeopleVaccinated/population)*100
FROM coviddeaths dea
JOIN covidvaccinations vac
	ON dea.location = vac.location
    AND dea.date = vac.date
-- WHERE dea.continent is not null
-- ORDER by 2,3;

SELECT *, (RollingPeopleVaccinated/Population)*100
FROM #PercentPopulationVaccinated


-- Creating View to store data for later visualizations

CREATE View PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location ORDER BY dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null 





