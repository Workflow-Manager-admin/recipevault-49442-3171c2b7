# RecipeVault API Documentation (Proposed Specification)

> **Note:**  
> This documentation describes a proposed API for the RecipeVault backend. As of this writing, there is no backend implementation in the repository. The endpoints, data schemas, and error codes described here are derived from project plans for reference and future backend development.

---

## Table of Contents

1. [Introduction](#introduction)
2. [Authentication](#authentication)
3. [Error Handling](#error-handling)
4. [Endpoints](#endpoints)
    - [Recipes](#recipes)
    - [Users](#users)
    - [Categories](#categories)
    - [Auth](#auth)
5. [Example Payloads](#example-payloads)
6. [Appendix: Proposed Database Models](#appendix-proposed-database-models)

---

## Introduction

The RecipeVault backend API is designed to provide secure, RESTful access to the RecipeVault application's core entities: recipes, users, and categories. The API supports full CRUD operations, JWT-based authentication, and role-based authorization.

---

## Authentication

- **JWT Authentication**:  
  All endpoints (except registration and login) require the client to present a valid JWT token in the `Authorization` HTTP header.

  ```
  Authorization: Bearer <token>
  ```

- **Roles:**  
  - Regular user: can browse, read, and create public recipes.
  - Admin: can create, update, and delete any recipe or category.

---

## Error Handling

API responses use standard HTTP status codes:

| Status Code | Meaning                  | Common Usage                             |
|-------------|--------------------------|------------------------------------------|
| 200         | OK                       | Successful GET, PUT, DELETE, etc.        |
| 201         | Created                  | Resource created (e.g., POST success)    |
| 204         | No Content               | Successful deletion, no body returned    |
| 400         | Bad Request              | Invalid input, malformed request         |
| 401         | Unauthorized             | Invalid or missing JWT                   |
| 403         | Forbidden                | Insufficient permissions                 |
| 404         | Not Found                | Resource does not exist                  |
| 409         | Conflict                 | Duplicate resource conflicts             |
| 422         | Unprocessable Entity     | Failed validation                        |
| 500         | Internal Server Error    | Unexpected backend error                 |

Error responses are typically JSON:

```json
{
  "error": "Descriptive error message",
  "details": { "optional": "extra info" }
}
```

---

## Endpoints

### Recipes

| Method | Endpoint         | Description                          | Auth      |
|--------|------------------|--------------------------------------|-----------|
| GET    | /recipes         | List recipes (optionally filter)     | Optional  |
| GET    | /recipes/{id}    | Get recipe details by ID             | Optional  |
| POST   | /recipes         | Create new recipe                    | Required  |
| PUT    | /recipes/{id}    | Update recipe by ID                  | Required  |
| DELETE | /recipes/{id}    | Delete recipe by ID                  | Required  |

#### Recipe Object

```json
{
  "id": 1,
  "title": "Avocado Toast",
  "description": "A modern classic for brunch.",
  "ingredients": ["Bread", "Avocado", "Salt", "Pepper"],
  "instructions": "Toast the bread, mash the avocado, combine.",
  "category_id": 2,
  "author_id": 5,
  "created_at": "2024-06-05T14:28:23.382Z",
  "updated_at": "2024-06-06T09:11:00.550Z"
}
```

### Users

| Method | Endpoint       | Description                       | Auth      |
|--------|----------------|-----------------------------------|-----------|
| GET    | /users/{id}    | Get user info by ID               | Required  |
| POST   | /users         | Register new user                 | Public    |
| PUT    | /users/{id}    | Update user info                  | Required  |
| DELETE | /users/{id}    | Delete user account               | Required  |

#### User Object

```json
{
  "id": 5,
  "username": "brunchfan",
  "email": "fan@example.com",
  "role": "user",
  "created_at": "2024-06-05T10:18:00.000Z"
}
```

### Categories

| Method | Endpoint           | Description                 | Auth      |
|--------|--------------------|-----------------------------|-----------|
| GET    | /categories        | List all categories         | Optional  |
| POST   | /categories        | Create new category (admin) | Required* |
| PUT    | /categories/{id}   | Update category (admin)     | Required* |
| DELETE | /categories/{id}   | Delete category (admin)     | Required* |

> \* These actions require admin privileges.

#### Category Object

```json
{
  "id": 2,
  "name": "Breakfast"
}
```

### Auth

| Method | Endpoint     | Description                  | Auth      |
|--------|--------------|------------------------------|-----------|
| POST   | /auth/login  | Authenticate user (JWT)      | Public    |
| POST   | /auth/register | Register user              | Public    |

#### Login Request

```json
{
  "username": "brunchfan",
  "password": "password123"
}
```

#### Login Success Response

```json
{
  "token": "<jwt-token-string>",
  "user": { "id": 5, "username": "brunchfan", "role": "user" }
}
```

---

## Example Payloads

### Create Recipe

**Request:**

```json
POST /recipes
{
  "title": "Avocado Toast",
  "description": "A modern classic for brunch.",
  "ingredients": ["Bread", "Avocado", "Salt", "Pepper"],
  "instructions": "Toast the bread, mash avocado, season.",
  "category_id": 2
}
```

**Response:**

```json
201 Created
{
  "id": 123,
  ...
}
```

### Error Example

```json
401 Unauthorized
{
  "error": "Authentication credentials were not provided."
}
```
---

## Appendix: Proposed Database Models

| Table     | Fields                                                                |
|-----------|-----------------------------------------------------------------------|
| users     | id, username, password_hash, email, role, created_at                  |
| recipes   | id, title, description, ingredients, instructions, category_id, author_id, created_at, updated_at |
| categories| id, name                                                              |
| favorites | id, user_id, recipe_id                                                |
| reviews   | id, user_id, recipe_id, rating, comment, created_at                   |

---

## Change History

- 2024-06-06: Initial draft (proposed endpoints/spec).

---

*This document is for planning purposes and must be updated in tandem with backend code development for accuracy.*
