###Deploy to test environment

#Circle CI Script for test
docker-machine start test #activate test machine
docker-machine eval $(docker-machine env test) #point at test machine
docker-compose -f test.yml pull web
docker-compose -f test.yml up --no-deps -d
#Check or return test result.
#If test result is True, deproy to production(staging)

docker-machine start production
docker-machine eval $(docker-machine env production) #point at test machine
docker-compose -f production.yml kill web
docker-compose -f production.yml rm -f -v web
docker-compose -f production.yml pull web
docker-compose -f production.yml up --no-deps -d
