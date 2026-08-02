#!/bin/bash

#this  is django deployment project using shell script

clone_code() {

     echo "Cloning Git repository..."

    if [ ! -d "django-notes-app" ]; then
        git clone https://github.com/LondheShubham153/django-notes-app.git
    fi

    cd django-notes-app || exit 1


}


installs_requirement() {

    echo "Checking requirements..."

    if command -v docker &>/dev/null; then
        echo "Docker is already installed."
    else
        sudo dnf install docker -y
    fi

    if command -v nginx &>/dev/null; then
        echo "Nginx is already installed."
    else
        sudo dnf install nginx -y
    fi
    
    if  command -v docker compose &>/dev/null; then
	echo "docker-compose is already installed."
    else
	sudo dnf install docker compose -y
    fi
}


require_restart() {
	sudo chown ramaram:docker /var/run/docker.sock
 	sudo systemctl enable --now  docker
	sudo systemctl enable --now  nginx
	sudo systemctl restart docker
}

deploy() {
	docker build -t notes-app .
	#docker run -d -p 8000:8000 notes-app:latest
	docker compose up -d
}



echo "----------------------------- deployment start -------------------------------------"
if ! clone_code;then
	echo "clone code is failde "
	exit 1

fi

if ! installs_requirement; then
	echo "installtion is failde"
	exit 1
fi

if ! require_restart; then
	echo "restart is faild"
	exit 1
fi

if ! deploy; then
	echo "deployment failde,mail admin"
	#sendmail 
	exit 1
fi

echo "----------------------------- deployment end ---------------------------------------"

