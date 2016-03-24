-- Number of atc codes missing
select count(distinct vnr) from _varenr_to_concept_id where atccode is null;
-- Number of ingredient concept ids missing (where atc code available)
select count(distinct vnr) from _varenr_to_concept_id where atccode is not null and ingredient_concept_id is null;
-- Total number of mapped codes (succes).
select count(distinct vnr) from _varenr_to_concept_id where ingredient_concept_id is not null;
-- Total number of varenr drugs
select count(*) from auh_frequencies;

-- Atc codes missing based on frequency
select sum(fr)
from (
    select avg(frequency) as fr
    from _varenr_to_concept_id
    where atccode is null
    group by vnr
    ) foo;

-- RxNorm mapped based on frequency
select sum(fr)
from (
    select avg(frequency) as fr
    from _varenr_to_concept_id
    where ingredient_concept_id is not null
    group by vnr
    ) foo;

-- Total frequency
select sum(frequency) from auh_frequencies;





-- Extra stats with cumulative frequency
-- 23-03-2016 ONLY INTERESTING FOR MANUAL MAPPING
SELECT count(distinct _varenr_to_concept_id.vnr), sum(_varenr_to_concept_id.frequency)
FROM _varenr_to_concept_id
INNER JOIN auh_frequencies_cum
    ON  _varenr_to_concept_id.vnr = auh_frequencies_cum.vnr
WHERE sum < 0.8 -- Cumulative frequency of varenr. Other 0.2 less interesting.
    AND atccode is null
    -- AND ingredient_concept_id is null
;
