DEBUG = 1

DOCKER_COMPOSE_FILE = srcs/docker-compose.yml

all: up

up:
	# @echo "Starting Docker Compose with debug mode $(DEBUG)"
	# $(if $(DEBUG),$(MAKE) -s debug-docker-compose)
	docker-compose -f $(DOCKER_COMPOSE_FILE) up --build -d

down:
	@echo "Stopping Docker Compose"
	docker-compose -f $(DOCKER_COMPOSE_FILE) down

clean: down
	@echo "Cleaning up Docker system and volumes"
	docker system prune -af
	docker volume prune -f

re: clean all

debug-docker-compose:
	@echo "Enabling Docker Compose debug mode"
	docker-compose -f $(DOCKER_COMPOSE_FILE) --verbose up

build-debug:
	@echo "Building Docker containers with debug output"
	docker-compose -f $(DOCKER_COMPOSE_FILE) build --no-cache --pull --verbose

.PHONY: all up down clean re debug-docker-compose build-debug