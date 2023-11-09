#! /bin/bash
clear
# forcyklus s inkrementovanou promennou
for ((i = 1; i <= 5; i++))
do
    echo "Iterace číslo $i"
done

echo "-------"
#For cyklus procházející pole
fruits=("jabko" "hruška" "broskev")
for fruit in "${fruits[@]}"
do
    echo "Ovoce: $fruit"
done

echo "-------"
#While cyklus 1
counter=1
while [ $counter -le 5 ]
do
    echo "Iterace číslo $counter"
    counter=$((counter+1))
done

#while cyklus 2
while true
do
    # Tělo smyčky
    echo "Tato smyčka bude opakovat, dokud nebude použit příkaz break."
    read -p "sem neco napis, konec ukonci tuto smycku" odpoved
	
    # Nějaká podmínka, která určuje, kdy má smyčka skončit
    if [ $odpoved == "konec" ]
    then
        break
    else
    	echo $odpoved	    
    fi
done

echo "--------"
#cyklus Until

counter=1
until [ $counter -gt 5 ]
do
    echo "Iterace číslo $counter"
    counter=$((counter+1))
done

