APP_NAME := MyGUI
TAR_NAME := ${APP_NAME}.tar
ARCHIVE_NAME := ${TAR_NAME}.gz
TMP_DIR := ${CURDIR}/_tmp/${APP_NAME}

default: submission

submission: ${ARCHIVE_NAME} cleantmp

clean: cleantmp
	-rm -f ./*~
	-rm -f ./*.swp
	-rm -f ${ARCHIVE_NAME}
	-rm -rf ./${APP_NAME}

cleantmp:
	-rm -rvf _tmp

${ARCHIVE_NAME}: ${TAR_NAME}
	cd _tmp && gzip ${TAR_NAME}
	mv _tmp/${ARCHIVE_NAME} .

${TAR_NAME}: ${TMP_DIR}
	cp ${CURDIR}/doinst.sh ${TMP_DIR}
	cp ${CURDIR}/slack-desc ${TMP_DIR}
	cp ${CURDIR}/README ${TMP_DIR}
	cp ${CURDIR}/MyGUI.info ${TMP_DIR}
	cp ${CURDIR}/MyGUI.SlackBuild ${TMP_DIR}
	cd _tmp && tar cvf ${TAR_NAME} ${APP_NAME}

${TMP_DIR}:
	-mkdir -p ${TMP_DIR}

.PHONY: default submission cleantmp clean
