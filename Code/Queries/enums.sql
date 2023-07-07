-- Roles enum
CREATE TYPE roleType AS ENUM ('passenger', 'travelAgencyManager', 'superAdmin');
-- Vehicle type enum
CREATE TYPE vehicleType AS ENUM ('train', 'bus', 'plane_domestic', 'plane_international');
-- Ticket type enum
CREATE TYPE ticketStatus AS ENUM ('reserved', 'paid', 'canceled');
-- message status enum
CREATE TYPE messageStatus AS ENUM ('unread', 'read', 'answered');