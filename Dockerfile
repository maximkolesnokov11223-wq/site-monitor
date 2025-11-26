FROM ubuntu:latest

RUN apt update && apt install -y \
    curl \
    iputils-ping \
    python3 \
    python3-pip

RUN pip3 install --break-system-packages matplotlib requests

COPY monitor.sh /monitor.sh
COPY plot_and_send.py /plot_and_send.py
RUN chmod +x /monitor.sh

CMD ["/monitor.sh"]
