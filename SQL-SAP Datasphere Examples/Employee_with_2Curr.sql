SELECT
    userId,
    COUNT(DISTINCT currencyCode) AS NumCurrencyCodes
FROM
    DOE_C_EmpPayCompRecurring_Prepared
GROUP BY
    userId
HAVING
    COUNT(DISTINCT currencyCode) > 1