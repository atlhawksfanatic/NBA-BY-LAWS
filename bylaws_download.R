# Deadspin noted that the bylaws went public:
# https://deadspin.com/that-secret-nba-constitution-is-now-online-1569509012

# Create a directory for the data
local_dir    <- "raw"
data_source <- paste0(local_dir, "/pages")
if (!file.exists(local_dir)) dir.create(local_dir, recursive = T)
if (!file.exists(data_source)) dir.create(data_source)

if (!file.exists(local_dir)) dir.create(local_dir)

bylaws_url <- paste0("http://prawfsblawg.blogs.com/files/",
                     "221035054-nba-constitution-and-by-laws.pdf")

bylaws_file <- paste(local_dir, basename(bylaws_url), sep = "/")
if (!file.exists(bylaws_file)) download.file(bylaws_url, bylaws_file)

# Parse the bylaws to a raw text file:
library(pdftools)
library(stringr)
library(tidyverse)

bylaws        <- pdf_text(bylaws_file)
# names(bylaws) <- seq(length(bylaws))
bylaws_toc    <- pdf_toc(bylaws_file)

# Write each page to a .txt file:
map2(bylaws, seq(length(bylaws)), function(bylaws, page){
  page      <- str_pad(page, 3, side = "left", pad = "0")
  temp_file <- paste0(data_source, "/bylaws_page_", page, ".txt")
  
  fileConn <- file(temp_file)
  writeLines(bylaws, fileConn)
  close(fileConn)
  
})

bylaws <- unlist(bylaws)

fileConn <- file(paste0(local_dir, "/bylaws_2012.txt"))
writeLines(bylaws, fileConn)
close(fileConn)