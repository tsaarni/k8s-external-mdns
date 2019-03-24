FROM golang as builder
WORKDIR /go/src/github.com/kubernetes-incubator/external-dns
RUN git clone --depth 1 https://github.com/tsaarni/external-dns-hosts-provider-for-mdns . && \
    make dep && \
    make build

FROM alpine:latest
COPY --from=builder /go/src/github.com/kubernetes-incubator/external-dns/build/external-dns /bin/external-dns
ENTRYPOINT ["/bin/external-dns"] 
