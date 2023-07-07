-- active users --
CREATE OR REPLACE PROCEDURE active_users(
    thisCode varchar(10),  
    thisUser_id integer
    )
AS $active_users$
BEGIN
    IF EXISTS (SELECT code FROM otp WHERE code = thisCode AND expTime > NOW() AND user_id = thisUser_id) THEN
        UPDATE userr
        SET verified = true
        WHERE user_id = thisUser_id;
    ELSE
        RAISE NOTICE 'Invalid code or expired';
    END IF;
END;
$active_users$
LANGUAGE plpgsql;

-- test active users
-- CALL active_users('123456', 2);