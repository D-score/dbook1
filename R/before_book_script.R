library(knitr)
library(kableExtra)

# knitr options
knit_hooks$set(document = function(x) {
  sub('\\usepackage[]{color}', '\\usepackage{xcolor}', x, fixed = TRUE)}
)

# R options
options(na.action = na.fail, width = 64, digits = 3, scipen = 6,
        continue = "  ")
