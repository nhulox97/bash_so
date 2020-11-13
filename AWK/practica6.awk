 {
   print $2 
    preferencias_total[$2] = j
    j++
    if(!(toupper($2) in preferencias)){
        preferencias[toupper($2)]=i
        i++
    }
}

END{
    for(preferencia in preferencias){
        count = 0
        for(preferencia_total in preferencias_total){
            if(preferencia == toupper(preferencia_total)){
                count++
            }            
        }
        if(count>=1){
            print "Para ", preferencia, " existen ", count , " coincidencias" 
        }
    } 
}

