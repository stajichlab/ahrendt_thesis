# Run R CMD Sweave in "./Chapter_Inhibition/tab/" on "Ahrendt_thesis_ChInhibition_Tabs.Rnw"
# Run R CMD Sweave in "./Chapter_RhodStruct/tab/" on "Ahrendt_thesis_ChRhodStruct_Tabs.Rnw"
# Run R CMD Sweave in "./Chapter_Coelomomyces/tab/" on "Ahrendt_thesis_ChCoelomomyces_Tabs.Rnw"

THESIS="Ahrendt_thesis"
TEX="$THESIS\.tex"
AUX="$THESIS\.aux"

if [-e $AUX]
then
  rm $AUX
fi
pdflatex $TEX
bibtex $AUX
pdflatex $TEX
pdflatex $TEX
