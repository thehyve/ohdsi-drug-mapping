/* Combine four mappings (in this order):
    - Clinical drug
    - Clinical Drug Component
    - Clinical Drug Form
    - Ingredient
    - Everything else
*/
SELECT *
INTO _varenr_mapping
FROM (
    SELECT *
    FROM _varenr_to_clinical_drug

    UNION ALL

        SELECT *
        FROM _varenr_to_component
        WHERE vnr NOT IN (SELECT vnr FROM _varenr_to_clinical_drug )

    UNION ALL

        SELECT *
        FROM _varenr_to_drug_form
        WHERE vnr NOT IN (SELECT vnr FROM _varenr_to_clinical_drug
                    UNION SELECT vnr FROM _varenr_to_component)

    UNION ALL

        SELECT _varenr_to_ingredient.vnr,
            ingredient_concept_id, ingredient_concept_id, -- ingredient = drug_id
            CASE WHEN ingredient_concept_id IS NULL
            THEN '*Not Mapped*'
            ELSE 'Ingredient' END,
            -- AS concept_class_id,
            danish_name, frequency,
            auh_products.strnum,auh_products.strunut,
            CASE WHEN ingredient_concept_id IS NULL
            THEN auh_products.atc
            ELSE auh_products.dosf_lt END,
            ingredient_concept_name
        FROM _varenr_to_ingredient
        JOIN auh_products
            ON _varenr_to_ingredient.vnr = auh_products.vnr
        WHERE _varenr_to_ingredient.vnr NOT IN (SELECT vnr FROM _varenr_to_clinical_drug
                    UNION SELECT vnr FROM _varenr_to_component
                    UNION SELECT vnr FROM _varenr_to_drug_form)
            -- AND ingredient_concept_id IS NOT NULL -- in varenr to ingredient zitten ook de niet gemapde.

) U
ORDER BY vnr
-- GROUP BY concept_class_id
;
