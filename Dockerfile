FROM golang:1.19-alpine AS build

WORKDIR /app

COPY ./Golang/go.mod ./
COPY ./Golang/go.sum ./
RUN go mod download

COPY ./Golang/*.go ./
COPY ./Golang/list/*.go ./list/
COPY ./Golang/liveurls/*.go ./liveurls/

RUN go build -o /allinone


#设置时区
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo '$TZ' > /etc/timezone
RUN cp "/usr/share/zoneinfo/Asia/Shanghai" "/etc/localtime" && \
    echo "Asia/Shanghai" > "/etc/timezone" && \

FROM alpine:3.14

COPY --from=build /allinone /allinone

EXPOSE 35455

CMD [ "/allinone" ]
