# update MICS Interesting and Noteworthy Findings

library(rmarkdown) # for most rendering

# library(bookdown) # for epub

# library(revealjs) # reveal.js

# library(tint) # tint is not tufte

# library(tufte) # tufte handouts

# 
# bookdown::render_book("data-driven-report-demo.Rmd", 
#                       "bookdown::gitbook",
#                       # output_dir = "book"
#                       )
# 

# render("MICS-interesting-and-noteworthy-findings.Rmd",
#        output_format = revealjs_presentation(css = "revealjs.css",
#                                              fig_height = 3),
#        output_file = "...")

render("MICS-interesting-and-noteworthy-findings.Rmd",
       output_format = slidy_presentation(incremental = TRUE,
                                          css = "UNslidy.css"),
       output_file = "MICS-interesting-and-noteworthy-findings-slidy.html")






