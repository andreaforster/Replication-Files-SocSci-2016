
# Replication files

Andrea Forster and Thijs Bol, January 2016

In this replication set you can find the code and (parts of) the data that were used to perform 
the analyses in the article Forster, Andrea G., Thijs Bol, and Herman G. Van de Werfhorst (2016). 
Vocational Education and Employment over the Life Cycle. Sociological Science 3: 473-494. 
If you have any questions, please send an e-mail to email@andrea-forster.com or t.bol@uva.nl. 


## Data

For this paper we use the Programme for the International Assessment of Adult Competencies (PIAAC)
from 2012, as well as indicators for educational systems developed by Bol and Van de Werfhorst (2013). The data for 
the macro indicators is version 4 of the dataset and is attached in this replication folder. The Public Use file from 
the PIAAC is freely downloadable at http://www.oecd.org/site/piaac/publicdataandanalysis.htm.The PIAAC data are updated, 
please note that for our analyses we rely on release Nov. 2013.


## Code

There are 2 Stata do-files and 2 R-files included in this replication file. 

The dataprep.do and analyses.do files are the main files that you can use to generate the results. You only have 
to change the name of the folder where you have downloaded the replication folder in and download the ado's that
we have used. 

The first do-file, dataprep.do, is used to prepare the dataset that we use for our analyses. All transformations 
we have applied to the PIAAC data can be found here. The descriptive statistics (Table 1) are also generated in
this do-file. After running this do-file, a new dataset called "workingdata.dta" is saved in the 03_posted folder
that can be used for the analyses.

In the second do-file, analyses.do, we run all the analyses on workingdata.dta. In this dofile all tables (except 
Table 1) are generated. Furthermore, this dofile saves a series of datasets in 03_posted that are used to generate
all the figures in R. 

There are two files to generate the figures (Figures 2-5.R and Appendix Figures.R). Here again one only needs to
set the folder correctly. The two R-files will  utilize the datasets that are saved after running analyses.do to
generate Figures 2-5 as well as all Appendix figures.


## Output 

All the output in the paper is created by the following do-files and R-files:

Table 1	- dataprep.do

Table 2	- analyes.do

Table 3	- analyes.do

Table 4	- analyes.do

Fig 1	- analyes.do

Fig 2	- Figures 2-5.R

Fig 3	- Figures 2-5.R

Fig 4	- Figures 2-5.R

Fig 5	- Figures 2-5.R

App A	- Appendix Figures.R

App B	- Appendix Figures.R
