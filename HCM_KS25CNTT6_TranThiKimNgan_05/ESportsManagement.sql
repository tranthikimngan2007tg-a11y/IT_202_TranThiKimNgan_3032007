CREATE DATABASE ESportsManagement;
USE ESportsManagement;

CREATE TABLE team (
	team_code VARCHAR(100) PRIMARY KEY,
    team_name VARCHAR(150) NOT NULL,
    country VARCHAR(150) NOT NULL,
    owners VARCHAR(150) NOT NULL,
    founding_year YEAR DEFAULT 2026
);
ALTER TABLE team
MODIFY owners VARCHAR(150) NULL;

CREATE TABLE player (
	player_id VARCHAR(100) PRIMARY KEY,
    fullname VARCHAR(150) NOT NULL,
    nickname VARCHAR(150) NOT NULL,
    playing_position VARCHAR(150) NOT NULL,
    salary DECIMAL (15, 2),
    team_code VARCHAR(100),
	match_id VARCHAR(100),
    CONSTRAINT FOREIGN KEY (team_code) REFERENCES team(team_code),
    CONSTRAINT FOREIGN KEY (match_id) REFERENCES matchs(match_id)
);

DROP TABLE phayer;

CREATE TABLE matchs (
	match_id VARCHAR(100) PRIMARY KEY,
    start_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    result VARCHAR(150) NOT NULL
);

CREATE TABLE match_statistic (
	match_statistic_id INT AUTO_INCREMENT PRIMARY KEY,
    kills INT DEFAULT 0,
    deaths INT DEFAULT 0,
    assists INT DEFAULT 0,
    match_id VARCHAR(100),
    player_id VARCHAR(100),
    CONSTRAINT FOREIGN KEY (match_id) REFERENCES matchs(match_id),
    CONSTRAINT FOREIGN KEY (player_id) REFERENCES player(player_id)
);
ALTER TABLE matchs 
ADD COLUMN award DECIMAL(15, 2);

ALTER TABLE team
RENAME COLUMN country TO area;

DROP TABLE match_statistic;
DROP TABLE matchs;

INSERT INTO team VALUES 
('MD001', 'D1', 'VN', 'Chủ sở hữu 1', 2025),
('MD002', 'D2', 'HQ', 'Chủ sở hữu 2', 2022),
('MD003', 'D3', 'TQ', 'Chủ sở hữu 3', 2023),
('MD004', 'D4', 'NB', 'Chủ sở hữu 4', 2024),
('MD005', 'D5', 'TL', 'Chủ sở hữu 5', 2007);
INSERT INTO team VALUES 
('MD008', 'D8', 'VN', '', 2007);

INSERT INTO player VALUES
('PL001', 'Trần Văn A', 'Sĩ Vương', 'Đi Rừng', 20000000,'MD001','MS_007'),
('PL002', 'Nguyễn Thị B', 'cá', 'Đi Top', 20000000,'MD002','MS_007'),
('PL003', 'Lê Văn C', 'lê', 'Đi Mid', 20000000, 'MD001','MS_001'),
('PL004', 'Lý Thị D', 'gà', 'Đi Ad', 20000000, 'MD003','MS_003'),
('PL005', 'Huỳnh Văn E', 'pig', 'Sp', 20000000, 'MD003','MS_004');

INSERT INTO matchs VALUES 
('MS_007','2026-05-03 14:09:00', 'Thắng 1-0',1500000),
('MS_001','2026-05-02 10:00:00', 'Thắng 2-1',1500000),
('MS_003','2026-05-01 08:00:00', 'Thua 0-1',1500000),
('MS_004','2026-05-04 02:00:00' , 'Thắng 1-0',1500000),
('MS_005','2026-05-02 05:00:00', 'Thắng 1-0',1500000);

UPDATE player SET salary = salary * 1.2 WHERE playing_position = 'Đi Rừng';

DELETE FROM team 
WHERE owners IS NULL;

SELECT * FROM player WHERE salary BETWEEN 50000000 AND 150000000;

SELECT nickname, playing_position
FROM player WHERE team_code IN (
	SELECT team_code  FROM team WHERE area ='VN'
);