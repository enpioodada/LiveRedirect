FROM golang:1.19-alpine AS build

WORKDIR /app

COPY ./Golang/ ./
RUN go mod download
RUN go build -o /allinone

FROM alpine:3.14
RUN apk update && apk add tzdata && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo Asia/Shanghai > /etc/timezone


COPY --from=build /allinone /allinone

EXPOSE 35455

CMD [ "/allinone" ]
