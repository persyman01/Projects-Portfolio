/*
Covid 19 Data Exploration 

Skills used: Joins,  Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/

/*
Data Cleaning Initially wanted to remove null values using the continent field
*/

Select *
From CovidProject..Deaths
Where continent is not null 
order by 3,4


-- Select Data that we are going to be starting with

Select Location, date, total_cases, new_cases, total_deaths, population
From CovidProject..Deaths
Where continent is not null 
order by 1,2


-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country
-- interested with Zimbabwe my country

Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From CovidProject..Deaths
Where location like '%zim%'
and continent is not null 
order by 1,2


-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

Select Location, date, Population, total_cases,  (total_cases/population)*100 as PercentPopulationInfected
From CovidProject..Deaths
--Where location like '%zim%'
order by 1,2


-- Countries with Highest Infection Rate compared to Population
--used Max function to determine the maximum number for the total cases
-- used groub by fucnction to group with Location and population
--order by to assist with easy visualization and desc to start with highest number going down

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From CovidProject..Deaths
--Where location like '%zim%'
Group by Location, Population
order by PercentPopulationInfected desc


-- Countries with Highest Death Count per Population
-- the original data type was nvarchar and need to convert it to Int for reliable analysis, therefore used cast function

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From CovidProject..Deaths
--Where location like '%zim%'
Where continent is not null 
Group by Location
order by TotalDeathCount desc



-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From CovidProject..Deaths
--Where location like '%zim%'
Where continent is not null 
Group by continent
order by TotalDeathCount desc



-- GLOBAL NUMBERS

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From CovidProject..Deaths
--Where location like '%zim%'
where continent is not null 
--Group By date
order by 1,2



-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidProject..Deaths dea
Join CovidProject..Vaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3




-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidProject..Deaths dea
Join CovidProject..Vaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
