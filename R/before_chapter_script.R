# automatically run before each chapter

# load standard packages
pkg <- c("knitr", "kableExtra", "ggplot2", "tidyr", "dplyr", "RColorBrewer")
loaded <- sapply(pkg, require, character.only = TRUE,
                 warn.conflicts = FALSE, quietly = TRUE)

# set ggplot theme
ggplot2::theme_set(theme_light())
