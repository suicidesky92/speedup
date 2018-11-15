#!/bin/bash
# Create a wrapper around the command ls
com () {
command $A
}
A=$1
com
