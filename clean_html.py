# -*- coding: utf-8 -*-
import sys

def traitement_fichier(texte, balise1, balise15, balise2):
    fichier = open(texte,'r', encoding = "utf-8")
    contenu = fichier.read()
    fichier.close()
    for i in range (20):
        string1 = balise1 + " " * i
        string1 += balise15
        try:
            index1=contenu.index(string1)
            w=i
            break
        except ValueError:
            pass
    contenu2 = contenu[(index1+12+w):]
            
    for j in range (20):
        string2 = balise2 + " " * j
        string2 += balise2
        try:
            index2=contenu2.index(string2)
            break
        except ValueError:
            pass
    fichier = open(texte,'w', encoding = "utf-8")
    fichier.write(contenu2[:index2-2])
    #print ("->",contenu2[:index2-2])
    fichier.close()

    fichier = open(texte,'r', encoding = "utf-8")
    contenu = fichier.read()
    fichier.close()
    while 1:
        contenu2=contenu.replace("  "," ")
        if contenu2 == contenu:
            break
        else:
            contenu = contenu2
    fichier = open(texte,'w', encoding = "utf-8")
    fichier.write(contenu)
    print ("->",contenu)
    fichier.close()
    
traitement_fichier(sys.argv[1],"on", "Twitter:","alternate")