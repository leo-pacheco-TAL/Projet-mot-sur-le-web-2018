#!/usr/bin/bash
# MODE D'EMPLOI DU PROGRAMME :
#               bash programme_tableau.sh NOM_DOSSIER_URL NOM_FICHIER_HTML MOTIF
# le programme prend 3 arguments : 
# - le premier est le nom du dossier contenant les fichiers d'URLs, i.e l'INPUT : $1 par la suite
# - le second est le fichier TABLEAU au format HTML : $2 par la suite
# - le troisième correspond aux différentes formes (une expression régulières) dans les différentes langues, soit le motif. $3
# les 3 sont fournis dans la ligne de commande via un chemin relatif par exemple
#-------------------------------------------------------------------------------
#fonctions à écrire au préalable:
#création du tableau:
function html_head($2){
	echo "<html>" > $2 ;
	echo "<head><title>TABLEAUX URL</title>
	<meta charset=\"UTF-8\" /></head>" >> $2 ;
	echo "<body>" >> $2 ;
}
function html_body($2){

}
function html_tail($2){
	echo "</body>" >> $2 ;
	echo "</html>" >> $2 ;
}


#Compteur pour le tableau
cpt_tab = 1;
#-------------------------------------------------------------------------------
#Trouver encodage
#Encodage ok (UTF-8)
#Encodage mauvais (non UTF-8)

#-------------------------------------------------------------------------------
#Motifs correspondant aux formes recherchés sous forme de de regex.
function regexFR ($3){

}
function regexEN ($3){

}
function regexJA ($3){

}
#-------------------------------------------------------------------------------
#bigrams
#contextes


#-------------------------------------------------------------------------------
# Phase 1 : ECRITURE ENTETE FICHIER HTML
#-------------------------------------------------------------------------------
# Phase 2 : traitement de chacun des fichier d'URLs
#-------------------------------------------------------------------------------
# Phase 3 : traitement de chaque ligne du fichier d'URL en cours
#-------------------------------------------------------------------------------
# Phase 4 : ECRITURE FIN DE FICHIER HTML
#-------------------------------------------------------------------------------
# c'est fini
exit;