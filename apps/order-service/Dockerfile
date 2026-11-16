FROM golang:1.22-alpine AS builder
WORKDIR /app
COPY main.go .
RUN go build -o order-service main.go

FROM alpine:latest
WORKDIR /app
COPY --from=builder /app/order-service .
EXPOSE 8080
CMD ["./order-service"]