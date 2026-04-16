use AdventureWorksDW2019
-- age calc 

SELECT 
    DATEDIFF(YEAR, birthdate, GETDATE()) 
      - CASE 
          WHEN DATEADD(YEAR, DATEDIFF(YEAR, birthdate, GETDATE()), birthdate) > GETDATE() 
          THEN 1 ELSE 0 
        END AS age 


-- table with age calc

SELECT 
        DATEDIFF(YEAR, c.birthdate, GETDATE()) 
      - CASE 
          WHEN DATEADD(YEAR, DATEDIFF(YEAR, c.birthdate, GETDATE()), c.birthdate) > GETDATE() 
          THEN 1 ELSE 0 
        END AS age,
    c.gender,
    g.city
    
FROM DimCustomer c
JOIN DimGeography g 
    ON g.GeographyKey = c.GeographyKey
	
ORDER BY g.city, age DESC;

-- table with age calculation and rank desc

SELECT 
        DATEDIFF(YEAR, c.birthdate, GETDATE()) 
      - CASE 
          WHEN DATEADD(YEAR, DATEDIFF(YEAR, c.birthdate, GETDATE()), c.birthdate) > GETDATE() 
          THEN 1 ELSE 0 
        END AS age,
    c.gender,
    g.city,
    RANK() OVER (PARTITION BY g.city ORDER BY DATEDIFF(YEAR, c.birthdate, GETDATE()) 
      - CASE 
          WHEN DATEADD(YEAR, DATEDIFF(YEAR, c.birthdate, GETDATE()), c.birthdate) > GETDATE() 
          THEN 1 ELSE 0 
	end
	
	DESC) AS age_rank
FROM DimCustomer c
JOIN DimGeography g 
    ON g.GeographyKey = c.GeographyKey
ORDER BY g.city, age DESC;

--
--count of man/women

SELECT 
        DATEDIFF(YEAR, c.birthdate, GETDATE()) 
      - CASE 
          WHEN DATEADD(YEAR, DATEDIFF(YEAR, c.birthdate, GETDATE()), c.birthdate) > GETDATE() 
          THEN 1 ELSE 0 
        END AS age,
    c.gender,
    g.city,
    RANK() OVER (PARTITION BY g.city ORDER BY DATEDIFF(YEAR, c.birthdate, GETDATE()) 
      - CASE 
          WHEN DATEADD(YEAR, DATEDIFF(YEAR, c.birthdate, GETDATE()), c.birthdate) > GETDATE() 
          THEN 1 ELSE 0 
	end
	
	DESC) AS age_rank,
SUM(case when c.gender = 'M' then 1 else 0 End)
OVER (PARTITION BY g.city ORDER BY DATEDIFF(YEAR, c.birthdate, GETDATE()) 
      - CASE 
          WHEN DATEADD(YEAR, DATEDIFF(YEAR, c.birthdate, GETDATE()), c.birthdate) > GETDATE() 
          THEN 1 ELSE 0 
	end) as sum_M,

SUM(case when c.gender = 'F' then 1 else 0 End)
OVER (PARTITION BY g.city ORDER BY DATEDIFF(YEAR, c.birthdate, GETDATE()) 
      - CASE 
          WHEN DATEADD(YEAR, DATEDIFF(YEAR, c.birthdate, GETDATE()), c.birthdate) > GETDATE() 
          THEN 1 ELSE 0 
	end) as sum_F



FROM DimCustomer c
JOIN DimGeography g 
    ON g.GeographyKey = c.GeographyKey


ORDER BY g.city, age DESC;
----
-- age group by city and gender


with agegroup as(

SELECT g.city,
        DATEDIFF(YEAR, c.birthdate, GETDATE()) 
      - CASE 
          WHEN DATEADD(YEAR, DATEDIFF(YEAR, c.birthdate, GETDATE()), c.birthdate) > GETDATE() 
          THEN 1 ELSE 0 
        END AS age,

SUM(case when c.gender = 'M' then 1 else 0 End)
as sum_M,

SUM(case when c.gender = 'F' then 1 else 0 End)
 as sum_F


FROM DimCustomer c
JOIN DimGeography g 
    ON g.GeographyKey = c.GeographyKey

group by g.City,
DATEDIFF(YEAR, c.birthdate, GETDATE()) 
      - CASE 
          WHEN DATEADD(YEAR, DATEDIFF(YEAR, c.birthdate, GETDATE()), c.birthdate) > GETDATE() 
          THEN 1 ELSE 0 
	end
)

select city, age, sum_m, sum_f,
RANK() OVER (PARTITION BY city ORDER BY DATEDIFF(YEAR, age, GETDATE()) ) as rank_s
   
from agegroup
ORDER BY city, age DESC;



--- age range
with agegroup as(

SELECT g.city,
case when 
        DATEDIFF(YEAR, c.birthdate, GETDATE()) 
      - CASE 
          WHEN DATEADD(YEAR, DATEDIFF(YEAR, c.birthdate, GETDATE()), c.birthdate) > GETDATE() 
          THEN 1 ELSE 0 
        END AS age,

SUM(case when c.gender = 'M' then 1 else 0 End)
as sum_M,

SUM(case when c.gender = 'F' then 1 else 0 End)
 as sum_F


FROM DimCustomer c
JOIN DimGeography g 
    ON g.GeographyKey = c.GeographyKey

group by g.City,
DATEDIFF(YEAR, c.birthdate, GETDATE()) 
      - CASE 
          WHEN DATEADD(YEAR, DATEDIFF(YEAR, c.birthdate, GETDATE()), c.birthdate) > GETDATE() 
          THEN 1 ELSE 0 
	end
)

select city, age, sum_m, sum_f,
RANK() OVER (PARTITION BY city ORDER BY DATEDIFF(YEAR, age, GETDATE()) ) as rank_s
   
from agegroup
ORDER BY city, age DESC;
