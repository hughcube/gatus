# Build the go application into a binary
FROM golang:alpine AS builder
RUN apk --update --no-cache add ca-certificates tzdata
WORKDIR /app
ENV GOPROXY=https://goproxy.cn,direct
COPY . ./
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o gatus .

# Run the binary on a lightweight alpine container
FROM alpine:latest
RUN apk --update --no-cache add ca-certificates tzdata
WORKDIR /
COPY --from=builder /app/gatus /gatus
COPY --from=builder /app/config.yaml /config/config.yaml
ENV GATUS_CONFIG_PATH=""
ENV GATUS_LOG_LEVEL="INFO"
ENV PORT="8080"
ENV TZ="Asia/Shanghai"
EXPOSE ${PORT}
ENTRYPOINT ["/gatus"]
