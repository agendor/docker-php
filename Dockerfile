FROM centos:7

ENV TERM linux

RUN  set -ex \
  && yum install -y epel-release python-setuptools \
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
      php-pecl-apc \
      php-pecl-igbinary \
      php-pecl-memcache \
      php-pecl-memcached \
      php-pecl-mongo \
      php-pgsql \
      php-process \
      php-soap \
      php-theseer-fDOMDocument \
      php-xml \
      wget \
      zlib-devel \
      openssl-devel \
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
  && echo "extension=newrelic.so" >> /etc/php.ini \
  && yum clean all

EXPOSE 80

CMD ["/usr/bin/supervisord", "--nodaemon", "--configuration=/etc/supervisord.conf"]
