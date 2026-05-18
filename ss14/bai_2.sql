USE RikkeiClinicDB;

DELIMITER //

CREATE PROCEDURE TransferBed(IN p_patient_id INT, IN p_new_bed_id INT)
BEGIN
	UPDATE Beds SET patient_ = NULL WHERE patient_id = p_patient_id;
    
    UPDATE Beds SET patient_id = p_patient_id WHERE bed_id = p_new_bed_id;
END //

DELIMITER ;

DROP PROCEDURE IF EXISTS transferbed;

DELIMITER //

CREATE PROCEDURE transferbed;(
    IN p_patient_id INT,
    IN p_new_bed_id INT
)
BEGIN
    START TRANSACTION;
    UPDATE Beds
    SET patient_id = NULL
    WHERE patient_id = p_patient_id;

    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Loi: He thong bi treo khi chuyen giuong!';

    UPDATE Beds
    SET patient_id = p_patient_id
    WHERE bed_id = p_new_bed_id;
    COMMIT;
    -- ROLLBACK;
END //

DELIMITER ;

CALL transferbed(1, 201);

-- Consistency (Tính nhất quán)trong nguyên lý ACID. Vì sau giao dịch, dữ liệu rơi vào trạng thái không hợp lệ: bệnh nhân nội trú đáng lẽ phải thuộc một giường nhưng hệ thống lại ghi nhận không nằm ở giường nào.
