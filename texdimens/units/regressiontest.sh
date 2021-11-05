#!/bin/bash

status=0
etex="${ETEX:-etex}"
etexopts=" -halt-on-error -interaction batchmode -- "
starline="******************************************************************************"
ctanbuilddir="ctanbuild/texdimens"

# much downsized from analogous ones from xint/polexpr which use tests
# producing some output and the regressions are detected by git
# the xint testing architecture can also checkout commits
# to search when a bug actually got introduced
# 
# for time being I will be using only auto-test files i.e. test
# files not producing output
# so very basic and simple here

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
# un fichier de test...
testfiles="test*tex"

cp $testfiles "$testdir"

echo "... faite"

echo "création des liens symboliques..."

# Pour le moment, tout cela est assez absurde car le script
# n'a plus le code pour faire un checkout d'un commit donné
if [ $withctan -eq 1 ]
then
    cd "$testdir"
# ATTENTION ICI
    for i in ../../"$ctanbuilddir"/texdimens.tex
    do
        ln -s "$i" "`basename $i`"
    done
    cd ..
else
    cd "$testdir"
    for i in ../../texdimens.tex
    do
        ln -s "$i" "`basename $i`"
        # echo $i
    done
    cd ..
fi
echo "... faite"

echo "entrée dans le repertoire $testdir"
cd "$testdir" && pwd && ls -l
echo ""

echo "Exécution des tests ..."

numero=0
errorfiles=""
for i in $testfiles
do
  numero=`expr $numero + 1`
# tester si un fichier foo.req existe
# faudrait peut-être ne pas le faire si script appelé sans argument
  j=$(basename "$i" .tex)
  echo -n "$numero. $i ... "
  $pre$etex $etexopts $i >/dev/null
  if [ $? -eq 0 ]
  then
      echo "fait"
  else
      echo -e "fait\033[1;31m"
      echo "$starline"
      echo "**** ERREUR AVEC $i"
      echo -e "$starline\033[0m"
      status=1
      errorfiles="$errorfiles $i"
  fi
done

echo "sortie du répertoire $testdir"

cd ../

if [ $status -eq 0 ]
then
    echo -e "==== Aucune erreur lors des compilations TeX.     ====\033[0m"
    read -p "Supprimer $testdir ? (o)ui/(n)on " reponse
    case $reponse in
        o) rm -fr $testdir ;;
    esac
else
    echo -e "\033[31m!!!! MAIS IL Y A DES ERREURS AVEC TeX                    !!!!"
    for file in $errorfiles
    do
        echo "!!!! $file"
    done
    echo -e "\033[0m!!!! Les fichiers sont dans units/$testdir                !!!!"
fi

exit $status
