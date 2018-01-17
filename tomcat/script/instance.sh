#!/bin/sh

script_dir=`pwd`
root_dir=`dirname $script_dir`
tomcat_dir="$root_dir/tomcat-8.5.15"

export CATALINA_HOME=$tomcat_dir

template_dir="$root_dir/template"
http_port=$2
let shutdown_port=$http_port+1
let redirect_port=$http_port+2
let ajp_port=$http_port+3
instance_dir=$root_dir/instances/$http_port
action=$1

. ./setEnv.sh

echo "ROOT_DIR=$root_dir"
echo "SCRIPT_DIR=$script_dir"
echo "TOMCAT_DIR=$tomcat_dir"
echo "TEMPLATE_DIR=$template_dir" 
echo "HTTP_PORT=$http_port"
echo "SHUTDOWN_PORT=$shutdown_port"
echo "REDIRECT_PORT=$redirect_port"
echo "AJP_PORT=$ajp_port"
echo "WEBAPP_DIR=$WEBAPP_DIR"
echo "INSTANCE_DIR=$instance_dir"
echo "ACTION=$action"

function replace()
{
	echo "replace $2 to $3"
	sed "s#$2#$3#g" $1 >/tmp/$$
	cp /tmp/$$ $1
	rm -rf /tmp/$$
}

function addInstance()
{
	echo "Step 1: Install package, copy $template_dir to $instance_dir."
	if [ -d "$instance_dir" ]; then
		rm -rf "$instance_dir"
	fi 
	cp -R $template_dir $instance_dir 

	serverXMLTemp=$instance_dir/conf/server.xml.template
	serverXML=$instance_dir/conf/server.xml

	echo "Step 2: Start to create $serverXML......"
	cp $serverXMLTemp $serverXML

	echo "Step 3: replace the parameters......"
	replace $serverXML __SHUTDOWN_PORT__ $shutdown_port
	replace $serverXML __HTTP_PORT__ $http_port
	replace $serverXML __REDIRECT_PORT__ $redirect_port
	replace $serverXML __AJP_PORT__ $ajp_port
	# replace $serverXML __WEBAPPS_DIR__ $instance_dir/webapps

	echo "Create new tomcat instance successfully!"
}

function removeInstance()
{
	if [ -d "$instance_dir" ]; then
        	rm -rf "$instance_dir"
	fi

	echo "remove instance $http_port successfullly!"
}

function listInstance()
{
	echo "#################CURRENT INSTANCE#################"
	filelist=$(ls $root_dir/instances)
	for filename in $filelist
	do
		echo $filename 
	done
}

function startInstance()
{
	# echo "Current Instance Dir: $instance_dir."
	export CATALINA_BASE=$instance_dir
	$tomcat_dir/bin/startup.sh	
}

function stopInstance()
{
	# echo "Current Instance Dir: $instance_dir."
	export CATALINA_BASE=$instance_dir
	$tomcat_dir/bin/shutdown.sh	
}

function startAll()
{
	filelist=$(ls $root_dir/instances)
	for filename in $filelist
	do
		
		echo "start instance $filename......"
		export CATALINA_BASE=$root_dir/instances/$filename
		$tomcat_dir/bin/startup.sh	
	done
}

function stopAll()
{
	filelist=$(ls $root_dir/instances)
	for filename in $filelist
	do
		
		echo "stop instance $filename......"
		export CATALINA_BASE=$root_dir/instances/$filename
		$tomcat_dir/bin/shutdown.sh	
	done
	
}

function removeAll()
{
	filelist=$(ls $root_dir/instances)
	for filename in $filelist
	do
		instance_dir=$root_dir/instances/$filename
		if [[ -d "$instance_dir" ]] && [[ $instance_dir != "." ]] && [[ $instance_dir != ".." ]]; then
			echo "remove instance $filename......"
        		rm -rf "$instance_dir"
		fi
	done
}

#########Main#######
if [ "$action" = "-add" ] ; then
	addInstance
elif [ "$action" = "-remove" ]; then
	removeInstance
elif [ "$action" = "-list" ]; then
	listInstance
elif [ "$action" = "-start" ]; then
	startInstance
elif [ "$action" = "-stop" ]; then
	stopInstance
elif [ "$action" = "-startAll" ]; then
	startAll	
elif [ "$action" = "-stopAll" ]; then
	stopAll	
elif [ "$action" = "-removeAll" ]; then
	removeAll	
fi


