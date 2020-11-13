#!/bin/bash

archivo='files/encuesta.txt'

show_menu() {
    echo '----------------- Menu -----------------'
    echo '(1). Lista todas las categorías de las preferencias'
    echo '(2). Contar cuantos eligieron April Cross'
    echo '(3). Contar cuantos eligieron Sicily Giant '
    echo '(4). Contar la cantidad de participantes '
    echo '(5). Contar y listar las categorías que fueron seleccionadas por al menos 5 participantes'
    echo '(6). Listar todas las selecciones que tiene una palabra'
    echo '(7). Listar todas las selecciones que tienen 2 o mas palabras'
    echo '(8). Salir'
}

practica1() {
    echo '----------------- Listar categorias -----------------'
    awk -F" - " '{
    #testtrim($2) 
    gsub(/^[ \t]+|[ \t]+$/, "", $2); 
    gsub(/[ ]+/, " ", $2); 
    if(!(toupper($2)  in prefs)){
        prefs[toupper($2)]=i
        i++
    }
}

END{
for(pref in prefs){
    print pref
} 
}' $archivo 
}

practica2() {
    echo '----------------- Coincidencias APRIL CROSS -----------------'
     awk -F" - " '{
            gsub(/^[ \t]+|[ \t]+$/, "", $2);
            gsub(/[ ]+/, " ", $2);
            if(toupper($2) == "APRIL CROSS"){
                cont++
            }
        }

        END{
            print "Coincidencias para  April Cross son: ", cont
        }' $archivo
}

practica3() {
    echo '----------------- Coincidencias SICILY GIANT -----------------'
     awk -F" - " '{
            gsub(/^[ \t]+|[ \t]+$/, "", $2);
            gsub(/[ ]+/, " ", $2);
            if(toupper($2) == "APRIL CROSS"){
                cont++
            }
        }

        END{
            print "Coincidencias para  April Cross son: ", cont
        }' $archivo

}

practica4() {
    echo '----------------- Contar participantes -----------------'
    awk -F" - " '{
        gsub(/^[ \t]+|[ \t]+$/, "", $1);
        gsub(/[ ]+/, " ", $1);
        participant=toupper($1);
        if(!(participant in participants)){
            participants[participant]=participant
            cont++
        }
    }

    END{
        print "El número de participantes es: ", cont
    }' $archivo
}

practica5() {
    echo '----------------- Listar categorias que fueron seleccionada al menos 5 veces -----------------'
    awk -F" - " '{
    gsub(/^[ \t]+|[ \t]+$/, "", $2); 
    gsub(/[ ]+/, " ", $2); 
    gpref=toupper($2)
    if(!(gpref in prefs)){
        prefs[gpref]=i
        i++
    }
    if(gpref == "WHITE ICICLE"){
        WHITEICICLE++
    }
    if(gpref == "RED KING"){
        REDKING++
    }
    if(gpref == "BUNNY TAIL"){
        BUNNYTAIL++ 
    }
    if(gpref == "PLUM PURPLE"){ 
        PLUMPURPLE++ 
    }
    if(gpref == "SICILY GIANT"){ 
        SICILYGIANT++ 
    }
    if(gpref == "SNOW BELLE"){ 
        SNOWBELLE++ 
    }
    if(gpref == "FRENCH BREAKFAST"){ 
        FRENCHBREAKFAST++ 
    }
    if(gpref == "CHAMPION"){ 
        CHAMPION++ 
    }
    if(gpref == "CHERRY BELLE"){ 
        CHERRYBELLE++ 
    }
    if(gpref == "DAIKON"){ 
        DAIKON++ 
    }
    if(gpref == "APRIL CROSS"){ 
        APRILCROSS++ 
    }
}

END{
    if(WHITEICICLE >= 5) {
        print "WHITE ICICLE", WHITEICICLE
    }
    if(REDKING >= 5) {
        print "RED KING", REDKING
    } 
    if(BUNNYTAIL >= 5) {
        print "BUNNY TAIL", BUNNYTAIL
    }
    if(PLUMPURPLE >= 5) {
        print "PLUM PURPLE", PLUMPURPLE
    }
    if(SICILYGIANT >= 5 ) {
        print "SICILY GIANT", SICILYGIANT
    }
    if(SNOWBELLE >= 5 ) {
        print "SNOW BELLE", SNOWBELLE
    }
    if (FRENCHBREAKFAST >= 5) {
        print "FRENCH BREAKFAST", FRENCHBREAKFAST
    }
    if (CHAMPION >= 5) {
        print "CHAMPION", CHAMPION
    }
    if (CHERRYBELLE >= 5) {
        print "CHERRY BELLE", CHERRYBELLE
    }
    if (DAIKON >= 5) {
        print "DAIKON", DAIKON
    }
    if (APRILCROSS >= 5) {
        print "APRIL CROSS", APRILCROSS
    }
}' $archivo 
}

practica6() {
    echo '----------------- Mostrar preferencias cuyo nombre solo tiene 1 palabra -----------------'
        awk -F" - " '{
        gsub(/^[ \t]+|[ \t]+$/, "", $2);
        gsub(/[ ]+/, " ", $2);
        pref=toupper($2);
        if(!(pref in prefs)){
            prefs[pref]=pref
        }
    }
    END{
        for(pref in prefs){
            count=0
            split(pref, string, "")
             for (j=0; j<length(string); j++) {
               if(string[j] == " "){
                   j=length(string)
                   count=1
               }
             }
            if(count == 0){
                print pref
            }
        }
    }' $archivo
}

practica7() {
    echo '----------------- Mostrar preferencias cuyo nombre tiene mas de 1 palabra -----------------'
        awk -F" - " '{
        gsub(/^[ \t]+|[ \t]+$/, "", $2);
        gsub(/[ ]+/, " ", $2);
        pref=toupper($2);
        if(!(pref in prefs)){
            prefs[pref]=pref
        }
    }
    END{
        for(pref in prefs){
            count=0
            split(pref, string, "")
             for (j=0; j<length(string); j++) {
               if(string[j] == " "){
                   j=length(string)
                   count=1
               }
             }
            if(count > 0){
                print pref
            }
        }
    }' $archivo
}

function main(){
    menu_condition='s'

    while [ $menu_condition = 's' ]; do
        show_menu
        read -p '=> Ingrese su opcion: ' option
        case $option in
            1)
                clear
                practica1;;
            2)
                clear
                practica2;;
            3)
                clear
                practica3;;
            4)
                clear
                practica4;;
            5)
                clear
                practica5;;
            6)
                clear
                practica6;;
            7)
                clear
                practica7;;
            8)
                clear
                menu_condition='n';;
        esac
        if [ $option -ne 8 ]; then
            read -p '=> Desea realizar otra operacion? (s)i (n)o: ' menu_condition
            echo -e "\n"
        fi
        clear
    done
}

main
