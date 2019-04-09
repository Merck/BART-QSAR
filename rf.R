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

library(randomForest)
library(quantregForest)
library(randomForestCI)

folder <- ('~/packages/BART-QSAR/')
source(paste0(folder, 'getPIrf.R'))
load(file=paste0(folder, "x.train.rda"))
load(file=paste0(folder, "y.train.rda"))
load(file=paste0(folder, "x.test.rda"))
load(file=paste0(folder, "y.test.rda"))

set.seed(100)
rfFit <-randomForest(x=x.train, y=y.train, 
                       ntree=100, do.trace=TRUE, keep.inbag=TRUE)
rfPred <- predict(rfFit, newdata=x.test)
R2.rf <- cor(rfPred, y.test)^2


qrfFit<- quantregForest(x=x.train, y=y.train, nodesize=5, ntree=100, do.trace=TRUE)
qrfPred <- predict(qrfFit, x.test, what = c(0.025, 0.25, 0.50, 0.75, 0.975))

PI <- getPIrf(x.train, y.train, x.test, rfFit, qrfPred)
cov.ijqrf <- mean(PI$ijqrf.lower < y.test & PI$ijqrf.upper > y.test) 
cov.ijrf <- mean(PI$ijrf.lower < y.test & PI$ijrf.upper > y.test)
cov.qrf <- mean(PI$qrf.lower < y.test & PI$qrf.upper > y.test)
cov.ijqrf; cov.ijrf; cov.qrf


mw.ijqrf <- median(PI$ijqrf.upper - PI$ijqrf.lower) 
mw.ijrf <- median(PI$ijrf.upper - PI$ijrf.lower)
mw.qrf <- median(PI$qrf.upper - PI$qrf.lower)
mw.ijqrf; mw.ijrf; mw.qrf
