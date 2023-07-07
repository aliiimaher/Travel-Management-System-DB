-- TAM ask a question by adding a support ticket --
CREATE OR REPLACE FUNCTION TAM_ask(
    thisTitle varchar(40),
    thisDescription varchar(255),
    thisTAM_id integer
) RETURNS void AS
$TAM_ask$
BEGIN
    INSERT INTO supportTicket (title, description, ask_time, travelAgencyManager_id)
    VALUES (thisTitle, thisDescription, NOW(), thisTAM_id);
END;
$TAM_ask$
LANGUAGE plpgsql;
-- test asking
-- SELECT TAM_ask('management title', 'big big', '1');

-- Managers should be able to add new travels --
CREATE OR REPLACE FUNCTION create_travel(
    thisSrcStation_id integer,
    thisDstStation_id integer,
    thisTravelTime time,
    thisTravelDate date,
    thisTravelPrice integer,
    thisTravelDuration integer,
    thisVehicle_id integer,
    thisAgency_id integer
) RETURNS void AS 
$create_travel$
BEGIN
    INSERT INTO travel (srcStation_id, dstStation_id, travelTime, travelDate, travelPrice, travelDuration, vehicle_id, agency_id)
    VALUES (thisSrcStation_id, thisDstStation_id, thisTravelTime, thisTravelDate, thisTravelPrice, thisTravelDuration, thisVehicle_id, thisAgency_id);
END;
$create_travel$
LANGUAGE plpgsql;
-- test adding travel
-- SELECT create_travel(1, 2, '12:00', '2020-12-12', 100, 2, 1, 1);

-- Managers can filter travels that their agency involved using different 
-- filtering parameters such as rating, price, time and etc.
CREATE OR REPLACE FUNCTION filter_travels(
    thisRating smallint,
    thisPrice integer,
    thisTime time
)
RETURNS TABLE (
    travel_id INTEGER,
    travelRating smallint,
    srcStation_id integer,
    dstStation_id integer,
    travelTime time,
    travelDate date,
    travelPrice integer,
    travelDuration smallint,
    vehicle_id integer,
    remainingSeats smallint,
    agency_id integer
)
AS $filter_travels$
BEGIN
    RETURN QUERY
    SELECT *
    FROM travel
    WHERE travelRating >= thisRating
        AND travelPrice <= thisPrice
        AND travelTime >= thisTime;
END;
$filter_travels$ 
LANGUAGE plpgsql;
-- test filtering travels
-- SELECT * FROM filter_travels(0::smallint, 100, '12:00');



-- Managers receive stats at once --
CREATE OR REPLACE PROCEDURE get_travel_stats()
LANGUAGE plpgsql
AS $$
DECLARE
    best_selling_travel travel%ROWTYPE;
    highest_income_travel travel%ROWTYPE;
    highest_rated_travel travel%ROWTYPE;
    most_popular_destination travel%ROWTYPE;
BEGIN
    -- Bestselling travels
    SELECT *
    INTO best_selling_travel
    FROM travel
    ORDER BY remainingSeats DESC
    LIMIT 1;

    -- Highest income through the year based on time
    SELECT *
    INTO highest_income_travel
    FROM travel
    WHERE EXTRACT(YEAR FROM travelDate) = EXTRACT(YEAR FROM CURRENT_DATE)
    ORDER BY travelPrice DESC
    LIMIT 1;

    -- Highest rated travel
    SELECT *
    INTO highest_rated_travel
    FROM travel
    ORDER BY travelRating DESC
    LIMIT 1;

    -- Most popular destination
    SELECT t.*
    INTO most_popular_destination
    FROM travel t
    JOIN (
        SELECT dstStation_id, COUNT(*) AS count
        FROM travel
        GROUP BY dstStation_id
        ORDER BY count DESC
        LIMIT 1
    ) p ON t.dstStation_id = p.dstStation_id
    LIMIT 1;

    -- Print the statistics
    RAISE NOTICE 'Bestselling Travel: %', best_selling_travel;
    RAISE NOTICE 'Highest Income Travel: %', highest_income_travel;
    RAISE NOTICE 'Highest Rated Travel: %', highest_rated_travel;
    RAISE NOTICE 'Most Popular Destination: %', most_popular_destination;
END;
$$;
-- test stats monitored for managers
-- CALL get_travel_stats();

-- Managers should be able to retrieve information on the top 5 customers 
-- with the highest total paid price for travels in a specific month. 
-- Include their full name, contact information (email or phone number), 
-- total paid price, number of destinations they traveled to in that month, 
-- and the name of the city they visited the most. 
CREATE OR REPLACE FUNCTION get_top_customers_by_total_paid_price(month INTEGER)
RETURNS TABLE (
    full_name VARCHAR(255),
    contact_info VARCHAR(255),
    total_paid_price INTEGER,
    destinations_count INTEGER,
    most_visited_city VARCHAR(255)
)
AS $get_top_customers_by_total_paid_price$
BEGIN
    RETURN QUERY
    SELECT
        u.fName || ' ' || u.lName AS full_name,
        u.email AS contact_info,
        SUM(o.totalPrice) AS total_paid_price,
        COUNT(DISTINCT t.dstStation_id) AS destinations_count,
        (
            SELECT s.stationName
            FROM (
                SELECT t.dstStation_id, COUNT(*) AS count
                FROM ticket tk
                INNER JOIN travel t ON t.travel_id = tk.travel_id
                WHERE EXTRACT(MONTH FROM t.travelDate) = month
                GROUP BY t.dstStation_id
                ORDER BY count DESC
                LIMIT 1
            ) sub
            INNER JOIN station s ON s.station_id = sub.dstStation_id
        ) AS most_visited_city
    FROM ticket tk
    INNER JOIN orderr o ON o.order_id = tk.order_id
    INNER JOIN passenger p ON p.passenger_id = o.passenger_id
    INNER JOIN userr u ON u.user_id = p.user_id
    INNER JOIN travel t ON t.travel_id = tk.travel_id
    WHERE EXTRACT(MONTH FROM t.travelDate) = month
    GROUP BY u.user_id
    ORDER BY total_paid_price DESC
    LIMIT 5;
END;
$get_top_customers_by_total_paid_price$ 
LANGUAGE plpgsql;

-- test top customers (pass the month number as an argument)
-- SELECT get_top_customers_by_total_paid_price(4); -- Pass the month number as an argument
