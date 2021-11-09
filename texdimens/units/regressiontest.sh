#!/bin/bash

status=0
etex="${ETEX:-etex}"
etexopts=" -halt-on-error -interaction batchmode -- "
starline="******************************************************************************"
ctanbuilddir="ctanbuild/texdimens"

shopt -s nullglob

INFO=""
# git ls-files ne trouve que les fichiers dans le répertoire courant,
# ou dans des sous-répertoires de celui-ci.
for file in `git ls-files`
do
    git diff --quiet -- "$file"
    if [ ! $? -eq 0 ]
    then
        INFO+="
INFO: $file est différent de sa version dans HEAD"
	# git diff -- "$file"
    fi
done

# ajout d'un flag pour utiliser les sources du répertoire ctanbuild
withctan=0
# déterminer si avec argument
if [ $# -eq 0 ]
then
    # pas d'argument
    :
else
    # argument : on va donc utiliser les sources d'un commit
    if [ "$1" = "--ctan" ]
    then
        withctan=1
        shift
    fi
fi


# attention à mes aventures avec TMPDIR dans le cadre des Makefile.
testdir=$(mktemp -d tmpXXXXX)
echo "On va utiliser le répertoire temporaire $testdir:"

echo "copie des fichiers..."

# pour l'instant simplement tous les fichiers de test
# attention de ne pas considérer texdimens lui-même comme
# un fichier de test... memo: the * is not "expanded" here
testfiles="test*tex"
outfiles="test*-out.txt"

cp $testfiles $outfiles "$testdir"

echo "... faite"

echo "création des liens symboliques..."

# Pour le moment, tout cela est assez absurde car le script
# n'a pas le code pour faire un checkout d'un commit donné,
# donc le texdimens.tex est nécessairement le même.
#
# Après hésitation faire aussi les legacy pour les tests
# "ctan", puisqu'après tout ce sont les tests à faire en
# dernier donc ils doivent être les plus complets
cd "$testdir"
if [ $withctan -eq 1 ]
then
    for i in ../../"$ctanbuilddir"/texdimens.tex ../../texdimenslegacy.tex
    do
        ln -s "$i" "`basename $i`"
    done
else
    for i in ../../{texdimens,texdimenslegacy}.tex
    do
        ln -s "$i" "`basename $i`"
        # echo $i
    done
fi
cd ..
echo "... faite"
echo "copie des tests de up/down vs legacy..."
legacytestfiles="legacytest*tex"
testfiles+=" $legacytestfiles"
cp $legacytestfiles "$testdir"
echo "... faite"

echo "entrée dans le repertoire $testdir"
cd "$testdir" && pwd && ls -l
echo ""

echo "Dépôt Git temporaire ..."
git init
cat <<\EOF >>.gitignore
*
!*out.txt
EOF
git add *out.txt
git commit -m "Commit des fichiers out.txt"
echo "... (prêt avec fichiers -out.txt)."
echo ""
echo "Exécution des tests ..."

numero=0
errorfiles=""
for i in $testfiles
do
  numero=`expr $numero + 1`
  j=$(basename "$i" .tex)
  echo -n "$numero. $i ... "
  $pre$etex $etexopts $i >/dev/null
  if [ $? -eq 0 ]
  then
      # echo -n "fait"
      if [ -f "../`basename $i .tex`-out.txt" ]
      then
	 git diff --quiet "`basename $i .tex`-out.txt"
	 if [ $? -eq 0 ]
	 then
             echo -e " output est \033[32mOK\033[0m"
	 else
             echo -e " \033[1;31mÉCHEC\033[0m"
	 fi
      else
	  echo -e " pas d'output (\033[32mOK\033[0m)"
      fi
  else
      echo -e "fait\033[1;31m"
      echo "$starline"
      echo "**** ERREUR AVEC $i"
      echo -e "$starline\033[0m"
      status=1
      errorfiles="$errorfiles $i"
  fi
done

echo "... faite"

git diff --quiet

if [ $? -eq 0 ]
then
    echo "sortie du répertoire $testdir"
    cd ../
    echo -e "\033[32m==== Aucune différence dans les fichiers -out.txt ===="
    if [ $status -eq 0 ]
    then
        echo -e "==== Aucune erreur lors des compilations TeX.     ====\033[0m"
        read -p "Supprimer $testdir ? (o)ui/(n)on " reponse
        case $reponse in
            o) memorizetestdir=0; rm -fr $testdir ;;
        esac
    else
        echo -e "\033[31m!!!! MAIS IL Y A DES ERREURS AVEC TeX                    !!!!"
        for file in $errorfiles
        do
            echo "!!!! $file"
        done
        echo -e "\033[0m!!!! Les fichiers sont dans units/$testdir                !!!!"
    fi
else
    git status -uno -s
    echo "sortie du répertoire $testdir"
    cd ../
    echo -e "\033[31m$starline"
    echo "!!!! ALERTE ! DIFFÉRENCES DANS AU MOINS UN OUT    !!!!"
    echo "!!!! Les tests sont dans units/$testdir           !!!!"
    if [ $status -eq 0 ]
    then
        echo -e "\033[0m==== Aucune erreur lors des compilations TeX.     ====\033[31m"
    else
        echo "!!!! ERREURS AVEC TeX.                            !!!!"
        for file in $errorfiles
        do
            echo "!!!! $file"
        done
    fi
    echo -e "$starline\033[0m"
    status=1
fi

echo "$INFO"
exit $status
