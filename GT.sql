select*
from portfolio..globalterrorism
where  country= 'United States' and city = 'New York City' and gname = 'Al-Qaida'

alter table globalterrorism
drop column country,region,attacktype1,attacktype2,attacktype3,targtype1,targsubtype1,natlty1,targtype2,targsubtype2,natlty2,targtype3,targsubtype3,natlty3,weapsubtype1,weaptype1,weaptype2,weapsubtype2

select*
from portfolio..globalterrorism
exec sp_rename'globalterrorism.country_txt', 'country'
    exec   sp_rename'globalterrorism.region_txt', 'region'
	
alter table portfolio..globalterrorism
drop column approxdate,resolution,specificity,vicinity,crit1,crit2,crit3,doubtterr,alternative,claimmode,claimmode2,claimmode3

select distinct (country),
       count(country) as Timescountryaffected
from portfolio..globalterrorism
group by country

select distinct (region),
       count(region) as Timesregionaffected
from portfolio..globalterrorism
group by region

--successful attempts
select country,region,provstate,city, count(success) as notfail
 from portfolio..globalterrorism
 where success = '1'
 group by country,region,provstate,city


 --failed attempts
 select country,region,provstate,city, count(success) as fail
 from portfolio..globalterrorism
 where success = '0'
 group by country,region,provstate,city


select*
from portfolio..globalterrorism
exec sp_rename'globalterrorism.attacktype1_txt','attacktype'
    exec   sp_rename'globalterrorism.weaptype1_txt', 'weaptype'


	select sum(nkill) as totalkills,Country,city, attacktype1_txt,gname,weaptype1_txt,iyear,imonth,iday,count(*)
from portfolio..globalterrorism
group by country,city,attacktype1_txt,gname,weaptype1_txt,iyear,imonth,iday
having count(*) > 1
order by totalkills desc

With dupCTE as(select Country,city, attacktype1_txt,gname,weaptype1_txt,iyear,imonth,iday,
ROW_NUMBER() over(partition by Country,city, attacktype1_txt,gname,weaptype1_txt,iyear,imonth,iday order by country) as dupcount
from portfolio..globalterrorism )

delete from dupCTE where dupcount >1

alter table portfolio..globalterrorism
add datess varchar(25);

select nkill,Country,city, attacktype1_txt,gname,weaptype1_txt,iyear,imonth,iday 
from portfolio..globalterrorism
group by country,city,attacktype1_txt,gname,weaptype1_txt,iyear,imonth,iday,nkill
order by nkill desc

concat( iday,'.', imonth, '.', iyear) as dates

update portfolio..globalterrorism
set datess =concat( iday,'.', imonth, '.', iyear)

alter table portfolio..globalterrorism
drop column related, dates

alter table portfolio..globalterrorism
alter column datess date
go

select cast(datess as bigint),
from portfolio..globalterrorism

select format(datess(), 'dd.mm.yy');

select convert(varchar(25), datess(),4);
from portfolio..globalterrorism