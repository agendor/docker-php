FROM centos:6

ENV TERM linux

RUN  set -ex \
  && yum install -y epel-release python-setuptools \
  && rpm -Uvh http://www.city-fan.org/ftp/contrib/yum-repo/city-fan.org-release-1-13.rhel6.noarch.rpm \
  && yum install -y \
      curl \
      gcc \
      gcc-c++ \
      make \
      openssl-devel \
      mhash \
      mysql-libs \
      nginx \
      pcre-devel \
      php \
      php-devel \
      php-bcmath \
      php-cli \
      php-cgi \
      php-common \
      php-curl \
      php-dba \
      php-fpm \
      php-gd \
      php-imap \
      php-json \
      php-mbstring \
      php-mcrypt \
      php-mysql \
      php-odbc \
      php-pdo \
      php-pear \
      php-pecl-igbinary \
      php-pecl-memcache \
      php-pecl-memcached \
      php-pecl-mongo \
      php-pecl-zendopcache \
      php-pgsql \
      php-process \
      php-soap \
      php-theseer-fDOMDocument \
      php-xml \
      wget \
      zlib-devel \
      openssl-devel \
  && cd /tmp \
  && curl -LO https://github.com/edenhill/librdkafka/archive/master.tar.gz \
  && tar xzvf master.tar.gz \
  && cd librdkafka* \
  && ./configure \
  && make \
  && make install \
  && rm -rf librdkafka* \
  && yum -y update \
  && localedef -i en_US -f UTF-8 en_US.UTF-8 \
  && pecl install rdkafka \
  && sed -i "s/short_open_tag = .*/short_open_tag = On/" /etc/php.ini \
  && echo "extension=rdkafka.so" >> /etc/php.ini \
  && easy_install \
      supervisor \
      supervisor-stdout \
  && echo -e "[include]\nfiles = /etc/supervisor/conf.d/*.conf" >> /etc/supervisord.conf \
  && mkdir -p \
      /etc/nginx/ \
      /run/nginx/ \
      /var/log/supervisor/ \
      /etc/php.secrets.d/ \
      /web/agendor-web/ \
  && yum clean all

# New Relic agent
RUN  set -ex \
  && export NR_INSTALL_SILENT=true \
  && rpm -Uvh http://yum.newrelic.com/pub/newrelic/el5/x86_64/newrelic-repo-5-3.noarch.rpm \
  && yum install -y newrelic-php5 \
  && newrelic-install install \
  && yum clean all

EXPOSE 80

CMD ["/usr/bin/supervisord", "--nodaemon", "--configuration=/etc/supervisord.conf"]
