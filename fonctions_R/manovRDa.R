# manovRDa: A function in R-language for two-way MANOVA-like
# RDA, with fixed or random factors
#
#===============================================================================
#
# manovRDa: TWO-WAY MANOVA-LIKE RDA, WITH FIXED OR RANDOM FACTORS
#
# Computed as described in Legendre & Anderson (1999)
# "manovRDa" was made by modifying function "rdaTest" by Legendre et al. (2005)
# 
# Etienne Laliberte, March 2007
# Laboratoire d'ecologie vegetale
# Institut de Recherche en Biologie Vegetale (IRBV)
# Departement de sciences biologiques, Universite de Montreal
# 4101 Sherbrooke Est, Montreal, QC, Canada H1X 2B2
# email: etiennelaliberte@gmail.com
#
# Address in 2007:
# School of Forestry, University of Canterbury
# Private Bag 4800, Christchurch, New Zealand 8140
#
# Current address:
# Institut de recherche en biologie végétale
# Département de sciences biologiques – Faculté des arts et des sciences
# Université de Montréal 
# Email: etienne.laliberte@umontreal.ca
# 
#===============================================================================
#
manovRDa <- function(YY.mat, AA.mat, BB.mat, AAxBB.mat, factAfixed=TRUE, factBfixed=TRUE, scale.Y=FALSE, nperm=499, print.results=TRUE)
#
# PARAMETERS:
#
# YY.mat (nxp) is the site-by-species data table (or other response variables
#	than species)
# AA.mat (nxa) contains the variables coding for main factor A
#	If using PCNM variables to code for space (or time), it is recommended to
#		use the first s/2 (or t/2), rounded up, where s is the number of
#		sites and t the number of times
#	If using orthogonal dummy variables, then there should be NO COLLINEAR
#		VARIABLES IN THE MATRIX; The number of variables 'a' will thus
#		correspond to the number of degrees of freedom for main factor A;
#		failure to do so will lead to incorrect p-values
# BB.mat (nxb) contains the variables coding for main factor B: follow the same
#	procedure than for factor A
# AAxBB.mat (nxc) contains the variables coding for the interaction AxB
#	It should contain the product of each vector in AA.mat by each vector in
#		BB.mat, i.e. the number of variables c = ab
# factAfixed contains a logical value: is Factor A fixed, or not
#	(if FALSE, it is considered a random factor)
# factBfixed contains a logical value: is Factor B fixed, or not
#	(if FALSE, it is considered a random factor)
# scale.Y contains a logical value: should YY.mat be standardized, or not
# nperm: number of permutations to perform; by default, 499 permutations
# print.results: prints the results of the MANOVA-like RDA on the screen
#
#===============================================================================
#
{
library(MASS)
if(is.logical(scale.Y)){
}else{
stop("Wrong operator; 'scale.Y' should be either 'FALSE' or 'TRUE'")
}
if(is.logical(factAfixed)){
}else{
stop("Wrong operator; 'factAfixed' should be either 'FALSE' or 'TRUE'")
}
if(is.logical(factBfixed)){
}else{
stop("Wrong operator; 'factBfixed' should be either 'FALSE' or 'TRUE'")
}

# Read the data tables. Transform them into matrices Y, A, B, and AxB
Y.mat=as.matrix(YY.mat)
A.mat=as.matrix(AA.mat)
B.mat=as.matrix(BB.mat)
AxB.mat=as.matrix(AAxBB.mat)
n=nrow(Y.mat)
p=ncol(Y.mat)
a=ncol(A.mat)
b=ncol(B.mat)
c=ncol(AxB.mat)
Y=apply(Y.mat,2,scale,center=TRUE,scale=scale.Y)
A=apply(A.mat,2,scale,center=TRUE,scale=TRUE)
B=apply(B.mat,2,scale,center=TRUE,scale=TRUE)
AxB=apply(AxB.mat,2,scale,center=TRUE,scale=TRUE)

# Compute projector of A and Yfit.A
invA = ginv(t(A) %*% A)
projA = A %*% invA %*% t(A)
Yfit.A = projA %*% Y

# Compute projector of B and Yfit.B
invB = ginv(t(B) %*% B)
projB = B %*% invB %*% t(B)
Yfit.B = projB %*% Y

# Compute projector of AxB and Yfit.AxB
invAxB = ginv(t(AxB) %*% AxB)
projAxB = AxB %*% invAxB %*% t(AxB)
Yfit.AxB = projAxB %*% Y

# Create a "compound matrix" to obtain R-square and adjusted R-square
ABAxB=cbind(A,B,AxB)

# Compute projector of ABAxB and Yfit.ABAxB
invABAxB = ginv(t(ABAxB) %*% ABAxB)
projABAxB = ABAxB %*% invABAxB %*% t(ABAxB)
Yfit.ABAxB = projABAxB %*% Y

# Compute R-square and adjusted R-square
SS.Y = sum(Y*Y)
SS.Yfit.ABAxB = sum(Yfit.ABAxB*Yfit.ABAxB)
# SS.Y = sum(diag(cov(Y)))
# SS.Yfit.ABAxB = sum(diag(cov(Yfit.ABAxB)))
Rsquare=SS.Yfit.ABAxB/SS.Y
totalDF=n-1
residualDF=n-(a+b+c)-1
adjRsq = 1-((1-Rsquare)*totalDF/residualDF)

# Compute Sums of squares (SS) and Mean squares (MS)
SS.Yfit.A = sum(Yfit.A*Yfit.A)
SS.Yfit.B = sum(Yfit.B*Yfit.B)
SS.Yfit.AxB = sum(Yfit.AxB*Yfit.AxB)
MS.A=SS.Yfit.A/a
MS.B=SS.Yfit.B/b
MS.AxB=SS.Yfit.AxB/c
MS.Res=(SS.Y-SS.Yfit.ABAxB)/(n-(a+b+c)-1)

# Print results of R-square and adjusted R-square
if(print.results==TRUE){
	cat('\n','----------','\n','\n',sep="")
	cat('Bimultivariate redundancy statistic','\n')
	cat('R-square =',Rsquare,'\n')
	cat('adjusted R-square = ',adjRsq,'\n',sep="")
	}else{}

# Tests of factors and interaction
Fref.AxB=MS.AxB/MS.Res
vec=c(1:n)
nPGE.AxB=1
nPGE.A=1
nPGE.B=1

if(factAfixed==TRUE) {
if(factBfixed==TRUE) {

Fref.A=MS.A/MS.Res
Fref.B=MS.B/MS.Res

# Permutation tests (When A and B are fixed)
for(i in 1:nperm)
{
YPerm = Y[sample(vec,n),]
YhatPerm.AxB = projAxB %*% YPerm
YhatPerm.A = projA %*% YPerm
YhatPerm.B = projB %*% YPerm
YhatPerm.ABAxB = projABAxB %*% YPerm
SS.YhatPerm.AxB = sum(YhatPerm.AxB*YhatPerm.AxB)
SS.YhatPerm.A = sum(YhatPerm.A*YhatPerm.A)
SS.YhatPerm.B = sum(YhatPerm.B*YhatPerm.B)
SS.YhatPerm.ABAxB = sum(YhatPerm.ABAxB*YhatPerm.ABAxB)
Fper.AxB=(SS.YhatPerm.AxB*(n-(a+b+c)-1))/((SS.Y-SS.YhatPerm.ABAxB)*c)
Fper.A=(SS.YhatPerm.A*(n-(a+b+c)-1))/((SS.Y-SS.YhatPerm.ABAxB)*a)
Fper.B=(SS.YhatPerm.B*(n-(a+b+c)-1))/((SS.Y-SS.YhatPerm.ABAxB)*b)
 if(Fper.AxB >= Fref.AxB) nPGE.AxB=nPGE.AxB+1
if(Fper.A >= Fref.A) nPGE.A=nPGE.A+1
if(Fper.B >= Fref.B) nPGE.B=nPGE.B+1
}

}
else {

Fref.A=MS.A/MS.AxB
Fref.B=MS.B/MS.Res

# Permutation tests (When A is fixed and B is random)
for(i in 1:nperm)
{
YPerm = Y[sample(vec,n),]
YhatPerm.AxB = projAxB %*% YPerm
YhatPerm.A = projA %*% YPerm
YhatPerm.B = projB %*% YPerm
YhatPerm.ABAxB = projABAxB %*% YPerm
SS.YhatPerm.AxB = sum(YhatPerm.AxB*YhatPerm.AxB)
SS.YhatPerm.A = sum(YhatPerm.A*YhatPerm.A)
SS.YhatPerm.B = sum(YhatPerm.B*YhatPerm.B)
SS.YhatPerm.ABAxB = sum(YhatPerm.ABAxB*YhatPerm.ABAxB)
Fper.AxB = (SS.YhatPerm.AxB*(n-(a+b+c)-1))/((SS.Y-SS.YhatPerm.ABAxB)*c)
Fper.A = (SS.YhatPerm.A*c)/((SS.YhatPerm.AxB)*a)
Fper.B = (SS.YhatPerm.B*(n-(a+b+c)-1))/((SS.Y-SS.YhatPerm.ABAxB)*b)
if(Fper.AxB >= Fref.AxB) nPGE.AxB=nPGE.AxB+1
if(Fper.A >= Fref.A) nPGE.A=nPGE.A+1
if(Fper.B >= Fref.B) nPGE.B=nPGE.B+1
}

}

}
else {
if(factBfixed==TRUE) {

Fref.A=MS.A/MS.Res
Fref.B=MS.B/MS.AxB

# Permutation tests (When A is random and B is fixed)
for(i in 1:nperm)
{
YPerm = Y[sample(vec,n),]
YhatPerm.AxB = projAxB %*% YPerm
YhatPerm.A = projA %*% YPerm
YhatPerm.B = projB %*% YPerm
YhatPerm.ABAxB = projABAxB %*% YPerm
SS.YhatPerm.AxB = sum(YhatPerm.AxB*YhatPerm.AxB)
SS.YhatPerm.A = sum(YhatPerm.A*YhatPerm.A)
SS.YhatPerm.B = sum(YhatPerm.B*YhatPerm.B)
SS.YhatPerm.ABAxB = sum(YhatPerm.ABAxB*YhatPerm.ABAxB)
Fper.AxB=(SS.YhatPerm.AxB*(n-(a+b+c)-1))/((SS.Y-SS.YhatPerm.ABAxB)*c)
Fper.A=(SS.YhatPerm.A*(n-(a+b+c)-1))/((SS.Y-SS.YhatPerm.ABAxB)*a)
Fper.B=(SS.YhatPerm.B*c)/((SS.YhatPerm.AxB)*b)
if(Fper.AxB >= Fref.AxB) nPGE.AxB=nPGE.AxB+1
if(Fper.A >= Fref.A) nPGE.A=nPGE.A+1
if(Fper.B >= Fref.B) nPGE.B=nPGE.B+1
}

}
else {

Fref.A=MS.A/MS.AxB
Fref.B=MS.B/MS.AxB

# Permutation tests (When A and B are random)
for(i in 1:nperm)
{
YPerm = Y[sample(vec,n),]
YhatPerm.AxB = projAxB %*% YPerm
YhatPerm.A = projA %*% YPerm
YhatPerm.B = projB %*% YPerm
YhatPerm.ABAxB = projABAxB %*% YPerm
SS.YhatPerm.AxB = sum(YhatPerm.AxB*YhatPerm.AxB)
SS.YhatPerm.A = sum(YhatPerm.A*YhatPerm.A)
SS.YhatPerm.B = sum(YhatPerm.B*YhatPerm.B)
SS.YhatPerm.ABAxB = sum(YhatPerm.ABAxB*YhatPerm.ABAxB)
Fper.AxB=(SS.YhatPerm.AxB*(n-(a+b+c)-1))/((SS.Y-SS.YhatPerm.ABAxB)*c)
Fper.A=(SS.YhatPerm.A*c)/((SS.YhatPerm.AxB)*a)
Fper.B=(SS.YhatPerm.B*c)/((SS.YhatPerm.AxB)*b)
if(Fper.AxB >= Fref.AxB) nPGE.AxB=nPGE.AxB+1
if(Fper.A >= Fref.A) nPGE.A=nPGE.A+1
if(Fper.B >= Fref.B) nPGE.B=nPGE.B+1
}
}
}
# Calculation of p-values
P.AxB=nPGE.AxB/(nperm+1)
P.A=nPGE.A/(nperm+1)
P.B=nPGE.B/(nperm+1)

# Print final results
if(print.results==TRUE){
cat('\n')	
cat('\n','Test results, permutation of raw data','\n',nperm, ' permutations','\n',sep="")
cat('\n')
cat('Interaction A x B','\n')
cat('df =',c,'\n')
cat('MS.AxB =',MS.AxB,'\n')
cat('F =' ,Fref.AxB,'\n')
cat('p =',P.AxB,'\n')
cat('\n')
cat('Factor A','\n')
cat('df =',a,'\n')
cat('MS.A =',MS.A,'\n')
cat('F =' ,Fref.A,'\n')
cat('p =',P.A,'\n')
cat('\n')
cat('Factor B','\n')
cat('df =',b,'\n')
cat('MS.B =',MS.B,'\n')
cat('F =' ,Fref.B,'\n')
cat('p =',P.B,'\n')
}else{}
}
