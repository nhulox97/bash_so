
{
    if((tolower($2) == "april cross")){
        cont++
    }
}

END{
    print "Coincidencias para  April Cross son: ", cont
}
