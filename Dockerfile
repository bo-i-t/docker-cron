ARG DEBIAN_RELEASE=bullseye

FROM debian:${DEBIAN_RELEASE}

RUN apt-get update && apt-get install -y cron

COPY cron.sh /usr/bin/cron.sh
RUN chmod +x /usr/bin/cron.sh

CMD /usr/bin/cron.sh