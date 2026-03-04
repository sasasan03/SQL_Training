.PHONY: help serve stop route-clear optimize-clear migrate seed test

# デフォルト
help:
	@echo "Usage:"
	@echo "  make serve           Start laravel dev server"
	@echo "  make route-list      Show route list"
	@echo "  make route-clear     Clear route cache"
	@echo "  make optimize-clear  Clear all cache"
	@echo "  make migrate         Run migrations"
	@echo "  make seed            Run database seeders"
	@echo "  make test            Run tests"

# Laravel

up:
	docker compose up -d

up--build:
	docker compose up -d  --build

down:
	docker compose down

ps:
	docker compose ps

restart:
	docker compose down
	docker compose up -d

app:
	docker compose exec app bash

db:
	docker compose exec db bash

mysql:
	docker compose exec db mysql -u phper -p

tinker:
	docker compose exec app php artisan tinker

serve:
	docker compose exec app php artisan serve
# 	docker compose exec app php artisan serve --host=0.0.0.0 --port=8000

route-list:
	docker compose exec app php artisan route:list

route-clear:
	docker compose exec app php artisan route:clear

optimize-clear:
	docker compose exec app php artisan optimize:clear

migrate:
	docker compose exec app php artisan migrate

seed:
	docker compose exec app php artisan db:seed

cache:
	docker compose exec app composer clear-cache
	docker compose exec app php artisan optimize:clear
	docker compose exec app php artisan event:clear
	docker compose exec app composer dump-autoload -o
	docker compose exec app php artisan optimize
	docker compose exec app php artisan view:cache

fresh:
	docker compose exec app php artisan migrate:fresh

fresh-seed:
	docker compose exec app php artisan migrate:fresh --seed

test:
	docker compose exec app php artisan test