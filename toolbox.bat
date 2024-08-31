@echo off

REM Function to clean up the build artifacts
:clean
    echo Cleaning up build artifacts...
    rmdir /s /q ..\laravel-store-rest-api
    rmdir /s /q ..\next-store-ui
    goto :eof

REM Function to build the project
:retrieve
    REM Clone the repository
    git clone https://github.com/ekinata/laravel-store-rest-api.git ..\laravel-store-rest-api

    cd ..\store-project-build
    git clone https://github.com/ekinata/next-store-ui.git ..\next-store-ui

    echo Retrieve completed successfully
    goto :eof

REM Function to deploy the project
:deploy
    REM Start Next.js project
    cd ..\next-store-ui
    yarn

    REM Start Laravel project
    cd ..\laravel-store-rest-api
    composer install
    copy .env.demo .env
    php artisan key:generate
    php artisan migrate --seed
    goto :eof

REM Function to update the project
:update
    cd ..\laravel-store-rest-api
    git pull
    composer install
    php artisan migrate

    cd ..\store-project-build
    cd ..\next-store-ui
    git pull
    yarn
    goto :eof

REM Docker build process
:docker_build
    REM Add your Docker build commands here
    docker-compose up -d --build
    goto :eof

REM Function to run the project
:run
    REM Trap to kill background processes on script exit
    call :trap

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
    goto :eof

REM Function to run the project in dev mode
:dev
    REM Trap to kill background processes on script exit
    call :trap

    REM Start Laravel project
    cd ..\laravel-store-rest-api
    start /b php artisan serve

    REM Start Next.js project
    cd ..\next-store-ui
    start /b yarn run dev

    echo CTRL+C to exit

    REM Wait for the background processes to finish
    pause
    goto :eof

REM Function to push the code
:push
    REM Push the code to the repository
    set msg=%1

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
    goto :eof

REM Trap function to kill background processes on exit
:trap
    REM No direct equivalent in batch scripts, typically handled by `Ctrl+C`
    goto :eof

REM Get 1 argument
set arg1=%1

REM Switch case for build options
if "%arg1%"=="run" (
    REM Run the projects
    call :run
) else if "%arg1%"=="dev" (
    REM Run the projects
    call :dev
) else if "%arg1%"=="retrieve" (
    REM Clone the repositories, install dependencies, and set up the environment
    call :retrieve
) else if "%arg1%"=="build" (
    REM Clone the repositories, install dependencies, and set up the environment
    call :retrieve
    call :deploy
) else if "%arg1%"=="update" (
    REM Pull the latest changes from the repositories and apply any updates
    call :update
) else if "%arg1%"=="docker-build" (
    REM Perform the docker build process
    call :retrieve
    call :docker_build
) else if "%arg1%"=="fresh" (
    REM Clean up build artifacts and perform a fresh build
    call :clean
    call :retrieve
    call :deploy
) else if "%arg1%"=="clean" (
    REM Clean up build artifacts
    call :clean
) else if "%arg1%"=="push" (
    REM Push the code to the repository
    call :push %2
) else if "%arg1%"=="help" (
    REM Display help information with explanations for each argument
    echo.
    echo Usage: toolbox.bat [run^|dev^|retrieve^|push^|build^|update^|docker-build^|fresh^|help]
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
) else (
    REM Invalid option
    echo.
    echo Invalid option: %arg1%
    echo Usage: toolbox.bat [run^|dev^|retrieve^|push^|build^|update^|docker-build^|fresh^|help]
    echo.
)

exit /b 0
