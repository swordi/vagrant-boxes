#!/usr/bin/env bash

function ensure_file_exists {
	if [[ ! -f $1 ]]; then
		echo "[ERROR] $1 Not found. Terminating."
		exit 1
	fi	
}

function exec_cmd {
	echo "[INFO] Running $1"
	eval $1
}

CQ_JAR=cq-quickstart-5.6.1-author-p4502.jar
CQ_JAR_PATH=/vagrant/${CQ_JAR}
CQ_LICENSE=license.properties
CQ_LICENSE_PATH=/vagrant/${CQ_LICENSE}
CQ_PROCESS_NAME=cq-quickstart-5.6.1-author-p4502.jar

ensure_file_exists ${CQ_JAR_PATH}
ensure_file_exists ${CQ_LICENSE_PATH}

if [[ ! -f /home/vagrant/crx-quickstart ]]; then
	echo "[INFO] Initializing the CQ repository"	

	# First create a symlink from /home/vagrant/ to cq-quickstart-5.6.1-author-p4502.jar
	# as we want to create the repository under /home/vagrant
	exec_cmd "ln -fs ${CQ_JAR_PATH} /home/vagrant/${CQ_JAR}"

	# copy the license file
	exec_cmd "cp ${CQ_LICENSE_PATH} /home/vagrant/${CQ_LICENSE}"

	exec_cmd "cd /home/vagrant/ && java -XX:MaxPermSize=256m -Xmx1024M -jar /home/vagrant/${CQ_JAR} > /dev/null 2>&1 &"

	# When the repository is successfully started, the login page will contain the QUICKSTART_HOMEPAGE text
	until [[ "$(curl --silent --location http://localhost:4502/libs/granite/core/content/login.html)" == *QUICKSTART_HOMEPAGE* ]]; do
		echo -n "."
		sleep 60
	done
	echo "[INFO] CQ is now initialized"

	CQ_PID=$(ps aux | grep java | grep ${CQ_PROCESS_NAME} | awk '{print $2}')	
	echo "[INFO] Stopping the CQ Process (PID: $CQ_PID)"
	sudo kill $CQ_PID
	while sudo kill -0 $CQ_PID 2> /dev/null; do
		echo -n "."
		sleep 1
	done
	echo	

	# Delete the symlink
	exec_cmd "rm /home/vagrant/${CQ_JAR}"

	# Delete the log files
	exec_cmd "rm /home/vagrant/crx-quickstart/logs/*"

	exec_cmd "chown -R vagrant /home/vagrant/crx-quickstart"

	exec_cmd "find /var/cache -type f -exec rm -rf {} \;"	
	exec_cmd "rm -f /home/vagrant/*.sh"
	exec_cmd "dd if=/dev/zero of=/EMPTY bs=1M"
	exec_cmd "rm -f /EMPTY"

	echo "[INFO] CQ is now successfully stopped"
	echo "[INFO] It is not safe to create a Vagrant box for this machince"
fi
