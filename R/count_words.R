# count words
sources <- c("Rmd/01-intro.Rmd",
             "Rmd/02-history.Rmd",
             "Rmd/03-threeways.Rmd",
             "Rmd/04-measurement.Rmd",
             "Rmd/05-estimation.Rmd",
             "Rmd/06-evaluation.Rmd",
             "Rmd/07-validity.Rmd",
             "Rmd/08-precision.Rmd",
             "Rmd/09-threestudies.Rmd",
             "Rmd/11-discussion.Rmd",
             "Rmd/Appendix-notation.Rmd")

words <- sapply(sources, FUN = wordcountaddin::word_count)
data.frame(words)

# excludes references
sum(words)
