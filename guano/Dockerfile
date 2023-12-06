FROM golang:1.21.4-alpine3.17 AS builder

WORKDIR /app
COPY . .
RUN go build -o guano

FROM alpine:latest
WORKDIR /app
COPY --from=builder /app/guano .
CMD ["./guano"]

