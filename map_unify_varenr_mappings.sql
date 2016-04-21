/* Combine four mappings (in this order):
    - Clinical drug
    - Clinical Drug Component
    - Clinical Drug Form
    - Ingredient
    - Everything that is not mapped
*/
SELECT *
INTO map.varenr_mapping
FROM (
    SELECT *
    FROM map.varenr_to_clinical_drug

    UNION ALL

        SELECT *
        FROM map.varenr_to_component
        WHERE vnr NOT IN (SELECT vnr FROM map.varenr_to_clinical_drug )

    UNION ALL

        SELECT *
        FROM map.varenr_to_drug_form
        WHERE vnr NOT IN (SELECT vnr FROM map.varenr_to_clinical_drug
                    UNION SELECT vnr FROM map.varenr_to_component)

    UNION ALL

        SELECT map.varenr_to_ingredient.vnr,
            ingredient_concept_id,
            CASE WHEN ingredient_concept_id IS NULL
            THEN 'Not Mapped*'
            ELSE 'Ingredient' END,
            -- AS concept_class_id,
            auh.products.pname, frequency,
            auh.products.strnum,auh.products.strunut,
            auh.products.dosf_lt, -- 20-04-2016: always include dosf_lt
            -- CASE WHEN ingredient_concept_id IS NULL
            -- THEN auh.products.atc
            -- ELSE auh.products.dosf_lt END,
            ingredient_concept_name
        FROM map.varenr_to_ingredient
        JOIN auh.products
            ON map.varenr_to_ingredient.vnr = auh.products.vnr
        WHERE map.varenr_to_ingredient.vnr NOT IN (
                          SELECT vnr FROM map.varenr_to_clinical_drug
                    UNION SELECT vnr FROM map.varenr_to_component
                    UNION SELECT vnr FROM map.varenr_to_drug_form)
            -- AND ingredient_concept_id IS NOT NULL -- in varenr to ingredient zitten ook de niet gemapde.

) U
ORDER BY vnr
-- GROUP BY concept_class_id
;
