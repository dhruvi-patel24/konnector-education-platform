# Konnector Education Platform

A comprehensive SaaS platform for educational organizations to manage schools, courses, batches, and student enrollments. Built with Ruby on Rails 8.

## Features

### User Roles & Permissions
The platform supports three distinct user roles, managed via **Devise** and **Pundit**:

*   **Super Admin**
    *   Manage all Schools.
    *   Manage all Users (Admins, School Admins, Students).
    *   Global oversight of the platform.

*   **School Admin**
    *   Manage their specific School's details.
    *   Create and manage Courses.
    *   Create and manage Batches (Classes).
    *   Manage Student Enrollments (Approve/Reject requests).
    *   Create Student accounts for their school.

*   **Student**
    *   View available Batches.
    *   Request enrollment in Batches.
    *   View their enrolled Batches and status.

### Core Modules
*   **School Management:** Centralized management of multiple educational institutions.
*   **Course Management:** Define courses with descriptions and details.
*   **Batch Management:** Schedule batches for courses with start and end dates.
*   **Enrollment System:** Workflow for students to join batches with an approval process (Pending -> Approved/Rejected).

## Tech Stack

*   **Framework:** Ruby on Rails 8.0.0
*   **Language:** Ruby 3.x
*   **Database:** PostgreSQL
*   **Authentication:** Devise
*   **Authorization:** Pundit
*   **Frontend:** Hotwire (Turbo & Stimulus), Importmaps, CSS Variables for theming
*   **Testing:** RSpec, FactoryBot, Faker

## Local Development Setup

Follow these steps to get the project running on your local machine.

### Prerequisites
*   Ruby 3.3.3 installed
*   PostgreSQL installed and running

### Installation

1.  **Clone the repository**
    ```bash
    git clone <repository-url>
    cd konnector-education-platform
    ```

2.  **Install Dependencies**
    ```bash
    bundle install
    ```

3.  **Database Setup**
    Update `config/database.yml` with your PostgreSQL credentials if necessary.
    ```bash
    bin/rails db:create
    bin/rails db:migrate
    bin/rails db:seed  # Populates initial data (roles, test users, etc.)
    ```

4.  **Run the Server**
    ```bash
    bin/rails server
    ```
    Visit `http://localhost:3000` in your browser.

## 🧪 Running Tests

This project uses RSpec for testing.

```bash
bundle exec rspec
```

## Project Structure

*   `app/models`: Core business logic and database interactions (User, School, Course, Batch, Enrollment).
*   `app/controllers`: Request handling, separated by namespaces (`Admin`, `SchoolAdmin`, `Student`).
*   `app/policies`: Pundit policies defining authorization rules for each role.
*   `app/views`: ERB templates, organized by namespace.
*   `db/schema.rb`: Database schema definition.

## Security

*   **Authentication:** Secure user sessions and password hashing via Devise.
*   **Authorization:** Strict resource access control using Pundit policies.
*   **Validations:** Robust model-level validations to ensure data integrity.
