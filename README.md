# Expert Portal

## Project Overview

**Expert Portal** is a web applicagion developed as part of a group project at the university. Aims to create a platform that allows Fiti(Frankfurt Institute of Technology and Inovations) to manage experts and projects intuitively, filter and sort resources, and respond swiftly to changes.

## What I was responsible for

In the team while writing the backend part, I was responsible for user managment. To create the user class, I used the **devise** library, which fully met my needs. Later on I was responsible for creating and implementing the design (frontend). I created the design in **Figma**, then implemented it using **HTML + Bootstrap and Stimulus with Hotwired** for interactive elements.  
Although I'm more focused on learning backend, and have not had much experience writing frontend before, I gained valuable experience in understanding how to write code and what difficulties developers may encounter when connecting frontend with backend, which will help me in the future.

## Screenshots
[Look at the screenshots](App_overview.md)

## Features

- Expert profiles
- Project assigments
- Document managment
- Multiple language
- Enables experts to update their information independently.

## Technologies Used

The project utilizes the following technologies:

- **Ruby on Rails**
- **HTML/CSS/Bootstrap/Stimulus with Hotwire**
- **SQLite**

## App Hosting with Docker

### Prerequisites
1. Docker Engine (Linux) or [Docker Desktop](https://www.docker.com/products/docker-desktop/) (Windows/MacOS) installed and running.
2. [Git](https://git-scm.com/downloads) installed and configured.

### Cloning the Repository
1. Create a directory for ExpertGrid.
2. Navigate to the directory using a shell of your choice.
3. Clone the repository: `git clone <http clone url>`

## Development Environment

### Creating the `.env` File
1. Create a new file named `.env` in the project directory. This file is used for local database and SMTP server configuration.
2. Open the `.env` file and define the environment variables. **Important:** The variable names **must** match the names defined in the `docker-compose.yml` file!
```
POSTGRES_USER=yourDbUsername
POSTGRES_PASSWORD=yourDbPassword
POSTGRES_DB=prodDbName
DATABASE_HOST=db
DATABASE_URL=postgres://yourDbUsername:yourDbPassword@db:5432/prodDbName
DATABASE_USERNAME=yourDbUsername
DATABASE_PASSWORD=yourDbPassword
SMTP_USERNAME=yourSmtpUsername
SMTP_PASSWORD=yourSmtpPassword
```
3. Save the `.env` file.

### Starting Docker Containers
1. Navigate to the root directory of the project using your shell.
2. Run `docker compose up --build`. The two containers, `db` and `app`, will start one after the other.

### Migrating the Database
1. Start the app container with a shell: `docker compose run app bash`
2. Create the local test and development databases: `rails db:create`
3. Migrate the local database: `rails db:migrate`
4. Check the status by accessing [http://localhost:3000/](http://localhost:3000/) on your host system.
