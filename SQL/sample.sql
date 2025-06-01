-- 1. User Upcoming Events
SELECT e.title, e.city, e.start_date, e.end_date
FROM Events e
JOIN Registrations r ON e.event_id = r.event_id
JOIN Users u ON r.user_id = u.user_id
WHERE e.status = 'upcoming' AND u.city = e.city
ORDER BY e.start_date;

-- 2. Top Rated Events
SELECT e.title, AVG(f.rating) AS avg_rating
FROM Feedback f
JOIN Events e ON f.event_id = e.event_id
GROUP BY e.event_id
HAVING COUNT(f.feedback_id) >= 10
ORDER BY avg_rating DESC;

-- 3. Inactive Users
SELECT u.full_name, u.email
FROM Users u
LEFT JOIN Registrations r ON u.user_id = r.user_id
WHERE r.registration_date IS NULL OR r.registration_date < CURDATE() - INTERVAL 90 DAY;

-- 4. Peak Session Hours
SELECT event_id, COUNT(*) AS session_count
FROM Sessions
WHERE HOUR(start_time) BETWEEN 10 AND 12
GROUP BY event_id;

-- 5. Most Active Cities
SELECT city, COUNT(DISTINCT user_id) AS total_users
FROM Users
JOIN Registrations ON Users.user_id = Registrations.user_id
GROUP BY city
ORDER BY total_users DESC
LIMIT 5;

-- 6. Event Resource Summary
SELECT event_id, 
       COUNT(CASE WHEN resource_type = 'pdf' THEN 1 END) AS pdf_count,
       COUNT(CASE WHEN resource_type = 'image' THEN 1 END) AS image_count,
       COUNT(CASE WHEN resource_type = 'link' THEN 1 END) AS link_count
FROM Resources
GROUP BY event_id;

-- 7. Low Feedback Alerts
SELECT u.full_name, f.rating, f.comments, e.title
FROM Feedback f
JOIN Users u ON f.user_id = u.user_id
JOIN Events e ON f.event_id = e.event_id
WHERE f.rating < 3;

-- 8. Sessions per Upcoming Event
SELECT e.title, COUNT(s.session_id) AS total_sessions
FROM Events e
LEFT JOIN Sessions s ON e.event_id = s.event_id
WHERE e.status = 'upcoming'
GROUP BY e.event_id;

-- 9. Organizer Event Summary
SELECT organizer_id, COUNT(event_id) AS total_events,
       COUNT(CASE WHEN status = 'upcoming' THEN 1 END) AS upcoming_events,
       COUNT(CASE WHEN status = 'completed' THEN 1 END) AS completed_events,
       COUNT(CASE WHEN status = 'cancelled' THEN 1 END) AS cancelled_events
FROM Events
GROUP BY organizer_id;

-- 10. Feedback Gap
SELECT e.title
FROM Events e
LEFT JOIN Feedback f ON e.event_id = f.event_id
WHERE f.feedback_id IS NULL;

-- 11. Daily New User Count
SELECT registration_date, COUNT(*) AS new_users
FROM Users
WHERE registration_date >= CURDATE() - INTERVAL 7 DAY
GROUP BY registration_date;

-- 12. Event with Maximum Sessions
SELECT event_id, COUNT(session_id) AS total_sessions
FROM Sessions
GROUP BY event_id
ORDER BY total_sessions DESC
LIMIT 1;

-- 13. Average Rating per City
SELECT e.city, AVG(f.rating) AS avg_rating
FROM Feedback f
JOIN Events e ON f.event_id = e.event_id
GROUP BY e.city;

-- 14. Most Registered Events
SELECT event_id, COUNT(user_id) AS total_registrations
FROM Registrations
GROUP BY event_id
ORDER BY total_registrations DESC
LIMIT 3;

-- 15. Event Session Time Conflict
SELECT s1.event_id, s1.title, s2.title
FROM Sessions s1
JOIN Sessions s2 ON s1.event_id = s2.event_id
WHERE s1.start_time < s2.end_time AND s2.start_time < s1.end_time AND s1.session_id <> s2.session_id;

-- 16. Unregistered Active Users
SELECT full_name, email
FROM Users
WHERE registration_date >= CURDATE() - INTERVAL 30 DAY
AND user_id NOT IN (SELECT user_id FROM Registrations);

-- 17. Multi-Session Speakers
SELECT speaker_name, COUNT(session_id) AS total_sessions
FROM Sessions
GROUP BY speaker_name
HAVING total_sessions > 1;

-- 18. Resource Availability Check
SELECT e.title
FROM Events e
LEFT JOIN Resources r ON e.event_id = r.event_id
WHERE r.resource_id IS NULL;

-- 19. Completed Events with Feedback Summary
SELECT e.title, COUNT(r.user_id) AS total_registrations, AVG(f.rating) AS avg_rating
FROM Events e
LEFT JOIN Registrations r ON e.event_id = r.event_id
LEFT JOIN Feedback f ON e.event_id = f.event_id
WHERE e.status = 'completed'
GROUP BY e.event_id;

-- 20. User Engagement Index
SELECT u.full_name, COUNT(r.event_id) AS total_attended, COUNT(f.feedback_id) AS total_feedbacks
FROM Users u
LEFT JOIN Registrations r ON u.user_id = r.user_id
LEFT JOIN Feedback f ON u.user_id = f.user_id
GROUP BY u.user_id;

-- 21. Top Feedback Providers
SELECT user_id, COUNT(feedback_id) AS total_feedbacks
FROM Feedback
GROUP BY user_id
ORDER BY total_feedbacks DESC
LIMIT 5;

-- 22. Duplicate Registrations Check
SELECT user_id, event_id, COUNT(*) AS duplicate_count
FROM Registrations
GROUP BY user_id, event_id
HAVING duplicate_count > 1;

-- 23. Registration Trends
SELECT YEAR(registration_date) AS year, MONTH(registration_date) AS month, COUNT(*) AS total_registrations
FROM Registrations
WHERE registration_date >= CURDATE() - INTERVAL 12 MONTH
GROUP BY year, month
ORDER BY year DESC, month DESC;

-- 24. Average Session Duration per Event
SELECT event_id, AVG(TIMESTAMPDIFF(MINUTE, start_time, end_time)) AS avg_duration
FROM Sessions
GROUP BY event_id;

-- 25. Events Without Sessions
SELECT e.title
FROM Events e
LEFT JOIN Sessions s ON e.event_id = s.event_id
WHERE s.session_id IS NULL;
