SELECT TRANSLATE('2*[3+4]/{7-2}', '[]{}', '()()');

SELECT REPLACE(REPLACE(REPLACE(REPLACE('2*[3+4]/{7-2}', '[', '('), ']', ')'), '{', '('), '}', ')');

SELECT TRANSLATE('[137.4,72.3]', '[,]', '( )') AS Point,
       TRANSLATE('(137.4 72.3)', '( )', '[,]') AS Coordinates;

SELECT TRANSLATE('abcdef', 'abc', 'bcd') AS Translated,
       REPLACE(REPLACE(REPLACE('abcdef', 'a', 'b'), 'b', 'c'), 'c', 'd') AS Replaced;
