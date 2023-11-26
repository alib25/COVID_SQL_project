/*

Queries used for Tableau Project

*/


-- 1. 

SELECT SUM(new_cases) AS total_cases, SUM(cast(new_deaths AS int)) AS total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
FROM coviddeaths
--Where location LIKE '%states%'
WHERE continent is not null 
--GROUP BY date
ORDER BY 1,2

-- Just a double check based off the data provided
-- Numbers are extremely close so I will keep them - The Second includes "International"  Location


--SELECT SUM(new_cases) AS total_cases, SUM(cast(new_deaths AS int)) AS total_deaths, SUM(cast(new_deaths AS int))/SUM(New_Cases)*100 AS DeathPercentage
--From PortfolioProject..CovidDeaths
----WHERE location LIKE '%states%'
--WHERE location = 'World'
----GROUP BY date
--ORDER BY 1,2


-- 2. 

-- Excluded these becasue they are not inluded in the above queries and want to stay consistent
-- European Union is part of Europe

SELECT location, SUM(cast(new_deaths AS int)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
--WHERE location LIKE '%states%'
WHERE continent is null 
AND location not in ('World', 'European Union', 'International')
GROUP BY location
ORDER BY TotalDeathCount DESC


-- 3.

SELECT Location, Population, MAX(total_cases) AS HighestInfectionCount,  Max((total_cases/population))*100 AS PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
--WHERE location LIKE '%states%'
GROUP BY Location, Population
ORDER BY PercentPopulationInfected DESC


-- 4.


SELECT Location, Population,date, MAX(total_cases) AS HighestInfectionCount,  Max((total_cases/population))*100 AS PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
--WHERE location LIKE '%states%'
GROUP BY Location, Population, date
ORDER BY PercentPopulationInfected DESC

