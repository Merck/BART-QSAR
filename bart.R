#    Copyright (c) 2019 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.
#  
#    This file is part of the BART-QSAR program.
#
#    BART-QSAR is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

library(dbarts)
library(coda)

folder <- ('~/packages/BART-QSAR/')


#R code for OpenBT-bart and OpenBT-hbart. This file was downloaded from OpenBT website.
source("openbt.R")

source(paste0(folder,"getPIbart.R"))

load(file=paste0(folder, "x.train.rda"))
load(file=paste0(folder, "y.train.rda"))
load(file=paste0(folder, "x.test.rda"))
load(file=paste0(folder, "y.test.rda"))

#---------------------------------BART----------------------------------
#train the model and predict the underlying response function
bartFit <- bart(x.train=x.train, 
                y.train=y.train, 
                x.test = x.test,
                sigest = sd(y.train),
                ntree=2000, power=1, ndpost=2000, nskip=1000)

#calcuate R2 for prediction accuracy
R2.bart <- cor(bartFit$yhat.test.mean, y.test)

#obtain prediction intervals and corresponding coverage and median width
pi.bart <- getPIbart(y.test, bartFit$yhat.test, bartFit$sigma)
cov.bart <- mean(pi.bart$pi.lower < y.test & pi.bart$pi.upper > y.test)
mw.bart <- median(pi.bart$pi.upper-  pi.bart$pi.lower)
cov.bart; mw.bart


#-------------------------------OpenBT-bart-----------------------------
#train the model
openBTbartFit <- openbt(x.train=x.train, y.train=y.train, pbd=c(0.7, 0.0),
                        ntreeh=1, tc=8, model="bart", modelname="qsarbart")

# Predict the underlying response function
openBTbartPred <- predict.openbt(openBTbartFit, x.test, tc=8)

#obtain prediction intervals and corresponding coverage and median width
pi.openBTbart <- getPIbart(y.test, openBTbartPred$mdraws, openBTbartPred$sdraws)
cov.openBTbart <- mean(pi.openBTbart$pi.lower < y.test & pi.openBTbart$pi.upper > y.test)
mw.openBTbart <- median(pi.openBTbart$pi.upper - pi.openBTbart$pi.lower)
cov.openBTbart; mw.openBTbart


#-------------------------------OpenBT-hbart-----------------------------
openBThbartFit <-  openbt(x.train=x.train, y.train=y.train, pbd=c(0.7, 0.0),
                          ntreeh=40, tc=8, model="hbart", modelname="qsarhbart")

openBThbartPred <- predict.openbt(openBThbartFit, x.test, tc=8)

pi.openBThbart <- getPIbart(y.test, openBThbartPred$mdraws, openBThbartPred$sdraws)
cov.openBThbart <- mean(pi.openBThbart$pi.lower < y.test & pi.openBThbart$pi.upper > y.test)
mw.openBThbart <- median(pi.openBThbart$pi.upper - pi.openBThbart$pi.lower)
cov.openBThbart; mw.openBThbart

#-------------------------------OpenBT-truncation-----------------------------
thresh <- quantile(y.train, 0.4)
y.train[y.train < thresh] <- thresh
y.test[y.test < thresh] <- thresh

openBTtbartFit <- openbt(x.train=x.train, y.train=y.train, pbd=c(0.7, 0.0),
                         ntreeh=1, tc=8, model="merck_truncated", modelname="qsartbart")

openBTtbartPred <- predict.openbt(openBTtbartFit, x.test, tc=8)

pi.openBTtbart <- getPIbart(y.test, openBTtbartPred$mdraws, openBTtbartPred$sdraws)
cov.openBTtbart <- mean(pi.openBTtbart$pi.lower < y.test & pi.openBTtbart$pi.upper > y.test)
mw.openBTtbart <- median(pi.openBTtbart$pi.upper - pi.openBTtbart$pi.lower)
cov.openBTtbart; mw.openBTtbart

