DEBUG = 1

DOCKER_COMPOSE_FILE = srcs/docker-compose.yml

all: up

up:
	docker-compose -f $(DOCKER_COMPOSE_FILE) up --build -d

down:
	@echo "Stopping Docker Compose"
	docker-compose -f $(DOCKER_COMPOSE_FILE) down

clean: down

fclean: clean
	@echo "Cleaning up Docker system and volumes"
	docker system prune -af
	docker volume prune -f

re: fclean all

.PHONY: all up down clean re fclean