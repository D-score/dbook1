library(magick)

fig <- image_read("fig/Afbeelding1.png")
f2 <- image_background(fig, "transparent")
image_write(f2, "fig/lineplot.png")
