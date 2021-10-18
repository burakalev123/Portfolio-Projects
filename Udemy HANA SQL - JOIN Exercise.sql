-- List instructors who are also registered as a student. (ID and NAME)
SELECT DISTINCT 
	INS.ID,
	STU.NAME
FROM 
	INSTRUCTOR AS INS
	INNER JOIN
	STUDENT AS STU
	ON INS.id = STU.id
	WHERE COURSE is NOT NULL;

    --Number of registration per course? (ID, NAME, Their Regis. Count)
SELECT 
	C.ID,
	C.NAME,
	COUNT(s.COURSE) AS "Registration Count"
FROM 
	COURSE AS C
	INNER JOIN
	STUDENT AS S
	ON C.id = s.course
GROUP BY 
	c.id,
	C.NAME;

-- Intructors who registered their own course
SELECT s.NAME
FROM 
	COURSE AS C
	INNER JOIN
	STUDENT AS S
	ON c.INSTRUCTOR = s.id
		AND c.id = s.course;

--How much payment should go to each instructor (instructor name included)?
SELECT 
	C.INSTRUCTOR AS "Instructor ID",
	I.name AS "Instructor Name",
	SUM(C.PRICE) AS "Course Price"
FROM 
	STUDENT AS S
	LEFT OUTER JOIN
	COURSE AS C
	ON s.COURSE = c.ID
	LEFT OUTER JOIN
	INSTRUCTOR AS I
	ON C.INSTRUCTOR = I.ID
WHERE s.course IS NOT NULL
GROUP BY 
	C.INSTRUCTOR,
	I.NAME;