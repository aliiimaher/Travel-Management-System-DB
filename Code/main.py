# DB Project
# Coded by Ali Maher and Arsalan Jabbari

import psycopg2
import psycopg2.extras
import random
import datetime
import time
from sqlRunner import executeScriptsFromFile
from triggerRunner import executeTriggersFromFile

# === connection ===
hostname = 'localhost'
database = 'db name'
username = 'postgres'
pwd = 'Enter ur pass'
port_id = 'related port'

conn = psycopg2.connect(
        host=hostname,
        dbname=database, 
        user=username,
        password=pwd, 
        port=port_id)
cur = conn.cursor(cursor_factory=psycopg2.extras.DictCursor)

# === main part ===
# Drop tables
cur.execute('DROP SCHEMA public CASCADE;')
cur.execute('CREATE SCHEMA public;')

# = Create enums =
executeScriptsFromFile('Queries/enums.sql', cur)

# = Create tables =
executeScriptsFromFile('Queries/createTables.sql', cur)

# = Trigger function =
# trigger function for set age based on DOB
executeTriggersFromFile('Queries/triggerFunctions.sql', cur)

# = Insert = 
executeScriptsFromFile('Queries/insert.sql', cur)

# = super admin tasks =
# executeTriggersFromFile('Queries/superAdmin.sql', cur)

# = OTP Handling =
def sendOTP():
    current_time = datetime.datetime.now()
    exp_time = current_time + datetime.timedelta(seconds=30)
    OTP = random.randrange(20, 50, 3)
    print('OTP sent!', end=' ===> ')
    print(OTP)
    insert_OTPForUser = 'INSERT INTO otp (code, expTime, user_id) VALUES (%s, %s, %s);'
    insert_OTPForUser_values = [(OTP, exp_time, 1), ]
    cur.execute(insert_OTPForUser, insert_OTPForUser_values[0])
#     time.sleep(15)
#     current_time = datetime.datetime.now()
#     delete_OTP = 'DELETE FROM otp WHERE expTime < %s;'
#     delete_OTP_values = [(current_time), ]
#     cur.execute(delete_OTP, delete_OTP_values[0])

# = test otp =
sendOTP()

# = save changes into database =
conn.commit()

# = print out userr =
cur.execute('SELECT * FROM userr FETCH FIRST 1 ROW ONLY;')
print(cur.fetchall())
