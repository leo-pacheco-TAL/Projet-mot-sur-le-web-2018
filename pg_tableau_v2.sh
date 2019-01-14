#!/usr/bin/bash
# MODE D'EMPLOI DU PROGRAMME :
#               bash programme_tableau.sh NOM_DOSSIER_URL NOM_FICHIER_HTML MOTIF
# le programme prend 3 arguments : 
# $1 = le premier est le nom du dossier contenant les fichiers d'URLs, i.e l'INPUT :
# $2 = le second est le fichier TABLEAU au format HTML : $2 par la suite
# $3= le troisième correspond aux différentes formes (une expression régulières) dans les différentes langues, soit le motif. $3
# les 3 sont fournis dans la ligne de commande via un chemin relatif par exemple
#-------------------------------------------------------------------------------
#FONCTIONS :
#création du tableau

#écriture tête du fichier
function html_head(){
	echo "<html>";
	echo "<head><title>TABLEAUX URL</title><meta charset=\"UTF-8\" /></head>";
	echo "<body>";
}

#écriture corps du fichier
function html_body(){
	echo "<table align=\"center\" border=\"1\">";
    echo "<tr bgcolor=\"yellow\"><td>N°</td><td>CodeHttp</td><td>URL</td><td>PageAspirée</td><td>Encodage</td><td>Dump</td><td>Contexte</td><td>Contexte HTML</td><td>Fq Motif</td><td>Index</td><td>Bigramme</td></tr>";
}

#écriture fin de fichier
function html_tail(){
	echo "</body>";
	echo "</html>";
}
#-------------------------------------------------------------------------------
#vérif code sortie, aspiration & dump des URLS
function check_code_http(){
	code_sortie=$(curl -s -L -o --no-check-certificate tmp.txt -w "%{http_code}" $ligne | tail -1);
}

function code_httpOK(){
	ENCODAGE=$(curl -sIL "$ligne" | egrep -i "charset" | cut -f2 -d"=" |  tr "[a-z]" "[A-Z]" |  tr -d "\n" |  tr -d "\r");
}
function code_httpPOURRI(){
	#echo -e "PB....$compteurtableau::$compteur::$code_sortie::::$ligne\n";
	#ligne suivante dans le tableau
	echo "<tr><td>$compteur</td><td><fontcolor=\"red\"><b>$code_sortie</b></td><td><atarget=\"_blank\"href=\"$ligne\">$ligne</a></td><td>-</td><td>-</td><td>-</td><td>-</td><td>-</td><td>-</td><td>-</td><td>-</td></tr>";
}
function aspi_URL(){
	curl -sL -o ./PAGES-ASPIREES/$compteurtableau-$compteur.html $ligne;
}

function py_Dump(){
	python ./PROGRAMMES/clean_html.py ./DUMP-TEXT/dumps_indiv/$compteurtableau-$compteur.txt;
	python ./PROGRAMMES/concat-dump.py ./DUMP-TEXT/dumps_indiv/$compteurtableau-$compteur.txt ./DUMP-TEXT/all_dumps.txt $compteurtableau-$compteur;
}

function py_Bigram(){
	python ./PROGRAMMES/concat-dump.py ./BIGRAMES/bigrames_indiv/bigrame-$compteurtableau-$compteur.txt ./BIGRAMES/all_bigrames.txt $compteurtableau-$compteur;
}

function py_Index(){
	python ./PROGRAMMES/concat-dump.py ./INDEXES/indexes_indiv/index-$compteurtableau-$compteur.txt ./INDEXES/all_indexes.txt $compteurtableau-$compteur;
}
function dump_URL(){
	#lynx -dump -nolist $ligne > ./DUMP-TEXT/$compteurtableau-$compteur.txt;
	lynx -assume_charset=$ENCODAGE -display_charset=$ENCODAGE -dump -nolist $ligne | tr "\n" " " > ./DUMP-TEXT/dumps_indiv/$compteurtableau-$compteur.txt;
	py_Dump;
}

function dump_URL_2(){
	lynx -assume_charset=$ENCODAGEFILE -display_charset=$ENCODAGEFILE -dump -nolist $ligne | iconv -c -f $ENCODAGEFILE -t UTF-8 > ./DUMP-TEXT/dumps_indiv/$compteurtableau-$compteur.txt;
	py_Dump;
}

#-------------------------------------------------------------------------------
#ENCODAGE
#isoler le charset

function isolate_charset(){
	echo $compteur; 
	egrep -o "meta.+charset *= *[^>]+" ./PAGES-ASPIREES/$fichier | egrep -o "charset *= *[^>]+" | cut -f2 -d"=" | egrep -o "(\w|-)+" | uniq; compteur=$((compteur+1));
	echo "stop, appuie sur return";
	read rep;
}

#Trouver encodage
function find_enc(){
	aspi_URL;
	ENCODAGEFILE=$(egrep -o "meta.+charset *= *[^>]+" ./PAGES-ASPIREES/$fichier | egrep -o "charset *= *[^>]+" | cut -f2 -d"=" | egrep -o "(\w|-)+" | uniq);
	#ENCODAGEFILE=$(file -i ./PAGES-ASPIREES/$compteurtableau-$compteur.html | cut -d"=" -f2);
	echo -e "ENCODAGE initial vide. ENCODAGE extrait via file : $ENCODAGEFILE \n";
	echo -e "Il faut désormais s'assurer que cet encodage peut être OK ou pas... \n";
}
#-------------------------------------------------------------------------------
#bigrams
function bigrams(){
	egrep -o "\w+" ./DUMP-TEXT/dumps_indiv/$compteurtableau-$compteur.txt > ./BIGRAMES/bi1.txt;
	tail -n +2 ./BIGRAMES/bi1.txt > ./BIGRAMES/bi2.txt ;
	paste ./BIGRAMES/bi1.txt ./BIGRAMES/bi2.txt > ./BIGRAMES/bi3.txt ;
	cat ./BIGRAMES/bi3.txt | sort | uniq -c | sort -r > ./BIGRAMES/bigrames_indiv/bigrame-$compteurtableau-$compteur.txt;
	py_Bigram;
}
#contexte
function context(){
	egrep -i "$3" ./DUMP-TEXT/dumps_indiv/$compteurtableau-$compteur.txt > ./CONTEXTES/contextes_indiv/$compteurtableau-$compteur.txt;
}

function freq_motif(){
	nbmotif=$(egrep -coi "$3" ./DUMP-TEXT/dumps_indiv/$compteurtableau-$compteur.txt);
}

function minigrep(){
	perl ./minigrep/minigrepmultilingue.pl "utf-8" ./DUMP-TEXT/$compteurtableau-$compteur.txt ./minigrep/parametre-motif.txt ;
	mv resultat-extraction.html ./CONTEXTES/$compteurtableau-$compteur.html ;
}

function index(){
	egrep -o "\w+" ./DUMP-TEXT/dumps_indiv/$compteurtableau-$compteur.txt | sort | uniq -c | sort -r > ./INDEXES/indexes_indiv/index-$compteurtableau-$compteur.txt;
	py_Index;
}

#nouvelles colonnes
function add_columns(){
	echo "<tr><td>$compteur</td><td>$code_sortie</td><td><a target=\"_blank\" href=\"$ligne\">$ligne</a></td><td><a target=\"_blank\" href=\"../PAGES-ASPIREES/$compteurtableau-$compteur.html\">page aspirée n° $compteur</a></td><td>$ENCODAGE</td><td><a target=\"_blank\" href=\"../DUMP-TEXT/dumps_indiv/$compteurtableau-$compteur.txt\">DUMP  n° $compteur</a></td><td><a href=\"../CONTEXTES/$compteurtableau-$compteur.txt\">CT $compteurtableau-$compteur</a></td><td><a href=\"../CONTEXTES/$compteurtableau-$compteur.html\">CTh $compteurtableau-$compteur</a></td><td>$nbmotif</td><td><a href=\"../DUMP-TEXT/index-$compteurtableau-$compteur.txt\">Ind $compteurtableau-$compteur</a></td><td><a href=\"../DUMP-TEXT/bigramme-$compteurtableau-$compteur.txt\">Bigr $compteurtableau-$compteur</a></td></tr>";
}
#-------------------------------------------------------------------------------
#Concaténer les fichiers DUMP dans un seul fichier
function concat_dump(){
	echo -e "<fichier=\"$fichier\">\n" >> ./DUMP-TEXT/all_dumps.txt;
	iconv -f UTF-8 -t UTF-8 ./DUMP-TEXT/all_dumps.txt;
	cat -A ./DUMP-TEXT/dumps_indiv/$fichier >> ./DUMP-TEXT/all_dumps.txt; 
	echo -e "\n</fichier>\n" >> ./DUMP-TEXT/all_dumps.txt;
	#iconv -f UTF-8 -t UTF-8 ./DUMP-TEXT/all_dumps.txt; #tentative de conversion en UTF-8
}

function traitement(){
	aspi_URL $1;
	#dump de l'URL
	dump_URL $1;
	#py_Dump;
	#contexte, bigramme, comptage occurrences dans DUMP
	context $3;
	freq_motif $3;
	#minigrep $3;
	index $3;
	bigrams $3;
	#ajout nouvelles colonnes
}

function traitement_2(){
	aspi_URL $1;
	#dump de l'URL
	dump_URL_2 $1;
	#py_Dump;
	#contexte, bigramme, comptage occurrences dans DUMP
	context $3;
	freq_motif $3;
	#minigrep $3;
	index $3;
	bigrams $3;
	#ajout nouvelles colonnes
}
#-------------------------------------------------------------------------------
#ECRITURE / IMPLÉMENTATION DU SCRIPT
#-------------------------------------------------------------------------------
# Phase 1 : ECRITURE ENTETE FICHIER HTML
rm TABLEAUX/tableau_url.html;
html_head >> $2;
#-------------------------------------------------------------------------------
# Phase 2 : traitement de chacun des fichier d'URLs
#Compteur pour le tableau
compteurtableau=1;
#initialisation des fichiers concaténés
echo "" > ./DUMP-TEXT/all_dumps-en.txt;
echo "" > ./DUMP-TEXT/all_dumps-fr.txt;
echo "" > ./BIGRAMES/all_bigrames-en.txt;
echo "" > ./BIGRAMES/all_bigrames-fr.txt;
echo "" > ./INDEXES/all_indexes-en.txt;
echo "" > ./INDEXES/all_indexes-fr.txt;
for fichier in $(ls $1) #pour chaque fichier dans le repertoire courant,
	do 
		html_body >> $2;
	#-------------------------------------------------------------------------------
	# Phase 3 : traitement de chaque ligne du fichier d'URL en cours
	compteur=1;
	for ligne in $(cat $1/$fichier)
	do
		check_code_http $1;
		if [[ $code_sortie == 200 ]]
			then
				echo -e "URL ok";
				#URL OK
				# recherche de l'encodage du l'URL en cours
				code_httpOK >> $2;
				echo -e "$compteurtableau::$compteur::$code_sortie::$ENCODAGE::$ligne\n";
				if [[ $ENCODAGE == "UTF-8" ]]
					then
						echo -e "ENCODAGE initial <$ENCODAGE> OK : on passe au traitement \n";
						#aspiration de l'URL
						traitement;
						add_columns >> $2;
					else
						echo -e "==> il faut traiter les URLs OK qui ne sont pas à priori en UTF8\n";
						echo -e "ENCODAGE initial : <$ENCODAGE> \n";
						if [[ $ENCODAGE == "" ]]
							then
							# On cherche l'encodage de la page en appliquant la commande file sur la page aspirée (++++++)
								find_enc $1;
								echo -e "encodage initial vide, extraction: $ENCODAGEFILE"
								#for fichier in $(ls ./PAGES-ASPIREES/); 
								#	do isolate_charset $1; #on isole le charset
								#done;
								#est-ce que ENCODAGEFILE vaut UTF8 ou non ???
								if [[ $ENCODAGEFILE == "UTF-8" ]]
									then
										#contextes et bigrams
										traitement;
										add_columns >> $2;
									else 
										ENCODAGE_RETOUR=$(iconv -l | egrep "$ENCODAGEFILE");
										if [[ ENCODAGE_RETOUR != "" ]]
											then
												traitement_2;
												add_columns >> $2;
											else
												echo -e "L'encodage est inconnu, il faut changer changer d'URL";
										fi
								fi
						fi
				fi
			else
				if [[ code_sortie != 200 ]]
					then
						code_httpPOURRI >> $2;
						echo -e "3 else $code_sortie";
						echo -e "PB....$compteurtableau::$compteur::$code_sortie::::$ligne\n";
				fi
		fi
		compteur=$((compteur + 1));
		echo -e "_____________________________________________________________________\n";
	done;
	echo "</table>" >> $2 ;
    echo "<hr color=\"red\" />" >> $2 ;
    compteurtableau=$((compteurtableau + 1));
done;
#concat dump
#for fichier in $(ls ./DUMP-TEXT/dumps_indiv | egrep "\.txt")
#	do concat_dump $1;
#done;
#concat context
#concat freq motif
#concat index
#concat bigrams
#-------------------------------------------------------------------------------
# Phase 4 : ECRITURE FIN DE FICHIER HTML
html_tail >> $2;
#-------------------------------------------------------------------------------
# c'est fini
exit;