## run_analysis_R

There is only a single script used

#You may need to install reshape2 package if not already done so.
This can be done by install.packahes(reshape2) at R Command line

## Script functionality

The script will do the following

1. Load the reshape2 library for melting data
2. Check if data set has already been download and if not, obtains the data
   and unzips the files
3. Read the anctivities and features records
4. Parse records for only those related to the mean and standard deviation
5. Nomralize and clean the records where mean and standard deviation exist in multiple ways
6. Read and Combine both the test and train data records
7. Writes out a clean data set called "tidy.txt"