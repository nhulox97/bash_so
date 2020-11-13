{
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
}

