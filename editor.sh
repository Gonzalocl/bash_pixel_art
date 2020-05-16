#!/bin/bash

# primer parametro archivo a editar
# primer parametro imagen segundo y tercero puntero
function visualizar {
	##### comprobar la posicion del puntero
	# a lo alto
	h=$(cat $1 | wc -l)
	if [ $h -eq $3 ]
	then
		echo -e "-1\t" >> $1
	fi
	
	# a lo ancho
	linea=$(cat $1 | head -n $((1+$3)) | tail -n -1)
	w=$(echo $linea | wc -w)
	if [ $w -le $2 ]
	then
		for o in $(seq 0 $(($2-w)))
		do
			linea=$(echo -en "$linea-1\t")
		done
		arriba=$(cat $1 | head -n $3)
		abajo=$(cat $1 | tail -n +$(($3+2)))
		echo "$arriba" > $1
		echo "$linea" >> $1
		echo "$abajo" >> $1
	fi
	
	#######################################

	Y=0
	while read l
	do
		X=0
		for n in $l
		do
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
		done
		echo -e "\e[0m"
		let Y=Y+1
	done < $1
}

# primer parametro imagen segundo u tercero puntero cuatrto y quinto offset
function visualizarOffset {

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

# primer parametro imagen segundo u tercero offset
function guardarOffset {

	# arriba
	yo=$3
	while [ $yo -gt 0 ]
	do
		echo -e "-1\t"
		let yo=yo-1
	done
	
	Y=0
	while read l
	do
		if [ $yo == 0 ]
		then
			xo=$2
			while [ $xo -gt 0 ]
			do
				echo -ne "-1\t"
				let xo=xo-1
			done
			
			X=0
			for n in $l
			do
				if [ $xo == 0 ]
				then
					echo -ne "$n\t"
				######## offset
				else
					let xo=xo+1
				fi
			done
			echo
		###########offset
		else
			let yo=yo+1
		fi
	done < $1
}


TEMP=$(mktemp)

function setOffset {
	Xoffset=0
	Yoffset=0
	clear
	visualizar $1 -1 -1 $Xoffset $Yoffset
	while read -n 1 j
	do
		case $j in
		j )
			let Xoffset=Xoffset-1
			clear
			visualizarOffset $1 -1 -1 $Xoffset $Yoffset
		;;
		l )
			let Xoffset=Xoffset+1
			clear
			visualizarOffset $1 -1 -1 $Xoffset $Yoffset
		;;
		i )
			let Yoffset=Yoffset-1
			clear
			visualizarOffset $1 -1 -1 $Xoffset $Yoffset
		;;
		k )
			let Yoffset=Yoffset+1
			clear
			visualizarOffset $1 -1 -1 $Xoffset $Yoffset
		;;
		o|q )
			clear
			guardarOffset $1 $Xoffset $Yoffset > $TEMP
			cat $TEMP > $1
			visualizar $1 -1 -1
			x=0
			y=0
			break
		;;
		esac
	done
}

# parametros 1 imagen 2 color 3 X 4 Y
function pintar {
	arriba=$(cat $1 | head -n $4)
	linea=$(cat $1 | head -n $((1+$4)) | tail -n -1)
	abajo=$(cat $1 | tail -n +$(($4+2)))
	echo "$arriba" > $1
	c=0
	for u in $linea
	do
		if [ $c -eq $3 ]
		then
			echo -ne "$2\t" >> $1
		else
			echo -ne "$u\t" >> $1
		fi
		let c=c+1
	done
	echo >> $1
	echo "$abajo" >> $1
}

x=0
y=0

clear
visualizar $1 -1 -1

while read -n 1 i
do
	case $i in
	j )
		## mover
		clear
		if [ $x = 0 ]
		then
			echo fuera del limite
		else
			let x=x-1
		fi
		visualizar $1 $x $y
	;;
	l )
		## mover
		let x=x+1
		clear
		visualizar $1 $x $y
	;;
	i )
		## mover
		clear
		if [ $y = 0 ]
		then
			echo fuera del limite
		else
			let y=y-1
		fi
		visualizar $1 $x $y
	;;
	k )
		## mover
		let y=y+1
		clear
		visualizar $1 $x $y
	;;
	f )
		pintar $1 9 $x $y
		clear
		visualizar $1 $x $y
	;;
	d )
		pintar $1 130 $x $y
		clear
		visualizar $1 $x $y
	;;
	s )
		pintar $1 222 $x $y
		clear
		visualizar $1 $x $y
	;;
	z )
		pintar $1 11 $x $y
		clear
		visualizar $1 $x $y
	;;
	a )
		## borrar
		pintar $1 -1 $x $y
		clear
		visualizar $1 $x $y
	;;
	q )
		## Salir
		echo Saliendo
		break
	;;
	o )
		setOffset $1
	;;
	esac
done

# eliminar bordes
function esVacia {
	read l
	for n in $l
	do
		if [ $n != -1 ]
		then
			return 1
		fi
	done
	return 0
}



tac $1 | while read l
do
	if ! echo $l | esVacia
	then
		echo "$l"
	fi
done | tac > $TEMP
cp $TEMP $1








rev $1 | while read l
do
	borrar=true
	for n in $l
	do
		if $borrar
		then
			if [ $n != 1- ]
			then
				borrar=false
				echo -n $n
			fi
		else
			echo -ne "\t$n"
		fi
	done
	echo
done | rev > $TEMP
cp $TEMP $1























rm $TEMP



