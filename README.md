# OpenShift HAProxy Router with Regular Expression Support
This image is an OpenShift Router - it connects on an [OpenShift Origin](https://github.com/openshift/origin) installation and begins serving HTTP(s) proxy routes for applications hosted on the OpenShift PaaS. It's based on [the stock Origin HAProxy router](https://hub.docker.com/r/openshift/origin-haproxy-router/), with added support for regular expressions in the paths.

## Running the router
Take the image above and run it anywhere where the networking allows the container to reach other pods. Only notable requirement is that the port 80 needs to be exposed to the node, so that DNS entries can point to the host/node where the router container is running.

    $ docker run --rm -it -p 80:80 elyscape/origin-haproxy-router-regexp -master $kube-master-url

example of kube-master-url : http://10.0.2.15:8080
