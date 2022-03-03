# build slides to various formats

library(xaringanBuilder)

build_pdf("./MICS-physical-abuse/MICS-physical-abuse.Rmd")

build_mp4("./MICS-physical-abuse/MICS-physical-abuse.Rmd",
          fps = .25)

# xaringan::moon_reader("./MICS-physical-abuse/MICS-physical-abuse.Rmd")