# Wordpress Staging Publisher

One command to duplicate the staging environment into its production environment.

## Getting started

Provided that you have already set the configurations...

In your command line, simply fire the statement:

```bash
/path/to/publi.sh
```

It should do the exhaustive work for you.

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

Just a bunch of pretty much basic bash tools which you can check by using the `which` command like so:

```bash
which zip
```

1. Staging
   - zip
   - mysqldump
   - php
2. Console
   - zip
   - unzip
   - awk
   - grep
   - sed
   - tr
   - cut
   - xargs
   - php
3. Production
   - unzip
   - mysql
   - php

If all is installed, then you are good to go.

## Configuration

1. Copy the `config/staging/install.conf.sample` into `config/staging/install.conf` and make neccessary changes
   ```bash
   cd /path/to/wordpress-staging-publisher
   cp config/staging/install.conf.sample config/staging/install.conf
   ```

   **install.conf**
   ```bash
   machine_username="abel"
   machine_hostname="staging.example.com"
   wordpress_dir="/var/www/html"
   base_site_url="http://staging.example.com"
   ```
   For more details, please see the [install.conf documentation](#install-conf) below.

2. Put a copy of an SSH key that can be used to access the staging machine inside the config directory `/path/to/wordpress-staging-publisher/config/staging`
   ```bash
   cp /source/staging.pem /path/to/wordpress-staging-publisher/config/staging/abel.pem
   ```
   It is important that the basename of the key should match the `machine_username` value. E.g. *abel.pem*


### install.conf

**machine_username** - When you login to the staging machine using SSH, what username do you use? E.g. `ssh abel@staging.example.com`. Define this configuration by providing the value of that username. In this case, it is `abel`
**machine_hostname** - When you login to the staging machine using SSH, what hostname do you call it? E.g. `ssh abel@staging.example.com`. Define this configuration by providing the value of that hostname. In this case, it is `staging.example.com`
