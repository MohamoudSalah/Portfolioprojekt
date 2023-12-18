Select * 
from CovidDeaths 
where continent is not null 
order by 3,4

--Select * 
--from [dbo].[CovidVaccinations]
--order by 3,4

Select location,date, total_cases, new_cases, total_deaths,population
from CovidDeaths
order by 1,2

--Total Caes VS Total Deaths 

Select location,date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathProcent
from CovidDeaths
--Where location Like 'India' 
order by DeathProcent desc



Select location,date, total_cases, total_deaths, (total_deaths/population)*100 as populationDeathProcent
from CovidDeaths
--Where location Like 'India' 
where continent is not null 
order by populationDeathProcent desc

-- countries with the highest infection rate compared to population
Select location, population, Max(total_cases)HighestInfectioncount,  Max((total_cases/population))*100 as populationinfectedProcent
from CovidDeaths
--Where location Like 'India'
where continent is not null 
group by location, population
order by populationinfectedProcent desc

-- countries with highest death count per population

Select location, max(cast(Total_deaths as int)) as TotalDeathcount
from CovidDeaths
--where location like '%state%'
where continent is not null 
group by location
order by TotalDeathcount desc


--Break down by continent

Select continent, max(cast(Total_deaths as int)) as TotalDeathcount
from CovidDeaths
--where location like '%state%'
where continent is not null 
group by continent
order by TotalDeathcount desc


Select location, max(cast(Total_deaths as int)) as TotalDeathcount
from CovidDeaths
--where location like '%state%'
where continent is null 
group by location
order by TotalDeathcount desc


--showing continent with highest deathcount
Select continent, max(cast(Total_deaths as int)) as TotalDeathcount
from CovidDeaths
--where location like '%state%'
where continent is not null 
group by continent
order by TotalDeathcount desc


--Global Numbers

Select date, sum(new_cases)as total_cases, sum(cast(new_deaths as int)) as total_deaths, 
sum(cast(new_deaths as int))/sum(new_cases)*100 as Deathpercentage
from CovidDeaths
--Where location Like 'India' 
where continent is not null 
group by date
order by 1,2

Select sum(new_cases)as total_cases, sum(cast(new_deaths as int)) as total_deaths, 
sum(cast(new_deaths as int))/sum(new_cases)*100 as Deathpercentage
from CovidDeaths
--Where location Like 'India' 
where continent is not null 
--group by date
order by 1,2

--total population vs vacciontasions

select dea.continent, dea.location, dea.date, dea.population, 
vac.new_vaccinations, sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,
dea.date) as Rollingpeoplevaccinated
from CovidDeaths dea
join CovidVaccinations vac
on dea.location =vac.location
and dea.date = vac.date
where dea.continent is not null
--where vac.new_vaccinations is not null
order by 2,3

-- use cte 
With popvsvac (continent,location,date,population, new_vaccinations,Rollingpeoplevaccinated)
as(

select dea.continent, dea.location, dea.date, dea.population, 
vac.new_vaccinations, sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,
dea.date) as Rollingpeoplevaccinated
from CovidDeaths dea
join CovidVaccinations vac
on dea.location =vac.location
and dea.date = vac.date
where dea.continent is not null
--where vac.new_vaccinations is not null
--order by 2,3
)

select * , (Rollingpeoplevaccinated/population)*100
from popvsvac


-- temp table 
drop table if exists percentpopulationvaccinated
create table percentpopulationvaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
rollingpeoplevaccinated numeric,
)
insert into percentpopulationvaccinated
select dea.continent, dea.location, dea.date, dea.population, 
vac.new_vaccinations, sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,
dea.date) as Rollingpeoplevaccinated
from CovidDeaths dea
join CovidVaccinations vac
on dea.location =vac.location
and dea.date = vac.date
--where dea.continent is not null
--where vac.new_vaccinations is not null
--order by 2,3

select * , (Rollingpeoplevaccinated/population)*100
from percentpopulationvaccinated


--creating view 
create view percentpeoplevaccinated as 
select dea.continent, dea.location, dea.date, dea.population, 
vac.new_vaccinations, sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,
dea.date) as Rollingpeoplevaccinated
from CovidDeaths dea
join CovidVaccinations vac
on dea.location =vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3


select * from percentpeoplevaccinated

create view highestdeathcontinent as   
Select continent, max(cast(Total_deaths as int)) as TotalDeathcount
from CovidDeaths
--where location like '%state%'
where continent is not null 
group by continent
--order by TotalDeathcount desc

select * from highestdeathcontinent