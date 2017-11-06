# Docker image with demo data  alpine 3.4

FROM java:8-jdk-alpine
RUN echo "http://mirrors.aliyun.com/alpine/v3.4/main" > /etc/apk/repositories \
&& echo "http://mirrors.aliyun.com/alpine/v3.4/community" >> /etc/apk/repositories
ENV SCIPIO_VERSION 1.14.3 
ENV SCIPIO_TGZ_URL https://github.com/ilscipio/scipio-erp/archive/v$SCIPIO_VERSION.tar.gz
ENV SCIPIO_HOME /opt/scipio

ENV PATH $SCIPIO_HOME/bin:$PATH
RUN mkdir -p "$SCIPIO_HOME"
WORKDIR $SCIPIO_HOME
##COPY ./scipio-erp-1.14.3.tar.gz /opt/scipio

RUN set -x \
	&& apk add --no-cache --virtual .fetch-deps \
		ca-certificates \
		tar \
		bash \
		vim \
		openssl \	
	&& wget -O scipio-erp-1.14.3.tar.gz "$SCIPIO_TGZ_URL" \
	&& tar -xvf scipio-erp-1.14.3.tar.gz --strip-components=1 \
	&& rm scipio-erp-1.14.3.tar.gz* \
    && sh ant load-demo

EXPOSE 8080 8443 8983
CMD ["sh", "./start.sh"]