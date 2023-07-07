-- Defining Discount -- 
CREATE OR REPLACE FUNCTION defineDiscount(
    thisDiscountCode varchar(10),
    thisDiscountPercentage smallint,
    thisSuperAdmin_id integer
) RETURNS void AS 
$$ 
BEGIN
    INSERT INTO discount (discountCode, discountPercentage, superAdmin_id)
    VALUES (thisDiscountCode, thisDiscountPercentage, thisSuperAdmin_id);
END;
$$ 
LANGUAGE plpgsql;
-- test define discount 
-- SELECT defineDiscount(CAST(random() AS CHAR), '15', 1);

-- Answer Support Ticket --
CREATE OR REPLACE FUNCTION answerSupportTicket(
    thisSupportTicket_id integer,
    thisResponse varchar(255),
    thisResponser_id integer
) RETURNS void AS 
$answerSupportTicket$
BEGIN
    UPDATE supportTicket
    SET response = thisResponse, responser_id = thisResponser_id, status = 'answered', response_time = NOW()  
    WHERE supportTicket_id = thisSupportTicket_id;
END;
$answerSupportTicket$
LANGUAGE plpgsql;
-- test support ticket
-- SELECT answerSupportTicket(1, 'answer dadm', 1);

-- super admin just seen the message --
CREATE OR REPLACE FUNCTION onlySeenSupportTicket(
    thisSupportTicket_id integer,
    thisResponser_id integer
) RETURNS void AS 
$onlySeenSupportTicket$
BEGIN
    UPDATE supportTicket
    SET responser_id = thisResponser_id, status = 'read', response_time = NOW()  
    WHERE supportTicket_id = thisSupportTicket_id;
END;
$onlySeenSupportTicket$
LANGUAGE plpgsql;
-- test seen a message 
-- SELECT onlySeenSupportTicket(1, 1);