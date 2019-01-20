# -*- coding: utf-8 -*-
import sys

def traitement_fichier(fichier_dump,concat,compteur):
    concaten = concat[:(len(concat))-4] + "-en.txt"
    concatfr = concat[:(len(concat))-4] + "-fr.txt"

    fichier = open(fichier_dump,'r', encoding = "utf-8")
    contenu = fichier.read()
    fichier.close()

    if compteur[0] == "1":
        fichier = open(concaten,'a', encoding = "utf-8")
    else:
        fichier = open(concatfr,'a', encoding = "utf-8")
    fichier.write("<Tweet_")
    fichier.write(compteur)
    fichier.write(">\n")
    fichier.write(contenu)
    fichier.write("\n")
    fichier.write("</Tweet_")
    fichier.write(compteur)
    fichier.write(">\n")
    print (compteur,"->",concat)
    fichier.close()

traitement_fichier(sys.argv[1], sys.argv[2], sys.argv[3])