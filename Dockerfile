FROM golang:1.19-alpine AS build

WORKDIR /app

COPY ./Golang/go.mod ./
COPY ./Golang/go.sum ./
RUN go mod download

COPY ./Golang/*.go ./
COPY ./Golang/list/*.go ./list/
COPY ./Golang/liveurls/*.go ./liveurls/

RUN go build -o /allinone
# Docker 内用户切换到 root
USER root
# 设置时区为东八区
RUN echo "Asia/shanghai" > /etc/timezone

FROM alpine:3.14

COPY --from=build /allinone /allinone

EXPOSE 35455

CMD [ "/allinone" ]
