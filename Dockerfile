FROM library/postgres
MAINTAINER Rui Wu
LABEL description="Postgres SQL."

RUN apt-get update -y
RUN apt-get install -y python-pip python-dev build-essential


#copy source code
COPY . /db_docker
WORKDIR /db_docker
ENV PYTHONPATH /db_docker

#setup db
ENV POSTGRES_USER docker
ENV POSTGRES_PASSWORD docker
ENV POSTGRES_DB docker


#install requirements
RUN pip install -r requirements.txt

EXPOSE 5000
ENV FIRE_PORT 80
ENV FIRE_HOST 0.0.0.0
EXPOSE ${FIRE_PORT}

CMD python views.py -p 5000 --threaded