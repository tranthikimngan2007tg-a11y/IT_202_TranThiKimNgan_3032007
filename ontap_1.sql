CREATE DATABASE race_management;
USE race_management;

CREATE TABLE teams(
	team_id INT AUTO_INCREMENT PRIMARY KEY,
    team_name VARCHAR(100) NOT NULL,
    hq_country VARCHAR(50) NOT NULL,
    budget_cap DECIMAL(15, 2) NOT NULL,
    current_rank INT DEFAULT 0
);

CREATE TABLE drivers(
	driver_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    driver_number INT NOT NULL UNIQUE,
    nationality VARCHAR(50) NOT NULL,
    annual_salary DECIMAL(12, 2) NOT NULL,
    team_id INT,
    CONSTRAINT fk_teams_drivers FOREIGN KEY (team_id) REFERENCES teams(team_id)
);

CREATE TABLE constructors_championship(
	championship_id INT AUTO_INCREMENT PRIMARY KEY,
    season_year YEAR NOT NULL,
    team_id INT,
    total_points DECIMAL(5, 1) DEFAULT 0.0,
    CONSTRAINT fk_teams_constructors_championship FOREIGN KEY (team_id) REFERENCES teams(team_id)
);

CREATE TABLE races(
	race_id INT AUTO_INCREMENT PRIMARY KEY,
    race_name VARCHAR(100) NOT NULL,
    circuit_name VARCHAR(100) NOT NULL,
    race_date DATETIME NOT NULL,
    race_status VARCHAR(30) DEFAULT 'Scheduled'
);

CREATE TABLE race_results(
	result_id INT AUTO_INCREMENT PRIMARY KEY,
    driver_id INT,
    race_id INT,
    grid_position INT NOT NULL,
    finish_position INT NULL,
    points_earned DECIMAL(4, 1) DEFAULT 0.0,
    fasstest_lap_speed DECIMAL(5, 2) DEFAULT 0.00,
    CONSTRAINT fk_drivers_race_results FOREIGN KEY (driver_id) REFERENCES drivers(driver_id),
	CONSTRAINT fk_races_race_results FOREIGN KEY (race_id) REFERENCES races(race_id)
);

INSERT INTO teams VALUES
(1, 'Red Bull Racing', 'Austria', 200000000000, 1),
(2, 'Mercedes', 'Germany', 180000000000, 2),
(3, 'Ferrari', 'Italy', 180000000000, 3),
(4, 'McLaren', 'British', 120000000000, 4),
(5, 'Aston Martin', 'British', 110000000000, 5);

INSERT INTO drivers VALUES
(1, 'Max Verstappen', 1, 'Netherlands', 300000000, 1),
(2, 'Lewis Hamilton', 44, 'British', 40000000, 2),
(3, 'Charles Leclerc', 16, 'Monaco', 12000000, 3),
(4, 'Lando Norris', 4, 'British', 15000000, 4),
(5, 'Fernando Alonso', 14, 'Spain', 20000000, 5);

INSERT INTO constructors_championship VALUES
(1, 2024, 1, 600.0),
(2, 2024, 2, 520.0),
(3, 2024, 3, 500.0),
(4, 2024, 4, 350.0),
(5, 2024, 5, 300.0);

INSERT INTO races VALUES
(1, 'Bahrain Grand Prix', 'Bahrain International Circuit', '2024-03-03 15:00:00', 'Scheduled'),
(2, 'Monaco Grand Prix', 'Circuit de Monaco', '2024-05-26 14:00:00', 'Scheduled'),
(3, 'British Grand Prix', 'Silverstone Circuit', '2024-07-07 14:00:00', 'Scheduled'),
(4, 'Japanese Grand Prix', 'Suzuka Circuit', '2024-09-22 14:00:00', 'Scheduled'),
(5, 'Italian Grand Prix', 'Autodromo Nazionale Monza', '2024-09-15 14:00:00', 'Scheduled');

INSERT INTO race_results VALUES
(1, 1, 1, 1, 3, 25.0, 242.50), 
(2, 1, 2, 2, 1, 18.0, 238.00),
(3, 1, 3, 3, 2, 15.0, 235.00),
(4, 1, 4, 4, NULL, 0.0, 0.00),   
(5, 1, 5, 5, NULL, 0.0, 0.00);

UPDATE drivers
SET annual_salary = annual_salary * 1.1
WHERE team_id IN (
    SELECT team_id
    FROM teams
    WHERE hq_country = 'British'
)
AND driver_id IN (
    SELECT driver_id
    FROM race_results
    GROUP BY driver_id
    HAVING AVG(points_earned) > 15.0
);

DELETE FROM race_results
WHERE finish_position > 20;

SELECT
    full_name,
    driver_number,
    nationality
FROM drivers
WHERE annual_salary > 20000000
   OR nationality = 'Dutch';

SELECT
    team_name,
    hq_country
FROM teams
WHERE current_rank BETWEEN 1 AND 3
AND (
        hq_country LIKE 'M%'
        OR hq_country LIKE 'G%'
    );


SELECT
    race_id,
    race_name,
    race_date
FROM races
ORDER BY race_date DESC
LIMIT 2 OFFSET 2;

SELECT
    d.full_name,
    t.team_name,
    SUM(rr.points_earned) AS total_points,
    MAX(rr.fastest_lap_speed) AS highest_fastest_lap_speed

FROM drivers d

JOIN teams t
ON d.team_id = t.team_id

JOIN race_results rr
ON d.driver_id = rr.driver_id

GROUP BY d.driver_id, d.full_name, t.team_name;

SELECT
    t.team_name,
    SUM(rr.points_earned) AS total_team_points

FROM teams t

JOIN drivers d
ON t.team_id = d.team_id

JOIN race_results rr
ON d.driver_id = rr.driver_id

GROUP BY t.team_id, t.team_name

HAVING SUM(rr.points_earned) > 50;

SELECT
    driver_id,
    full_name,
    annual_salary
FROM drivers
WHERE annual_salary = (
    SELECT MAX(annual_salary)
    FROM drivers
);

CREATE INDEX idx_driver_perf
ON race_results(finish_position, points_earned);

CREATE VIEW view_team_financials AS

SELECT
    t.team_name,
    COUNT(d.driver_id) AS total_drivers,
    SUM(d.annual_salary) AS total_salary_budget

FROM teams t

JOIN drivers d
ON t.team_id = d.team_id

WHERE d.annual_salary > 0

GROUP BY t.team_id, t.team_name;

DELIMITER //

CREATE TRIGGER trg_bonus_salary
AFTER INSERT ON race_results
FOR EACH ROW

BEGIN

    IF NEW.points_earned > 25 THEN

        UPDATE drivers
        SET annual_salary = annual_salary + 50000
        WHERE driver_id = NEW.driver_id;

    END IF;

END //

DELIMITER ;

INSERT INTO races(race_name, circuit_name, race_date)
VALUES
('Test GP', 'Test Circuit', NOW());

INSERT INTO race_results
(driver_id, race_id, grid_position, finish_position, points_earned, fastest_lap_speed)
VALUES
(2, 6, 1, 1, 30.0, 246.00);

SELECT
    full_name,
    annual_salary
FROM drivers
WHERE driver_id = 2;

DELIMITER //

CREATE TRIGGER trg_update_constructor_points
AFTER UPDATE ON races
FOR EACH ROW

BEGIN

    IF NEW.race_status = 'Finished'
       AND OLD.race_status <> 'Finished' THEN

        UPDATE constructors_championship cc

        JOIN teams t
            ON cc.team_id = t.team_id

        JOIN drivers d
            ON t.team_id = d.team_id

        JOIN race_results rr
            ON d.driver_id = rr.driver_id

        SET cc.total_points = cc.total_points + 10

        WHERE rr.race_id = NEW.race_id
          AND rr.finish_position = 1;

    END IF;

END //

DELIMITER ;

SELECT * FROM view_team_financials;
UPDATE races
SET race_status = 'Finished'
WHERE race_id = 4;

SELECT *
FROM constructors_championship;