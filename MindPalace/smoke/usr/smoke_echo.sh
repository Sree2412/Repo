#!/bin/bash

echo_line() {
    echo -n $(date +"[ %T ] ")
    echo -n " "
    echo $1
}


echo_status() {
    echo -n $(date +"[ %T ] ")
    echo -n " "
    echo -n -e $1
    echo -n -e "..."
}

echo_ok() {
    echo -e "[ OK ]"
}

echo_error() {
    echo -e "[ ERROR ]"
}

echo_warning() {
    echo -e "[ $1 ]"
}

