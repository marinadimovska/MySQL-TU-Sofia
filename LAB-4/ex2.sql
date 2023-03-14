USE school_sport_clubs;
SELECT firstpl.name as firstPlayer, secondpl.name as secondPlayer, sports.name as sportName
FROM students as firstpl JOIN students as secondpl
ON firstpl.id > secondpl.id 
JOIN sports ON (
		secondpl.id IN(
		SELECT student_id 
                FROM student_sport
		WHERE sportGroup_id IN(
		SELECT id 
                FROM sportgroups
		WHERE sport_id = sports.id
		) 
		)	
AND (firstPl.id IN( SELECT student_id 
FROM student_sport
WHERE sportGroup_id IN(
SELECT id 
FROM sportgroups							WHERE sport_id = sports.id							) 
				)
    )
)
WHERE firstPL.id IN(
	  SELECT student_id
	  FROM student_sport
	  WHERE sportGroup_id IN(
			SELECT sportGroup_id
			FROM student_sport
			WHERE student_id = secondPl.id
		)
)
ORDER BY sportName;
