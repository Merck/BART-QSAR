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


#This shared library was built from compling files donwloaded from OpenBT website.
dyn.load(paste0(folder, "allbrt.so"))

#R code for OpenBT-bart and OpenBT-hbart. This file was downloaded from OpenBT website.
source(paste0(folder,"psambrt.R"))

source(paste0(folder,"getPIbart.R"))

load(file=paste0(folder, "x.train.rda"))
load(file=paste0(folder, "y.train.rda"))
load(file=paste0(folder, "x.test.rda"))
load(file=paste0(folder, "y.test.rda"))

#---------------------------------BART----------------------------------
bartFit <- bart(x.train=x.train, 
                y.train=y.train, 
                x.test = x.test,
                sigest = sd(y.train),
                ntree=2000, power=1, ndpost=2000, nskip=1000)

R2.bart <- cor(bartFit$yhat.test.mean, y.test)
#[1] 0.6244436
pi.bart <- getPIbart(y.test, bartFit$yhat.test, bartFit$sigma)
cov.bart <- mean(pi.bart$pi.lower < y.test & pi.bart$pi.upper > y.test)
mw.bart <- median(pi.bart$pi.upper-  pi.bart$pi.lower)
cov.bart; mw.bart


#-------------------------------OpenBT-bart-----------------------------
openBTbartFit <- psambrt(x.train=x.train, y.train=y.train, ntreeh=1, tc=8)
openBTbartPred <- psambrt.predict(openBTbartFit, x.test=x.test)
pi.openBTbart <- getPIbart(y.test, openBTbartPred$mdraws, openBTbartPred$sdraws)
cov.openBTbart <- mean(pi.openBTbart$pi.lower < y.test & pi.openBTbart$pi.upper > y.test)
mw.openBTbart <- median(pi.openBTbart$pi.upper - pi.openBTbart$pi.lower)
cov.openBTbart; mw.openBTbart


#-------------------------------OpenBT-hbart-----------------------------
openBThbartFit <- psambrt(x.train=x.train, y.train=y.train, tc=8)
openBThbartPred <- psambrt.predict(openBThbartFit, x.test=x.test)
pi.openBThbart <- getPIbart(y.test, openBThbartPred$mdraws, openBThbartPred$sdraws)
cov.openBThbart <- mean(pi.openBThbart$pi.lower < y.test & pi.openBThbart$pi.upper > y.test)
mw.openBThbart <- median(pi.openBThbart$pi.upper - pi.openBThbart$pi.lower)
cov.openBThbart; mw.openBThbart

