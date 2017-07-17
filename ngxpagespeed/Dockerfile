FROM centos:6

ENV TERM linux

RUN  set -ex \
  && yum -y install epel-release python-setuptools \
  && rpm -Uvh http://www.city-fan.org/ftp/contrib/yum-repo/city-fan.org-release-1-13.rhel6.noarch.rpm \
  && yum -y install \
      curl \
      mhash \
      mysql-libs \
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
  && mkdir -p \
      /var/log/supervisor/ \
      /etc/php.secrets.d/ \
      /run/nginx/ \
  && yum -y install \
        bzip2-devel \
        file-devel \
        gd-devel \
        GeoIP-devel \
        geoip-devel \
        glib2-devel \
        jansson-devel \
        libcap-ng-devel \
        libcap-ng-devel \
        libcurl-devel \
        libgssapi-devel \
        libnet-devel \
        libnet-devel \
        libnetfilter_queue-devel \
        libnl-devel \
        libpcap-devel \
        libunwind \
        libxml2-devel \
        libxslt-devel \
        libyaml-devel \
        lm_sensors-libs \
        lua-devel \
        luajit \
        luajit-devel \
        ncurses-devel \
        net-snmp-libs \
        nss-devel \
        pcre-devel \
        popt-devel \
        readline-devel \
        unzip \
        wget \
        zlib-devel \
        openssl-devel \
  && curl -f -L -sS -o ./nginxpagespeed_install https://ngxpagespeed.com/install \
  && sed -r -i \
        -e 's/sudo\s?//g' \
        -e 's/yum install/yum -y install/g' \
        -e 's/buildir/builddir/g' \
      ./nginxpagespeed_install \
  && chmod +x ./nginxpagespeed_install \
  && export ADDITIONAL_NGINX_CONFIGURE_ARGUMENTS=" \
        --prefix=/usr/share/nginx \
        --sbin-path=/usr/sbin/nginx \
        --modules-path=/usr/lib64/nginx/modules \
        --conf-path=/etc/nginx/nginx.conf \
        --error-log-path=/var/log/nginx/error.log \
        --http-log-path=/var/log/nginx/access.log \
        --pid-path=/var/run/nginx.pid \
        --lock-path=/var/lock/subsys/nginx \
        --with-file-aio \
        --with-http_ssl_module \
        --with-http_v2_module \
        --with-http_realip_module \
        --with-http_addition_module \
        --with-http_xslt_module=dynamic \
        --with-http_image_filter_module=dynamic \
        --with-http_geoip_module=dynamic \
        --with-http_sub_module \
        --with-http_dav_module \
        --with-http_flv_module \
        --with-http_mp4_module \
        --with-http_gunzip_module \
        --with-http_gzip_static_module \
        --with-http_random_index_module \
        --with-http_secure_link_module \
        --with-http_degradation_module \
        --with-http_slice_module \
        --with-http_stub_status_module \
        --with-mail=dynamic \
        --with-mail_ssl_module \
        --with-pcre \
        --with-pcre-jit \
        --with-stream=dynamic \
        --with-stream_ssl_module \
        --with-debug \
        --with-cc-opt='-O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector --param=ssp-buffer-size=4 -m64 -mtune=generic' \
        --with-ld-opt=' -Wl,-E' \
    " \
  && ./nginxpagespeed_install -y \
        --nginx-version latest --ngx-pagespeed-version 1.12.34.2 \
  && yum -y remove *-devel \
  && yum -y update \
  && yum clean all

# New Relic agent
RUN  set -ex \
  && export NR_INSTALL_SILENT=true \
  && rpm -Uvh http://yum.newrelic.com/pub/newrelic/el5/x86_64/newrelic-repo-5-3.noarch.rpm \
  && yum -y install newrelic-php5 \
  && newrelic-install install \
  && yum clean all

RUN  set -ex \
        yum -y install easy_install \
        && easy_install supervisor supervisor-stdout \
        && echo_supervisord_conf > /etc/supervisord.conf

RUN echo -e "[include]\nfiles = /etc/supervisor/conf.d/*.conf" >> /etc/supervisord.conf

EXPOSE 80

CMD ["/usr/bin/supervisord", "--nodaemon", "--configuration=/etc/supervisord.conf"]
