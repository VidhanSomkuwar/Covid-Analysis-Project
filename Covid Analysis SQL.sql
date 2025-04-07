


SELECT * FROM Combined_CovidDeaths

SELECT location, date, total_cases, new_cases, total_deaths
FROM CovidDeaths_1
UNION
(SELECT location, date, total_cases, new_cases, total_deaths
FROM CovidDeaths_2)
ORDER BY 1,2

SELECT location, date, total_cases, new_cases, total_deaths
FROM CovidDeaths_1
ORDER BY 1,2

--Below commented code is for debugging


--SELECT location, date, total_cases, new_cases, total_deaths
--FROM CovidDeaths_1
--ORDER BY 1,2

--SELECT DISTINCT total_deaths FROM CovidDeaths_1;

--SELECT COLUMN_NAME, DATA_TYPE 
--FROM INFORMATION_SCHEMA.COLUMNS 
--WHERE TABLE_NAME = 'CovidDeaths_2';

--SELECT COUNT(*) 
--FROM CovidDeaths_1
--WHERE TRY_CAST(total_deaths AS FLOAT) IS NOT NULL;

    
--Merging both the parts of the CovidDeaths file into a single table
SELECT * 
INTO Combined_CovidDeaths
FROM (
    SELECT * FROM CovidDeaths_1  -- Table 1
    UNION ALL
    SELECT * FROM CovidDeaths_2  -- Table 2
) AS Combined;

--Merging both the parts of the CovidVaccinations file into a single table
SELECT * 
INTO Combined_Vaccinations
FROM (
    SELECT * FROM CovidVaccinations_1  -- Table 1
    UNION ALL
    SELECT * FROM CovidVaccinations_2  -- Table 2
) AS Combined;

SELECT location, date, total_cases, new_cases, total_deaths
FROM Combined_CovidDeaths
ORDER BY 1,2

--Total Cases VS Total Deaths
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 AS death_percentage
FROM Combined_CovidDeaths
WHERE location = 'India'
ORDER BY 1,2


--Total cases VS population
SELECT location, date, total_cases, population, (total_cases/population) * 100 as positive_percentage
FROM Combined_CovidDeaths
WHERE location = 'India'
ORDER BY 1,2

--Countries with highest infection rate
SELECT location, MAX(total_cases) as Highest_infected, population, MAX((total_cases/population) *100) as infection_rate
FROM Combined_CovidDeaths
GROUP BY location, population
ORDER BY infection_rate DESC

--Contries with Highest death count in a day
SELECT location, MAX(total_deaths) as highest_deaths
FROM Combined_CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY highest_deaths DESC


--Continents with Highest death count in a day
SELECT location, MAX(total_deaths) as highest_deaths
FROM Combined_CovidDeaths
WHERE continent IS NULL
GROUP BY location
ORDER BY highest_deaths DESC


SELECT continent, MAX(total_deaths) as highest_deaths
FROM Combined_CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY highest_deaths DESC

--SELECT COUNT(*) AS NullCount
--FROM CovidDeaths_1
--WHERE new_deaths IS NOT NULL;

--Global Stats
SELECT date, SUM(new_cases) as total_cases, SUM(CAST(new_deaths as int)) AS total_deaths, SUM(CAST(new_deaths as int))/SUM(new_cases) * 100 as death_percentatge
FROM Combined_CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1

SELECT  SUM(new_cases) as total_cases, SUM(CAST(new_deaths as int)) AS total_deaths, SUM(CAST(new_deaths as int))/SUM(new_cases) * 100 as death_percentatge
FROM Combined_CovidDeaths
WHERE continent IS NOT NULL
--GROUP BY date
--ORDER BY 1


SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS rolling_count
FROM Combined_CovidDeaths dea
JOIN Combined_Vaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3

--SELECT COUNT(*) FROM Combined_Vaccinations
--WHERE total_vaccinations IS NOT NULL


--CTE to show increase in %age people vaccinated after each day

WITH popVSvacc AS (
SELECT dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS rolling_count
FROM Combined_CovidDeaths dea
JOIN Combined_Vaccinations vac
ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL 
)

SELECT *, (rolling_count/population)*100 AS cumulative_vacc_percentage
FROM popVSvacc


-- Using Temp table
DROP TABLE IF EXISTS #percentagePopulationVaccinated
CREATE TABLE #percentagePopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population float,
new_vaccinations float,
rolling_count float
)

INSERT INTO #percentagePopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS rolling_count
FROM Combined_CovidDeaths dea
JOIN Combined_Vaccinations vac
ON dea.location = vac.location AND dea.date = vac.date

SELECT *, (rolling_count/population)*100 AS cumulative_vacc_percentage
FROM #percentagePopulationVaccinated
WHERE continent IS NOT NULL
ORDER BY 1,2,3
