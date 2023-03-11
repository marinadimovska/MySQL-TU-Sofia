use school_sport_clubs;


SELECT students.name, students.class, sportgroups.id
 FROM students JOIN sportgroups
 ON students.id IN (
	SELECT student_id
	FROM student_sport
	WHERE student_sport.sportGroup_id = sportgroups.id
 )
 WHERE sportgroups.id IN(
	SELECT sportgroup_id
    FROM student_sport
    WHERE sportGroup_id IN(
		SELECT id
		FROM sportgroups
		WHERE dayOfWeek = 'Monday'
		AND hourOfTraining = '08:00:00'
		AND coach_id IN(
			SELECT id
			FROM coaches
			WHERE name = 'Иван Тодоров Петров'
		)
        AND sport_id =(
			SELECT id
			FROM sports
            WHERE name = 'Football'
		)
    )
 );
