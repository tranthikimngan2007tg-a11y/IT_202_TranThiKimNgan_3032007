CREATE DATABASE dbt_football_player_management_system;
USE dbt_football_player_management_system;
DROP DATABASE dbt_football_player_management_system;

CREATE TABLE teams(
	team_id INT AUTO_INCREMENT PRIMARY KEY,
    team_name VARCHAR(100) NOT NULL,
    founded_year YEAR NOT NULL, -- CHECK (founded_year < YEAR(CURRENT_DATE)) bị lỗi ràng buộc
    stadium VARCHAR(100) NOT NULL,
    ranking_position INT DEFAULT 0
);

CREATE TABLE coaches(
	coach_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    nationality VARCHAR(50) NOT NULL,
    experience_years INT DEFAULT 0,
    team_id INT,
    FOREIGN KEY (team_id) REFERENCES teams(team_id)
);

CREATE TABLE players(
	player_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    jersey_number INT NOT NULL,
    position VARCHAR(50) NOT NULL,
    salary DECIMAL(12, 2) NOT NULL,
    team_id INT,
    FOREIGN KEY (team_id) REFERENCES teams(team_id)
);

CREATE TABLE matches(
	match_id INT AUTO_INCREMENT PRIMARY KEY,
    home_team_id INT,
    away_team_id INT,
    match_date DATETIME NOT NULL,
    stadium VARCHAR(100) NOT NULL,
    match_status VARCHAR(30) DEFAULT 'Scheduled',
    FOREIGN KEY (home_team_id) REFERENCES teams(team_id),
    FOREIGN KEY (away_team_id) REFERENCES teams(team_id)
);

CREATE TABLE player_statistics(
	stat_id INT AUTO_INCREMENT PRIMARY KEY,
    player_id INT,
    match_id INT,
    goals INT DEFAULT 0,
	assists INT DEFAULT 0,
    yellow_cards INT DEFAULT 0,
    rating_score DECIMAL(3, 1) DEFAULT 0,
    FOREIGN KEY (player_id) REFERENCES players(player_id),
    FOREIGN KEY (match_id) REFERENCES matches(match_id)
);

INSERT INTO teams VALUES
(1, 'Manchester City', '1901', 'Etihad Stadium', 1),
(2, 'Real Madrid', '1902', 'Santiago Bernabeu', 2),
(3, 'Hanoi FC', '2006', 'Hang Day Stadium', 3),
(4, 'Saigon United', '2015', 'Thong Nhat Stadium', 5),
(5, 'Thép xanh Nam Định', '1979', 'Thiên Trường Stadium', 10);

INSERT INTO coaches VALUES
(1, 'Pep Guardiola', 'Spanish', 15, 1),
(2, 'Carlo Anceloti', 'Italian', 25, 2),
(3, 'Chu Đình Nghiêm', 'Vietnamese', 12, 3),
(4, 'Alexandre Polking', 'German-Brazilian', 10, 4),
(5, 'Park Hang-seo', 'Korean', 30, 5);

INSERT INTO players VALUES
(1, 'Erling Haaland', 9, 'Forward', 450000000, 1),
(2, 'Kevin De Bruyne', 17, 'Midfielder', 400000000, 1),
(3, 'Nguyễn Quang Hải', 19, 'Midfielder', 60000000, 3),
(4, 'Kylian Mbappe', 7, 'Forward', 500000000, 2),
(5, 'Nguyễn Văn Quyết', 10, 'Forward', 55000000, 3);

INSERT INTO matches VALUES
(1, 1, 2, '2026-05-10 19:00:00', 'Etihad Stadium', 'Finished'),
(2, 3, 4, '2026-05-12 18:30:00', 'Hang Day Stadium', 'Finished'),
(3, 5, 1, '2026-05-15 20:00:00', 'Thiên Trường Stadium', 'Scheduled'),
(4, 2, 3, '2026-05-20 21:00:00', 'Santiago Bernabeu', 'Scheduled'),
(5, 4, 5, '2026-05-25 17:00:00', 'Thong Nhat Stadium', 'Finished');

INSERT INTO player_statistics VALUES
(1, 1, 1, 2, 1, 0, 9.5),
(2, 4, 1, 1, 0, 1, 8.2),
(3, 3, 2, 0, 2, 0, 8.5),
(4, 5, 2, 3, 0, 0, 9.0),
(5, 1, 4, 0, 0, 3, 5.0);

UPDATE players 
SET salary = salary * 1.15
WHERE position = 'Forward' AND (player_id IN (SELECT player_id FROM player_statistics WHERE rating_score > 8.0));

DELETE 
FROM player_statistics
WHERE yellow_cards > 2;

SELECT full_name,jersey_number,position
FROM players
WHERE salary > 50000000 OR position = 'Midfielder';

SELECT team_name,stadium
FROM teams
WHERE (ranking_position BETWEEN 1 AND 5) AND stadium LIKE 'S%' ;

SELECT match_id,stadium,match_date
FROM matches
ORDER BY match_date DESC
LIMIT 3 OFFSET 2;

SELECT full_name, team_name, goals,assists
FROM players AS pl
INNER JOIN teams AS t
ON pl.team_id = t.team_id
INNER JOIN player_statistics AS ps
ON pl.player_id = ps.player_id;

SELECT team_name, SUM(goals) AS 'Tổng bàn thắng'
FROM teams AS t
INNER JOIN players AS pl 
ON pl.team_id = t.team_id
INNER JOIN player_statistics AS ps
ON pl.player_id = ps.player_id
GROUP BY team_name
HAVING SUM(goals) > 10;

SELECT player_id,full_name,salary
FROM players
WHERE salary = (SELECT MAX(salary) FROM players);

CREATE INDEX ON idx_players (position,salary);

CREATE VIEW view_team_information AS 
SELECT team_name, COUNT(player_id) AS 'tổng số cầu thủ', SUM(salary) AS 'tổng quỹ lương của đội'
FROM teams AS t
INNER JOIN players AS p
ON t.team_id = p.team_id
WHERE salary <> 0
GROUP BY team_name;

SELECT *
FROM view_team_information;

DILIMITER //

CREATE TRIGGER trigger_after_insert_player_statistics
AFTER INSERT ON player_statistics
FOR EACH ROW
BEGIN
	IF NEW.goals > 10 THEN
    UPDATE players SET salary = salary * 1.05 WHERE player_id = NEW.player_id
    
END //

DELIMITER ;

INSERT INTO player_statistics VALUES
(null, 1, 1, 11, 2, 0, 9.5)