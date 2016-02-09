FROM openshift/origin-haproxy-router:v1.1.2

# First line switches to regular expression matching on map files with paths
# Second line locks map files with paths to match the beginning of the URI
RUN sed -i \
  -e '/os_\(reencrypt\|http_be\|edge_http_\(redirect\|be\|expose\)\)\.map/ s/map_beg/map_reg/' \
  -e 's/{{$cfg.Host}}{{$cfg.Path}} {{$idx}}/^&/' \
  /var/lib/haproxy/conf/haproxy-config.template
