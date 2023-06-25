FROM nginx:stable-alpine3.17

RUN apk update && apk add --no-cache python3 py3-pip

COPY configs/nginx.conf /etc/nginx/nginx.conf
COPY html /usr/share/nginx/html/
COPY scripts/data_receiver.py /usr/local/bin/
COPY scripts/entrypoint.sh /usr/local/bin/

RUN pip3 install requests

RUN chmod +x /usr/local/bin/data_receiver.py
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]