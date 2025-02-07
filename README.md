# Currency Exchange Rate API

This project implements a Currency Exchange Rate API using a Clean Architecture approach. It aims to deliver high code readability and maintainability by decoupling responsibilities, applying dependency injection, and enabling comprehensive unit testing.

---

## Table of Contents
- [Currency Exchange Rate API](#currency-exchange-rate-api)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Clean Architecture](#clean-architecture)  
- [Technology Stack](#technology-stack)
  - [Project Structure](#project-structure)
  - [API Documentation](#api-documentation)
    - [1. Retrieve Currency Details](#1-retrieve-currency-details)
    - [2. Convert Currency](#2-convert-currency)
    - [3. Retrieve Exchange Rate Time Series](#3-retrieve-exchange-rate-time-series)
    - [4. Calculate Time-Weighted Rate (TWR)](#4-calculate-time-weighted-rate-twr)
  - [Sample cURL Requests](#sample-curl-requests)
    - [Fetch Currency Details](#fetch-currency-details)
    - [Convert Currency Amount](#convert-currency-amount)
    - [Retrieve Exchange Rate Time Series](#retrieve-exchange-rate-time-series)
    - [Calculate Time-Weighted Rate](#calculate-time-weighted-rate)

---

## Overview

This project manages currencies and exchange rates and includes endpoints to retrieve currency details, convert amounts between currencies, and retrieve historical exchange rate time series. The implementation follows Clean Architecture principles to keep the core business logic independent of external frameworks and delivery mechanisms.

---

## Clean Architecture

The project is organized into distinct layers:

![Clean Architecture Diagram](docs/clean_arch.jpeg)
- **Entities (Domain):**  
  Represent the business objects of the application. For example, `CurrencyEntity` and `CurrencyExchangeRateEntity` encapsulate the essential attributes and behaviors associated with currencies and exchange rates.

- **Use Cases / Interactors (Services):**  
  Business logic is encapsulated in service classes (interactors) such as `CurrencyInteractor` and `CurrencyExchangeRateInteractor`. These classes orchestrate domain operations, applying business rules and interacting with repositories.

- **Interfaces / Repository Interfaces:**  
  This layer defines contracts for data persistence and external services. Repository interfaces abstract away the details of how data is stored and accessed.  
  - **Database Repositories:** Implemented using Django's ORM, they handle CRUD operations on models.
  - **Cache Repositories:** Utilize Redis (via Django’s caching framework) to store and retrieve frequently accessed data.

- **Adapters / Controllers:**  
  Django Rest Framework ViewSets act as adapters. They bridge the HTTP layer with the use cases by translating HTTP requests into method calls on interactors. Serializers validate and transform data between JSON and domain entities.

- **Dependency Injection:**  
  `CurrencyRepositoryFactory` create and inject the dependencies by instantiating lower-level components (e.g., database and cache repositories) and composing them together. They are decoupled by injecting repository implementations into interactor classes. This allows easy substitution with mocks during testing and better separation between business logic and infrastructure concerns.
---

## Technology Stack

- **Backend Framework:** Django  
- **API Framework:** Django Rest Framework  
- **Background Tasks:** Celery  
- **Relational Database:** PostgreSQL  
- **Cache Service:** Redis  
- **Testing:** Pytest and unittest.mock

---

## Project Structure

The codebase follows a layered structure inspired by Clean Architecture:
```
├── src
│ ├── domain
│ │ └── exchange_rate.py # Domain entities and business rules
│ ├── usecases
│ │ └── exchange_rate.py # Interactors implementing business logic
│ ├── infrastructure
│ │ ├── orm
│ │ │ ├── db
│ │ │ │ ├── exchange_rate
│ │ │ │ │ ├── models.py # Django ORM models
│ │ │ │ │ └── repositories.py # Database repository implementations
│ │ │ │ └── cache
│ │ │ │ │ └── exchange_rate
│ │ │ │ │ └── repositories.py # Cache repository implementations
│ ├── interface
│ │ ├── controllers
│ │ │ └── exchange_rate.py # API controllers / viewsets (DRF)
│ │ ├── repositories
│ │ │ └── exchange_rate.py # Repository interface definitions
│ │ └── serializers
│ │ └── exchange_rate.py # Data validation & transformation for API payloads
├── tests # Unit and integration tests
└── README.md
```

---

## API Documentation

### 1. Retrieve Currency Details

- **Endpoint:** GET `/api/currencies/<code>/`
- **Description:** Retrieves details of a currency based on its code.
- **Response Example:**
  ```json
  {
      "code": "USD",
      "name": "US Dollar",
      "symbol": "$"
  }
  ```

### 2. Convert Currency

- **Endpoint:** GET `/api/exchange-rate-convert/`
- **Query Parameters:**
  - `source_currency`: Code of the source currency.
  - `exchanged_currency`: Code of the target currency.
  - `amount`: Amount to convert.
- **Description:** Converts an amount from one currency to another using the latest exchange rate.
- **Response Example:**
  ```json
  {
      "exchanged_currency": "EUR",
      "exchanged_amount": 89.75,
      "rate_value": 0.8975
  }
  ```

### 3. Retrieve Exchange Rate Time Series

- **Endpoint:** GET `/api/exchange-rate-list/`
- **Query Parameters:**
  - `source_currency`: Code of the source currency.
  - `date_from`: Start date in YYYY-MM-DD format.
  - `date_to`: End date in YYYY-MM-DD format.
- **Description:** Returns a list of historical exchange rate records.
- **Response Example:**
  ```json
  [
      {
          "source_currency": "USD",
          "exchanged_currency": "EUR",
          "valuation_date": "2023-01-05",
          "rate_value": 0.8987
      },
      {
          "source_currency": "USD",
          "exchanged_currency": "EUR",
          "valuation_date": "2023-01-15",
          "rate_value": 0.9023
      }
  ]
  ```

### 4. Calculate Time-Weighted Rate (TWR)

- **Endpoint:** GET `/api/exchange-rate-calculate-twr/`
- **Query Parameters:**
  - `source_currency`: Code of the source currency.
  - `exchanged_currency`: Code of the target currency.
  - `date_from`: Start date in YYYY-MM-DD format.
  - `date_to`: End date in YYYY-MM-DD format.
- **Description:** Calculates the time-weighted average exchange rate over a specific period.
- **Response Example:**
  ```json
  {
      "time_weighted_rate": 0.9001
  }
  ```

---

## Sample cURL Requests

### Fetch Currency Details
```bash
curl -X GET "http://localhost:8000/api/currencies/USD/"
```

### Convert Currency Amount
```bash
curl -G "http://localhost:8000/api/exchange-rate-convert/" \
--data-urlencode "source_currency=USD" \
--data-urlencode "exchanged_currency=EUR" \
--data-urlencode "amount=100"
```

### Retrieve Exchange Rate Time Series
```bash
curl -G "http://localhost:8000/api/exchange-rate-list/" \
--data-urlencode "source_currency=USD" \
--data-urlencode "date_from=2023-01-01" \
--data-urlencode "date_to=2023-01-31"
```

### Calculate Time-Weighted Rate
```bash
curl -G "http://localhost:8000/api/exchange-rate-calculate-twr/" \
--data-urlencode "source_currency=USD" \
--data-urlencode "exchanged_currency=EUR" \
--data-urlencode "date_from=2023-01-01" \
--data-urlencode "date_to=2023-01-31"
```
