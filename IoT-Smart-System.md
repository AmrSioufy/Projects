### This project has its own repository

https://github.com/AmrSioufy/Raspberry-Pi

#### This Project highlights the Collision Avoidance System application, part of my Graduation Project #####
#### The below explanation is about the workstation in RaspberryPi directories regarding the Collision Avoidance System ####

- car_run.py > is the script that runs the car and processes data from distance sensor, stores car speed. based on that data decision is taken for different scenarios

- transmit.sh > transmits a file to a user in the same network using secure copy. 
#### To transmit a file you need to specify (Desitnation IP Address, Destination path, Destination username, Destination password, Path of transmitted files)

- Transmit.py > runs all scripts in a loop while continously sending files to a specified user using transmit.sh

- ultrasonic.py > distance sensor script
#### After reading the sensor readings, data is stored in a text file to be fetched later for a decision inside the "car_run.py"

*Every sensor script exports the data to a txt file which will be imported to the car_run.py for the buildup scenarios*
