CREATE OR REPLACE FUNCTION strengToDecimal(streng varchar)
    RETURNS decimal AS
$$
DECLARE
    string_digits varchar;
    n_matches integer;
    regex_decimal varchar := '\d+[,.]?\d*[.]?\d*';
    regex_ratio varchar := '1:(\d+)';
BEGIN
    /* Multiple ingredients (separated by a '+') */
    IF streng ~ '\+' THEN
        RETURN Null;
    END IF;

    /* Ratio. Assume 1:xxx. Keep last part. */
    IF streng ~ '\d:\d' THEN
        string_digits := substring(streng, regex_ratio); -- Null if no match
        RETURN CAST( string_digits AS decimal );
    END IF;

    /* Check for multiple numbers in the string */
    SELECT COUNT(*) INTO n_matches
    FROM regexp_matches( streng, regex_decimal, 'g' );

    IF n_matches != 1 AND streng !~ 'timer' THEN
        /* No numbers or two or more, return Null.
           Do continue if timer in streng, e.g. '12,5 mg/24 timer' (standarized in unit)*/
        RETURN Null;
    END IF;

    /* Two variants: percentage and concentration/units */
    IF streng ~ '%' THEN
        /* Percentage. Has '.' as decimal separator */
        string_digits := substring(streng, regex_decimal);
        string_digits := replace(string_digits, ',', '.'); -- to be sure
        RETURN CAST( string_digits AS decimal );

    ELSE
        /*Concentration. Comma as decimal separator, dot as thousand separator.
        Remove dots, replace commas by dot and cast to decimal.*/
        string_digits := substring(streng, regex_decimal);
        string_digits := replace( string_digits, '.', '' ); -- remove dots (thousand separator)
        string_digits := replace( string_digits, ',', '.' );
        RETURN string_digits::decimal;
    END IF;
END;
$$ LANGUAGE plpgsql;


/* Tests */
-- select CASE WHEN strengToDecimal('500 mg') = 500 THEN 'passed 1' ELSE '#!#FAILED#!#' END;
-- select CASE WHEN strengToDecimal('2,5 MG/ML') = 2.5 THEN 'passed 2' ELSE '#!#FAILED#!#' END;
-- select CASE WHEN strengToDecimal('1:200 WV') = 200 THEN 'passed 3' ELSE '#!#FAILED#!#' END;
-- select CASE WHEN strengToDecimal('88.4%') = 88.4 THEN 'passed 4' ELSE '#!#FAILED#!#' END;
-- select CASE WHEN strengToDecimal('0,1 mg/dosis') = 0.1 THEN 'passed 5' ELSE '#!#FAILED#!#' END;
-- select CASE WHEN strengToDecimal('300.000 IE/ml') = 300000 THEN 'passed 6' ELSE '#!#FAILED#!#' END;
-- select CASE WHEN strengToDecimal('300 IU/0,50 ml ') IS Null THEN 'passed 7' ELSE '#!#FAILED#!#' END;
-- select CASE WHEN strengToDecimal('5 Mill. IE/ml') = 5 THEN 'passed 8' ELSE '#!#FAILED#!#' END;
-- select CASE WHEN strengToDecimal('7%') = 7 THEN 'passed 9' ELSE '#!#FAILED#!#' END;
-- select CASE WHEN strengToDecimal('11.700 anti-Xa IE/ml ') = 11700 THEN 'passed 10' ELSE '#!#FAILED#!#' END;
-- select CASE WHEN strengToDecimal('150 mg/400 mg/75 mg ') IS Null THEN 'passed 11' ELSE '#!#FAILED#!#' END;
-- select CASE WHEN strengToDecimal('mg') IS Null THEN 'passed 12' ELSE '#!#FAILED#!#' END;
-- select CASE WHEN strengToDecimal('20 mg/ml + 5 mikg/ml ') IS Null THEN 'passed 13' ELSE '#!#FAILED#!#' END;
-- select CASE WHEN strengToDecimal('9,5 mg/24 timer') = 9.5 THEN 'passed 14' ELSE '#!#FAILED#!#' END;
-- select CASE WHEN strengToDecimal('1.500.000 IE  ') = 1500000 THEN 'passed 15' ELSE '#!#FAILED#!#' END;
