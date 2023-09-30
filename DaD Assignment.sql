--CREATE SCRIPTS
CREATE TABLE research_group (
    research_group_id VARCHAR(10) NOT NULL,
    group_name VARCHAR(100) NOT NULL,
    date_established DATE NOT NULL,
    research_moto VARCHAR(255) NOT NULL,
    PRIMARY KEY (research_group_id)
);

CREATE TABLE academic (
    academic_id VARCHAR(10) NOT NULL,
    academic_name VARCHAR(100) NOT NULL,
    academic_qualification VARCHAR(100) NOT NULL,
    employement_date DATE NOT NULL,
    research_group_id VARCHAR(10) NOT NULL,
    PRIMARY KEY (academic_id),
    FOREIGN KEY (research_group_id) REFERENCES research_group(research_group_id)
);

CREATE TABLE publication (
    publication_id VARCHAR(10) NOT NULL,
    publication_name VARCHAR(255) NOT NULL,
    publication_date DATE NOT NULL,
    PRIMARY KEY (publication_id)
);

CREATE TABLE authoring_link (
    academic_id VARCHAR(10) NOT NULL,
    publication_id VARCHAR(10) NOT NULL,
    PRIMARY KEY (academic_id, publication_id),
    FOREIGN KEY (academic_id) REFERENCES academic(academic_id),
    FOREIGN KEY (publication_id) REFERENCES publication(publication_id)
);

--INSERT SCRIPTS
/* Research Group Insert Script */
INSERT INTO research_group VALUES ('G1', 'Aexo Group', '30-JUL-2003', 'Software Development Research');
INSERT INTO research_group VALUES ('G2', 'Randor Group', '23-AUG-2010', 'Machine Learning Research');
INSERT INTO research_group VALUES ('G3', 'Quantum Research Group', '23-MAR-1994', 'Computer Hardware Research');

/* Academics Insert Script */
INSERT INTO academic VALUES ('A1', 'Dita Harshad', 'Ph.D.', '05-SEP-2006', 'G1');
INSERT INTO academic VALUES ('A2', 'Yahya Marcel', 'Masters', '23-NOV-1998', 'G3');
INSERT INTO academic VALUES ('A3', 'Felix Smith', 'Ph.D.', '27-JUL-2003', 'G3');
INSERT INTO academic VALUES ('A4', 'Millie Brooks', 'Bachelors', '15-MAR-2016', 'G2');
INSERT INTO academic VALUES ('A5', 'Cemile Rosemarie', 'Masters', '01-AUG-2020', 'G1');
INSERT INTO academic VALUES ('A6', 'Theo Irwin', 'Ph.D.', '08-FEB-2004', 'G1');
INSERT INTO academic VALUES ('A7', 'Russell Zarandin', 'Associate', '08-OCT-2021', 'G1');
INSERT INTO academic VALUES ('A8', 'David Johnson', 'Bachelors', '18-FEB-2013', 'G2');

/* Publications Insert Script */
INSERT INTO publication VALUES ('P1', 'The core usages of Python', '12-MAY-2012');
INSERT INTO publication VALUES ('P2', 'Fundamentals of C++', '22-APR-2005');
INSERT INTO publication VALUES ('P3', 'The future of artificial intelligence in the modern world', '04-AUG-2018');
INSERT INTO publication VALUES ('P4', 'Development of Memory Management and optimsation', '25-MAR-2015');
INSERT INTO publication VALUES ('P5', 'Optimsation of the central processing unit', '09-DEC-2008');
INSERT INTO publication VALUES ('P6', 'Search Engine Optimsation', '23-SEP-2018');
INSERT INTO publication VALUES ('P7', 'The effects of tempatures of components', '12-OCT-2014');
INSERT INTO publication VALUES ('P8', 'Downfalls of artifical intelligence', '27-DEC-2020');

/* Authoring Link Insert Script */
INSERT INTO authoring_link VALUES ('A1', 'P1'); -- The core usages of Python, Dita Harshad
INSERT INTO authoring_link VALUES ('A6', 'P1'); -- The core usages of Python, Theo Irwin
INSERT INTO authoring_link VALUES ('A1', 'P6'); -- Search Engine Optimsation, Dita Harshad
INSERT INTO authoring_link VALUES ('A3', 'P5'); -- Optimsation of the central processing unit, Felix Smith
INSERT INTO authoring_link VALUES ('A3', 'P4'); -- Development of Memory Management and optimsation, Felix Smith
INSERT INTO authoring_link VALUES ('A2', 'P4'); -- Development of Memory Management and optimsation, Yahya Marcel
INSERT INTO authoring_link VALUES ('A6', 'P2'); -- Fundamentals of C++, Theo Irwin
INSERT INTO authoring_link VALUES ('A1', 'P2'); -- Fundamentals of C++, Dita Harshad
INSERT INTO authoring_link VALUES ('A2', 'P7'); -- The effects of tempatures of components, Yahya Marcel
INSERT INTO authoring_link VALUES ('A8', 'P3'); -- The future of artificial intelligence in the modern world, David Johnson
INSERT INTO authoring_link VALUES ('A8', 'P8'); -- Downfalls of artifical intelligence, David Johnson

--SELECT SCRIPTS
/* Report List 1 */
SELECT academic_name, academic_qualification, employement_date
FROM academic;

/* Report List 2 */
SELECT academic_name, group_name, date_established, research_moto
FROM academic, research_group
WHERE academic.research_group_id = research_group.research_group_id;

/* Report List 3*/
SELECT academic_name, academic_qualification, group_name, research_moto, date_established, count(academic_name) collaborations
FROM academic, research_group, authoring_link,
    (SELECT publication_id, count(publication_id) counter
    FROM authoring_link
    GROUP BY publication_id) inner
WHERE research_group.research_group_id = academic.research_group_id
AND academic.academic_id = authoring_link.academic_id
AND authoring_link.publication_id = inner.publication_id
AND counter>1
AND academic.academic_id = 'A1'
GROUP BY (academic_name, academic_qualification, group_name, research_moto, date_established);

/* Report List 4 */
SELECT group_name, count(group_name) collaborations
FROM academic, research_group, authoring_link,
    (SELECT publication_id, count(publication_id) counter
    FROM authoring_link
    GROUP BY publication_id) inner
WHERE research_group.research_group_id = academic.research_group_id
AND academic.academic_id = authoring_link.academic_id
AND authoring_link.publication_id = inner.publication_id
AND counter>1
GROUP BY (group_name)
ORDER BY collaborations DESC
FETCH FIRST 2 ROWS ONLY;

--DROP SCRIPTS
DROP TABLE authoring_link;
DROP TABLE academic;
DROP TABLE research_group;
DROP TABLE publication;
