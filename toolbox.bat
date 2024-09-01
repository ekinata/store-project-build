@echo off

REM #################################
REM Note from developer:
REM #################################
REM This script is a simple build tool for managing the Laravel and Next.js projects.
REM I know it's not perfect, but it gets the job done.
REM In Bash, I would use a case statement. But in Windows batch scripts, 
REM I have to use if-else and in batch functions are not really reliable 
REM so i use it like this as a quick solution.
REM Feel free to modify it to suit your needs.
REM #################################


REM Repo addresses:
REM Laravel:
set api_repo=https://github.com/ekinata/laravel-store-rest-api.git
REM Next.js:
set ui_repo=https://github.com/ekinata/next-store-ui.git

REM Get 1 argument
set arg1=%1

REM Switch case for build options
if "%arg1%"=="run" (
    REM Run the projects
    REM Trap to kill background processes on script exit
    REM Start Laravel project
    cd ..\laravel-store-rest-api
    start /b php artisan serve

    REM Start Next.js project
    cd ..\next-store-ui
    yarn build
    start /b yarn start

    echo CTRL+C to exit

    REM Wait for the background processes to finish
    pause
    exit /b 0
) else if "%arg1%"=="dev" (
    REM Run the projects in dev mode
    REM Trap to kill background processes on script exit
    REM Start Laravel project
    cd ..\laravel-store-rest-api
    start /b php artisan serve

    REM Start Next.js project
    cd ..\next-store-ui
    start /b yarn run dev

    echo CTRL+C to exit

    REM Wait for the background processes to finish
    pause
    exit /b 0
) else if "%arg1%"=="retrieve" (
    REM Clone the repositories, install dependencies, and set up the environment
    REM Clone the repository
    mkdir ..\laravel-store-rest-api
    git clone %api_repo% ..\laravel-store-rest-api

    mkdir ..\next-store-ui
    git clone %ui_repo% ..\next-store-ui

    echo Retrieve completed successfully
    exit /b 0
) else if "%arg1%"=="build" (
    REM Clone the repositories, install dependencies, and set up the environment
    REM Clone the repository
    mkdir ..\laravel-store-rest-api
    git clone %api_repo% ..\laravel-store-rest-api

    mkdir ..\next-store-ui
    git clone %ui_repo% ..\next-store-ui

    echo Retrieve completed successfully

    REM Start Next.js project
    cd ..\next-store-ui
    yarn

    REM Start Laravel project
    cd ..\laravel-store-rest-api
    composer install
    copy .env.demo .env
    php artisan key:generate
    php artisan migrate --seed
    exit /b 0
) else if "%arg1%"=="update" (
    REM Pull the latest changes from the repositories and apply any updates
    cd ..\laravel-store-rest-api
    git pull
    composer install
    php artisan migrate

    cd ..\next-store-ui
    git pull
    yarn
    exit /b 0
) else if "%arg1%"=="docker-build" (
    REM Perform the docker build process
    REM Clone the repository
    mkdir ..\laravel-store-rest-api
    git clone %api_repo% ..\laravel-store-rest-api

    mkdir ..\next-store-ui
    git clone %ui_repo% ..\next-store-ui

    echo Retrieve completed successfully

    REM Start Next.js project
    cd ..\next-store-ui
    yarn

    REM Start Laravel project
    cd ..\laravel-store-rest-api
    composer install
    copy .env.demo .env
    php artisan key:generate
    php artisan migrate --seed

    REM Add your Docker build commands here
    docker-compose up -d --build
    exit /b 0
) else if "%arg1%"=="fresh" (
    REM Clean up build artifacts and perform a fresh build
    echo Cleaning up build artifacts...
    if exist ..\laravel-store-rest-api (
        rmdir /s /q ..\laravel-store-rest-api
    )
    if exist ..\next-store-ui (
        rmdir /s /q ..\next-store-ui
    )

    REM Clone the repository
    mkdir ..\laravel-store-rest-api
    git clone %api_repo% ..\laravel-store-rest-api

    mkdir ..\next-store-ui
    git clone %ui_repo% ..\next-store-ui

    echo Retrieve completed successfully

    REM Start Next.js project
    cd ..\next-store-ui
    yarn

    REM Start Laravel project
    cd ..\laravel-store-rest-api
    composer install
    copy .env.demo .env
    php artisan key:generate
    php artisan migrate --seed
    exit /b 0
) else if "%arg1%"=="clean" (
    REM Clean up build artifacts
    echo Cleaning up build artifacts...
    if exist ..\laravel-store-rest-api (
        rmdir /s /q ..\laravel-store-rest-api
    )
    if exist ..\next-store-ui (
        rmdir /s /q ..\next-store-ui
    )
    exit /b 0
) else if "%arg1%"=="push" (
    REM Push the code to the repository
    set msg=%2

    cd ..\laravel-store-rest-api
    git add .
    git commit -m "%msg%"
    git push

    cd ..\next-store-ui
    git add .
    git commit -m "%msg%"
    git push

    cd ..\store-project-build
    git add .
    git commit -m "%msg%"
    git push
    exit /b 0
) else if "%arg1%"=="help" (
    REM Display help information with explanations for each argument
    echo.
    echo Usage: toolbox.bat [run^|dev^|retrieve^|push^|build^|update^|docker-build^|fresh^|clean^|help]
    echo.
    echo Options:
    echo     run           ^|  Run the projects.
    echo     dev           ^|  Run the projects in dev mode.
    echo     retrieve      ^|  Clone the repositories, install dependencies, and set up the environment.
    echo     push          ^|  Push the code to the repository.
    echo     build         ^|  Retrieve and deploy the project.
    echo     update        ^|  Pull the latest changes from the repositories and apply any updates.
    echo     docker-build  ^|  Perform a Docker build process. Add your Docker build commands in the script.
    echo     fresh         ^|  Clean up build artifacts and perform a fresh build.
    echo     clean         ^|  Clean up build artifacts.
    echo     help          ^|  Display this help information with details about each option.
    echo.
    exit /b 0
) else (
    REM Invalid option
    echo.
    echo Invalid option: %arg1%
    echo Usage: toolbox.bat [run^|dev^|retrieve^|push^|build^|update^|docker-build^|fresh^|help]
    echo.
    exit /b 0
)
