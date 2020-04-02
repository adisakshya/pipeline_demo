echo 'Running test docker image'
docker run --name test-image-container demo-app-test
echo 'Successfully ran test docker image'

echo 'Removing test docker image'
docker container stop test-image-container
docker rmi demo-app-test
echo 'Removed test docker image'