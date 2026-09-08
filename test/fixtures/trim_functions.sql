SELECT TRIM('     test    ') AS Result;

SELECT LTRIM('     Five spaces are at the beginning of this string.');

DECLARE @string_to_trim VARCHAR(60);
SET @string_to_trim = '     Five spaces are at the beginning of this string.';
SELECT @string_to_trim AS [Original string],
       LTRIM(@string_to_trim) AS [Without spaces];
GO

SELECT LTRIM('123abc.', '123.');

SELECT RTRIM('Removes trailing spaces.   ');

DECLARE @string_to_trim VARCHAR(60);
SET @string_to_trim = 'Four spaces are after the period in this sentence.    ';
SELECT @string_to_trim + ' Next string.';
SELECT RTRIM(@string_to_trim) + ' Next string.';
GO

SELECT RTRIM('.123abc.', 'abc.');

SELECT TRIM('.,! ' FROM '     #     test    .') AS Result;

SELECT TRIM(LEADING '.,! ' FROM '     .#     test    .') AS Result;

SELECT TRIM(TRAILING '.,! ' FROM '     .#     test    .') AS Result;

SELECT TRIM(BOTH '123' FROM '123abc123') AS Result;
