@echo off
setlocal enabledelayedexpansion

:: Function to clean up the build artifacts
:clean
echo Cleaning up build artifacts...
rd /s /q ..\laravel-store-rest-api
rd /s /q ..\next-store-ui
goto :eof

:: Function to build the project
:retrieve
:: Clone the repository
git clone https://github.com/ekinata/laravel-store-rest-api.git ..\laravel-store-rest-api

cd ..\store-project-build
git clone https://github.com/ekinata/next-store-ui.git ..\next-store-ui

echo Retrieve completed successfully
goto :eof

:: Function to deploy the project
:deploy
:: Start Next.js project
cd ..\next-store-ui
call yarn

:: Start Laravel project
cd ..\laravel-store-rest-api
call composer install
copy .env.example .env
call php artisan key:generate
call php artisan migrate --seed
goto :eof

:: Function to update the project
:update
cd ..\laravel-store-rest-api
call git pull
call composer install
call php artisan migrate

cd ..\store-project-build
cd ..\next-store-ui
call git pull
call yarn
goto :eof

:: Docker build process
:docker_build
:: Add your Docker build commands here
docker-compose up -d --build
goto :eof

:: Function to run the project
:run
:: Start Laravel project
cd ..\laravel-store-rest-api
start /b php artisan serve

:: Start Next.js project
cd ..\next-store-ui
call yarn build
start /b yarn start

echo CTRL+C to exit
timeout /t -1
goto :eof

:: Function to run the project in dev mode
:dev
:: Start Laravel project
cd ..\laravel-store-rest-api
start /b php artisan serve

:: Start Next.js project
cd ..\next-store-ui
start /b yarn run dev

echo CTRL+C to exit
timeout /t -1
goto :eof

:: Get the first argument
set arg1=%1

:: Switch case for build options
if "%arg1%"=="run" goto :run
if "%arg1%"=="dev" goto :dev
if "%arg1%"=="retrieve" goto :retrieve
if "%arg1%"=="build" goto :retrieve & goto :deploy
if "%arg1%"=="update" goto :update
if "%arg1%"=="docker-build" goto :retrieve & goto :docker_build
if "%arg1%"=="fresh" goto :clean & goto :retrieve & goto :deploy
if "%arg1%"=="clean" goto :clean
if "%arg1%"=="help" goto :help

:: Invalid option
echo Invalid option: %arg1%
goto :help

:help
echo.
echo Usage: build.bat [run|dev|build|update|docker-build|fresh|help]
echo.
echo Options:
echo      run           |  Run the projects.
echo      dev           |  Run the projects in dev mode.
echo      retrieve      |  Clone the repositories, install dependencies, and set up the environment.
echo      build         |  Retrieve and deploy the project.
echo      update        |  Pull the latest changes from the repositories and apply any updates.
echo      docker-build  |  Perform a Docker build process. Add your Docker build commands in the script.
echo      fresh         |  Clean up build artifacts and perform a fresh build.
echo      clean         |  Clean up build artifacts.
echo      help          |  Display this help information with details about each option.
echo.
exit /b 0
