-- Number of atc codes missing
select 'ATC missing', count(distinct vnr), sum(frequency) as frequency
from map.varenr_to_ingredient
where atccode is null;
-- Number of ingredient concept ids missing (where atc code available)
select 'RxNorm missing', count(distinct vnr), sum(frequency) as frequency
from map.varenr_to_ingredient
where atccode is not null and ingredient_concept_id is null;
-- Total number of mapped codes (succes).
select 'Total succes', count(distinct vnr), sum(frequency) as frequency
from map.varenr_to_ingredient
where ingredient_concept_id is not null;
-- Total number of varenr drugs
select 'Total', count(*), sum(frequency) as frequency
from auh.frequencies;

/*
-- Atc codes missing based on frequency
select sum(fr)
from (
    select avg(frequency) as fr
    from map.varenr_to_ingredient
    where atccode is null
    group by vnr
    ) foo;

-- RxNorm mapped based on frequency
select sum(fr)
from (
    select avg(frequency) as fr
    from map.varenr_to_ingredient
    where ingredient_concept_id is not null
    group by vnr
    ) foo;

-- Total frequency
select sum(frequency) from auh.frequencies;





-- Extra stats with cumulative frequency
-- 23-03-2016 ONLY INTERESTING FOR MANUAL MAPPING
SELECT count(distinct _varenr_to_concept_id.vnr), sum(_varenr_to_concept_id.frequency)
FROM map.varenr_to_ingredient
INNER JOIN auh.frequencies_cum
    ON  _varenr_to_concept_id.vnr = auh.frequencies_cum.vnr
WHERE sum < 0.8 -- Cumulative frequency of varenr. Other 0.2 less interesting.
    AND atccode is null
    -- AND ingredient_concept_id is null
;
*/
