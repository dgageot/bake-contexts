# syntax=docker/dockerfile@sha256:9ba7531bd80fb0a858632727cf7a112fbfd19b17e94c4e84ced81e24ef1a0dbc
FROM golang:1.19.2-alpine3.16@sha256:e4dcdac3ed37d8c2b3b8bcef2909573b2ad9c2ab53ba53c608909e8b89ccee36 AS build
WORKDIR /src
COPY --from=base . ./
RUN go build -o main ./pkg1/

FROM scratch
COPY --from=build /src/main /main
