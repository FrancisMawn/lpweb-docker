# LP-WEB Docker
The intent of this project is to allow for an easy deployment of a [LP-WEB](https://dev.azure.com/CSPS-EFPC-UX/learning-platform/_git/lp-web) instance on a web server or local environment using Docker containers.

**Prerequisites**

- You should have [Docker Engine](https://docs.docker.com/engine/install/) already installed
- You should have [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) already installed

---

## Setup the Docker images and containers
1. Clone this repository:
    ```shell
    $ cd /path/to/your/projects
    $ git clone https://github.com/FrancisMawn/lpweb-docker.git`
    ```
2. Within the project directory, build the Docker images and containers:
    ```shell
    $ docker-compose up -d
    ```
3. Browse to http://localhost/

If everything went fine, you should now have an instance of LP-WEB running into its own container. 

---

## Install LP-WEB
The first time you instantiate the container, you will need to install the application.  
Follow these steps:

1. Open a shell to run commands inside the application container:
    ```shell
    $ docker exec -ti lpweb-docker_web_1 sh
    ```
2. Run the CraftCMS installation command:
    ```shell
    $ ./craft install
    ```
3. Run the content migrations:
    ```shell
    $ ./craft migrate/all
    ```
4. Import the course entries (this may take a while):
    ```shell
    $ ./craft feed-me/feeds/run --id=1,2
    ```
The application is now installed and configured, ready to be used!

---

## Update LP-WEB

... To be continued
