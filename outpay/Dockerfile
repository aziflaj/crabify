FROM golang:1.21.4-alpine3.17 AS builder

WORKDIR /app
COPY . .
RUN go build -o outpay

FROM alpine:latest
WORKDIR /app
COPY --from=builder /app/outpay .
CMD ["./outpay"]

