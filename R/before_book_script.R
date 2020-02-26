library(knitr)

# knitr options
knit_theme$set(knit_theme$get("earendel"))
knit_hooks$set(document = function(x) {
  sub('\\usepackage[]{color}', '\\usepackage{xcolor}', x, fixed = TRUE)})

# R options
options(na.action = na.fail, width = 64, digits = 3, scipen = 6,
        continue = "  ")
