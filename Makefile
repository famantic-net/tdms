
build:
	docker build -t tdms:app .

run:
	docker run -it --rm --name tdms_app --link tdms-reloaded:tdmsdb tdms:app

remove:
	docker rmi tdms:app
