## Sobol' low-discrepancy design
plot(sobol_design(lower=c(a=0,b=100),upper=c(b=200,a=1),nseq=100))

## Uniform random design
plot(runif_design(lower=c(a=0,b=100),upper=c(b=200,a=1),100))

## A one-parameter profile design:
x <- profile_design(p=1:10,lower=c(a=0,b=0),upper=c(a=1,b=5),nprof=20)
dim(x)
plot(x)

## A two-parameter profile design:
x <- profile_design(p=1:10,q=3:5,lower=c(a=0,b=0),upper=c(b=5,a=1),nprof=200)
dim(x)
plot(x)

## A two-parameter profile design with random points:
x <- profile_design(p=1:10,q=3:5,lower=c(a=0,b=0),upper=c(b=5,a=1),nprof=200,type="runif")
dim(x)
plot(x)

## A single 11-point slice through the point c(A=3,B=8,C=0) along the B direction.
x <- slice_design(center=c(A=3,B=8,C=0),B=seq(0,10,by=1))
dim(x)
plot(x)

## Two slices through the same point along the A and C directions.
x <- slice_design(c(A=3,B=8,C=0),A=seq(0,5,by=1),C=seq(0,5,length=11))
dim(x)
plot(x)

