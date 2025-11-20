####### STAGE 1: Build #######
FROM golang:1.23-alpine AS builder

WORKDIR /app

# Copy dependency files first for caching
COPY go.mod go.sum ./
RUN go mod download

# Copy source code
COPY . .

# Build binary
RUN go build -o dispatch .

####### STAGE 2: Runtime #######
FROM gcr.io/distroless/static-debian12

WORKDIR /app

COPY --from=builder /app/dispatch /app/dispatch

USER 10001
CMD ["/app/dispatch"]
