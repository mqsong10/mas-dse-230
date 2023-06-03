$IMAGE_VERSION="latest"
$ID="chaitanyaanimesh"
$LABEL="jupyter-spark"
$IMAGE="${ID}/${LABEL}"

try { $has_docker = $(docker --version) }
Catch { "Docker is not installed. Download and install Docker from https://docs.docker.com/desktop/windows/install/"; exit; }

echo "$has_docker installed"

$is_running = & docker ps -q 2>&1 | Out-String
if ($is_running -like "docker.exe : error during connect*")
{
    echo "Docker is not running. Please start docker on your computer and re-run this script"
    exit
}

$available=$(docker images -q ${IMAGE}:${IMAGE_VERSION})
if ($available -eq $null)
{
    echo "Downloading the ${LABEL}:${IMAGE_VERSION} computing environment"
    docker logout
    docker pull ${IMAGE}:${IMAGE_VERSION}
}

$BUILD_DATE=$(docker inspect -f '{{.Created}}' ${IMAGE}:${IMAGE_VERSION})

echo "-----------------------------------------------------------------------"
echo "Starting the ${LABEL} computing environment"
echo "Build date: ${BUILD_DATE}"
echo "Base dir. /home/work: ${PWD}"

try { docker run --rm -it --init -p 127.0.0.1:8888:8888 -p 127.0.0.1:4040:4040 -p 127.0.0.1:4041:4041 -p 127.0.0.1:8787:8787 -p 127.0.0.1:8788:8788 -v ${PWD}:/home/work ${IMAGE}:${IMAGE_VERSION} }
Catch 
{
    echo "-----------------------------------------------------------------------"
    echo "It seems there was a problem starting the docker container. Please"
    echo "report the issue and add a screenshot of any messages shown on screen."
    echo "Press [ENTER] to continue"
    echo "-----------------------------------------------------------------------"
    exit
}