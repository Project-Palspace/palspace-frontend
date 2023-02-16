default:
	echo 'Usage: make <parameter>';

build-runner:
	flutter pub get
	flutter pub run build_runner build