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
DJANGO_ENV ?= develop
export DJANGO_ENV

.PHONY: all migrate runserver

# dependency
venv-config: poetry config virtualenvs.in-project true

install: poetry install --no-root

all: migrate runserver

migrate:
	@echo "Running migrations with DJANGO_ENV=$(DJANGO_ENV)..."
	@python manage.py migrate

run:
	@echo "Starting Django development server on 0.0.0.0:$(PORT) with DJANGO_ENV=$(DJANGO_ENV)..."
	@python manage.py runserver 0.0.0.0:$(PORT)
loaddata:
	@echo "Starting load fixture data into your Django project's database with DJANGO_ENV=$(DJANGO_ENV)..."
	@python manage.py loaddata fixtures/*.json