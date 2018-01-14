
	
# Customize this path to the folder on your computer where the replication files are located ####

#setwd("C:/Users/.../.../replication files")
#setwd("C:/Users/aforste1/Dropbox/andrea/research/03_papers/2015_vocational_decline_paper/05_replication files/replication files")
setwd("C:/Users/Thijs/Dropbox/piaac_vocational_lifecourse/05_replication files/replication files")

# load libraries ####

library("foreign")
library("Hmisc")
library("plm")
library("lme4")
library("plyr")
library("ggplot2")
library("ggthemes")
library("gridExtra")
library("RColorBrewer")
library("grid")

# Read data ####	

pooled_men   <- read.dta("03_posted/fig2_data_m.dta")
pooled_women <- read.dta("03_posted/fig2_data_f.dta")
zvoc_men     <- read.dta("03_posted/fig3_data_m.dta")
zvoc_women   <- read.dta("03_posted/fig3_data_f.dta")
dual_men     <- read.dta("03_posted/fig4_data_m.dta")
dual_women   <- read.dta("03_posted/fig4_data_f.dta")
single_men   <- read.dta("03_posted/fig5_data.dta")

#- Figure 2 ------------------------------------------------------------------------------------
# Predicted Probabilities of Employment by Type of Education (Vocational/General)
#----------------------------------------------------------------------------------------------#

summary(pooled_men)
summary(pooled_women)

#men
pdf("04_graphs/Figure_2a.pdf", width=8, height=6.4)
pooled_men$upr <- pooled_men$b + (1.96 * pooled_men$se)
pooled_men$lwr <- pooled_men$b - (1.96 * pooled_men$se)

panel_a <-  ggplot(pooled_men, aes(Age, b)) +
        geom_ribbon(aes(ymin = lwr, ymax = upr, fill = vet), alpha = .25) +
        geom_line(aes(colour = vet, linetype = vet), size = 1) + 
        labs(x = "", y = "Predicted probability (pr=Employed)") + coord_cartesian(xlim = c(15, 65), ylim = c(0,1)) +
        theme(legend.position="bottom") + theme(legend.title = element_blank()) + theme(legend.text = element_text(size = 12)) +
        theme(panel.background = element_blank(), axis.line.x = element_line(color="#000000", size=0.3), 
              axis.line.y = element_line(color="#000000", size=0.3))
print(panel_a)
dev.off()


#women
pdf("04_graphs/Figure_2b.pdf", width=8, height=6.4)
pooled_women$upr <- pooled_women$b + (1.96 * pooled_women$se)
pooled_women$lwr <- pooled_women$b - (1.96 * pooled_women$se)

panel_b <-  ggplot(pooled_women, aes(Age, b)) +
        geom_ribbon(aes(ymin = lwr, ymax = upr, fill = vet), alpha = .25) +
        geom_line(aes(colour = vet, linetype = vet), size = 1) +
        labs(x = "Age", y = "Predicted probability (pr=Employed)") + coord_cartesian(xlim = c(15, 65), ylim = c(0,1)) +
        theme(legend.position="bottom") + theme(legend.title = element_blank()) + theme(legend.text = element_text(size = 12)) +
        theme(panel.background = element_blank(), axis.line.x = element_line(color="#000000", size=0.3), 
              axis.line.y = element_line(color="#000000", size=0.3))
print(panel_b)
dev.off()

#- Figure 3 ---------------------------------------------------------------------------------------
# Average Marginal Effect of VET on Employment in Countries with Low and High Vocational Enrollment
#-------------------------------------------------------------------------------------------------#

summary(zvoc_men)
summary(zvoc_women)

#men
pdf("04_graphs/Figure_3a.pdf", width=8, height=6.4)
zvoc_men$upr <- zvoc_men$b + (1.96 * zvoc_men$se)
zvoc_men$lwr <- zvoc_men$b - (1.96 * zvoc_men$se)

panel_a <- 	ggplot(zvoc_men, aes(Age, b)) +
  			geom_ribbon(aes(ymin = lwr, ymax = upr, fill = vet), alpha = .25) +
  			geom_line(aes(colour = vet, linetype = vet), size = 1) +
  			labs(x = "", y = "Average Marginal Effect of VET") + geom_hline(yintercept=0, color="#A0A0A0", size=0.5) + coord_cartesian(xlim = c(15, 65)) +
  			theme(legend.position="bottom") + theme(legend.title = element_blank()) + theme(legend.text = element_text(size = 12)) +
        theme(panel.background = element_blank(), axis.line.x = element_line(color="#000000", size=0.3), 
              axis.line.y = element_line(color="#000000", size=0.3))
print(panel_a)
dev.off()



#women
pdf("04_graphs/Figure_3b.pdf", width=8, height=6.4)
zvoc_women$upr <- zvoc_women$b + (1.96 * zvoc_women$se)
zvoc_women$lwr <- zvoc_women$b - (1.96 * zvoc_women$se)

panel_b <- 	ggplot(zvoc_women, aes(Age, b)) +
  			geom_ribbon(aes(ymin = lwr, ymax = upr, fill = vet), alpha = .25) +
  			geom_line(aes(colour = vet, linetype = vet), size = 1) +
  			labs(x = "Age", y = "Average Marginal Effect of VET") + geom_hline(yintercept=0, color="#A0A0A0", size=0.5) + coord_cartesian(xlim = c(15, 65)) +
  			theme(legend.position="bottom") + theme(legend.title = element_blank()) + theme(legend.text = element_text(size = 12)) +
        theme(panel.background = element_blank(), axis.line.x = element_line(color="#000000", size=0.3), 
              axis.line.y = element_line(color="#000000", size=0.3))
print(panel_b)
dev.off()

#- Figure 4 ----------------------------------------------------------------------------------------
# Average Marginal Effect of VET on Employment in Countries with Low and High Dual System Enrollment
#--------------------------------------------------------------------------------------------------#

#men
pdf("04_graphs/Figure_4a.pdf", width=8, height=6.4)
dual_men$upr <- dual_men$b + (1.96 * dual_men$se)
dual_men$lwr <- dual_men$b - (1.96 * dual_men$se)

panel_a <- 	ggplot(dual_men, aes(Age, b)) +
  			geom_ribbon(aes(ymin = lwr, ymax = upr, fill = vet), alpha = .25) +
  			geom_line(aes(colour = vet, linetype = vet), size = 1) +
  			labs(x = "", y = "Average Marginal Effect of VET") + geom_hline(yintercept=0, color="#A0A0A0", size=0.5) + coord_cartesian(xlim = c(15, 65)) +
  			theme(legend.position="bottom") + theme(legend.title = element_blank()) + theme(legend.text = element_text(size = 12)) +
        theme(panel.background = element_blank(), axis.line.x = element_line(color="#000000", size=0.3), 
              axis.line.y = element_line(color="#000000", size=0.3))
print(panel_a)
dev.off()

#women
pdf("04_graphs/Figure_4b.pdf", width=8, height=6.4)
dual_women$upr <- dual_women$b + (1.96 * dual_women$se)
dual_women$lwr <- dual_women$b - (1.96 * dual_women$se)

panel_b <- 	ggplot(dual_women, aes(Age, b)) +
  			geom_ribbon(aes(ymin = lwr, ymax = upr, fill = vet), alpha = .25) +
  			geom_line(aes(colour = vet, linetype = vet), size = 1) +
  			labs(x = "Age", y = "Average Marginal Effect of VET") + geom_hline(yintercept=0, color="#A0A0A0", size=0.5) + coord_cartesian(xlim = c(15, 65)) +
  			theme(legend.position="bottom") + theme(legend.title = element_blank())  + theme(legend.text = element_text(size = 12)) +
        theme(panel.background = element_blank(), axis.line.x = element_line(color="#000000", size=0.3), 
              axis.line.y = element_line(color="#000000", size=0.3))
print(panel_b)
dev.off()

#- Figure 5---------------------------------------------------------------------------------
# Predicted Probabilities of Employment per Country (Men)
#------------------------------------------------------------------------------------------#

summary(single_men)
describe(single_men)

single_men$upr <- single_men$b + (1.96 * single_men$se)
single_men$lwr <- single_men$b - (1.96 * single_men$se)

  #Austria
  austria <- single_men[ which(single_men$country=='Austria'),]

  a1 <-  ggplot(austria, aes(Age, b)) +
        geom_ribbon(aes(ymin = lwr, ymax = upr, fill = vet), alpha = .25) +
        geom_line(aes(colour = vet, linetype = vet), size = 0.6) + 
        labs(x = "", y = "") + coord_cartesian(xlim = c(15, 65), ylim = c(0,1)) +
        theme(legend.position="bottom") + theme(legend.title = element_blank()) +
        ggtitle("Austria") + theme(panel.background = element_blank(), axis.line.x = element_line(color="#000000", size=0.3), 
              axis.line.y = element_line(color="#000000", size=0.3)) +
        theme(plot.title=element_text(size=8)) + theme(axis.text=element_text(size=6))

  #Belgium
  belgium <- single_men[ which(single_men$country=='Belgium'),]

  a2 <-  ggplot(belgium, aes(Age, b)) +
        geom_ribbon(aes(ymin = lwr, ymax = upr, fill = vet), alpha = .25) +
        geom_line(aes(colour = vet, linetype = vet), size = 0.6) + 
        labs(x = "", y = "") + coord_cartesian(xlim = c(15, 65), ylim = c(0,1)) +
        theme(legend.position="none") + theme(legend.title = element_blank()) +
        ggtitle("Belgium") + theme(panel.background = element_blank(), axis.line.x = element_line(color="#000000", size=0.3), 
              axis.line.y = element_line(color="#000000", size=0.3)) +
        theme(plot.title=element_text(size=8)) + theme(axis.text=element_text(size=6))

  #Canada
  can <- single_men[ which(single_men$country=='Canada'),]

  a3 <-  ggplot(can, aes(Age, b)) +
        geom_ribbon(aes(ymin = lwr, ymax = upr, fill = vet), alpha = .25) +
        geom_line(aes(colour = vet, linetype = vet), size = 0.6) + 
        labs(x = "", y = "") + coord_cartesian(xlim = c(15, 65), ylim = c(0,1)) +
        theme(legend.position="none") + theme(legend.title = element_blank()) +
        ggtitle("Canada") + theme(panel.background = element_blank(), axis.line.x = element_line(color="#000000", size=0.3), 
              axis.line.y = element_line(color="#000000", size=0.3)) +
        theme(plot.title=element_text(size=8)) + theme(axis.text=element_text(size=6))

  #Czech Republic
  cze <- single_men[ which(single_men$country=='Czech Republic'),]

  a4 <-  ggplot(cze, aes(Age, b)) +
        geom_ribbon(aes(ymin = lwr, ymax = upr, fill = vet), alpha = .25) +
        geom_line(aes(colour = vet, linetype = vet), size = 0.6) + 
        labs(x = "", y = "") + coord_cartesian(xlim = c(15, 65), ylim = c(0,1)) +
        theme(legend.position="none") + theme(legend.title = element_blank()) +
        ggtitle("Czech Rep.") + theme(panel.background = element_blank(), axis.line.x = element_line(color="#000000", size=0.3), 
              axis.line.y = element_line(color="#000000", size=0.3)) +
        theme(plot.title=element_text(size=8)) + theme(axis.text=element_text(size=6))

  #Denmark
  den <- single_men[ which(single_men$country=='Denmark'),]

  a5 <-  ggplot(den, aes(Age, b)) +
        geom_ribbon(aes(ymin = lwr, ymax = upr, fill = vet), alpha = .25) +
        geom_line(aes(colour = vet, linetype = vet), size = 0.6) + 
        labs(x = "", y = "") + coord_cartesian(xlim = c(15, 65), ylim = c(0,1)) +
        theme(legend.position="none") + theme(legend.title = element_blank()) +
        ggtitle("Denmark") + theme(panel.background = element_blank(), axis.line.x = element_line(color="#000000", size=0.3), 
              axis.line.y = element_line(color="#000000", size=0.3)) +
       theme(plot.title=element_text(size=8)) + theme(axis.text=element_text(size=6))

  #Estonia
  est <- single_men[ which(single_men$country=='Estonia'),]

  a6 <-  ggplot(est, aes(Age, b)) +
        geom_ribbon(aes(ymin = lwr, ymax = upr, fill = vet), alpha = .25) +
        geom_line(aes(colour = vet, linetype = vet), size = 0.6) + 
        labs(x = "", y = "") + coord_cartesian(xlim = c(15, 65), ylim = c(0,1)) +
        theme(legend.position="none") + theme(legend.title = element_blank()) +
        ggtitle("Estonia") + theme(panel.background = element_blank(), axis.line.x = element_line(color="#000000", size=0.3), 
              axis.line.y = element_line(color="#000000", size=0.3)) +
         theme(plot.title=element_text(size=8)) + theme(axis.text=element_text(size=6))

  #Finland
  fin <- single_men[ which(single_men$country=='Finland'),]

  a7 <-  ggplot(fin, aes(Age, b)) +
        geom_ribbon(aes(ymin = lwr, ymax = upr, fill = vet), alpha = .25) +
        geom_line(aes(colour = vet, linetype = vet), size = 0.6) + 
        labs(x = "", y = "") + coord_cartesian(xlim = c(15, 65), ylim = c(0,1)) +
        theme(legend.position="none") + theme(legend.title = element_blank()) +
        ggtitle("Finland") + theme(panel.background = element_blank(), axis.line.x = element_line(color="#000000", size=0.3), 
              axis.line.y = element_line(color="#000000", size=0.3)) +
         theme(plot.title=element_text(size=8)) + theme(axis.text=element_text(size=6))

  #France
  fra <- single_men[ which(single_men$country=='France'),]

  a8 <-  ggplot(fra, aes(Age, b)) +
        geom_ribbon(aes(ymin = lwr, ymax = upr, fill = vet), alpha = .25) +
        geom_line(aes(colour = vet, linetype = vet), size = 0.6) + 
        labs(x = "", y = "") + coord_cartesian(xlim = c(15, 65), ylim = c(0,1)) +
        theme(legend.position="none") + theme(legend.title = element_blank()) +
        ggtitle("France") + theme(panel.background = element_blank(), axis.line.x = element_line(color="#000000", size=0.3), 
              axis.line.y = element_line(color="#000000", size=0.3)) +
        theme(plot.title=element_text(size=8)) + theme(axis.text=element_text(size=6))

  #Germany
  ger <- single_men[ which(single_men$country=='Germany'),]

  a9 <-  ggplot(ger, aes(Age, b)) +
        geom_ribbon(aes(ymin = lwr, ymax = upr, fill = vet), alpha = .25) +
        geom_line(aes(colour = vet, linetype = vet), size = 0.6) + 
        labs(x = "", y = "") + coord_cartesian(xlim = c(15, 65), ylim = c(0,1)) +
        theme(legend.position="none") + theme(legend.title = element_blank()) +
        ggtitle("Germany") + theme(panel.background = element_blank(), axis.line.x = element_line(color="#000000", size=0.3), 
              axis.line.y = element_line(color="#000000", size=0.3)) +
         theme(plot.title=element_text(size=8)) + theme(axis.text=element_text(size=6))   

  #Ireland
  ire <- single_men[ which(single_men$country=='Ireland'),]

  a10 <-  ggplot(ire, aes(Age, b)) +
        geom_ribbon(aes(ymin = lwr, ymax = upr, fill = vet), alpha = .25) +
        geom_line(aes(colour = vet, linetype = vet), size = 0.6) + 
        labs(x = "", y = "") + coord_cartesian(xlim = c(15, 65), ylim = c(0,1)) +
        theme(legend.position="none") + theme(legend.title = element_blank()) +
        ggtitle("Ireland") + theme(panel.background = element_blank(), axis.line.x = element_line(color="#000000", size=0.3), 
              axis.line.y = element_line(color="#000000", size=0.3)) +
         theme(plot.title=element_text(size=8)) + theme(axis.text=element_text(size=6))   

  #Italy
  it <- single_men[ which(single_men$country=='Italy'),]

  a11 <-  ggplot(it, aes(Age, b)) +
        geom_ribbon(aes(ymin = lwr, ymax = upr, fill = vet), alpha = .25) +
        geom_line(aes(colour = vet, linetype = vet), size = 0.6) + 
        labs(x = "", y = "") + coord_cartesian(xlim = c(15, 65), ylim = c(0,1)) +
        theme(legend.position="none") + theme(legend.title = element_blank()) +
        ggtitle("Italy") + theme(panel.background = element_blank(), axis.line.x = element_line(color="#000000", size=0.3), 
              axis.line.y = element_line(color="#000000", size=0.3)) +
         theme(plot.title=element_text(size=8)) + theme(axis.text=element_text(size=6))   

  #Japan
  jap <- single_men[ which(single_men$country=='Japan'),]

  a12 <-  ggplot(jap, aes(Age, b)) +
        geom_ribbon(aes(ymin = lwr, ymax = upr, fill = vet), alpha = .25) +
        geom_line(aes(colour = vet, linetype = vet), size = 0.6) + 
        labs(x = "", y = "") + coord_cartesian(xlim = c(15, 65), ylim = c(0,1)) +
        theme(legend.position="none") + theme(legend.title = element_blank()) +
        ggtitle("Japan") + theme(panel.background = element_blank(), axis.line.x = element_line(color="#000000", size=0.3), 
              axis.line.y = element_line(color="#000000", size=0.3)) +
         theme(plot.title=element_text(size=8)) + theme(axis.text=element_text(size=6))   

  #Korea, Republic of
  kor <- single_men[ which(single_men$country=='Korea, Republic of'),]

  a13 <-  ggplot(kor, aes(Age, b)) +
        geom_ribbon(aes(ymin = lwr, ymax = upr, fill = vet), alpha = .25) +
        geom_line(aes(colour = vet, linetype = vet), size = 0.6) + 
        labs(x = "", y = "") + coord_cartesian(xlim = c(15, 65), ylim = c(0,1)) +
        theme(legend.position="none") + theme(legend.title = element_blank()) +
        ggtitle("Korea Rep.") + theme(panel.background = element_blank(), axis.line.x = element_line(color="#000000", size=0.3), 
              axis.line.y = element_line(color="#000000", size=0.3)) +
         theme(plot.title=element_text(size=8)) + theme(axis.text=element_text(size=6))   

  #Netherlands
  net <- single_men[ which(single_men$country=='Netherlands'),]

  a14 <-  ggplot(net, aes(Age, b)) +
        geom_ribbon(aes(ymin = lwr, ymax = upr, fill = vet), alpha = .25) +
        geom_line(aes(colour = vet, linetype = vet), size = 0.6) + 
        labs(x = "", y = "") + coord_cartesian(xlim = c(15, 65), ylim = c(0,1)) +
        theme(legend.position="none") + theme(legend.title = element_blank()) +
        ggtitle("Netherlands") + theme(panel.background = element_blank(), axis.line.x = element_line(color="#000000", size=0.3), 
              axis.line.y = element_line(color="#000000", size=0.3)) +
         theme(plot.title=element_text(size=8)) + theme(axis.text=element_text(size=6))   

  #Norway
  nor <- single_men[ which(single_men$country=='Norway'),]

  a15 <-  ggplot(nor, aes(Age, b)) +
        geom_ribbon(aes(ymin = lwr, ymax = upr, fill = vet), alpha = .25) +
        geom_line(aes(colour = vet, linetype = vet), size = 0.6) + 
        labs(x = "", y = "") + coord_cartesian(xlim = c(15, 65), ylim = c(0,1)) +
        theme(legend.position="none") + theme(legend.title = element_blank()) +
        ggtitle("Norway") + theme(panel.background = element_blank(), axis.line.x = element_line(color="#000000", size=0.3), 
              axis.line.y = element_line(color="#000000", size=0.3)) +
       theme(plot.title=element_text(size=8)) + theme(axis.text=element_text(size=6))   

  #Poland
  pol <- single_men[ which(single_men$country=='Poland'),]

  a16 <-  ggplot(pol, aes(Age, b)) +
        geom_ribbon(aes(ymin = lwr, ymax = upr, fill = vet), alpha = .25) +
        geom_line(aes(colour = vet, linetype = vet), size = 0.6) + 
        labs(x = "", y = "") + coord_cartesian(xlim = c(15, 65), ylim = c(0,1)) +
        theme(legend.position="none") + theme(legend.title = element_blank()) +
        ggtitle("Poland") + theme(panel.background = element_blank(), axis.line.x = element_line(color="#000000", size=0.3), 
              axis.line.y = element_line(color="#000000", size=0.3)) +
         theme(plot.title=element_text(size=8)) + theme(axis.text=element_text(size=6))   

  #Russian Federation
  rus <- single_men[ which(single_men$country=='Russian Federation'),]

  a17 <-  ggplot(rus, aes(Age, b)) +
        geom_ribbon(aes(ymin = lwr, ymax = upr, fill = vet), alpha = .25) +
        geom_line(aes(colour = vet, linetype = vet), size = 0.6) + 
        labs(x = "", y = "") + coord_cartesian(xlim = c(15, 65), ylim = c(0,1)) +
        theme(legend.position="none") + theme(legend.title = element_blank()) +
        ggtitle("Russia") + theme(panel.background = element_blank(), axis.line.x = element_line(color="#000000", size=0.3), 
              axis.line.y = element_line(color="#000000", size=0.3)) +
         theme(plot.title=element_text(size=8)) + theme(axis.text=element_text(size=6))   

  #Slovak Republic
  slo <- single_men[ which(single_men$country=='Slovak Republic'),]

  a18 <-  ggplot(slo, aes(Age, b)) +
        geom_ribbon(aes(ymin = lwr, ymax = upr, fill = vet), alpha = .25) +
        geom_line(aes(colour = vet, linetype = vet), size = 0.6) + 
        labs(x = "", y = "") + coord_cartesian(xlim = c(15, 65), ylim = c(0,1)) +
        theme(legend.position="none") + theme(legend.title = element_blank()) +
        ggtitle("Slovakia") + theme(panel.background = element_blank(), axis.line.x = element_line(color="#000000", size=0.3), 
              axis.line.y = element_line(color="#000000", size=0.3)) +
      theme(plot.title=element_text(size=8)) + theme(axis.text=element_text(size=6))   

  #Spain
  esp <- single_men[ which(single_men$country=='Spain'),]

  a19 <-  ggplot(esp, aes(Age, b)) +
        geom_ribbon(aes(ymin = lwr, ymax = upr, fill = vet), alpha = .25) +
        geom_line(aes(colour = vet, linetype = vet), size = 0.6) + 
        labs(x = "", y = "") + coord_cartesian(xlim = c(15, 65), ylim = c(0,1)) +
        theme(legend.position="none") + theme(legend.title = element_blank()) +
        ggtitle("Spain") + theme(panel.background = element_blank(), axis.line.x = element_line(color="#000000", size=0.3), 
              axis.line.y = element_line(color="#000000", size=0.3)) +
        theme(plot.title=element_text(size=8)) + theme(axis.text=element_text(size=6))   

  #Sweden
  swe <- single_men[ which(single_men$country=='Sweden'),]

  a20 <-  ggplot(swe, aes(Age, b)) +
        geom_ribbon(aes(ymin = lwr, ymax = upr, fill = vet), alpha = .25) +
        geom_line(aes(colour = vet, linetype = vet), size = 0.6) + 
        labs(x = "", y = "") + coord_cartesian(xlim = c(15, 65), ylim = c(0,1)) +
        theme(legend.position="none") + theme(legend.title = element_blank()) +
        ggtitle("Sweden") + theme(panel.background = element_blank(), axis.line.x = element_line(color="#000000", size=0.3), 
              axis.line.y = element_line(color="#000000", size=0.3)) +
        theme(plot.title=element_text(size=8)) + theme(axis.text=element_text(size=6))    

  #United Kingdom
  uk <- single_men[ which(single_men$country=='United Kingdom'),]

  a21 <-  ggplot(uk, aes(Age, b)) +
        geom_ribbon(aes(ymin = lwr, ymax = upr, fill = vet), alpha = .25) +
        geom_line(aes(colour = vet, linetype = vet), size = 0.6) + 
        labs(x = "", y = "") + coord_cartesian(xlim = c(15, 65), ylim = c(0,1)) +
        theme(legend.position="none") + theme(legend.title = element_blank()) +
        ggtitle("United Kingdom") + theme(panel.background = element_blank(), axis.line.x = element_line(color="#000000", size=0.3), 
              axis.line.y = element_line(color="#000000", size=0.3)) +
        theme(plot.title=element_text(size=8)) + theme(axis.text=element_text(size=6))

  #United States
  us <- single_men[ which(single_men$country=='United States'),]

  a22 <-  ggplot(us, aes(Age, b)) +
        geom_ribbon(aes(ymin = lwr, ymax = upr, fill = vet), alpha = .20) +
        geom_line(aes(colour = vet, linetype = vet), size = 0.6) + 
        labs(x = "", y = "") + coord_cartesian(xlim = c(15, 65), ylim = c(0,1)) +
        theme(legend.position="none") + theme(legend.title = element_blank()) + 
        ggtitle("United States") + theme(panel.background = element_blank(), axis.line.x = element_line(color="#000000", size=0.3), 
              axis.line.y = element_line(color="#000000", size=0.3)) +
        theme(plot.title=element_text(size=8)) + theme(axis.text=element_text(size=6))
  
  #create legend
  g_legend <- function(a.gplot){
    tmp <- ggplot_gtable(ggplot_build(a.gplot))
    leg <- which(sapply(tmp$grobs, function(x) x$name) == "guide-box")
    legend <- tmp$grobs[[leg]]
    return(legend)
    }

  mylegend<-g_legend(a1)

  #create blank plot
  blankPlot <- ggplot()+geom_blank(aes(1,1)) + cowplot::theme_nothing()


  pdf("04_graphs/Figure_5.pdf", width=14, height=9)


  #create figure
  fig5 <- grid.arrange(a1+ theme(legend.position="none"), a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12,
                        a13, a14, a15, a16, a17, a18, a19, a20, a21, a22, blankPlot, mylegend, nrow=4,
                        bottom=textGrob("Age"), left=textGrob("Predicted probability (pr=Employed", rot = 90, vjust = 1))
  print(fig5)
  dev.off()