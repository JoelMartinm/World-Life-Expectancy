SELECT 
    *
FROM
    world_life_expectancy.world_life_expectancy;
    
SELECT 
    Country,
    Year,
    CONCAT(Country, Year),
    COUNT(CONCAT(Country, Year))
FROM
    world_life_expectancy
GROUP BY Country , Year , CONCAT(Country, Year)
HAVING COUNT(CONCAT(Country, Year)) > 1;
    
    SELECT * FROM (
    SELECT Row_id,
    CONCAT(Country,Year),
    ROW_NUMBER() OVER(PARTITION BY CONCAT(Country,Year) ORDER BY CONCAT(Country, Year)) AS Row_NUM
    FROM world_life_expectancy
    ) AS Row_table
    WHERE Row_Num > 1;
    
    DELETE FROM world_life_expectancy
    WHERE Row_id IN ( 
    SELECT Row_id FROM (
    SELECT Row_id,
    CONCAT(Country,Year),
    ROW_NUMBER() OVER(PARTITION BY CONCAT(Country,Year) ORDER BY CONCAT(Country, Year)) AS Row_NUM
    FROM world_life_expectancy
    ) AS Row_table
    WHERE Row_Num > 1
    );
    
    SELECT DISTINCT(STATUS)
    FROM world_life_expectancy
    WHERE Status <> '';
    
	SELECT DISTINCT(COUNTRY)
    FROM world_life_expectancy
    WHERE Status = 'Developing';
    
    UPDATE world_life_expectancy
    SET Status = 'Developing'
    WHERE Country IN (SELECT DISTINCT(COUNTRY)
    FROM world_life_expectancy
    WHERE Status = 'Developing');
    
    UPDATE world_life_expectancy t1
    JOIN world_life_expectancy t2
         ON t1.Country = t2.Country
	SET t1.Status ='Developing'
    WHERE t1.status = ''
    AND t2.status <> ''
    AND t2.status ='Developing';
    
	SELECT *
    FROM world_life_expectancy
    WHERE Country = 'United States of America';
    
	UPDATE world_life_expectancy t1
    JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
	SET t1.Status ='Developed'
    WHERE t1.status = ''
    AND t2.status <> ''
    AND t2.status ='Developed';
    
    SELECT * FROM world_life_expectancy
    #WHERE `Life expectancy` ='';
	
    SELECT t1.Country, t1.Year, t1.`Life expectancy`,
    t2.Country, t2.Year, t2.`Life expectancy`,
    t3.Country, t3.Year, t3.`Life expectancy`,
    ROUND((t2.`Life expectancy` + t3.`Life expectancy`)/2,1)
    FROM world_life_expectancy t1
    JOIN world_life_expectancy t2
       ON t1.Country = t2.Country
       AND t1.YEAR = t2.Year -1 
	JOIN world_life_expectancy t3
       ON t1.Country = t3.Country
       AND t1.YEAR = t3.Year +1 
	WHERE t1.`Life expectancy` =''
    ;

UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
	AND t1.YEAR = t2.Year -1 
JOIN world_life_expectancy t3
	ON t1.Country = t3.Country
	AND t1.YEAR = t3.Year +1 
SET t1.`Life expectancy`=ROUND((t2.`Life expectancy` + t3.`Life expectancy`)/2,1)
WHERE t1.`Life expectancy` ='' ;
    