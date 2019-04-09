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


#get node information from RF
rfNodes <- function(x, rfFit) {
  rfModel <- rfFit
  nodes <- attr(predict(rfModel, x, predict.all=TRUE, nodes=TRUE), 'nodes')
  list(model=rfModel, nodes=nodes)
}

#get residuals in nodes
nbrResid <- function(node, nodeList, data) {
  x <- data[nodeList == node]
  x - mean(x)
}

#get prediction interval for RF
getPIrf <- function(x.train, y.train, x.test, rfFit, qrfPred) {
  nodes <- rfNodes(x.train, rfFit)
  
  p <- predict(nodes$model, x.test, nodes=TRUE)

  stefan <- randomForestInfJack(nodes$model, x.test, calibrate = TRUE)
  
  #obtain estimate of variance of residual for IJQRF method
  iqr <- qrfPred[,4] - qrfPred[,2]
  poolVarIQR <- ((iqr) / (2*qnorm(0.75)))^2

  #obtain estimate of variance of residual for IJRF method
  trainNodes <- as.data.frame(nodes$nodes)
  newNodes <- attr(p, 'nodes')
  poolVar <- rep(NA, nrow(newNodes))
  for (i in 1:nrow(newNodes)) {
    r <- mapply(nbrResid, newNodes[i,], trainNodes, MoreArgs=list(data=y.train))
    poolVar[i] <- sum(sapply(r, function(x) sum(x^2))) / 
      (sum(sapply(r, length)) - length(r))
  }

  list(ijqrf.lower=c(p) - qnorm(0.975)*sqrt(stefan$var.hat+poolVarIQR), 
       ijqrf.upper=c(p) + qnorm(0.975)*sqrt(stefan$var.hat+poolVarIQR),
       ijrf.lower=c(p) - qnorm(0.975)*sqrt(stefan$var.hat+poolVar), 
       ijrf.upper=c(p) + qnorm(0.975)*sqrt(stefan$var.hat+poolVar),
       qrf.lower=qrfPred[,1],
       qrf.upper=qrfPred[,5])

}


