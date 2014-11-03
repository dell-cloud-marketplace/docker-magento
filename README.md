# docker-magento
This image installs [Magento](http://magento.com/), an open-source content management system for e-commerce web sites.

## Components
The stack comprises the following components:

Name       | Version                   | Description
-----------|---------------------------|------------------------------
Magento    | 1.9.0.1 | E-commerce content management system
Ubuntu     | see [docker-lamp-base](https://github.com/dell-cloud-marketplace/docker-lamp-base)                    | Operating system
MySQL      | see [docker-lamp-base](https://github.com/dell-cloud-marketplace/docker-lamp-base)      | Database
Apache     | see [docker-lamp-base](https://github.com/dell-cloud-marketplace/docker-lamp-base)      | Web server
PHP        | see [docker-lamp-base](https://github.com/dell-cloud-marketplace/docker-lamp-base)      | Scripting language

## Usage

### 1. Start the Container
If you wish to create data volumes, which will survive a restart or recreation of the container, please follow the instructions in [Advanced Usage](#advanced-usage).

#### A. Basic Usage
Start your container with:

 - Ports 80, 443 (Apache Web Server) and 3306 (MySQL) exposed.
 - A named container (**magento**).

As follows:

```no-highlight
sudo docker run -d -p 80:80 -p 443:443 -p 3306:3306 --name magento dell/magento
```

<a name="advanced-usage"></a>
#### B. Advanced Usage
Start your container with:

- Ports 80, 443 (Apache Web Server) and 3306 (MySQL) exposed.
- Two data volumes (which will survive a restart or recreation of the container). The MySQL data is available in **/data/mysql** on the host. The PHP application files are available in **/app** on the host.
- A named container (**magento**).

As follows:

```no-highlight
sudo docker run -d -p 80:80 -p 3306:3306 -p 443:443 -v /app:/var/www/html \
-v /data/mysql:/var/lib/mysql --name lamp dell/magento
```

### 2. Check the Log Files

Check the logs for the randomly generated **admin** and **magento** MySQL passwords:

```no-highlight
sudo docker logs magento
```

Look for output similar to the following text:

```no-highlight
========================================================================
You can now connect to this MySQL Server using:

    mysql -uadmin -pMYHU4RejDh0q -h<host> -P<port>

Please remember to change the above password as soon as possible!
MySQL user 'root' has no password but only allows local connections
========================================================================
=> Waiting for confirmation of MySQL service startup
========================================================================

MySQL magento user password: ooVoh7aedael

========================================================================
```

Make a secure note of:

* The admin user password (in this case **MYHU4RejDh0q**)
* The magento user password (in this case **ooVoh7aedael**)

You will need the **magento** user password, shortly, so please test the connection to MySQL:

```no-highlight
mysql -u magento -pooVoh7aedael -h127.0.0.1 -P3306
```

### 3. Configure Magento
Access the container from your browser:

```no-highlight
http://<ip address>
```

OR
```no-highlight
https://<ip address>
```

**We strongly recommend that you connect via HTTPS**, for this step, and all subsequent administrative tasks, if the container is running outside your local machine (e.g. in the Cloud). Your browser will warn you that the certificate is not trusted. If you are unclear about how to proceed, please consult your browser's documentation on how to accept the certificate.

#### Step 1: Welcome to Magento's Installation Wizard!

Read the license, and if you accept:

* Check **I agree to the above terms and conditions**.
* Click on **Continue**.

#### Step 2: Localization
Choose your settings for:

* Locale
* Time Zone
* Default Currency

Click on **Continue**.

#### Step 3: Configuration
Complete the required information:

* Database Type: **MySQL**
* Host: **localhost**
* Database Name: **magento**
* User Name: **magento**
* User Password *<value read from the logs, earlier>*
* Tables Prefix: (optional)

Next, please:

* Check **Use Secure URLs**.
* Check **Run admin interface with SSL**.

Click on **Continue**.

#### Step 4: Create Admin Account
Provide the following details for the **admin** account:

* First Name
* Last Name
* Email
* Username
* Password / Confirm Password

Click on **Continue**.

### Step 5: You're All Set!
Make a secure note of your encryption key (near the bottom of the page).

You may wish to complete the survey.

Next, click on **Go to Backend**, and login with your admin name and password.

## Some Housekeeping

### Remove Old Messages
After you log in, you will see message (at the top right hand side of the screen) saying: "You have 1 critical, 5 major, 19 minor and 56 notice unread message(s)." Some of these messages date back to 2008.

Click on link **Go to messages**. From there, click on **Select All** (LHS, near the top), select action **Remove** and click on **Submit** (RHS, near the top).

### Set the Unsecure URL
Select option **System -> Configuration -> Web -> Unsecure**. Change the Base URL from **https** to **http**. If you don't do this you will get an error when upload images.

## Reference

### Image Details

Inspired by [ilampirai/magentoone](https://github.com/ilampirai/magentoone)

Pre-built Image | [https://registry.hub.docker.com/u/dell/magento](https://registry.hub.docker.com/u/dell/magento) 
