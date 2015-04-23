FROM dell/lamp-base:1.1
MAINTAINER Dell Cloud Market Place <Cloud_Marketplace@dell.com>

# Do an update of the base packages.
RUN apt-get update --fix-missing

RUN DEBIAN_FRONTEND=noninteractive \ 
    apt-get -y install \
        php5-mcrypt \
        openssh-server \
        php5-curl \
        php5-gd

RUN php5enmod mcrypt

# Update Apache permissions.
RUN sed -i 's/AllowOverride Limit/AllowOverride All/g' \
    /etc/apache2/sites-available/000-default.conf

# Clean the application folder.
RUN rm -fr /var/www/html

# Get the Magento files
RUN wget http://www.magentocommerce.com/downloads/assets/1.9.1.0/magento-1.9.1.0.tar.gz
RUN mv magento-1.9.1.0.tar.gz /tmp
RUN cd /tmp && tar -zxvf magento-1.9.1.0.tar.gz
RUN mv /tmp/magento /app

# Add scripts and make them executable.
COPY run.sh /run.sh
RUN chmod +x /*.sh

# Add volumes for MySQL and the application.
VOLUME ["/var/lib/mysql", "/var/www/html"]

EXPOSE 80 3306 443

CMD ["/run.sh"]
