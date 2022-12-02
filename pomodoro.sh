#!/bin/sh

carpetacache="$XDG_CACHE_HOME/pomodoro.sh"
carpetalog="$XDG_DATA_HOME/pomodoro.sh"
cache="$carpetacache/cycle"
log="$carpetalog/log"
seg='0'
min='0'
mintrabajo='25'
mindescanso='5'
mindescansolargo='10'

contador () {
	while test $(( min )) -lt $1; do
		seg='0'
		while test $(( seg )) -lt $2; do
			sleep 0.03
			echo ${min}:${seg}
			seg=$(( seg + 1))
		done
		min=$(( min + 1 ))
	done
}

cacheprobar () {
	test -e ${cache} && {
		test -s ${cache} || {
			rm ${cache}
			echo "trabajo" > ${cache}
			echo "0" >> ${cache}
		}
	} || {
		mkdir -p $carpetacache
		echo "trabajo" > ${cache}
		echo "0" >> ${cache}
	}
}

cacheactualizar () {
	ciclo=$(head -n 1 ${cache})
	test ${ciclo} = "trabajo" && {
		sed -i 's/trabajo/descanso/' ${cache}
		num=$(tail -n 1 ${cache})
		num=$((num + 1))
		sed -i "2c $num" ${cache}
	} || {
		sed -i 's/descanso/trabajo/' ${cache}
	}
}

cacheleer () {
	ciclo=$(head -n 1 ${cache})
	test ${ciclo} = "trabajo" && {
		echo ${mintrabajo} 60
	} || {
		echo ${mindescanso} 60
	}
}

optstring="r"
while getopts ${optstring} arg; do
	case ${arg} in
		r)
			rm $cache
			cacheprobar
			;;
		?)
			:
			;;
		*)
			:
			;;
	esac
done

while true; do
	contador $(cacheleer)
	cacheactualizar
done
