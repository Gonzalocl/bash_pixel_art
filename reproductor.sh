#!/bin/bash

# primer parametro carpeta cion los cuadros





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


frames=$(cat $1/inf | head -n 1)
delay=$(cat $1/inf | head -n 2 | tail -n -1)

echo $frames
echo $delay



while true
do
	for i in $(seq 0 $frames)
	do
		clear
		visualizar $1/$i -1 -1
		sleep $delay
	done
	
done

















































exit

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



























