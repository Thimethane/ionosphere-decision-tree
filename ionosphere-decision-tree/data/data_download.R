# =============================================================================
# data_download.R
# Downloads the Ionosphere dataset from the course URL and saves it locally.
# Only needed if NOT using mlbench::data(Ionosphere).
# =============================================================================

# URL provided in the assignment
url <- "https://my.uopeople.edu/pluginfile.php/295432/mod_workshop/instructauthors/Ionosphere.txt"

# Destination path
dest <- "data/Ionosphere.txt"

# Download
if (!file.exists(dest)) {
  message("Downloading Ionosphere.txt ...")
  tryCatch(
    download.file(url, destfile = dest, method = "auto"),
    error = function(e) {
      message("Download failed (link may require login). Using mlbench instead.")
      message("Run: library(mlbench); data(Ionosphere)")
    }
  )
} else {
  message("data/Ionosphere.txt already exists.")
}

# If downloaded manually, read it in like this:
# col_names <- c(paste0("V", 1:34), "Class")
# ionosphere_manual <- read.csv(dest, header = FALSE, col.names = col_names)
# ionosphere_manual$Class <- factor(ionosphere_manual$Class)
