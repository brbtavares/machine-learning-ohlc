#' @title Load R Packages Silently
#'
#' @description This function loads a list of R packages, suppressing their
#'   startup messages. It also checks if packages are installed and installs
#'   them if they are missing.
#'
#' @param package_list A character vector of package names to be loaded.
#'
#' @return Invisible NULL. The function is called for its side effects (loading packages).
#'
#' @examples
#' # Example usage:
#' # my_packages <- c("ggplot2", "dplyr", "tidyr")
#' # load_packages_silently(my_packages)
#' # Now you can use functions from ggplot2, dplyr, etc.
load_packages_silently <- function(package_list) {
  # Check if packages are installed and install them if not
  new_packages <- package_list[!(package_list %in% installed.packages()[,"Package"])]
  if(length(new_packages)) install.packages(new_packages)
  
  # Load packages silently
  suppressPackageStartupMessages({
    sapply(package_list, library, character.only = TRUE)
  })
}

#' @title Loads data from a specified file path or default raw data folder.
#' @description
#' This function provides a flexible way to load data into R.
#' It can either load a single file from a specified directory (defaulting to './data/raw/')
#' or load a specific file identified by its full path.
#' It currently supports CSV files and is designed for easy extension
#' to other formats like SQLite in the future.
#'
#' @param file_path A character string specifying the path to the data file,
#'                  or the directory containing the data file.
#'                  If it's a directory, the function will attempt to find a
#'                  single file within it. If it's a full file path (ending
#'                  with a file extension), it will load that specific file.
#'                  The default directory is "./data/raw/".
#' @param type A character string indicating the type of the data source.
#'             Currently supported: "csv".
#'             Future support may include: "sqlite", "excel", etc.
#' @param ... Additional arguments to be passed to the specific data loading
#'            function (e.g., `read.csv`, `read_csv`, etc.).
#'
#' @return A data frame containing the loaded data.
#' @export
#'
#' @examples
#' # Assume you have a file named 'my_trade_data.csv' in './data/raw/'
#' # df <- load_data() # Loads the only file in './data/raw/'
#'
#' # If you have a specific file and want to provide the full path:
#' # df_specific <- load_data(file_path = "./data/my_specific_data/another_file.csv")
#'
#' # Passing additional arguments to read.csv (e.g., specifying separator)
#' # df_semicolon <- load_data(file_path = "./data/raw/", type = "csv", sep = ";")
#'
#' # Or if providing a full path:
#' # df_semicolon_full <- load_data(file_path = "./data/my_specific_data/data_with_semicolon.csv", sep = ";")
load_data <- function(file_path = "./data/raw/", type = "csv", ...) {
  
  # Input validation
  if (!is.character(file_path) || length(file_path) != 1) {
    stop("'file_path' must be a single character string.")
  }
  if (!is.character(type) || length(type) != 1) {
    stop("'type' must be a single character string.")
  }
  
  # Determine if file_path is a directory or a full file path
  is_directory <- FALSE
  if (dir.exists(file_path)) {
    is_directory <- TRUE
    # Ensure directory path ends with '/'
    if (!grepl("/$", file_path)) {
      file_path <- paste0(file_path, "/")
    }
  } else if (!file.exists(file_path)) {
    stop(paste("The specified path does not exist or is not a valid file/directory:", file_path))
  }
  
  full_file_to_load <- NULL
  
  if (is_directory) {
    # If file_path is a directory, find files matching the type
    # For now, only handles CSV. Extend this with more types later.
    pattern <- switch(
      type,
      "csv" = "\\.csv$",
      stop(paste("Unsupported data type for directory scan:", type))
    )
    
    files_in_dir <- list.files(path = file_path, pattern = pattern, full.names = TRUE)
    
    if (length(files_in_dir) == 0) {
      stop(paste("Error: No", type, "files found in the directory:", file_path))
    } else if (length(files_in_dir) > 1) {
      stop(paste("Error: More than one", type, "file found in the directory:", file_path,
                 "\nPlease specify the exact file path or ensure only one file exists."))
    } else {
      full_file_to_load <- files_in_dir[1]
    }
  } else {
    # If file_path is a full file path, use it directly
    full_file_to_load <- file_path
    # Basic check for file type consistency if a type is specified
    if (type == "csv" && !grepl("\\.csv$", full_file_to_load, ignore.case = TRUE)) {
      warning(paste("File extension for '", full_file_to_load, "' does not match specified type 'csv'. Attempting to load anyway.", sep = ""))
    }
  }
  
  # Check if the determined file exists
  if (!file.exists(full_file_to_load)) {
    stop(paste("File not found at the resolved path:", full_file_to_load))
  }
  
  # Load data based on type
  data <- switch(
    type,
    "csv" = {
      # Prefer readr::read_csv for performance and consistency,
      # but fall back to utils::read.csv if readr is not available.
      if (requireNamespace("readr", quietly = TRUE)) {
        message(paste("Loading CSV with readr::read_csv from:", full_file_to_load))
        readr::read_csv(full_file_to_load, ...)
      } else {
        message(paste("Loading CSV with utils::read.csv from:", full_file_to_load))
        read.csv(full_file_to_load, ...)
      }
    },
    # --- Future extensions for other data types ---
    # "sqlite" = {
    #   if (!requireNamespace("RSQLite", quietly = TRUE)) {
    #     stop("Package 'RSQLite' is required for SQLite files. Please install it.")
    #   }
    #   message(paste("Loading SQLite database from:", full_file_to_load))
    #   # Example for SQLite - you'd pass table name via ...
    #   # con <- RSQLite::dbConnect(RSQLite::SQLite(), full_file_to_load)
    #   # data <- RSQLite::dbReadTable(con, ...) # You'd need a 'table_name' param
    #   # RSQLite::dbDisconnect(con)
    #   # data
    #   stop("SQLite loading not yet implemented.")
    # },
    # "excel" = {
    #   if (!requireNamespace("readxl", quietly = TRUE)) {
    #     stop("Package 'readxl' is required for Excel files. Please install it.")
    #   }
    #   message(paste("Loading Excel file from:", full_file_to_load))
    #   readxl::read_excel(full_file_to_load, ...) # You might need a 'sheet' param
    # },
    # -----------------------------------------------
    stop(paste("Unsupported data type:", type, ". Currently only 'csv' is supported."))
  )
  
  message(paste("Data loaded successfully from:", full_file_to_load))
  return(data)
}