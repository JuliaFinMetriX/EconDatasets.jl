
# coding: utf-8

### Accessible data

# The function tries to make data from Kenneth R. French's data [library](http://mba.tuck.dartmouth.edu/pages/faculty/ken.french/data_library.html) accessible. 

### What the function expects

# The function expects to find a .zip file which contains a .txt file of data. Thereby the .txt file starts with a description of the data, and lists several data sets afterwards. The individual data sets are separated by empty lines, and each data set has one header line followed by one or two lines of column names. The first column of the data contains dates given without any separator.
# 
# The obstacle for full automation was dealing with the column names, since a single variable name sometimes may consist of two parts separated by whitespace. Hence, it is very difficult to tell automatically, whether two separated strings refer to two different column names or just one single column name.
# 
# As an example, the following cell shows an extract of data *6 Portfolios formed on size and momentum (2 x 3)* - the comment signs `##` at the beginning of each line are not part of the original file, and shall only avoid execution of the lines by julia. 

# In[26]:

##This file was created by CMPT_ME_PRIOR_RETS using the 201405 CRSP database.
##It contains value- weighted returns for the intersections of  2 ME portfolios
##and  3 prior return portfolios.
##
##The portfolios are constructed monthly.  ME is market cap at the end of the
##previous month.  PRIOR_RET is from -12 to - 2.
##
##Missing data are indicated by -99.99 or -999.
##
##
##  Average Value Weighted Returns -- Monthly
##              Small                 Big         
##          Low     2    High    Low     2    High 
##192701   0.01   3.79   0.39  -0.63   0.23   0.00
##192702   7.13   6.24   5.75   5.59   3.78   4.49
##192703  -3.26  -2.95  -2.30  -7.66  -0.22   2.29
##192704  -0.56  -0.96   3.36  -1.90   0.78   1.89
##192705   2.47  11.39   7.00   4.21   4.87   7.10
##                          .
##                          .
##                          .
##201401  -2.48  -3.55  -2.59  -5.00  -3.35  -1.51
##201402   3.90   4.12   5.49   3.90   4.13   6.62
##201403   0.61   1.50  -1.20   2.02   1.63  -2.72
##201404  -2.45  -3.03  -5.27   2.70   0.73  -2.23
##201405   0.64   0.89  -0.50   0.61   2.40   3.43
##
##
##  Average Equal Weighted Returns -- Monthly
##               Small                 Big         
##          Low     2    High    Low     2    High 
##192701   1.77   3.33  -0.81   0.36   0.62   0.95
##192702   6.82   6.46   6.08   7.93   4.98   5.10
##192703  -4.55  -1.02  -3.56  -4.46  -1.19   0.63
##192704   2.13  -1.05   3.51  -1.74   0.95   1.33
##192705   2.72  11.36   7.54   5.51   4.60   8.43
##192706  -2.86  -1.33  -2.61  -4.19  -1.66  -1.59
##192707   5.32   4.88   6.45   6.01   6.72   6.85


### Application

# The function needs to be called with some url given as `ASCIIString`. It returns a tuple consisting of three parts:
# - the actual data sets as `Array{Any,1}`
# - the description of each individual data set as `Array{Symbol,1}`
# - the column / variable names as `Array{Union(UTF8String,ASCIIString),1})`

# In[16]:

dataUrl = "http://mba.tuck.dartmouth.edu/pages/faculty/ken.french/ftp/6_Portfolios_ME_Prior_12_2.zip"
(data, dataNames, varnames) = readFamaFrenchRaw(dataUrl)

(typeof(data), typeof(dataNames), typeof(varnames))


#### Data format

# Each data set is one entry in an `Array{Any,1}`. Hence, the number of data sets can be determined with `length`.

# In[19]:

nData = length(data)


# Their descriptions can be found in variable `dataNames`.

# In[21]:

dataNames


# Any individual data set is stored as `Timematr`, with default names for the individual columns.

# In[20]:

data[1]


#### Data processing

# For a clean end result, one only needs to rename the individual variable names. The variable names can accessed from variable `varnames`. Note that the function assumes that the column names of all data sets are the same!

# In[22]:

varnames


# As an example, we translate these variable names manually into the following names:

# In[23]:

newVarnames = [:SmallLow, :SmallMed, :SmallHigh, :BigLow, :BigMed, :BigHigh]


# In[24]:

for ii=1:length(data)
    rename!(data[ii].vals, names(data[ii].vals), newVarnames)
end


# In[25]:

data[1]

