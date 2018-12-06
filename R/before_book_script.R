# packages loaded for all chapters
pkg <- c("knitr", "ggplot2", "tidyr", "dplyr")
loaded <- sapply(pkg, require, character.only = TRUE,
                 warn.conflicts = FALSE, quietly = TRUE)

# knitr options
knit_theme$set(knit_theme$get("earendel"))
opts_chunk$set(comment = NA, background = "#FBFBFB")
knit_hooks$set(document = function(x) {
  sub('\\usepackage[]{color}', '\\usepackage{xcolor}', x, fixed = TRUE)})

# R options
options(na.action = na.fail, width = 64, digits = 3, scipen = 6,
        continue = "  ")

# ggplot theme
ggplot2::theme_set(theme_light())
