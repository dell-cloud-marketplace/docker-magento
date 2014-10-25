FROM dell/lamp-base:v0.1
MAINTAINER Dell Cloud Market Place <Cloud_Marketplace@dell.com>

RUN DEBIAN_FRONTEND=noninteractive apt-get -y install php5-mcrypt
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install openssh-server
RUN php5enmod mcrypt

# Add image configuration and scripts
ADD start-sshd.conf /etc/supervisor/conf.d/start-sshd.conf


# OpenSSH configuration
RUN mkdir -p /var/run/sshd
RUN echo "root:admin123" | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Config to enable .htaccessi and enable Magento portal
ADD apache_default /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite

#Get Magento files
RUN wget http://www.magentocommerce.com/downloads/assets/1.9.0.1/magento-1.9.0.1.tar.gz
RUN mv magento-1.9.0.1.tar.gz /tmp
RUN cd /tmp && tar -zxvf magento-1.9.0.1.tar.gz
RUN mv /tmp/magento /app -f

RUN chmod -R o+w /app/media /app/var
RUN chmod o+w /app/app/etc
RUN cd /app && wget http://sourceforge.net/projects/adminer/files/latest/download?source=files
RUN cd /app && mv download\?source\=files adminer.php

RUN mkdir -p /app && rm -fr /var/www/html && ln -s /app /var/www/html

EXPOSE 80 3306 22 443
CMD ["/run.sh"]
