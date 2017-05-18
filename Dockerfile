FROM centos:6

ENV TERM linux

RUN  set -ex \
  && yum install -y epel-release python-setuptools \
  && rpm -Uvh http://www.city-fan.org/ftp/contrib/yum-repo/city-fan.org-release-1-13.rhel6.noarch.rpm \
  && yum install -y \
      curl \
      mhash \
      mysql-libs \
      nginx \
      php \
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
  && yum -y update \
  && localedef -i en_US -f UTF-8 en_US.UTF-8 \
  && sed -i "s/short_open_tag = .*/short_open_tag = On/" /etc/php.ini \
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
  && yum clean all \
  && rm -rf \
      /sbin/sln \
      /usr/{share/{man,doc,info,cracklib,i18n},{lib,lib64}/gconv,bin/localedef} \
      /{root,tmp,var/cache/{ldconfig,yum}}/*

# New Relic agent
RUN  set -ex \
  && export NR_INSTALL_SILENT=true \
  && rpm -Uvh http://yum.newrelic.com/pub/newrelic/el5/x86_64/newrelic-repo-5-3.noarch.rpm \
  && yum install -y newrelic-php5 \
  && newrelic-install install \
  && yum clean all \
  && rm -rf \
      /sbin/sln \
      /usr/{share/{man,doc,info,cracklib,i18n},{lib,lib64}/gconv,bin/localedef} \
      /{root,tmp,var/cache/{ldconfig,yum}}/*

EXPOSE 80

CMD ["/usr/bin/supervisord", "--nodaemon", "--configuration=/etc/supervisord.conf"]
