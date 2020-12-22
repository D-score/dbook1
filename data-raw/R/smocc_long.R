#Get smocc_long3

# Packages
library(ddata)
library(dscore)
library(haven)
library(dplyr)

# Get smocc data
smocc <- get_gcdg(study="Netherlands 1", adm = T, cov=T)
#head(smocc)
#summary(smocc)

# Get IQ at 5 years [DIT NOG AANPASSEN!]
ddir <- file.path("data-raw/data/smocc")
geg5jaar <- haven::read_spss(file.path(ddir, "geg5jaar.sav"))


# Keep only IQ and patientnr
sub.geg5jaar <- subset(geg5jaar, select = c("PNR", "IQ"))
names(sub.geg5jaar) <- c("id", "IQ")

# Merge datasets
data.smocc <- left_join(smocc, sub.geg5jaar, "id")
data.smocc$age <- data.smocc$age/12 #make age in years

colnames(data.smocc)[21:77] <- dscore::rename_gcdg_gsed(colnames(data.smocc)[21:77])
# CALCULATE D-SCORES

# Overview of the items per wave in a list
items_by_wave <- list(wave1=c("n1", "n2", "n3", "n4", "n5"),
                      wave2=c("n6", "n7"),
                      wave3=c("n8", "n9", "n10", "n11", "n12"),
                      wave4=c("n13", "n14", "n15", "n16", "n17", "n18"),
                      wave5=c("n19", "n20", "n21", "n22", "n23", "n24", "n25"),
                      wave6=c("n26", "n27", "n28", "n29", "n30", "n31"),
                      wave7=c("n32", "n33", "n34", "n35", "n36", "n37"),
                      wave8=c("n38", "n39", "n40", "n41", "n42", "n43"),
                      wave9="n44"
)

# Apply de function for each wave (1-9)
d_by_wave <- lapply(1:9, function(x){
  waveitems <- dscore::rename_gcdg_gsed(items_by_wave[[x]])
  dscore <- dscore(data.smocc, items=waveitems, key="gcdg") #dscore bepalen obv de items per wave (nu wordt wel voor iedereen die een of meer van deze items heeft de dscore bepaald)
  d <- data.frame(data.smocc[,c("id", "wave", "age")], dscore) #id wave en age aan de dscore plakken
  d <- subset(d, wave==x) # alleen de rijen van de juiste wave selecteren
  d
})

# Merge D-scores per wave
smocc_d <- do.call('rbind', d_by_wave)

# Merge D-scores to smocc data
data.smocc1 <- left_join(data.smocc, smocc_d)


# CALCULATE D-SCORES NEXT WAVE

# Overview of the items per wave in a list
items_by_wave_nw <- list(wave1=c("n6", "n7"),
                      wave2=c("n8", "n9", "n10", "n11", "n12"),
                      wave3=c("n13", "n14", "n15", "n16", "n17", "n18"),
                      wave4=c("n19", "n20", "n21", "n22", "n23", "n24", "n25"),
                      wave5=c("n26", "n27", "n28", "n29", "n30", "n31"),
                      wave6=c("n32", "n33", "n34", "n35", "n36", "n37"),
                      wave7=c("n38", "n39", "n40", "n41", "n42", "n43"),
                      wave8="n44"
)

# Apply de function for each wave (1-8)
d_by_wave_nw <- lapply(1:8, function(x){
  waveitems_nw <- dscore::rename_gcdg_gsed(items_by_wave_nw[[x]])
  dscore_nw <- dscore(data.smocc, items=waveitems_nw, key="gcdg")#dscore bepalen obv de items per wave (nu wordt wel voor iedereen die een of meer van deze items heeft de dscore bepaald)
  d_nw <- data.frame(data.smocc[,c("id", "wave", "age")], dscore_nw) #id wave en age aan de dscore plakken
  d_nw <- subset(d_nw, wave==x) # alleen de rijen van de juiste wave selecteren
  d_nw
})

# Merge D-scores per wave
smocc_d_nw <- do.call('rbind', d_by_wave_nw)
colnames(smocc_d_nw)[4:8] <- paste(colnames(smocc_d_nw)[4:8], "nw", sep = "_")

# Merge D-scores to smocc data
data.smocc2 <- left_join(data.smocc1, smocc_d_nw)

#VOEG aantal negatieve scores wave toe!
neg_scores_by_wave <- lapply(1:9, function(x){
  neg_scores <-
})


#VOEG aantal negatieve scores next wave toe!


#Subset van de data zonder de losse scores op de items:
data.long1 <- data.smocc1[1:n-1, c("country", "study", "id", "wave", "age", "male", "gestage", "birthweight",
                                 "birthsize", "agemom", "edumo", "edumocat", "residence", "height", "weight",
                                 "haz", "waz", "whz", "baz", "IQ", "dscore")]

data.long2 <- data.smocc2[1:n-1, c("country", "study", "id", "wave", "age", "male", "gestage", "birthweight",
                                 "birthsize", "agemom", "edumo", "edumocat", "residence", "height", "weight",
                                 "haz", "waz", "whz", "baz", "IQ", "dscore")]

