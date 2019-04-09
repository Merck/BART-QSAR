# BART-QSAR Documentation     

Authors: Dai Feng, Andy Liaw. 

Contact: dai_feng@merck.com, andy_liaw@merck.com.

Affiliation: Merck Biometrics Research, Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.

Date: 03/25/2019

Acknowledgement: 
	
If you use the BART-QSAR for scientific work that gets published, you should include in that publication a citation 
of the following paper:

Dai Feng, Vladimir Svetnik, Andy Liaw, Matthew Pratola, and Robert P. Sheridan. "Building Quantitative Structure-Activity
Relationship Models Using Bayesian Additive Regression Trees". Journal of Chemical Information and Modeling, 2019.


## Basic info
### System requirements:
R (>= 3.5.1)


### Installation of R Packages:

[randomForest:] https://cran.r-project.org/web/packages/randomForest/

[quantregForest:] https://cran.r-project.org/web/packages/quantregForest/

[randomForestCI:] https://github.com/swager/randomForestCI

[dbarts:] https://cran.r-project.org/web/packages/dbarts/

[OpenBT:] https://bitbucket.org/mpratola/openbt

[coda:] https://cran.r-project.org/web/packages/coda/


## Brief explaination of all R files

[getPIrf.R:] Get prediction intervals using three methods based on Random Forest: IJRF, IJQRF, and QRF.
	
[rf.R:] An example showing how to obtain different prediction intervals using different methods based on Random Forest.

[getPIbart.R] Get prediction intervals using three methods based on BART: BART, OpenBT-bart, and OpenBT-hbart.

[bart.R] An example showing how to obtain differetn prediction intervals using different methods based on BART.
	

## Brief explaination of all data files
[x.train.rda] Features of training data

[y.train.rda] Response of training data
    
[x.test.rda] Features of test data

[y.test.rda] Response of test data