# get packages
pkgs <- c("sjlabelled", "dplyr", "haven", "gtools", "AGD")
notthere <- !(pkgs %in% installed.packages()[, "Package"])
new.packages <- pkgs[notthere]
if(length(new.packages)) install.packages(new.packages)

# load packages
loaded <- sapply(pkgs, require, character.only = TRUE,
                 warn.conflicts = FALSE, quietly = TRUE)

## Netherlands
## using smock.sav, dated 22May2009
filenames <- c("smock.sav",
               "SMOCCchild.sav",
               "SMOCCtime.sav")
ddir <- file.path("data-raw/data/smocc")
file1 <- haven::read_spss(file.path(ddir, filenames[1]))
file2 <- haven::read_spss(file.path(ddir, filenames[2]))
file3 <- haven::read_spss(file.path(ddir, filenames[3]))

# create overview of file, variable name and label
objects <- paste0("file", 1)
overview <- data.frame(file = NULL, var_name = NULL, var_label = NULL)
for (i in 1:length(objects)) {
  fn <- objects[i]
  x <- get(fn)
  df <- data.frame(study = "NL1",
                   filename = filenames[i],
                   object = objects[i],
                   var_name = names(x),
                   var_label = get_label(x))
  overview <- rbind(overview, df)
}

#write.table(overview, file = file.path(getwd(), "notes", "NL1_variables.txt"),
#            sep = "\t", na = "", quote = FALSE, row.names = FALSE)

# file1
# decompose pnr
names(file1) <- tolower(names(file1))
file1$id <- floor(file1$pnr.new/10)
file1$wave <- file1$pnr.new %% 10
file1$agedays <- file1$lft

# adopt "lex_gcdg" naming
oldnames <- names(file1)[8:64]
newnames <- paste0("n", 1:57)
names(file1)[8:64] <-  newnames

# recode
z <- get_labels(file1)
items <- paste0("n", 1:57)
tab <- function(x) table(x, useNA = "always")
raw1 <- t(sapply(file1[, items], tab))
to_0_1 <- function(x) recode(x, "0" = 0, "1" = 1, .default = NaN)
file1[, items] <- lapply(file1[, items], to_0_1)

# file2
z <- get_labels(file2)
## find birth wgt, birth hgt and birth hdc in broad data
file2$id <- file2$pnr
file2$birthweight <- file2$k061417
file2$birthsize <- file2$k062223
file2$birthsize[file2$birthsize == 0] <- NA

# add birth measurements to long data
wgt.0 <- file2$birthweight / 1000
hgt.0 <- file2$birthsize
hdc.0 <- file2$k062425
hdc.0[hdc.0 == 0] <- NA
dob <- with(file2, ISOdate(1900 + k011617, k011415, k011213))
dob <- format(as.Date(dob), "%d-%m-%y")

male <- recode(as_label(file2$k0118), "Jongen" = 1, "Meisje" = 0, .default = NaN)
birth <- data.frame(src = "smocc", id = file2$pnr,
                    male = male,
                    agedays = 0, agemth = 0, ageyr = 0,
                    height = hgt.0, weight = wgt.0, hdc = hdc.0)

## Child level variables
file2$edumocat <- recode(as_label(file2$k0273), "Blo" = 0, "Lo" = 1, "Lbo" = 1,
                         "Havo" = 2, "Mavo" = 2, "Mbo" = 2, "Vwo" = 2,
                         "Hbo" = 3, "Univ" = 3, .default = NaN)
file2$edumocat <- ifelse(is.nan(file2$edumocat), NA, file2$edumocat)
file2$male <- recode(as_label(file2$k0118), "Jongen" = 1, "Meisje" = 0, .default = NaN)
file2$gestage <- file2$k051213
file2$gestage[file2$gestage == 0] <- NA

hgtm <- file2$k032123
hgtm[hgtm == 0] <- NA
hgtf <- file2$k026062
hgtf[hgtf == 0] <- NA
# age of mother
bdm <- file2$k026364
bdm[bdm == 0 | bdm == 99 | is.na(bdm)] <- 1
bmm <- file2$k026566
bmm[bmm == 0 | bmm == 99 | is.na(bmm)] <- 1
bym <- file2$k026768
bym[bym == 0] <- NA
daym <- as.numeric(with(file2,
                        ISOdate(1900 + k011617, k011415, k011213) -
                          ISOdate(1900 + bym, bmm, bdm)))
file2$agemom <- round(daym / 365.25)

timefixed <- file2[, c("id", "male", "edumocat", "birthweight", "birthsize",
                       "gestage", "agemom")]

# file3
# >>> time-varying covariates
# agemth, agedays, male, height, weight, haz, whz, waz
# select all visits from the long data (n = 16953) 2040 unique children
file3 <- file3[file3$visit == 1, ]
id <- file3$pnr
male <- recode(as_label(file3$k1018), "Jongen" = 1, "Meisje" = 0, .default = NaN)

# calculate dates of measurement and dates of birth
dom <- with(file3, ISOdate(1900 + year, month, day))
dob <- with(file3, ISOdate(1900 + k101617, k101415, k101213))

# calculate decimal age
agedays <- as.numeric(dom - dob)
ageyr <- round(agedays / 365.25, 4)
agemth <- ageyr * 12

# simple data transforms and edits
hgt <- file3$k103336 / 10
hgt[hgt < 35] <- NA
wgt <- file3$k102832/1000
wgt[wgt == 0] <- NA
hdc <- file3$k103739 / 10
hdc[hdc == 0] <- NA

# save dates in Dutch format
dob <- format(as.Date(dob), "%d-%m-%y")
dom <- format(as.Date(dom), "%d-%m-%y")

timevarying <- data.frame(src = "smocc",
                          id = id,
                          male = male,
                          agedays = agedays,
                          agemth = agemth,
                          ageyr = ageyr,
                          height = hgt,
                          weight = wgt,
                          hdc = hdc)
#
timevarying <- rbind(birth, timevarying)

# pad record number, sort according to id and age
idx <- order(timevarying$id, timevarying$agedays)
timevarying <- timevarying[idx, ]
mrec <- table(timevarying[idx, "id"])
rec <- unlist(sapply(mrec, seq)) # record number
nrec <- rep(mrec, times = mrec)  # number of records
timevarying <- data.frame(rec = rec, nrec = nrec, timevarying)
rownames(timevarying) <- 1:nrow(timevarying)

# add Z-scores
sexc <- recode(male, "1" = "M", "0" = "F", .default = NA_character_)

haz <- with(timevarying,
            y2z(y = height, x = ageyr, ref = AGD::who.hgt,
                sex = sexc))
whz <- with(timevarying,
            y2z(y = weight, x = height, ref = AGD::who.wfl,
                sex = sexc))
waz <- with(timevarying,
            y2z(y = weight, x = ageyr, ref = AGD::who.wgt,
                sex = sexc))
baz <- with(timevarying,
            y2z(y = weight/(height/100)^2,
                x = ageyr, ref = AGD::who.bmi,
                sex = sexc))
timevarying <- data.frame(timevarying,
                          haz = haz,
                          waz = waz,
                          baz = baz,
                          whz = whz)

# join the three datasets

data <- merge(file1, timevarying, by = c("id", "agedays"), all = TRUE)
data <- merge(data, timefixed, by = c("id"))

# remove rows without any Van Wiechen data
items <- paste0("n", 1:57)
observed <- rowSums(!is.na(data[, items]))
data <- data[observed > 0, ]

# restructure
cov <- c("height", "weight",
         "haz", "waz", "baz", "whz", "edumocat",
         "birthweight", "birthsize", "gestage", "agemom")
data <- data.frame(country = "NL",
                   study = "Netherlands 1",
                   id = data$id,
                   male = data$male.y,
                   age = round(12 * data$agedays / 365.25, 3),
                   wave = data$wave,
                   data[, items],
                   data[, cov],
                   stringsAsFactors = FALSE)


# save
NL <- data
save("NL", file = file.path("data/smocc.rda"), compress = "xz")

# unload packages
Vectorize(detach)(name = paste0("package:", pkgs), unload = TRUE,
                  character.only = TRUE)
