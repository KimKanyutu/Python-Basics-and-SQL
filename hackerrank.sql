SELECT submission_date,
       (SELECT COUNT(DISTINCT hacker_id) AS nunique_hacker_id 
        FROM Submissions
        WHERE Submissions.submission_date = Hackers.submission_date
        AND 
        (SELECT COUNT(DISTINCT nunique_hacker_id.submission_date)
             FROM   submissions
             WHERE  nunique_hacker_id.hacker_id = Hackers.hacker_id
             AND nunique_hacker_id.submission_date < Submissions.submission_date
	    ) = Datediff(Submissions.submission_date, '2016-03-01')
       ) AS nunique_hackers,
       (SELECT hacker_id 
        FROM submissions S2
        WHERE  Submissions.submission_date = Hackers.submission_date
        GROUP  BY hacker_id
        ORDER  BY COUNT(submission_id) DESC, hacker_id ASC LIMIT  1
       ) AS max_sub_hacker_id,
       (SELECT name FROM hackers
        WHERE  hacker_id = max_sub_hacker_id
       ) AS NAME
FROM   (SELECT DISTINCT submission_date FROM submissions) Submissions
GROUP BY submission_date;