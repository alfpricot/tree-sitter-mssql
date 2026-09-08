CREATE TABLE Person (
    ID integer PRIMARY KEY,
    name varchar(100)
) AS NODE;

CREATE TABLE likes (
    weight float
) AS EDGE;

SELECT Person1.name, Person2.name
FROM Person Person1, likes, Person Person2
WHERE MATCH(Person1-(likes)->Person2);

SELECT Person1.name, Person2.name
FROM Person Person1, likes, Person Person2
WHERE MATCH(Person2<-(likes)-Person1);

SELECT Person1.name
FROM Person Person1, likes, Person Person2
WHERE MATCH(SHORTEST_PATH(Person1-(likes)->Person2+));

CREATE TABLE reports_to (
    since date
) AS EDGE;

SELECT Person1.name, Person2.name
FROM Person Person1, likes, reports_to, Person Person2
WHERE MATCH(Person1-(likes|reports_to)->Person2);
