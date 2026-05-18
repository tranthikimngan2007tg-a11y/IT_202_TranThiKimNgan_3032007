USE RikkeiClinicDB;


DELIMITER //

CREATE PROCEDURE dispensemedicine(
    IN p_patient_id INT,
    IN p_medicine_id INT,
    IN p_quantity INT,
    OUT p_message VARCHAR(100)
)
BEGIN

    DECLARE v_stock INT;
    DECLARE v_price DECIMAL(18,2);
    DECLARE v_total DECIMAL(18,2);

    START TRANSACTION;
    SELECT stock, price
    INTO v_stock, v_price
    FROM Medicines
    WHERE medicine_id = p_medicine_id;

    IF v_stock < p_quantity THEN
        ROLLBACK;
        SET p_message =
        'Lỗi: Số lượng tồn kho không đủ';
    ELSE
        UPDATE Medicines
        SET stock = stock - p_quantity
        WHERE medicine_id = p_medicine_id;
        SET v_total =
        p_quantity * v_price;
        UPDATE Patient_Invoices
        SET total_due =
        total_due + v_total
        WHERE patient_id =
        p_patient_id;
        COMMIT;
        SET p_message =
        'Đã cấp phát thành công';
    END IF;

END //

DELIMITER ;

CALL dispensemedicine(
    1,
    1,
    10,
    @message
);

SELECT *
FROM Patient_Invoices
WHERE patient_id = 1;
