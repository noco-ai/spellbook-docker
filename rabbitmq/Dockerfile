FROM rabbitmq:3-management
RUN apt-get update && apt-get install -y openssl curl && apt-get clean
ADD rabbitmq/amqp-init.sh /amqp-init.sh
RUN chmod +x /amqp-init.sh
RUN mkdir /credentials
RUN chown rabbitmq:rabbitmq credentials
ENV RABBITMQ_PID_FILE /var/lib/rabbitmq/mnesia/rabbitmq
CMD ["/amqp-init.sh"]