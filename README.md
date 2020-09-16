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

2. Copy the `.env.sample` file to `.env` and edit its content to your liking.

3. Within the project directory, build the Docker images and containers:
    ```shell
    $ sh docker-build.sh
    ```
3. Browse to http://localhost:port/

If everything went fine, you should now have an instance of LP-WEB running into its own container. 
