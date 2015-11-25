FROM quay.io/octoblu/pen-node-base

RUN npm i -g coap-cli
COPY run.sh run.sh
CMD ["./run.sh"]
