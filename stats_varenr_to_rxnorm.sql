-- Number of atc codes missing
select count(distinct vnr) from _varenr_to_concept_id where atccode is null;
-- Number of ingredient concept ids missing (where atc code available)
select count(distinct vnr) from _varenr_to_concept_id where atccode is not null and ingredient_concept_id is null;
-- Total number of non mapped codes.
select count(distinct vnr) from _varenr_to_concept_id where ingredient_concept_id is null;
-- Total number of varenr drugs
select count(*) from auh_frequencies;

-- Occurance of drugs found.
select sum(fr)
from (
    select avg(frequency) as fr
    from _varenr_to_concept_id
    where atccode is not null and ingredient_concept_id is not null
    group by vnr
    ) foo;
-- Total occurance
select sum(frequency) from auh_frequencies;
