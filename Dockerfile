FROM golang:1.25-alpine AS build
WORKDIR /src
COPY . .
RUN CGO_ENABLED=0 go build -trimpath -ldflags "-s -w" -o /ddns-go .

FROM alpine
RUN apk add --no-cache curl grep tzdata
WORKDIR /app
COPY --from=build /ddns-go /app/ddns-go
ENV TZ=Asia/Shanghai
EXPOSE 9876
ENTRYPOINT ["/app/ddns-go"]
CMD ["-l", ":9876", "-f", "300"]
