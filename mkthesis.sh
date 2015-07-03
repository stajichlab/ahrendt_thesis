# Run R CMD Sweave in "./Chapter_Inhibition/tab/" on "Ahrendt_thesis_ChInhibition_Tabs.Rnw"
# Run R CMD Sweave in "./Chapter_RhodStruct/tab/" on "Ahrendt_thesis_ChRhodStruct_Tabs.Rnw"
# Run R CMD Sweave in "./Chapter_Coelomomyces/tab/" on "Ahrendt_thesis_ChCoelomomyces_Tabs.Rnw"

THESIS="Ahrendt_thesis"
TEX="$THESIS.tex"
AUX="$THESIS.aux"
#echo $AUX
#echo $TEX

if [ -e $AUX ]
then
  rm $AUX
fi

pdflatex $TEX
bibtex $AUX
pdflatex $TEX
pdflatex $TEX

# updated from http://tex.stackexchange.com/questions/27878/pdflatex-bash-script-to-supress-all-output-except-error-messages
#pdflatex -shell-escape -interaction=nonstopmode -file-line-error $TEX | grep -i ".*:[0-9]*:.*\|warning" > .firstpass.log
#bibtex -terse $AUX > .bibtex.log
#pdflatex -shell-escape -interaction=nonstopmode -file-line-error $TEX | grep -i ".*:[0-9]*:.*\|warning" > .secondpass.log
#pdflatex -shell-escape -interaction=nonstopmode -file-line-error $TEX | grep -i ".*:[0-9]*:.*\|warning"
