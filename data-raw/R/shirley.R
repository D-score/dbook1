# stores data/shirley.rda in

shirley <- data.frame(
  name = c("Martin", "Carol", "Max", "Virginia Ruth", "Sibyl",
           "David", "James D.", "Harvey", "Winnifred", "Quentin",
           "Maurice", "Judy", "Irene May", "Peter", "Walley", "Fred",
           "Donovan", "Patricia", "Torey", "Larry", "Doris"),
  sex = c("boy", "girl", "boy", "girl", "girl",
          "boy", "boy", "boy", "girl", "boy",
          "boy", "girl", "girl", "boy", "boy", "boy",
          "boy", "girl", "boy", "boy", "girl"),
  stepping = c(15, 15, 14, NA, NA, 19, 19, 14, 15, 15,
               18, 18, 19, 15, 18, 15, NA, 15, NA, 13, NA),
  standing = c(NA, 19, NA, 21, 22, 27, 30, 27, 30, 23,
               23, 29, 34, 29, 33, 32, 23, 30, 21, 41, 23),
  walk_help = c(21, 37, 25, 41, 37, 34, 45, 42, 41, 38,
                45, 45, 45, 49, 54, 46, 50, 45, 72, 54, 44),
  walk_alone = c(50, 50, 54, 54, 58, 60, 60, 62, 62, 64,
                 66, 66, 66, 66, 68, 70, 70, 70, 74, 76, NA))

save(shirley, file = file.path("data/shirley.rda"), compress = "xz")
