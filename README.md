

# Expose Kubernetes services with mDNS

This tutorial shows how to use MetalLB and ExternalDNS to expose
services (and ingresses) with .local hostname in LAN using mDNS.

Note: This approach is only suitable for test clusters in local area
network.


Following projects are used

* [Avahi](https://www.avahi.org/) as mDNS server
* [ExternalDNS fork](https://github.com/tsaarni/external-dns-hosts-provider-for-mdns) with hosts file provisioner support



## Installation

Install MetalLB to assign public IP for services.  The IP range should be changed to the IP address range of your network:

    kubectl apply -f https://raw.githubusercontent.com/google/metallb/v0.7.3/manifests/metallb.yaml

    kubectl apply -f - <<EOF
    apiVersion: v1
    kind: ConfigMap
    metadata:
      namespace: metallb-system
      name: config
    data:
      config: |
        address-pools:
        - name: default
          protocol: layer2
          addresses:
          - 192.168.1.100-192.168.1.250
    EOF


Install Avahi mDNS daemon on the master node

    apt-get install -y avahi-daemon


Install fork of ExternalDNS

    kubectl apply -f https://raw.githubusercontent.com/tsaarni/k8s-external-mdns/master/external-dns-with-avahi-mdns.yaml


ExternalDNS listens for externally published services and writes hosts
name to `/etc/avahi/hosts` for Avahi to pick up and serve using mDNS.
