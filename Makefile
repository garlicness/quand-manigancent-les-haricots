PANDOC_DOCKER_IMAGE = pandoc/core:2.18

MARKDOWN_FILE = Quand-manigancent-les-haricots.md

# Some colors
COLOR_GREEN  = $(shell tput -Txterm setaf 2)
COLOR_YELLOW = $(shell tput -Txterm setaf 3)
COLOR_WHITE  = $(shell tput -Txterm setaf 7)
COLOR_CYAN   = $(shell tput -Txterm setaf 6)
COLOR_RESET  = $(shell tput -Txterm sgr0)

# build
build: ## Build epub file
	@echo "Building..."
	@make clean
	mkdir target
	cp Quand-manigancent-les-haricots.md target
	cp styles.css target
	sed -i -e "s/date: XXXX-XX-XX/date: `date +%d-%m-%Y`/" target/Quand-manigancent-les-haricots.md
	docker run --rm -v `pwd`/target:/project \
		-w /project $(PANDOC_DOCKER_IMAGE) \
		-o "Quand_manigancent_les_haricots.epub" \
		./Quand-manigancent-les-haricots.md \
		--css styles.css \
		--toc --toc-depth=1

# Clean:
clean: ## Clean generated files
	@echo "Cleaning..."
	@rm -rf target

## Help:
help: ## Show this help.
	@echo ''
	@echo "Usage:"
	@echo '  ${COLOR_YELLOW}make${COLOR_RESET} ${COLOR_GREEN}<target>${COLOR_RESET}'
	@echo ''
	@echo 'Targets:'
	@echo
	@awk 'BEGIN {FS = ":.*?## "} { \
		if (/^[a-zA-Z_-]+:.*?##.*$$/) {printf "    ${COLOR_YELLOW}%-20s${COLOR_GREEN}%s${COLOR_RESET}\n", $$1, $$2} \
		else if (/^## .*$$/) {printf "  ${COLOR_CYAN}%s${COLOR_RESET}\n", substr($$1,4)} \
		}' $(MAKEFILE_LIST)
	@echo ''
	@echo 'This Makefile depends on ${COLOR_CYAN}docker${COLOR_RESET}. To install jt, please follow the instructions:'
	@echo '- for ${COLOR_YELLOW}macOS${COLOR_RESET}: https://docs.docker.com/docker-for-mac/install/'
	@echo '- for ${COLOR_YELLOW}Windows${COLOR_RESET}: https://docs.docker.com/docker-for-windows/install/'
	@echo '- for ${COLOR_YELLOW}Linux${COLOR_RESET}: https://docs.docker.com/engine/install/'