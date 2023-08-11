# Travel-Management-System

This project focuses on designing a comprehensive database system for an online travel ticket purchasing platform that serves all customers, travel agencies and application's super admins.

## Table of Contents
- [Introduction](#introduction)
- [Project Overview](#project-overview)
- [Features](#features)
- [Getting Started](#getting-started)
- [Conclusion](#conclusion)

## Introduction
Traveling allows us to explore new places, cultures, and perspectives. The growth of the internet has made a significant impact on the travel industry, providing travelers with the convenience of purchasing travel tickets online from their own homes. This project aims to design the database system of an online travel ticket purchasing platform that caters to both customers and travel agencies.

![ERD](https://raw.githubusercontent.com/arsalanjabbari/Travel-Management-System/main/ERD/ERD.png)

## Project Overview
In this project, we will develop a comprehensive online travel ticket booking platform. The system will handle various types of travel options including trains, buses, and airplanes, with a focus on dynamic seat management. Users will have the flexibility to register and log in using either their phone numbers or email addresses, enhancing the authentication process's convenience and security. The project will encompass three types of users: passengers, travel agency managers, and super admins.
```
/Travel-Management-System
├── /ERD
│   └── ERD.png
├── /Code
│   ├── /Queries
│   │   ├── /Tasks
│   │   │   ├── passengerTasks.sql
│   │   │   ├── superAdminTasks.sql
│   │   │   ├── TAMTasks.sql
│   │   │   └── userTasks.sql
│   │   ├── createTables.sql
│   │   ├── enums.sql
│   │   ├── insert.sql
│   │   └── triggerFunctions.sql
│   ├── main.py
│   ├── sqlRunner.py
│   └── triggerRunner.py
├── README.md
└── LICENSE
```

## Features
- **Database-based**: Most of the constraints and features have been handled in the database instead of the back end.
####
- **Database Schema and Functionality**: The schema has tables for users, travels, tickets, orders, agencies, discounts, support tickets, vehicles, stations, etc. Procedures manage reservation, ordering, payment, tracking, and support.
####
- **Security**: The process of user registration encompasses the utilization of a one-time password (OTP) mechanism, conveyed through either SMS or email. These OTPs are endowed with a finite validity period, necessitating their validation within the designated timeframe to fulfill the account verification procedure. The imperative of securely storing passwords is underscored, serving the dual purpose of fortifying database security and safeguarding user information.
####
- **Support System**: The platform enables online communication between customers, managers, and support services. It includes an online support system for improved customer-manager interaction. Users create support tickets for queries and can exchange messages, maintaining clear communication. Additional features like message status indicators can enhance user experience.
####
- **Travels**: The platform facilitates various travel modes, providing information such as date, time, vehicle type, price, and seat availability. It encompasses Train, Bus, and Airplane travel types, the latter of which includes both domestic and international options. Each travel type includes details about date, time, vehicle type, price, and available seats. Dynamic updates to seat availability are essential after passenger interactions to maintain accuracy.
####
- **Users**: This project supports three types of users with different roles:
  - **Passenger**: After registration, users gain access to a personalized panel containing personal details. Passengers can reserve, order, and pay for tickets, track order statuses, and apply discounts using codes. They can also search for tickets using various parameters and rate past travels.
  - **Travel Agency Manager**: Incorporating new travel choices, statistical insights, and agency-related travel filtering are prominent features. Managers have the prerogative to append fresh itineraries and employ filters for agency-associated travels based on diverse criteria. They can access pertinent statistics such as top-selling journeys, highest revenue, best ratings, popular destinations, and more. Managers can also retrieve data on the highest-paying customers for travels within a specific month, limited to the top 5.
  - **Super Admin**: Super administrators possess the capability to initiate chat dialogues with both customers and travel agency managers within the confines of the support system. This privileged group retains access to the complete spectrum of ticket generation and messaging functionalities inherent to the online support system.


## Getting Started
1. Clone this repository.
2. Set up your database according to the schema provided in the ERD.
3. Install the required dependencies listed in the 'requirements.txt' file.
4. Configure your server settings as needed.
5. Run the application by executing the `main.py` script.
6. Utilize the `sqlRunner.py` script to execute SQL queries.
7. Use the `triggerRunner.py` script to run trigger functions.

    Warning: Make sure the database connection in main.py before running.

## Conclusion
The Travel Management System project aims to create a user-friendly and feature-rich platform for both travelers and travel agency managers. By carefully designing the database schema and incorporating various functionalities such as dynamic seat management, authentication, discount application, and support interactions, this project aims to enhance the travel booking experience. Through this project, we strive to showcase the fusion of technology and travel to provide users with a convenient and efficient way to explore the world.