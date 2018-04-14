FROM python:alpine3.6

WORKDIR /usr/src/app

COPY src/requirements.txt ./
RUN apk add --no-cache git bash sed gawk jq expect grep && \
    pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

COPY ./src/ .


ENTRYPOINT [ "/bin/bash", "-c" ]

CMD [ "mqttcat --help" ]
