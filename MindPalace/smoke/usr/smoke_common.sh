#!/bin/bash
source smoke_echo.sh


root_required()
{
    echo_status "Checking privileges"
    if [ "$EUID" -ne 0 ]; then
	echo_warning "ROOT REQUIRED"
	exit 1
    else
	echo_ok
    fi
}

ping_host()
{
    echo_status "Pinging $1"
    ping -c 2 $1 >/dev/null

    if [ $? == 0 ]; then
        echo_ok
    else
	echo_error
    fi
}


mount_storage()
{
    ping_host $1
    echo_status "Checking $1"
    cat /proc/mounts | grep "$1" > /dev/null;

    if [ $? == 1 ]; then
	echo_warning "NOT MOUNTED"
        root_required

	echo_status "Mounting $1"
        mkdir -p "/mnt/$1/$2"
	mount -t cifs -o $3 "//$1/$2" "/mnt/$1/$2" &> mount_storage.log
            if [ $? == 0 ]; then
                echo_ok
            else
                echo_error
                cat mount_storage.log
		rm -f mount_storage.log
            fi
	rm -f mount_storage.log
    else
	echo_ok
    fi
}

umount_storage()
{
    echo_status "Checking $1"
    cat /proc/mounts | grep "/mnt/$1" > /dev/null;
    if [ $? == 0 ]; then
	echo_warning "MOUNTED"
        root_required
        echo_status "Unmounting $1"
        sudo umount "/mnt/$1"
        echo_ok
    else
	echo_ok
    fi
}


umount_sambas() 
{
    umount -a -t cifs -l
}


