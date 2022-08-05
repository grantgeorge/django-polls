# pull official base image
FROM python:3.9.12

ADD ./requirements.txt /app/requirements.txt

# RUN set -ex \
#   && apt-get add --no-cache --virtual .build-deps postgresql-dev build-base \
#   && python -m venv /env \
#   && /env/bin/pip install --upgrade pip \
#   && /env/bin/pip install --no-cache-dir -r /app/requirements.txt \
#   && runDeps="$(scanelf --needed --nobanner --recursive /env \
#   | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
#   | sort -u \
#   | xargs -r apt-get info --installed \
#   | sort -u)" \
#   && apt-get add --virtual rundeps $runDeps \
#   && apt-get del .build-deps

ADD . /app
WORKDIR /app

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# install system dependencies
RUN apt-get update \
  && apt-get -y install netcat gcc postgresql \
  && apt-get clean

# install dependencies
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

ENV VIRTUAL_ENV /env
ENV PATH /env/bin:$PATH

EXPOSE 8000
