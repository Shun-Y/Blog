#!/bin/bash

# confirm function
function confirm {
    MSG=$1
    while :
    do  
        echo -n "${MSG} [Y/N]: "
        read ans 
        case $ans in
            [yY]) return 1 ;;
            [nN]) return 0 ;;
        esac
    done
}

#make a branch for the task.
echo -n "Input task name\n"
read task
git checkout -b $task master

#wait for finishing task.
while (confirm "tell me when you finish editting\n"); do
    echo "finished?\n"
done

#commit branch
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa_github
git add . -A
echo -n "Input commit messages\n"
read commit_message
git commit -m "$commit_message"
git push -u origin $task

#wait for pull request 
while (confirm "tell me when pull request finished \n"); do
    echo "finished?\n"
done

#merge to master branch
git checkout master
git pull # To make sure master is up-to-date.
git pull origin $task # To merge the central repository’s copy of<TASK>
#check whether bug exists or not.
while (confirm "tell me you checked whether there exists bug\n"); do
    echo "finished?\n"
done
git push origin master # To push back to origin master

#push to docker repository
docker-compose run --rm --no-deps web stack clean && docker-compose run --rm --no-deps web stack build && docker-compose run --rm --no-deps web stack install
sudo docker-compose build --no-cache web
docker tag -f blog_web:latest shuny/blog_web:latest
docker images
docker login
docker push shuny/blog_web:latest
