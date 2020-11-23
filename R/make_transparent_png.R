library(magick)

fig <- image_read("fig/Afbeelding1.png")
f2 <- image_background(fig, "transparent")
image_write(f2, "fig/lineplot.png")

fig <- image_read("fig/dynamic.png")
f2 <- image_background(fig, "pink")
f3 <- image_fill(fig, "pink", point = "+10+10")
# image_write(f2, "fig/dynamic2.png")
