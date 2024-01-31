library(GENESPACE)
library(ggplot2)
# 1) Specify paths to the working directory and MCScanX
wd <- "/home/ianis/Documents/Genespace"
path2mcscanx <- "/home/ianis/Programs/MCScanX/MCScanX-master"
# 2) Run init_genespace to make sure that the input data is OK.
# It also produces the correct directory structure and corresponding paths
# for the GENESPACE run
gpar <- init_genespace(
  wd = wd,
  path2mcscanx = path2mcscanx)
# 3) Run GENESPACE
out <- run_genespace(gpar, overwrite = T)
