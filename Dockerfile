FROM returntocorp/semgrep:latest

RUN apk add make

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]