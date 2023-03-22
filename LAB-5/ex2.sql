use school_sport_clubs;    
#4 Определете двойки ученици
create view StudentCouples as
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
FROM sportgroups WHERE sport_id = sports.id							) 
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
            AND sports.name='Football'
		)
)
ORDER BY sportName;
#5. Изведете имената на учениците, класовете им, местата на тренировки и
#името на треньорите за тези ученици, чийто тренировки започват в 8.00 часа. 

create view TrainingIn8oclock as
SELECT students.name as StudentName,students.class as Class,sg.location as Location,c.name as Coach
FROM students JOIN student_sport as ss ON students.id=ss.student_id
			  JOIN sportgroups as sg ON ss.sportGroup_id=sg.id
              JOIN coaches as c ON sg.coach_id=c.id
              JOIN sports sp ON sg.sport_id=sp.id
              WHERE sg.hourOfTraining='8:00';

#6. Изведете имената на всеки спорт и броя ученици, които тренират
SELECT s.name AS SportName, COUNT(st.id) AS CountOfStudents
FROM sports s
LEFT JOIN sportGroups sg ON sg.sport_id = s.id
LEFT JOIN student_sport ss ON ss.sportGroup_id = sg.id
LEFT JOIN students st ON st.id = ss.student_id
GROUP BY s.name;



