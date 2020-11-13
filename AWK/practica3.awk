
{
    if((tolower($2) == "sicily giant")){
        cont++
    }
}

END{
    print "Coincidencias para  Sicily Giant son: ", cont
}
