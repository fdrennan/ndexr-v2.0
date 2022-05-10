all: db restart assh

help: ## Show this help
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'


leave: all ## git the lazy way
	git add --all
	git commit -m 'stored and shit'
	git push origin $$(git rev-parse --abbrev-ref HEAD)

build: style
	R -e "install.packages('srcpkgs/rredis_1.7.0.tar.gz', repo=NULL)"
	R -e "devtools::install_deps('./state')"
	R -e "devtools::document('./state')"
	R -e "devtools::install('./state')"
	R -e "devtools::install_deps('./redpul')"
	R -e "devtools::document('./redpul')"
	R -e "devtools::install('./redpul')"
	R -e "devtools::install_deps('./frontend')"
	R -e "devtools::document('./frontend')"
	R -e "devtools::install('./frontend')"
	docker build -t redpul:0.0.2 --file ./Dockerfile .

dbnc:
	docker build -t redpul:0.0.4 --file ./Dockerfile . --no-cache

style:
	R -e "styler::style_dir('./scripts/')"
	R -e "styler::style_dir('./state')"
	R -e "styler::style_dir('./state/R')"
	R -e "styler::style_dir('./redpul')"
	R -e "styler::style_dir('./redpul/R')"
	R -e "styler::style_dir('./frontend')"
	R -e "styler::style_dir('./frontend/R')"

ddown:
	docker-compose down

dup:
	docker-compose up -d

logs:
	docker-compose logs -f --tail=10

clean:
	rm -rf *.tar.gz
	rm -rf *.Rcheck

backup-pg:
	docker exec -it postgres bash -c '/usr/bin/pg_dump -h localhost -p 5432 -Fc -v -U $$POSTGRES_USER $$POSTGRES_DB --table submissions > /data/submissions.sql'
	Rscript scripts/backpg.R

backup: backup-pg clean

dangerous:
	docker-compose down
	docker rm -f $$(docker ps -a -q) | echo 'No containers to remove'
	docker volume rm $$(docker volume ls -q) | echo 'No volumes to remove'
	docker image rm -f $$(docker image ls -q) | echo 'No images to remove'
	sudo rm -rf volumes

push:
	git add --all
	git commit -m '$m'
	git push origin $$(git rev-parse --abbrev-ref HEAD)


killassh:
	sudo killall autossh

ports:
	lsof -i -P -n | grep LISTEN
#kill $(lsof -t -i:80)

nxcp:
	sudo cp nginx/nginx.conf /etc/nginx/nginx.conf
	sudo cp nginx/sites-available/default /etc/nginx/sites-enabled/default
	sudo systemctl restart nginx

aup:
	docker pull amazon/aws-cli
	docker run --rm -ti -v ~/.aws:/root/.aws amazon/aws-cli ec2 start-instances --instance-ids i-05c59c495112a504e

adown:
	docker pull amazon/aws-cli
	docker run --rm -ti -v ~/.aws:/root/.aws amazon/aws-cli ec2 stop-instances --instance-ids i-05c59c495112a504e

amodify:
	docker pull amazon/aws-cli
	docker run --rm -ti -v ~/.aws:/root/.aws amazon/aws-cli ec2 modify-instance-attribute \
	    --instance-id i-05c59c495112a504e \
    	--instance-type "{\"Value\": \"t2.nano\"}"

as:
	autossh -f -nNT -R 8787:localhost:8787 -R 5432:localhost:5432 -R 5000:localhost:5000 -R 8080:localhost:8080 -R 8000:localhost:8000 -R 8001:localhost:8001 -R 8002:localhost:8002 -R 8003:localhost:8003 -i /home/freddy/Projects/current/redpul/redpul-main.pem ubuntu@ndexr.com -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o ExitOnForwardFailure=yes

db:
	docker build -t redpul --file ./Dockerfile .

restart: ddown dup
drestart: db restart
dncrestart: dbnc restart
d:
	docker-compose up nginx app

pull:
	docker-compose down
	docker-compose up -d redpul postgres

fix_b:
	git filter-branch -f --index-filter "git rm -rf --cached --ignore-unmatch extdata/ukraine_authors.rda" -- --all

