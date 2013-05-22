Individual scrapers are located in the root. Each scraper should output the data into the data/ directory. The structure and consistency of the file naming will evolve. 

The merged-municipalities.csv file is created by running each scraper, then running merging and deduping the resulting files. Try something like:

    cat $(ls -t) > merged-municipalities.csv
    uniq merged-municipalities.csv
    sort --key=1,2 merged-municipalities.csv > out.txt
    mv out.txt merged-municipalities.csv
    
A good starting point for other scrapers is here: http://www.nlc.org/about-nlc/state-league-programs/state-municipal-leagues/state-municipal-league-directory
