.PHONY: all clean download unpack install deploy

all: download unpack install

clean:
	rm -Rf build

download: build/TestFlightSDK_Android1.2.zip
unpack: download build/TestFlightLib.jar

build:
	mkdir build

build/TestFlightSDK_Android1.2.zip: build
	@wget -c `cat link.url`

build/TestFlightLib.jar: build/TestFlightSDK_Android1.2.zip
	@unzip -o -qq -d build/ build/TestFlightSDK_Android1.2.zip

install-local: build/TestFlightLib.jar
	@mvn deploy:deploy-file -DpomFile=testflight-sdk.pom.xml -Dfile=build/TestFlightLib.jar -DcreateChecksum=true

install: build/TestFlightLib.jar
	@mvn deploy:deploy-file -DpomFile=testflight-sdk.pom.xml -Dfile=build/TestFlightLib.jar -Durl=file://${CURDIR}/repository -DcreateChecksum=true

deploy: build/TestFlightLib.jar
	@# REPO - url of repository to deploy to
	@# REPO_ID - id of repository to deploy to
	@# usage: make REPO="repo" REPO_ID="repoid" deploy
	ifndef REPO
	ifndef REPO_ID
	$(error Usage: make REPO="repo" REPO_ID="repoid" deploy)
	endif
	endif
	@mvn deploy:deploy-file -DpomFile=testflight-sdk.pom.xml -Dfile=build/TestFlightLib.jar -Durl=${REPO} -DcreateChecksum=true  -DrepositoryId=${REPO_ID}
