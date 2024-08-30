#!/bin/bash

# Function to clean up the build artifacts
clean() {
    echo "Cleaning up build artifacts..."
    rm -rf ../laravel-store-rest-api
    rm -rf ../next-store-ui
}

# Function to build the project
retrieve() {
    # Clone the repository
    git clone https://github.com/ekinata/laravel-store-rest-api.git ../laravel-store-rest-api

    cd ../store-project-build
    git clone https://github.com/ekinata/next-store-ui.git ../next-store-ui

    echo "Retrieve completed successfully"
}

# Function to deploy the project
deploy() {
    # Add your deployment commands here
    cd ../next-store-ui
    yarn 
    yarn build

    yarn start &

    cd ../laravel-store-rest-api
    composer install
    cp .env.example .env
    php artisan key:generate
    php artisan migrate --seed

    php artisan serve &
}

# Function to update the project
update() {
    cd ../laravel-store-rest-api
    git pull
    composer install
    php artisan migrate

    cd ../store-project-build
    cd ../next-store-ui
    git pull
    yarn
}

# Docker build process
docker_build() {
    # Add your Docker build commands here
    docker-compose up -d --build
}

# Get 1 argument
arg1=$1

# Switch case for build options
case $arg1 in
    "build")
        # Clone the repositories, install dependencies, and set up the environment
        retrieve
        deploy
        ;;
    "update")
        # Pull the latest changes from the repositories and apply any updates
        update
        ;;
    "docker-build")
        # Perform the docker build process
        retrieve
        docker_build
        ;;
    "fresh")
        # Clean up build artifacts and perform a fresh build
        clean
        retrieve
        deploy
        ;;
    "clean")
        # Clean up build artifacts
        clean
        ;;
    "help")
        # Display help information with explanations for each argument
        echo "  "
        echo "Usage: ./build.sh [build|update|docker-build|fresh|help]"
        echo
        echo "Options:"
        echo "      build         |  Clone the repositories, install dependencies, and set up the environment."
        echo "      update        |  Pull the latest changes from the repositories and apply any updates."
        echo "      docker-build  |  Perform a Docker build process. Add your Docker build commands in the script."
        echo "      fresh         |  Clean up build artifacts and perform a fresh build."
        echo "      clean         |  Clean up build artifacts."
        echo "      help          |  Display this help information with details about each option."
        echo "  "
        ;;
    *)
        # Invalid option
        echo "Invalid option: $arg1"
        echo "Usage: ./build.sh [build|update|docker-build|fresh|help]"
        ;;
esac

exit 0