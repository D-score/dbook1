# automatically run before each new chapter

# clean out session objects
rm(list = ls(all = TRUE))

# graphical parameter hooks
source("R/hooks.R")

pkg <- c("knitr", "kableExtra", "ggplot2", "tidyr", "dplyr")
loaded <- sapply(pkg, require, character.only = TRUE,
                 warn.conflicts = FALSE, quietly = TRUE)
ggplot2::theme_set(theme_light())
