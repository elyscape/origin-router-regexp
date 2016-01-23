FROM openshift/origin-haproxy-router

WORKDIR /var/lib/haproxy/conf
# First line switches to regular expression matching on map files with paths
# Second line locks map files with paths to match the beginning of the URI
RUN sed -i \
  -e '/os_\(reencrypt\|http_be\|edge_http_\(redirect\|be\|expose\)\)\.map/ s/map_beg/map_reg/' \
  -e 's/{{$cfg.Host}}{{$cfg.Path}} {{$idx}}/^&/' \
  haproxy-config.template

EXPOSE 80
ENV TEMPLATE_FILE=/var/lib/haproxy/conf/haproxy-config.template \
    RELOAD_SCRIPT=/var/lib/haproxy/reload-haproxy
ENTRYPOINT ["/usr/bin/openshift-router"]
