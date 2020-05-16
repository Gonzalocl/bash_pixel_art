#!/bin/bash

# primer parametro archivo a editar

# primer parametro imagen segundo u tercero puntero cuatrto y quinto offset
function visualizar {

	yo=$5
	while [ $yo -gt 0 ]
	do
		echo
		let yo=yo-1
	done
	
	Y=0
	while read l
	do
		if [ $yo == 0 ]
		then
			xo=$4
			while [ $xo -gt 0 ]
			do
				echo -n "  "
				let xo=xo-1
			done
			
			X=0
			for n in $l
			do
				if [ $xo == 0 ]
				then
					if [ $2 == $X -a $3 == $Y ]
					then
						p="+ "
					else
						p="  "
					fi
				
					if [ $n == -1 ]
					then
						echo -ne "\e[0m${p}"
					else
						echo -ne "\e[48;5;${n}m${p}"
					fi
				
					let X=X+1
				else
					let xo=xo+1
				fi
			done
			echo -e "\e[0m"
			let Y=Y+1
		else
			let yo=yo+1
		fi
	done < $1
}

Xoffset=0
Yoffset=0


function setOffset {
	clear
	visualizar $1 -1 -1 $Xoffset $Yoffset
	while read -n 1 j
	do
		case $j in
		'j' )
			let Xoffset=Xoffset-1
			clear
			visualizar $1 -1 -1 $Xoffset $Yoffset
		;;
		'l' )
			let Xoffset=Xoffset+1
			clear
			visualizar $1 -1 -1 $Xoffset $Yoffset
		;;
		'i' )
			let Yoffset=Yoffset-1
			clear
			visualizar $1 -1 -1 $Xoffset $Yoffset
		;;
		'k' )
			let Yoffset=Yoffset+1
			clear
			visualizar $1 -1 -1 $Xoffset $Yoffset
		;;
		'o' )
			clear
			visualizar $1 -1 -1 $Xoffset $Yoffset
			break
		;;
		'q' )
			clear
			visualizar $1 -1 -1 $Xoffset $Yoffset
			break
		;;
		esac
	done
}

x=0
y=0

clear
visualizar $1 -1 -1 $Xoffset $Yoffset

while read -n 1 i
do
	case $i in
	'j' )
		clear
		if [ $x = 0 ]
		then
			echo fuera del limite
		else
			let x=x-1
		fi
		visualizar $1 $x $y $Xoffset $Yoffset
	;;
	'l' )
		let x=x+1
		clear
		visualizar $1 $x $y $Xoffset $Yoffset
	;;
	'i' )
		clear
		if [ $y = 0 ]
		then
			echo fuera del limite
		else
			let y=y-1
		fi
		visualizar $1 $x $y $Xoffset $Yoffset
	;;
	'k' )
		let y=y+1
		clear
		visualizar $1 $x $y $Xoffset $Yoffset
	;;
	'r' )
		echo rojo
	;;
	'v' )
		echo verde
	;;
	'a' )
		echo azul
	;;
	'b' )
		echo borrar
	;;
	'q' )
		echo Saliendo
		break
	;;
	'o' )
		setOffset $1
	;;
	esac
done




