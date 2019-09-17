# Wordpress Staging Publisher

One command to duplicate the staging environment into its production environment.

## Getting started

![Console, Staging, and Production](docs/images/wordpress-staging-publisher.basic.png?raw=true "Console, Staging, and Production")

The three independent machines:
 - **Staging** - where an existing staging wordpress website was installed.
 - **Production** - where a copy of the production website will be installed.
 - **Console** - where the [Wordpress Staging Publisher](https://github.com/InternationalRiceResearchInstitute/wordpress-staging-publisher) was installed.

Provided that you have already set the [configurations](#configurations)... In your console, simply fire the statement:

```bash
/path/to/wordpress-staging-publisher/publi.sh
```

It should do the exhaustive work for you. The algorithm section below explains the inner workings of the tool.

## Algorithm

1. Zip the whole wordpress directory from the staging environment -- output is the `wordpress.zip`
2. Backup the database of the staging environment -- output is the `database.sql`
3. Download the files from the staging environment to the console
   - `wordpress.zip`
   - `database.sql`
4. Temporarily unzip the downloaded `wordpress.zip`
5. Search and replace the [`wp-config.php` file](https://wordpress.org/support/article/editing-wp-config-php/) with the values intended for the production environment
   - replace the value of `DB_HOST`
   - replace the value of `DB_USER`
   - replace the value of `DB_PASSWORD`
   - replace the value of `DB_NAME`
6. Zip back into the new `wordpress.zip`
7. Search and replace the `database.sql` file using the `base_site_url` of the staging with the value of `base_site_url` of the production. E.g. `http://staging.example.com` into `https://www.example.com`
8. Upload the prepared files to the production environment
   - `wordpress.zip`
   - `database.sql`
9. Unzip `wordpress.zip` to the wordpress directory of the production environment
10. Populate the database of the production environment using the `database.sql`

## Requirements

Just a bunch of pretty basic command-line tools which can checked by using the `which` command like so:

```bash
which zip
```

1. **Staging**
   - `zip`
   - `mysqldump`
   - `php`
2. **Console**
   - `ssh`
   - `zip`
   - `unzip`
   - `awk`
   - `grep`
   - `sed`
   - `tr`
   - `cut`
   - `xargs`
   - `php`
3. **Production**
   - `unzip`
   - `mysql`
   - `php`

If all are installed on those three machines, then you are good to go.

## File structure

Below should be the file structure to make the publisher working.

```
---/wordpress-staging-publisher
   |
   +--/config
   |  |
   |  +--/staging
   |  |  |
   |  |  +--install.conf
   |  |  |
   |  |  +--abel.pem
   |  |
   |  +--/production
   |     |
   |     +--install.conf
   |     |
   |     +--my.cnf
   |     |
   |     +--abel.pem
   |
   +--/baked
   |  |
   |  +--dump_helper.php
   |
   +--/prepared
   |  |
   |  +--/local
   |  |  |
   |  |  +--my.cnf.database.php
   |  |  |
   |  |  +--wp-config.search-and-replace.php
   |  |
   |  +--/remote
   |     |
   |     +--front_liner.staging.sh
   |     |
   |     +--front_liner.production.sh
   |     |
   |     +--file_generator.zip.sh
   |     |
   |     +--file_generator.unzip.sh
   |     |
   |     +--database_generator.sh
   |    
   +--publi.sh 
```

See the below section for customizing the configurations.

## Configurations

1. **Copy** the `config/staging/install.conf.sample` into `config/staging/install.conf` like so:
   ```bash
   cd /path/to/wordpress-staging-publisher
   cp config/staging/install.conf.sample config/staging/install.conf
   ```

   **install.conf** ([Documentation](#installconf))
   ```
   machine_username="abel"
   machine_hostname="staging.example.com"
   wordpress_dir="/var/www/html"
   base_site_url="http://staging.example.com"
   ```
   Then make necessary changes. 

2. **Put a copy** of an SSH key that can be used to access the staging machine inside the config directory `/path/to/wordpress-staging-publisher/config/staging` like so:
   ```bash
   cp /source/of/usable/staging.pem /path/to/wordpress-staging-publisher/config/staging/abel.pem
   ```
   It is important that the basename of the key file should match the `machine_username` value. E.g. *abel.pem*

3. **Copy** the `config/production/install.conf.sample` into `config/production/install.conf` like so:
   ```bash
   cd /path/to/wordpress-staging-publisher
   cp config/production/install.conf.sample config/production/install.conf
   ```

   **install.conf** ([Documentation](#installconf))
   ```
   machine_username="abel"
   machine_hostname="www.example.com"
   wordpress_dir="/var/www/html"
   base_site_url="https://www.example.com"
   ```
   Then make necessary changes.

4. **Put a copy** of an SSH key that can be used to access the Production machine inside the config directory `/path/to/wordpress-staging-publisher/config/production` like so:
   ```bash
   cp /source/of/usable/production.pem /path/to/wordpress-staging-publisher/config/production/abel.pem
   ```
   It is important that the basename of the key file should match the `machine_username` value. E.g. *abel.pem*

5. Copy the `config/production/my.cnf.sample` into `config/production/my.cnf` like so:
   ```bash
   cd /path/to/wordpress-staging-publisher
   cp config/production/my.cnf.sample config/production/my.cnf
   ```

   **my.cnf** ([Documentation](#mycnf))
   ```
   [mysql]
   host=hostname-here
   user=username-here
   password=password-here
   database=database-here
   ```

   Then make necessary changes.

### install.conf

#### `machine_username`
When you login to the staging machine using SSH, what username do you use? E.g. `ssh abel@staging.example.com`. Define this configuration by providing the value of that username. In this case, it is `abel`

#### `machine_hostname`
When you login to the staging machine using SSH, what hostname do you call it? E.g. `ssh abel@staging.example.com`. Define this configuration by providing the value of that hostname. In this case, it is `staging.example.com`

#### `wordpress_dir`
The full path of the directory of where wordpress was installed. E.g. `/var/www/html`. Define this configuration by providing the value of the full path.

#### `base_site_url`
Usually this is the URL of the homepage but without the ending slash `/` at the end of it. E.g. `http://staging.example.com` or `http://www.example.com`

### my.cnf

#### `host`
Hostname of the database server. E.g. `localhost`

#### `user`
Username of the database user that can access the database server. E.g. `abel`

#### `password`
Password of the database user that can access the database server. E.g. `c4!n`

#### `database`
Name of the database where the wordpress data will be stored.. E.g. `my_database`

## Installation setups
1. **Basic**

   ![Console, Staging, and Production](docs/images/wordpress-staging-publisher.basic.png?raw=true "Console, Staging, and Production")

   - Requires 3 independent machines for it to work.
   - The [Wordpress Staging Publisher](https://github.com/InternationalRiceResearchInstitute/wordpress-staging-publisher) was installed in an independent machine.

   See [full documentation](docs/installation-setups/basic)

2. **Staging as console**

   ![Staging as console, and Production](docs/images/wordpress-staging-publisher.staging-as-console.png?raw=true "Staging as console, and Production")

   - Requires only 2 independent machines for it to work.
   - The [Wordpress Staging Publisher](https://github.com/InternationalRiceResearchInstitute/wordpress-staging-publisher) was installed in the staging.

   See [full documentation](docs/installation-setups/staging-as-console)

3. **Production as console**

   ![Staging as console, and Production](docs/images/wordpress-staging-publisher.production-as-console.png?raw=true "Staging as console, and Production")

   - Requires only 2 independent machines for it to work.
   - The [Wordpress Staging Publisher](https://github.com/InternationalRiceResearchInstitute/wordpress-staging-publisher) was installed in the staging.

   See [full documentation](docs/installation-setups/production-as-console)

## License

Copyright (C) 2019  Abel Callejo, International Rice Research Institute (a.callejo@irri.org)

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see [https://www.gnu.org/licenses/gpl-3.0.html](https://www.gnu.org/licenses/gpl-3.0.html).
