test_that("use", {
  if (!tmhmm::is_on_ci()) return()
  if (!curl::has_internet()) return()
  if (!tmhmm::is_url_valid()) return()

  if (tmhmm::is_tmhmm_installed()) {
    uninstall_tmhmm()
    install_tmhmm()
    expect_true(tmhmm::is_tmhmm_installed())
  } else {
    install_tmhmm()
    expect_true(tmhmm::is_tmhmm_installed())
    uninstall_tmhmm()
  }
})
