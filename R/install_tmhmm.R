#' Install tmhmm to a local folder
#' @inheritParams default_params_doc
#' @examples
#' if (tmhmm::is_url_valid() && !tmhmm::is_tmhmm_installed()) {
#'   folder_name <- tempfile()
#'
#'   install_tmhmm(folder_name = folder_name)
#'
#'   unlink(folder_name, recursive = TRUE)
#' }
#' @author Richèl J.C. Bilderbeek
#' @export
install_tmhmm <- function(
  download_url = tmhmm::get_tmhmm_url(),
  folder_name = tmhmm::get_default_tmhmm_folder()
) {
  is_bin_installed <- tmhmm::is_tmhmm_bin_installed( # nolint tmhmm function
    folder_name = folder_name
  )
  if (!is_bin_installed) {
    tmhmminstall::install_tmhmm_bin( # nolint tmhmm function
      download_url = download_url,
      folder_name = folder_name
    )
  }
  is_set_up <- tmhmm::is_tmhmm_set_up( # nolint tmhmm function
    folder_name = folder_name
  )
  if (!is_set_up) {
    tmhmminstall::set_up_tmhmm( # nolint tmhmm function
      folder_name = folder_name
    )
  }
}

#' Install the TMHMM binary to a local folder
#' @inheritParams default_params_doc
#' @author Richèl J.C. Bilderbeek
#' @export
install_tmhmm_bin <- function(
  download_url = tmhmm::get_tmhmm_url(),
  folder_name = rappdirs::user_data_dir()
) {
  bin_path <- file.path(folder_name, "tmhmm-2.0c", "bin", "tmhmm")
  if (file.exists(bin_path)) {
    stop("TMHMM binary is already installed")
  }

  dir.create(path = folder_name, showWarnings = FALSE, recursive = TRUE)

  archive_filename <- "tmhmm-2.0c.Linux.tar.gz"
  local_path <- file.path(folder_name, archive_filename)
  tryCatch(
    suppressWarnings(
      utils::download.file(
        url = file.path(download_url, archive_filename),
        destfile = local_path
      )
    ),
    error = function(e) {
      stop(
        "'download_url' is invalid.\n",
        "URL:", download_url, "\n",
        "Request a download URL at the TMHMM request page at\n",
        "\n",
        "https://services.healthtech.dtu.dk/service.php?TMHMM-2.0/\n",
        "\n",
        "Full error message: \n",
        "\n",
        e$message
      )
    }
  )

  testthat::expect_true(file.exists(local_path))
  # Linux has a tar file
  utils::untar(
    tarfile = local_path,
    exdir = path.expand(folder_name)
  )
  testthat::expect_true(file.exists(bin_path))
}
