{
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
}

