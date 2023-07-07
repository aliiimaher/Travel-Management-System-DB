CREATE OR REPLACE FUNCTION set_age() 
RETURNS TRIGGER AS 
$$
BEGIN
        IF NEW.age IS NULL THEN
                NEW.age = (CURRENT_DATE - NEW.dob)/365;
        END IF;
        RETURN NEW;
END;
$$ 
LANGUAGE plpgsql;
--
CREATE TRIGGER set_age_trigger
BEFORE INSERT OR UPDATE 
ON userr
FOR EACH ROW
EXECUTE FUNCTION set_age();
--
CREATE OR REPLACE FUNCTION add_user_to_related_role()
RETURNS TRIGGER AS
$add_user_to_related_role$
BEGIN
        IF NEW.user_role = 'superAdmin' THEN
                INSERT INTO superAdmin (user_id) VALUES (NEW.user_id);
        ELSIF NEW.user_role = 'travelAgencyManager' THEN
                INSERT INTO travelAgencyManager (user_id) VALUES (NEW.user_id);
        ELSIF NEW.user_role = 'passenger' THEN
                INSERT INTO passenger (user_id) VALUES (NEW.user_id);
        END IF;
        RETURN NEW;
END;
$add_user_to_related_role$
LANGUAGE plpgsql;
--
CREATE TRIGGER add_user_to_related_role_trigger
AFTER INSERT OR UPDATE
ON userr
FOR EACH ROW
EXECUTE FUNCTION add_user_to_related_role();
--
CREATE OR REPLACE FUNCTION set_remaining_seats()
RETURNS TRIGGER AS
$set_remaining_seats$
BEGIN
    UPDATE travel
    SET remainingSeats = (SELECT vehicleCapacity FROM vehicle WHERE vehicle_id = NEW.vehicle_id)
    WHERE travel_id = NEW.travel_id;
    RETURN NEW;
END;
$set_remaining_seats$
LANGUAGE plpgsql;
-- 
CREATE TRIGGER set_remaining_seats_trigger
AFTER INSERT 
ON travel
FOR EACH ROW
EXECUTE FUNCTION set_remaining_seats();
--
CREATE OR REPLACE FUNCTION reduce_remaining_seats()
RETURNS TRIGGER AS
$reduce_remaining_seats$
BEGIN
    UPDATE travel
    SET remainingSeats = remainingSeats - 1
    WHERE travel_id = NEW.travel_id;
    RETURN NEW;
END;
$reduce_remaining_seats$
LANGUAGE plpgsql;
--
CREATE TRIGGER reduce_remaining_seats_trigger
AFTER INSERT 
ON ticket
FOR EACH ROW
EXECUTE FUNCTION reduce_remaining_seats();
--
CREATE OR REPLACE FUNCTION user_login_if_verified(phone_Number varchar, pass varchar)
RETURNS INT AS
$user_login_if_verified$
DECLARE temp_user_id INT;
BEGIN
     IF EXISTS (SELECT user_id FROM userr WHERE phoneNumber = phone_Number and password = crypt(pass, password) and verified = true) THEN
        SELECT user_id INTO temp_user_id WHERE phoneNumber = phone_Number and password = crypt(pass, password) and verified = true;
     ELSE RAISE EXception 'This user is not verified';
     END IF;
END;
$user_login_if_verified$
LANGUAGE plpgsql;
--
