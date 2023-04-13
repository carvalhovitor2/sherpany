FROM python:3.10-slim as build

RUN apt-get update
RUN apt-get install -y --no-install-recommends build-essential gcc 

WORKDIR /usr/app

RUN python -m venv /usr/app/venv
ENV PATH="/usr/app/venv/bin:$PATH"
COPY requirements.txt .
RUN pip install -r requirements.txt

#Using multi-stage build artifacts to run the image
FROM python:3.10-slim

RUN groupadd -g 999 python && \
    useradd -r -u 999 -g python python

#Everything should be owned by python
RUN mkdir /usr/app && chown python:python /usr/app
WORKDIR /usr/app

COPY --chown=python:python --from=build /usr/app/venv ./venv
COPY --chown=python:python . .

WORKDIR /usr/app

COPY --from=build /usr/app/venv ./venv
COPY . .
ENV PATH="/usr/app/venv/bin:$PATH"

EXPOSE 8000
