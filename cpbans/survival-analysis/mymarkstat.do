* Survival Analysis of Corporal Punishment Bans

cd "C:\Users\agrogan\Box Sync\Box Sync\GitHub\research\cpbans\survival-analysis" // Windows

cd "/Users/agrogan/Box Sync/GitHub/research/cpbans/survival-analysis" // Mac

clear all // clear workspace

doedit "survival-analysis.stmd"

* HTML

markstat using "survival-analysis.stmd", mathjax // HTML

graph close _all

* PDF

erase "survival-analysis.pdf" // erase prior PDF file

markstat using "survival-analysis.stmd", pdf // PDF

graph close _all

erase "survival-analysis.tex" // erase TeX file

erase "survival-analysis.md" // erase markdown file

erase "survival-analysis.pdx" // erase pdx file

* MS Word

markstat using "survival-analysis.stmd", docx // MS Word

graph close _all



