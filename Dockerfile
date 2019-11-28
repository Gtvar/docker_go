FROM golang:alpine AS builder

ARG BASEPATH
ARG PACKAGE
ARG APP
ENV BASEPATH $BASEPATH
ENV PACKAGE $PACKAGE
ENV APP $APP

RUN apk update && apk add --no-cache git

WORKDIR /go/src/${BASEPATH}/${PACKAGE}/
COPY src/$BASEPATH/$PACKAGE .

RUN go get -d -v

RUN go build -o /go/bin/${APP}

FROM scratch

ARG APP
ENV APP $APP

COPY --from=builder /go/bin/$APP /go/bin/$APP

ENTRYPOINT ["/go/bin/hello"]
CMD ["/bin/sh"]


# ~/progs/go docker-compose -f docker-compose.yaml up -d --build
# docker-compose -f docker-compose.yaml run go
