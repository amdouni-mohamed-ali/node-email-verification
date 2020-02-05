# Node Email Verification

User registration is a process in every web application. To secure the way of user registration and avoid spam we will implement a verification process
by sending a token to the user email address after signing up and waiting for his confirmation.

The way this works is as follows:

- After signing up, we will send an URL containing a token to the user email address and save his account temporarily
- when the URL is accessed, the user account will be confirmed and he can login to the app

To implement this solution we have used these technologies :

- [Node JS](https://nodejs.org/en/) - Node.js® is a JavaScript runtime built on Chrome's V8 JavaScript engine.
- [Express JS](https://expressjs.com/) - Used to create the routes of our application
- [bcryptjs](https://www.npmjs.com/package/bcryptjs) - Used to hash passwords of our users after registration
- [jsonwebtoken](https://www.npmjs.com/package/jsonwebtoken) - Used to manipulate tokens generated by our app
- [Mysql](https://www.mysql.com/fr/) - Used to store users and tokens
- [nodemailer](https://nodemailer.com/) - This node module is used to facilitate the sending of emails
- [sendgrid](https://sendgrid.com/) - This the platform used to deliver emails
- [Pug](https://pugjs.org/api/getting-started.html) - This is a node template engine
- [nodemon](https://www.npmjs.com/package/nodemon) - This is a node dev module. It will automatically restart the node application when file changes
- [docker](https://www.docker.com/) - As we will not install mysql on ou local machines. We'll use docker to create a dev environment for our app

To have at our database structure, check the `schema.sql` script under the `docker/sql` directory. This script will be executed the first time we run our docker environment.

## Development prerequisites

for development, you will need :

### Docker

In order to run this application as a container you'll need docker installed.

- [Windows](https://docs.docker.com/windows/started)
- [OS X](https://docs.docker.com/mac/started/)
- [Linux](https://docs.docker.com/linux/started/)

### Node

You need to install node in your environment to build and run the application.

[Node](https://nodejs.org/en/) is really easy to install & now include [NPM](https://npmjs.org/).
You should be able to run the following command after the installation procedure
below.

    $ node --version
    v0.10.24

    $ npm --version
    1.3.21

### SendGrid

You need to create a send grid account to send emails to users of the app. You can create a free account from here :

- https://signup.sendgrid.com/

Then you have to create a new api key to be used after in the app. Check this link to create a new one :

- https://sendgrid.com/docs/ui/account-and-settings/api-keys/#creating-an-api-key

When creating this api key, choose Full Access as permission.

After generating it, use it to replace the environment variable named `SENDGRID_API_KEY` in the `docker-compose-yml` file and don't share is on the net of course.

## Install

Checkout the project :

    $ git clone https://github.com/amdouni-mohamed-ali/node-email-verification.git
    $ cd node-email-verification

As we will not install a mysql database on our local machine. We will use a mysql docker image. Check the `docker-compose-yml` and you'll find that we are using 3 containers :

- node-app : which is ou app
- mysql : the used database
- adminer: (formerly phpMinAdmin) is a GUI to manipulate our database

We are defining a secret to generate our tokens. its name is `JWT_SECRET` and you can change it if you want to.

## Run/Stop the app

To start the docker environment, run this command :

    $ docker-compose up --build

Well, the first time you run this command you have to wait about 10 minutes to setup the database :

Wait for these logs :

```log
mysql       | 2020-02-04T15:40:39.855273Z 0 [Warning] CA certificate ca.pem is self signed.
mysql       | 2020-02-04T15:40:40.206740Z 1 [Warning] root@localhost is created with an empty password ! Please consider switching off the --initialize-insecure option.
|
|
|
mysql       | 2020-02-04T15:31:25.379440Z 0 [Note] mysqld: ready for connections.
|
|
mysql       | 2020-02-04 15:31:43+00:00 [Note] [Entrypoint]: Creating database db
mysql       | 2020-02-04 15:31:43+00:00 [Note] [Entrypoint]: Creating user user
mysql       | 2020-02-04 15:31:43+00:00 [Note] [Entrypoint]: Giving user user access to schema db
mysql       | 2020-02-04 15:31:43+00:00 [Note] [Entrypoint]: /usr/local/bin/docker-entrypoint.sh: running /docker-entrypoint-initdb.d/schema.sql
|
|
|
mysql       | 2020-02-04 15:43:21+00:00 [Note] [Entrypoint]: Database files initialized
mysql       | 2020-02-04 15:43:21+00:00 [Note] [Entrypoint]: Starting temporary server
mysql       | 2020-02-04 15:43:21+00:00 [Note] [Entrypoint]: Waiting for server startup
|
|
mysql       | 2020-02-04T15:43:55.339162Z 0 [Note] mysqld: ready for connections.
mysql       | Version: '5.7.28'  socket: '/var/run/mysqld/mysqld.sock'  port: 3306  MySQL Community Server (GPL)
```

As we can see the database is ready now for connections.

To check the database status, use adminer to connect to it :

![adminer](https://user-images.githubusercontent.com/16627692/73834477-16f23180-480c-11ea-9d00-a11b76f10801.png)

The password is : password

To stop the app you can simply run this command :

    $ docker-compose down

Each time you change the project dependencies or the schema.sql file you have to delete the app volumes and rerun the app :

    $ docker-compose down
    $ docker-compose rm
    $ docker volume prune

## Simple Test

In this section we will show you how the app works by making a registration scenario.

Check the database content (USERS and TOKENS tables) before continuing :

![adminer_add_user](https://user-images.githubusercontent.com/16627692/73835712-2bcfc480-480e-11ea-9437-01e5f7029b63.jpg)

![adminer_add_token](https://user-images.githubusercontent.com/16627692/73835628-017e0700-480e-11ea-9062-2a8ac3c6d7c7.png)

Go to the registration page and create a new account :

- [http://localhost:3000/signup](http://localhost:3000/signup)

![signup](https://user-images.githubusercontent.com/16627692/73835246-5ec58880-480d-11ea-8e85-dcf996676300.jpg)

![after_signup](https://user-images.githubusercontent.com/16627692/73835504-c5e33d00-480d-11ea-9491-b442efabbaa3.png)

Now check your email address, you will find a new message :

![confirmation_email](https://user-images.githubusercontent.com/16627692/73835768-44d87580-480e-11ea-9409-73fb9973afe1.png)

Copy/paste the link in your browser and click enter. The verification process will be triggered anf if every thing is OK you will be redirected
to the login page :

![login](https://user-images.githubusercontent.com/16627692/73836063-c6300800-480e-11ea-87dc-f183eaeccb1f.png)

Check the database and you'll find that your account has beed verified :

![adminer_add_token_after](https://user-images.githubusercontent.com/16627692/73836178-faa3c400-480e-11ea-89f2-9d55d909b0d4.png)

The token confirmation data has been updated and the request host and user agent also.

![adminer_add_user_after](https://user-images.githubusercontent.com/16627692/73836308-3b034200-480f-11ea-905f-ba90cb049132.jpg)

And the user account has been confirmed.

Now we can access the app via the login page :

- [http://localhost:3000/login](http://localhost:3000/login)

![dashboard](https://user-images.githubusercontent.com/16627692/73836400-74d44880-480f-11ea-883f-c799c5006cfb.png)

## Authors

- Mohamed Ali AMDOUNI
