#!/bin/bash

# Function to clean up the build artifacts
clean() {
    echo "Cleaning up build artifacts..."
    sudo rm -rf ../laravel-store-rest-api
    sudo rm -rf ../next-store-ui
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
    # Start Next.js project
    cd ../next-store-ui
    yarn 

    # Start Laravel project
    cd ../laravel-store-rest-api
    composer install
    cp .env.demo .env
    php artisan key:generate
    php artisan migrate --seed
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

# Function to run the project
run() {
    # Trap to kill background processes on script exit
    trap 'kill %1; kill %2' SIGINT SIGTERM EXIT

    # Start Laravel project
    cd ../laravel-store-rest-api
    php artisan serve &  # Run in the background

    # Start Next.js project
    cd ../next-store-ui
    yarn build
    yarn start &  # Run in the background

    echo "CTRL+C to exit"

    # Wait for the background processes to finish
    wait
}

# Function to run the project in dev mode
dev() {
    # Trap to kill background processes on script exit
    trap 'kill %1; kill %2' SIGINT SIGTERM EXIT

    # Start Laravel project
    cd ../laravel-store-rest-api
    php artisan serve &  # Run in the background

    # Start Next.js project
    cd ../next-store-ui
    yarn run dev &  # Run in the background

    echo "CTRL+C to exit"
    
    # Wait for the background processes to finish
    wait
}

# Function to push the code
push() {
    # Push the code to the repository
    

    cd ../laravel-store-rest-api
    git add .
    git commit -m "$msg"
    git push

    cd ../next-store-ui
    git add .
    git commit -m "$msg"
    git push


    cd ../store-project-build
    git add .
    git commit -m "$msg"
    git push
}

# Get 1 argument
arg1=$1
# Get arg 2 or default to empty string
msg=${2:-''}

# Switch case for build options
case $arg1 in
    "run")
        # Run the projects
        run
        ;;
    "dev")
        # Run the projects
        dev
        ;;
    "retrieve")
        # Clone the repositories, install dependencies, and set up the environment
        retrieve
        ;;
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
    "push")
        # Push the code to the repository
        push
        ;;
    "help")
        # Display help information with explanations for each argument
        echo "  "
        echo "Usage: ./toolbox.sh [run|dev|retrieve|push|build|update|docker-build|fresh|help]"
        echo
        echo "Options:"
        echo "      run           |  Run the projects."
        echo "      dev           |  Run the projects in dev mode."
        echo "      retrieve      |  Clone the repositories, install dependencies, and set up the environment."
        echo "      push          |  Push the code to the repository."
        echo "      build         |  Retrieve and deploy the project."
        echo "      update        |  Pull the latest changes from the repositories and apply any updates."
        echo "      docker-build  |  Perform a Docker build process. Add your Docker build commands in the script."
        echo "      fresh         |  Clean up build artifacts and perform a fresh build."
        echo "      clean         |  Clean up build artifacts."
        echo "      help          |  Display this help information with details about each option."
        echo "  "
        ;;
    *)
        # Invalid option
        echo "  "
        echo "Invalid option: $arg1"
        echo "Usage: ./toolbox.sh [run|dev|retrieve|push|build|update|docker-build|fresh|help]"
        echo "  "
        ;;
esac

exit 0
