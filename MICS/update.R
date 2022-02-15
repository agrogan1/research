# update MICS Interesting and Noteworthy Findings

library(rmarkdown) # for most rendering

# library(bookdown) # for epub

# library(tint) # tint is not tufte

# library(tufte) # tufte handouts

render("./MICS/MICS.Rmd",
       output_format = slidy_presentation(incremental = TRUE,
                                          css = "UMslidy.css",
                                          slide_level = 2),
       output_file = "MICS-slidy.html")

# render("./MICS/MICS.Rmd",
#        output_format = pdf_document(),
#        output_file = "MICS.pdf")


