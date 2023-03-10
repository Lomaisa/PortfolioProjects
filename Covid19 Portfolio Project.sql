Select*
From CovidDeaths
where continent is not null
order by 3,4

Select*
From CovidVaccinations
order by 3,4

/*Selecting Rows from the CovidDeaths Data*/

Select Location, date, total_cases, new_cases, total_deaths, population
From CovidDeaths
Order by Location, date

/*Identifying the Column total_deaths datatype*/
SELECT
    DATA_TYPE, 
    CHARACTER_MAXIMUM_LENGTH AS MAX_LENGTH, 
    CHARACTER_OCTET_LENGTH AS OCTET_LENGTH 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'CovidDeaths' 
AND COLUMN_NAME = 'total_deaths';

/*Trying to Convert total_deaths from varchar to numeric datatype, didn't work*/

SELECT SUM(CAST(total_deaths AS decimal(8,2))) 
FROM CovidDeaths;

/*Finding the non-numeric values*/

SELECT total_deaths
FROM CovidDeaths
WHERE ISNUMERIC(total_deaths) <> 1;

/*Converting the Data total_deaths Data Type from nvarchar to int*/

ALTER TABLE CovidDeaths
    ALTER COLUMN total_deaths int;
GO

/*Converting the Data total_cases Data Type from nvarchar to int*/
ALTER TABLE CovidDeaths
    ALTER COLUMN total_cases int;
GO

/*Death Percentage*/

Select Location, date, total_cases, total_deaths,(total_deaths * 1.0/total_cases) * 100  as DeathPercentage
From CovidDeaths
Where Location = 'Kenya'
Order by 1,2

/*Total Cases vs Population */
/*Percent of Population Infected*/

Select Location, date, total_cases, population,(total_cases * 1.0/population) * 100  as PercentPopInfected
From CovidDeaths
Where Location = 'Kenya'
Order by 1,2

/*Returns The Countries with the highest infection rates in Descending Order*/

Select Location, MAX(total_cases * 1.0/population) * 100  as PercentPopInfected
From CovidDeaths
Group by Location
Order by 2 Desc;

/* Countries with the Highest Death Count Per Population*/

Select Location, Population, Max(total_deaths) as HighestTotDeaths, Max((total_deaths*1.0/population))*100 as HighPopDeathRate
from CovidDeaths
where continent is not null
Group by Location, Population
Order by HighPopDeathRate Desc;


/*Let's look at the continent*/

Select continent, Max(total_deaths) as HighestTotDeaths, Max((total_deaths*1.0/population))*100 as HighPopDeathRate
from CovidDeaths
where continent is not null
Group by continent
Order by continent

/*Global Data*/
ALTER TABLE CovidDeaths
    ALTER COLUMN new_cases int;
GO

ALTER TABLE CovidDeaths
    ALTER COLUMN new_cases int;
GO

Select date, sum(new_cases) as totalnewcases, sum(new_deaths) as totalnewdeaths, (sum(new_deaths)*1.0/sum(total_deaths))*100 as totalnewdeathrate 
from CovidDeaths
where continent is not null
Group by date
order by 1,2

Select sum(new_cases) as totalnewcases, sum(new_deaths) as totalnewdeaths 
from CovidDeaths
where continent is not null
order by 1,2

/*Joining CovidDeaths and CovidVaccinations Tables Together*/

Select*
From CovidDeaths dea
join CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date

/*Looking at Total Population vs Vaccinations in the World*/
ALTER TABLE CovidVaccinations
    ALTER COLUMN total_vaccinations BIGInt;
GO

ALTER TABLE CovidDeaths
    ALTER COLUMN population BIGInt;
GO

Select sum(population) totpop, sum(total_vaccinations)totvaccinations
From CovidDeaths dea
join CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date

/*Looking at Total population vs Vaccinations by Location and using new_vaccinations*/
/*Also Creating a View*/
ALTER TABLE CovidVaccinations
    ALTER COLUMN new_vaccinations BigInt;
GO

Create view TotalVaccinationsbyCountry as
Select dea.continent,dea.location, dea.date, dea.population,vac.new_vaccinations, sum(new_vaccinations) Over (Partition by dea.location Order by dea.location,dea.date) as TotalVaccinationsbyCountry
from CovidDeaths dea
join CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
Order by 2,3


