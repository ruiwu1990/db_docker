This is an example about how to integrate PostgreSQL with Flask.

#Local Quick Start
##Before You Start
First, open a terminal set up a PostgreSQL database
```
sudo -u postgres psql
create database tmpdb;
create user tmp with encrypted password 'tmp';
grant all privileges on database tmpdb to tmp;
```


Then, open another terminal to create a virtual environment
```
mkvirtualenv -p python2.7 dev
```

If you have created the virtual environment, then use this commend to enter it
```
virtualenv dev && source dev/bin/activate
```

Here is the command to install the requirements
```
pip install -r requirements.txt
```
Here is the command to set up and run the program
```
python views.py -h 134.197.20.79 -p 5000 --threaded
```
134.197.20.79 should be replaced with your machine ip address. The command is to set up a server with your machine


#Docker Quick Start
##Before You Start
1. You need to install the docker engine and here is the official link how to do it:
[Docker Engine Install Official link](https://docs.docker.com/engine/installation/linux/ubuntu/#install-using-the-repository). 
The system has been tested with Docker version 17.03 and 17.05
2. All the server components should work if you have installed docker correctly.



You can run the program by:
```
docker run --name <container_name> -h <your_machine_ip> -p 5000:5000 ruiwu1990/db_docker python views.py
```

'container_name' is your docker container name and 'your_machine_ip' should be your machine ip.

-p 5000:5000 means that mapping host machine port 5000 (first one) with docker container port 5000 (second one)

Here is the command I used in my machine:
```
docker run --name postgresql_docker -h 150.216.82.155 -p 5000:5000 ruiwu1990/db_docker python views.py
```

#Website URL
The system is available here
```
<Your IP>:5000/
```
For me the URL replaced with my ip is:
```
150.216.82.155:5000/
```