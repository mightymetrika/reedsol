test_that("reedsol_sim works", {

  dat <- reedsol_sim(c(1, 2, 3), n = 1, q = 8)
  expect_equal(length(dat), 1)
  expect_true(dat >= 0)

})
