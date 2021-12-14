FROM golang:1.17-alpine AS builder

WORKDIR /src

COPY go.mod ./
COPY go.sum ./
RUN go mod download

COPY . ./

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o grpcox grpcox.go


FROM alpine

COPY ./index /index
COPY --from=builder /src/grpcox ./
RUN mkdir /log
EXPOSE 6969
ENTRYPOINT ["./grpcox"]
