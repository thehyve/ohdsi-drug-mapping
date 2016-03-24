/* For some stats */
CREATE VIEW auh_frequencies_cum AS
    SELECT vnr, frequency, sum(frequency/934032::float)
    OVER (ORDER BY frequency DESC)
    FROM auh_frequencies;
