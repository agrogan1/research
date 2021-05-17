* Survival Analysis of Corporal Punishment Bans

cd "C:\Users\agrogan\Box Sync\Box Sync\GitHub\research\cpbans\survival-analysis"

doedit "survival-analysis.stmd"

markstat using "survival-analysis.stmd", mathjax // HTML

graph close _all

markstat using "survival-analysis.stmd", pdf // PDF

graph close _all

markstat using "survival-analysis.stmd", docx // MS Word

graph close _all



