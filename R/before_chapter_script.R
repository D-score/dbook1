# automatically run before each new chapter

# clean out current session objects
rm(list = ls(all = TRUE))

# load standard packages
pkg <- c("knitr", "kableExtra", "ggplot2", "tidyr", "dplyr")
loaded <- sapply(pkg, require, character.only = TRUE,
                 warn.conflicts = FALSE, quietly = TRUE)

# set ggplot theme
ggplot2::theme_set(theme_light())
