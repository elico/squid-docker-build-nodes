#!/usr/bin/env bash

case $1 in
	build)
		rm -v ./*/build
	;;
	packages)
		rm -v ./*/srv/packages/*.rpm
		rm -v ./*/srv/packages/*.tar
		rm -v ./*/srv/packages/*.tar.gz
		rm -v ./*/srv/packages/*.tar.xz
	;;
	ccache)
		read -p "Are you sure you want to clean all CCACHE (y/n)?" choice
		case "$choice" in 
			y|Y )
				echo "yes.."
				rm -rfv ./*/srv/ccache/
			;;
			n|N ) echo "no";;
			* ) echo "invalid";;
		esac
	;;
	*)
		echo "Usage: $0 (packages|ccache|build)"
	;;
esac
