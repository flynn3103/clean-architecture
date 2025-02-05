# Makefile for Django management tasks
#
# Usage:
#   make migrate    # To run Django migrations
#   make runserver  # To start the Django development server
#   make            # Runs both migrate and runserver sequentially
#
# Environment variables (with defaults):
#   PORT         - Port number for the development server (defaults to 8000)
#   DJANGO_ENV   - Environment variable indicating the Django environment (defaults to development)

PORT ?= 8000
DJANGO_ENV ?= development
export DJANGO_ENV

.PHONY: all migrate runserver

all: migrate runserver

migrate:
	@echo "Running migrations with DJANGO_ENV=$(DJANGO_ENV)..."
	@python manage.py migrate --settings=src.infrastructure.config.settings

run:
	@echo "Starting Django development server on 0.0.0.0:$(PORT) with DJANGO_ENV=$(DJANGO_ENV)..."
	@python manage.py runserver 0.0.0.0:$(PORT) --settings=src.infrastructure.config.settings
