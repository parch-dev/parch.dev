# Variables
DC=docker compose --file docker-compose.yml --env-file ./src/.env

.PHONY: up down sh logs setup test migrate rollback npm vite restart clear run queue

up:
	$(DC) up -d --build
	$(DC) exec parch composer install
	$(DC) exec parch-node npm install

setup: up

down:
	$(DC) down

sh:
	$(DC) exec parch bash

test:
	$(DC) exec parch vendor/bin/pest --coverage

test-report:
	$(DC) exec parch vendor/bin/pest --coverage-html=report

logs:
	$(DC) logs -f --tail=10

migrate:
	$(DC) exec parch php artisan migrate

migrate-seed:
	$(DC) exec parch php artisan migrate --seed

rollback:
	$(DC) exec parch php artisan migrate:rollback

npm:
	$(DC) exec parch-node npm install

vite:
	$(DC) exec parch-node npm run dev

restart:
	$(DC) down
	make up

clear:
	$(DC) exec parch php artisan cache:clear
	$(DC) exec parch php artisan config:clear
	$(DC) exec parch php artisan route:clear
	$(DC) exec parch php artisan view:clear
	$(DC) exec parch php artisan optimize:clear

run:
	$(DC) exec parch composer docker-dev

queue:
	$(DC) exec parch php artisan queue:listen
