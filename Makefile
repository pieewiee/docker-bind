all: build

build:
	@docker build --tag=pieewiee/bind .
