USE RikkeiClinicDB;


DROP PROCEDURE IF EXISTS payhospitalfee;

DELIMITER //

CREATE PROCEDURE payhospitalfee(
    IN p_patient_id INT,
    IN p_amount DECIMAL(18,2),
    OUT p_message VARCHAR(100)
)
BEGIN
    DECLARE v_balance DECIMAL(18,2);
    START TRANSACTION;

    IF p_amount <= 0 THEN
        ROLLBACK;
        SET p_message =
        'Lỗi: Số tiền thanh toán không hợp lệ';
    ELSE
        SELECT balance
        INTO v_balance
        FROM Wallets
        WHERE patient_id =
        p_patient_id;

        IF v_balance < p_amount THEN
            ROLLBACK;
            SET p_message =
            'Lỗi: Số dư ví không đủ';
        ELSE
            UPDATE Wallets
            SET balance =
            balance - p_amount
            WHERE patient_id =
            p_patient_id;

            UPDATE Patient_Invoices
            SET total_due =
            total_due - p_amount
            WHERE patient_id =
            p_patient_id;
            COMMIT;
            SET p_message =
            'Thanh toán thành công';
        END IF;
    END IF;
END //

DELIMITER ;

CALL payhospitalfee(
    1,200000,
    @message
);

SELECT @message;

-- Hệ thống cần nhập mã bệnh nhân và số tiền thanh toán để thực hiện thanh toán viện phí nên dùng tham số IN.
-- Sau khi xử lý xong, hệ thống sẽ trả về thông báo kết quả như “Thanh toán thành công” hoặc “Lỗi: Số dư ví không đủ” nên dùng tham số OUT.