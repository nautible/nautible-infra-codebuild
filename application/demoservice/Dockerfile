FROM golang:1.15.2-alpine3.12 as builder

COPY src/main.go ./

RUN apk add --no-cache \
        alpine-sdk \
        git \
    && go get github.com/prometheus/client_golang/prometheus \
    && go get github.com/prometheus/client_golang/prometheus/promhttp

RUN go build -o /go-app ./main.go

#---
FROM alpine:3.12

COPY --from=builder /go-app .
ENTRYPOINT ["./go-app"]