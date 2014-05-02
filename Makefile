SHELL := /bin/bash
APP_NAME := MyGUI
TAR_NAME := ${APP_NAME}.tar
ARCHIVE_NAME := ${TAR_NAME}.gz
TMP_DIR := ${CURDIR}/_tmp/${APP_NAME}
CHECK_DIR := ${CURDIR}/_dist
SOURCE_URL_32 := `awk '!/DOWNLOAD_x86_64/ {print}' ${APP_NAME}.info | awk -F'"' '/DOWNLOAD/ {print $$2}'`
VERSION := 3.2.0
SOURCE_ARCHIVE := ${APP_NAME}\_${VERSION}.zip

default: dist

distcheck: dist
	-mkdir ${CHECK_DIR}
	cp ${ARCHIVE_NAME} ${CHECK_DIR}
	cd ${CHECK_DIR} && tar xvzf ${ARCHIVE_NAME}
	if [ ! -e ./${SOURCE_ARCHIVE} ]; then \
		wget ${SOURCE_URL_32};\
	fi
	cp ${SOURCE_ARCHIVE} ${CHECK_DIR}/${APP_NAME}
	cd ${CHECK_DIR}/${APP_NAME} && sh ./${APP_NAME}.SlackBuild
	${MAKE} clean

dist: ${ARCHIVE_NAME} cleantmp

clean: cleantmp
	-rm -f ./*~
	-rm -f ./*.swp
	-rm -f ${ARCHIVE_NAME}
	-rm -rf ./${APP_NAME}
	-rm -rf ./_dist

cleantmp:
	-rm -rvf _tmp

${ARCHIVE_NAME}: ${TAR_NAME}
	cd _tmp && gzip ${TAR_NAME}
	mv _tmp/${ARCHIVE_NAME} .

${TAR_NAME}: ${TMP_DIR}
	cp ${CURDIR}/doinst.sh ${TMP_DIR}
	cp ${CURDIR}/slack-desc ${TMP_DIR}
	cp ${CURDIR}/README ${TMP_DIR}
	cp ${CURDIR}/${APP_NAME}.info ${TMP_DIR}
	cp ${CURDIR}/${APP_NAME}.SlackBuild ${TMP_DIR}
	cd _tmp && tar cvf ${TAR_NAME} ${APP_NAME}

${TMP_DIR}:
	-mkdir -p ${TMP_DIR}

.PHONY: default dist distcheck cleantmp clean
