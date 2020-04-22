---
title: "HMODEL_replication"
author: "Molly Carney"
date: "4/22/2020"
---

## HMODEL Replication
This repository holds all code, data, and the ODD for the forthcoming paper "Agent-Based Modeling, Scientific Reproducibility, and Taphonomy: A Successful Model Implementation Case Study." Below, we include all code for reproducing the statistical analyses and graphs.

### Packages
```{r packages used}
library("dplyr")
library("ggpubr")
library("reshape2")
library("scales")
```

### Statistics from Tables 1 and 2
```r
var.test(hmodel.means$excavation10_100_0, hmodel.means$survey_100_0)
t.test(hmodel.means$excavation10_100_0, hmodel.means$survey_100_0)
```

### Biplots from Figures 2, 4a, 4b, and 5
```r
survey_100_0 <- read.csv(file.choose()) 
plot(x = c(1,2000), y = c(1,100), type = "n")
for(i in 1:1000) points(survey_100_0[i, ], 1:100, cex = 0.5, pch = 16, main="HMODEL Replication EI: 50 ED: 0.5", col = alpha("black", alpha = 0.5)) 
abline(a=0, b=.05, col = "red", lty = 2, lwd = 2)
```

### Boxplots from Figures 3 and 6
```r
probs.boxplot <- melt(probs.means)
ggboxplot(probs.boxplot, x="variable", y="value", border="black", xlab="Experiment", ylab="Radiocarbon Date Value", ylim= c(0, 2000))
```

Carney, Molly, and Benjamin Davies
2020 Agent-Based Modeling, Scientific Reproducibility, and Taphonomy:  A Successful Model Implementation Case Study. SocArXiv, April 22.
