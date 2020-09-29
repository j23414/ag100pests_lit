#! /usr/bin/env bash
# Auth: Jennifer Chang
# Date: 2020/09/29

set -e
set -u

SEARCH_PMC=../bin/search_PMC.sh
FETCH_PMC=../bin/fetch_PMC.sh
XML_TSV=../bin/xml_to_tsv.pl

# ==== Get PMC IDS
while read TERM; do
    OUTFILE=$(echo ${TERM} | tr '+' '_')
    if [[ ! -f pmc/${OUTFILE}.pmc ]]; then
	sleep 1
	echo "searching Pubmed Central for $TERM... "
	bash ${SEARCH_PMC} ${TERM} > pmc/${OUTFILE}.pmc
    fi
done < $1

# ==== Get PMC XML files
while read TERM; do
    OUTFILE=$(echo ${TERM} | tr '+' '_')
    if [[ ! -f pmc/${OUTFILE}.xml ]]; then
	sleep 1
	echo "fetching XML files for $TERM... "
	bash ${FETCH_PMC} pmc/${OUTFILE}.pmc > pmc/${OUTFILE}.xml
    fi
done < $1

# ==== Get generate author paper lists
while read TERM; do
    OUTFILE=$(echo ${TERM} | tr '+' '_')
    if [[ ! -f pmc/${OUTFILE}_papers.tsv ]]; then
	sleep 1
	echo "pulling papers and authors for $TERM... "
	perl ${XML_TSV} "." pmc/${OUTFILE}_papers.tsv pmc/${OUTFILE}_authors.tsv pmc/${OUTFILE}.xml
    fi
done < $1
