# Build stage
FROM golang:1.25.1-alpine AS builder

WORKDIR /go/src/github.com/franciscozamorau/osmi-db

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN go build -o migrator ./cmd/main.go

# Final stage
FROM alpine:latest

RUN apk --no-cache add ca-certificates

WORKDIR /root/

COPY --from=builder /go/src/github.com/franciscozamorau/osmi-db/migrator .

CMD ["./migrator"]
