# update MICS Interesting and Noteworthy Findings

library(rmarkdown) # for most rendering

# library(bookdown) # for epub

# library(tint) # tint is not tufte

# library(tufte) # tufte handouts

render("./MICS/MICS.Rmd",
       output_format = slidy_presentation(incremental = TRUE,
                                          css = "UMslidyUPDATED.css",
                                          slide_level = 2,
                                          fig_height = 2),
       output_file = "MICS-slidy.html")

render("./MICS/MICS.Rmd",
       output_format = ioslides_presentation(incremental = TRUE,
                                             widescreen = TRUE,
                                             smaller = TRUE),
       output_file = "MICS-ioslides.html")


