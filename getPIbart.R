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


getPIbart <- function(y.test, post.mean, post.sd){
    pdraws <- matrix(0, dim(post.mean)[1], dim(post.mean)[2])	  

    if(is.matrix(post.sd)){
	for(ii in 1:dim(post.mean)[1]){
            for(jj in 1:dim(post.mean)[2]){
                pdraws[ii, jj] <- rnorm(1, mean=post.mean[ii,jj], sd=post.sd[ii,jj])
            }
        }
    }
    else{
        for(ii in 1:dim(post.mean)[1]){
            for(jj in 1:dim(post.mean)[2]){
                pdraws[ii, jj] <- rnorm(1, mean=post.mean[ii,jj], sd=post.sd[ii])
            }
        }
    }
    cis <- apply(pdraws, 2, function(x) HPDinterval(mcmc(x)))
 
    list(pi.lower=cis[1,], pi.upper=cis[2,])
}

