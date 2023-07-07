-- Password Encryption
CREATE EXTENSION IF NOT EXISTS pgcrypto;
-- user
CREATE TABLE IF NOT EXISTS userr (
    user_id serial PRIMARY KEY,
    username varchar(255) NOT NULL UNIQUE,
    password varchar(255) NOT NULL,
    fName varchar(255) NOT NULL,
    lName varchar(255) NOT NULL,
    email varchar(255) NOT NULL UNIQUE,
    phoneNumber varchar(255) NOT NULL UNIQUE,
    DOB date NOT NULL,
    age smallint,
    user_role roleType NOT NULL,
    verified boolean DEFAULT false
);
-- super admin ==> ISA user
CREATE TABLE IF NOT EXISTS superAdmin (
    superAdmin_id serial PRIMARY KEY,
    user_id integer NOT NULL,
    CONSTRAINT fk_superAdmin_user FOREIGN KEY (user_id)
        REFERENCES userr (user_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);
-- Travel Agency Manager ==> ISA user
CREATE TABLE IF NOT EXISTS travelAgencyManager (
    travelAgencyManager_id serial PRIMARY KEY,
    user_id integer NOT NULL,
    CONSTRAINT fk_travelAgencyManager_user FOREIGN KEY (user_id)
        REFERENCES userr (user_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);
-- Passenger ==> ISA user
CREATE TABLE IF NOT EXISTS passenger (
    passenger_id serial PRIMARY KEY,
    user_id integer NOT NULL,
    CONSTRAINT fk_passenger_user FOREIGN KEY (user_id)
        REFERENCES userr (user_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);
-- Agency
CREATE TABLE IF NOT EXISTS agency (
    agency_id serial PRIMARY KEY,
    agencyName varchar(255) NOT NULL,
    agencyPhoneNumber varchar(255) NOT NULL,
    agencyAddress varchar(255) NOT NULL,
    agencyRating smallint DEFAULT 0,
    travelAgencyManager_id integer NOT NULL,
    CONSTRAINT fk_agency_travelAgencyManager FOREIGN KEY (travelAgencyManager_id)
        REFERENCES travelAgencyManager (travelAgencyManager_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);
-- OTP
CREATE TABLE IF NOT EXISTS OTP (
    OTP_id serial PRIMARY KEY,
    code varchar(10) NOT NULL,
    expTime timestamp NOT NULL,
    user_id integer NOT NULL,
    CONSTRAINT fk_OTP_user FOREIGN KEY (user_id)
        REFERENCES userr (user_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);
-- Discount
CREATE TABLE IF NOT EXISTS discount (
    discount_id serial PRIMARY KEY,
    discountCode varchar(10) NOT NULL,
    discountPercentage int DEFAULT 10,
    superAdmin_id integer,
    CONSTRAINT fk_discount_superAdmin FOREIGN KEY (superAdmin_id)
        REFERENCES superAdmin (superAdmin_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);
-- Support Ticket
CREATE TABLE IF NOT EXISTS supportTicket (
    supportTicket_id serial PRIMARY KEY,
    title varchar(40),
    description varchar(255) NOT NULL,
    response varchar(255),
    status messageStatus DEFAULT 'unread',
    ask_time timestamp NOT NULL,
    response_time timestamp,
    responser_id integer,
    CONSTRAINT fk_supportTicket_responser FOREIGN KEY (responser_id)
        REFERENCES superAdmin (superAdmin_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    passenger_id integer DEFAULT NULL,
    CONSTRAINT fk_supportTicket_passenger FOREIGN KEY (passenger_id)
        REFERENCES passenger (passenger_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    travelAgencyManager_id integer DEFAULT NULL,
    CONSTRAINT fk_supportTicket_travelAgencyManager FOREIGN KEY (travelAgencyManager_id)
        REFERENCES travelAgencyManager (travelAgencyManager_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);
-- Order
CREATE TABLE IF NOT EXISTS orderr (
    order_id serial PRIMARY KEY,
    totalPrice integer NOT NULL,
    passenger_id integer NOT NULL,
    CONSTRAINT fk_order_passenger FOREIGN KEY (passenger_id)
        REFERENCES passenger (passenger_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    discount_id integer
);
-- Vehicle
CREATE TABLE IF NOT EXISTS vehicle (
    vehicle_id serial PRIMARY KEY,
    vehicleName varchar(255) NOT NULL,
    vehicle_Type vehicleType NOT NULL,
    vehicleCapacity smallint NOT NULL
);
-- Station
CREATE TABLE IF NOT EXISTS station (
    station_id serial PRIMARY KEY,
    stationName varchar(255) NOT NULL,
    stationAddress varchar(255) NOT NULL,
    stationPhoneNumber varchar(255) NOT NULL
);
-- Travel
CREATE TABLE IF NOT EXISTS travel (
    travel_id serial PRIMARY KEY,
    travelRating smallint DEFAULT 0,
    srcStation_id integer NOT NULL,
    CONSTRAINT fk_travel_srcStation FOREIGN KEY (srcStation_id)
        REFERENCES station (station_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    dstStation_id integer NOT NULL,
    CONSTRAINT fk_travel_dstStation FOREIGN KEY (dstStation_id)
        REFERENCES station (station_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    travelTime time NOT NULL,
    travelDate date NOT NULL,
    travelPrice integer NOT NULL,
    travelDuration smallint NOT NULL,
    vehicle_id integer NOT NULL,
    CONSTRAINT fk_travel_vehicle FOREIGN KEY (vehicle_id)
        REFERENCES vehicle (vehicle_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    remainingSeats smallint,
    agency_id integer NOT NULL,
    CONSTRAINT fk_travel_agency FOREIGN KEY (agency_id)
        REFERENCES agency (agency_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);
-- ticket
CREATE TABLE IF NOT EXISTS ticket (
    ticket_id serial PRIMARY KEY,
    seatNumber smallint NOT NULL UNIQUE,
    rate smallint DEFAULT NULL,
    ticket_status ticketStatus DEFAULT NULL,
    order_id integer NOT NULL,
    CONSTRAINT fk_ticket_order FOREIGN KEY (order_id)
        REFERENCES orderr (order_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    travel_id integer NOT NULL,
    CONSTRAINT fk_ticket_travel FOREIGN KEY (travel_id)
        REFERENCES travel (travel_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);
