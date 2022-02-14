# update MICS Interesting and Noteworthy Findings

library(rmarkdown) # for most rendering

# library(bookdown) # for epub

# library(tint) # tint is not tufte

# library(tufte) # tufte handouts



render("index.Rmd",
       output_format = slidy_presentation(incremental = TRUE,
                                          css = "UNslidy.css"),
       output_file = "MICS-slidy.html")






