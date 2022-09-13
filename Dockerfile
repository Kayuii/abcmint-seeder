FROM alpine as builder

RUN apk update && \
    apk add --no-cache dpkg make gcc build-base linux-headers \
    openssl-dev openssl-libs-static cmake boost-dev

COPY . /opt/dnsseed

RUN cd /opt/dnsseed && \
  cmake -S . -B build && \
  make -C build

FROM alpine

COPY --from=builder /opt/dnsseed/build/dnsseed /usr/local/bin
