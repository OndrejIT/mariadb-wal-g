FROM golang:1.20-bullseye AS builder

ENV WALG_VERSION=v2.0.1

RUN apt-get update && \
	apt-get install -y libbrotli-dev libsodium-dev liblzo2-dev cmake git && \
	git clone https://github.com/wal-g/wal-g/  $GOPATH/src/wal-g && \
	cd $GOPATH/src/wal-g/ && \
	git checkout $WALG_VERSION && \
	make deps && \
	make mysql_build && \
	install main/mysql/wal-g /usr/local/bin/wal-g


FROM docker.io/mariadb:10.11

COPY --from=builder /usr/local/bin/wal-g /usr/local/bin/

ADD bin/* /usr/local/bin/
COPY docker-entrypoint.sh /usr/local/bin/
COPY /etc/mariadb.cnf /etc/mysql/mariadb.cnf

RUN \
	apt-get update && \
	apt-get install -y tzdata && \
	apt-get clean && \
	chmod +x /usr/local/bin/docker-entrypoint.sh && \
	chmod +x /usr/local/bin/wal-g /usr/local/bin/backup /usr/local/bin/restore
