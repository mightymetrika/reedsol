#' Simulate from a Reed-Solomon distribution
#'
#' @description
#' This function simulates random samples from a probability distribution based on
#' Reed-Solomon codes. It takes a vector of data, creates a polynomial-based curve,
#' normalizes it, and generates samples using rejection sampling.
#'
#' @param data A numeric vector used to generate the Reed-Solomon curve.
#' @param n Integer. Number of samples to generate. Default is 1.
#' @param q Integer. Size of the finite field GF(q). Should be a prime number or power of prime.
#'   Default is 256 (2^8).
#' @param k Integer. Degree of the polynomial to use. If NULL (default), uses the length of data.
#'
#' @return A numeric vector of length n containing samples from the Reed-Solomon distribution.
#'
#' @details
#' The function works by:
#' 1. Converting input data to elements in GF(q)
#' 2. Constructing a probability density function as a polynomial with coefficients from the data
#' 3. Normalizing this function through numerical integration
#' 4. Using rejection sampling to generate random samples
#'
#' The distribution domain 0 to q-1, corresponding to the elements of GF(q).
#'
#' @examples
#' # Generate a single sample using small data and field size
#' reedsol_sim(c(1, 2, 3), n = 1, q = 8)
#'
#' @importFrom stats integrate optimize runif
#'
#' @export
reedsol_sim <- function(data, n = 1, q = 256, k = NULL) {
  # Input validation
  if (!is.vector(data) || !is.numeric(data)) {
    stop("Input data must be a numeric vector")
  }

  # If k is not provided, use length of data
  if (is.null(k)) {
    k <- length(data)
  }

  # Step 1: Process the input data
  # Ensure data is within the finite field GF(q)
  data <- data %% q

  # Step 2: Generate Reed-Solomon curve
  # This function represents the probability density
  rs_curve <- function(x) {
    # Initialize result
    result <- 1

    # Generate polynomial based on data points
    for (i in 1:k) {
      if (i <= length(data)) {
        # Use actual data where available
        coef <- data[i]
      } else {
        # Pad with zeros if needed
        coef <- 0
      }

      # Multiply by x^(i-1) term
      result <- result + coef * x^(i-1)
    }

    # Make sure result is non-negative (for probability)
    return(pmax(0, result))
  }

  # Step 3: Numerical integration for normalization
  # Define integration limits
  lower_bound <- 0
  upper_bound <- q-1

  # Perform numerical integration
  normalization <- integrate(rs_curve, lower = lower_bound, upper = upper_bound)$value

  # Handle case where normalization is close to zero
  if (normalization < 1e-10) {
    warning("Normalization constant is very close to zero, using uniform distribution")
    return(runif(n, min = lower_bound, max = upper_bound))
  }

  # Step 4: Create sampling function
  # Using rejection sampling method
  sample_from_rs <- function() {
    max_density <- optimize(rs_curve, c(lower_bound, upper_bound), maximum = TRUE)$objective

    while (TRUE) {
      # Generate candidate from uniform distribution
      x <- runif(1, min = lower_bound, max = upper_bound)

      # Acceptance probability
      accept_prob <- rs_curve(x) / (max_density * normalization)

      # Accept or reject
      if (runif(1) < accept_prob) {
        return(x)
      }
    }
  }

  # Generate samples
  samples <- replicate(n, sample_from_rs())

  return(samples)
}
