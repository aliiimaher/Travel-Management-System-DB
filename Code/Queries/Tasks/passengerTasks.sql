-- passenger ask a question by adding a support ticket
CREATE OR REPLACE FUNCTION passenger_ask(
    thisTitle varchar(40),
    thisDescription varchar(255),
    thisPassenger_id integer
) RETURNS void AS
$passenger_ask$
BEGIN
    INSERT INTO supportTicket (title, description, ask_time, passenger_id)
    VALUES (thisTitle, thisDescription, NOW(), thisPassenger_id);
END;
$passenger_ask$
LANGUAGE plpgsql;
--  test asking
-- SELECT passenger_ask('good title', 'bad ass', '1');

-- Passengers can see their personal info --
CREATE OR REPLACE PROCEDURE get_passenger_info(thisUserID integer)
LANGUAGE plpgsql
AS $get_passenger_info$
DECLARE
    personal_fName userr.fName%TYPE;
    personal_lName userr.lName%TYPE;
    personal_email userr.email%TYPE;
    personal_phoneNumber userr.phoneNumber%TYPE;
    personal_age userr.age%TYPE;
BEGIN  
    SELECT fName INTO personal_fName FROM userr WHERE user_id = thisUserID;
    SELECT lName INTO personal_lName FROM userr WHERE user_id = thisUserID;
    SELECT email INTO personal_email FROM userr WHERE user_id = thisUserID;
    SELECT phoneNumber INTO personal_phoneNumber FROM userr WHERE user_id = thisUserID;
    SELECT age INTO personal_age FROM userr WHERE user_id = thisUserID;

    RAISE NOTICE 'First name: %', personal_fName;
    RAISE NOTICE 'Last name: %', personal_lName;
    RAISE NOTICE 'Email: %', personal_email;
    RAISE NOTICE 'Phone Number: %', personal_phoneNumber;
    RAISE NOTICE 'Age: %', personal_age;
END;
$get_passenger_info$;

-- test passenger info monitoring
-- CALL get_passenger_info(1);


-- Reserve ticket --
CREATE OR REPLACE FUNCTION reserve_ticket(
    thisSeatNumber smallint,
    thisOrder_id integer,
    thisTravel_id integer
) RETURNS void 
AS $reserve_ticket$
BEGIN
    INSERT INTO ticket (seatNumber, order_id, travel_id)
    VALUES (thisSeatNumber, thisOrder_id, thisTravel_id);
END;
$reserve_ticket$
LANGUAGE plpgsql;

-- test reserve ticket
-- SELECT reserve_ticket(9::smallint, 1, 1);

