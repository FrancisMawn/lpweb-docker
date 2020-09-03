# LP-WEB Docker
The intent of this project is to allow for an easy deployment of a [LP-WEB](https://dev.azure.com/CSPS-EFPC-UX/learning-platform/_git/lp-web) instance on a web server or local environment using Docker containers.

**Prerequisites**

- You should have [Docker Engine](https://docs.docker.com/engine/install/) already installed
- You should have [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) already installed

---

## Setup the Docker images and containers
- Clone this repository:  
    `cd /path/to/your/projects`  
    `git clone https://github.com/FrancisMawn/lpweb-docker.git`
- Within the project directory, build the Docker images and containers:
    `docker-compose up -d`  
- Browse to http://localhost/

If everything went fine, you should now have an instance of LP-WEB running into its own container. 

---

## Install LP-WEB
The first time you instantiate the container, you will need to install the application.  
Follow these steps:

- Open a shell to run commands inside the application container:  
    `docker exec -ti lpweb-docker_web_1 sh`  
- Run the CraftCMS installation command:  
    `./craft install`  
- Run the content migrations:  
    `./craft migrate/all`  
- Import course entries:  
    `./craft feed-me/feeds/run --id=1,2`

The application is now installed and configured, ready to be used!

---

## Update LP-WEB

... To be continued
