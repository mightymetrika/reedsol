
<!-- README.md is generated from README.Rmd. Please edit that file -->

# reedsol

The goal of reedsol is to sample from a Reed-Solomon distribution using
rejection sampling.

## Installation

You can install the development version of reedsol from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("mightymetrika/reedsol")
```

## Example

Sample using reedsol_sim() as follows:

``` r
library(reedsol)

reedsol_sim(data = c(2, 4, 6),
            n = 5,
            q = 8)
#> [1] 3.680775 6.643057 6.360046 3.292287 6.533138
```

## Parameters

- data: A numeric vector used to generate the Reed-Solomon curve.
- n: Number of samples to generate (default: 1)
- q: Size of the finite field GF(q) (default: 256)
- k: Degree of the polynomial to use (default: length of data)

## Description

The function works by:

1.  Converting input data to elements in GF(q)
2.  Constructing a probability density function as a polynomial with
    coefficients from the data
3.  Normalizing this function through numerical integration
4.  Using rejection sampling to generate random samples
