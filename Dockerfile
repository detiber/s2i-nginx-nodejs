FROM registry.access.redhat.com/rhscl/nodejs-4-rhel7
USER root

ENV NGINX_BASE_DIR /opt/rh/rh-nginx18/root
ENV NGINX_VAR_DIR /var/opt/rh/rh-nginx18

RUN yum repolist && \
    yum-config-manager --enable rhel-server-rhscl-7-rpms && \
    yum-config-manager --enable rhel-7-server-ose-3.1-rpms && \
    yum-config-manager --enable rhel-7-server-optional-rpms && \
    yum install -y rh-nginx18 && \
    yum install -y bzip2 && \
    yum install -y nss_wrapper && \
    yum clean all && \
    mkdir -p /opt/app-root/etc/nginx.conf.d /opt/app-root/run && \
    chmod -R a+rx  $NGINX_VAR_DIR/lib/nginx && \
    chmod -R a+rwX $NGINX_VAR_DIR/lib/nginx/tmp \
                   $NGINX_VAR_DIR/log \
                   $NGINX_VAR_DIR/run \
                   /opt/app-root/run
   
COPY ./etc/ /opt/app-root/etc
COPY ./.s2i/bin/ ${STI_SCRIPTS_PATH}

RUN cp /opt/app-root/etc/nginx.server.sample.conf /opt/app-root/etc/nginx.conf.d/default.conf \
 && chown -R 1001:1001 /opt/app-root

USER 1001

EXPOSE 8080

CMD ["usage"]
