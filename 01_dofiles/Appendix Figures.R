
# load libraries

# Customize this path to the folder on your computer where the replication files are located

#setwd("C:/Users/.../.../replication files")
#setwd("D:/Dropbox/andrea/research/03_papers/2015_vocational_decline_paper/05_replication files/replication files")
setwd("C:/Users/Thijs/Dropbox/piaac_vocational_lifecourse/05_replication files/replication files")


library("foreign")
library("Hmisc")
library("plm")
library("lme4")
library("plyr")
library("ggplot2")
library("ggthemes")
library("gridExtra")
library("RColorBrewer")
library("cowplot")


app_a1_men          <- read.dta("03_posted/app1_data_m.dta")
app_a1_women        <- read.dta("03_posted/app1_data_f.dta")
app_a2_zvoc_men     <- read.dta("03_posted/app2_data_zvoc_m.dta")
app_a2_zvoc_women   <- read.dta("03_posted/app2_data_zvoc_f.dta")
app_a2_dual_men     <- read.dta("03_posted/app2_data_zdual_m.dta")
app_a2_dual_women   <- read.dta("03_posted/app2_data_zdual_f.dta")
app_b1_women        <- read.dta("03_posted/app3_data.dta")

#-------------------------------------------------------------------------------------------
# APPENDIX: Figure A1: Predicted Probabilities of Employment by Type of Education 
# (Vocational/General) with Additional Interaction between Age squared and VET
#-------------------------------------------------------------------------------------------

summary(app_a1_men)
summary(app_a1_women)

#men
pdf("04_graphs/Appendix_A1a.pdf", width=8, height=6.4)
app_a1_men$upr <- app_a1_men$b + (1.96 * app_a1_men$se)
app_a1_men$lwr <- app_a1_men$b - (1.96 * app_a1_men$se)

panel_a <-  ggplot(app_a1_men, aes(Age, b)) +
        geom_ribbon(aes(ymin = lwr, ymax = upr, fill = vet), alpha = .25) +
        geom_line(aes(colour = vet, linetype = vet), size = 1) + 
        labs(x = "", y = "Predicted probability (pr=Employed)") + coord_cartesian(xlim = c(15, 65), ylim = c(0,1)) +
        theme(legend.position="bottom") + theme(legend.title = element_blank()) + ggtitle("Men") +
        theme(panel.background = element_blank(), axis.line = element_line(colour = "black"))
panel_a
print(panel_a)
dev.off()


#women
pdf("04_graphs/Appendix_A1b.pdf", width=8, height=6.4)
app_a1_women$upr <- app_a1_women$b + (1.96 * app_a1_women$se)
app_a1_women$lwr <- app_a1_women$b - (1.96 * app_a1_women$se)

panel_b <-  ggplot(app_a1_women, aes(Age, b)) +
        geom_ribbon(aes(ymin = lwr, ymax = upr, fill = vet), alpha = .25) +
        geom_line(aes(colour = vet, linetype = vet), size = 1) +
        labs(x = "Age", y = "Predicted probability (pr=Employed)") + coord_cartesian(xlim = c(15, 65), ylim = c(0,1)) +
        theme(legend.position="bottom") + theme(legend.title = element_blank()) +ggtitle("Women") +
        theme(panel.background = element_blank(), axis.line = element_line(colour = "black"))
panel_b
print(panel_b)
dev.off()


#-------------------------------------------------------------------------------------------
# APPENDIX: Figure A2: Average Marginal Eects of VET on Employment for Countries with Low and
# High Vocational Enrollment (Including Interactions with Age Squared)
#-------------------------------------------------------------------------------------------

summary(app_a2_zvoc_men)
summary(app_a2_zvoc_women)

#men
pdf("04_graphs/Appendix_A2a.pdf", width=8, height=6.4)
app_a2_zvoc_men$upr <- app_a2_zvoc_men$b + (1.96 * app_a2_zvoc_men$se)
app_a2_zvoc_men$lwr <- app_a2_zvoc_men$b - (1.96 * app_a2_zvoc_men$se)

panel_a <- 	ggplot(app_a2_zvoc_men, aes(Age, b)) +
  			geom_ribbon(aes(ymin = lwr, ymax = upr, fill = vet), alpha = .25) +
  			geom_line(aes(colour = vet, linetype = vet), size = 1) +
  			labs(x = "", y = "Average Marginal Effect of VET") + geom_hline(yintercept=0, color="#A0A0A0", size=0.5) + coord_cartesian(xlim = c(15, 65)) +
  			theme(legend.position="bottom") + theme(legend.title = element_blank()) +
  			theme(panel.background = element_blank(), axis.line = element_line(colour = "black"))
panel_a
print(panel_a)
dev.off()

#women
pdf("04_graphs/Appendix_A2b.pdf", width=8, height=6.4)
app_a2_zvoc_women$upr <- app_a2_zvoc_women$b + (1.96 * app_a2_zvoc_women$se)
app_a2_zvoc_women$lwr <- app_a2_zvoc_women$b - (1.96 * app_a2_zvoc_women$se)

panel_b <- 	ggplot(app_a2_zvoc_women, aes(Age, b)) +
  			geom_ribbon(aes(ymin = lwr, ymax = upr, fill = vet), alpha = .25) +
  			geom_line(aes(colour = vet, linetype = vet), size = 1) +
  			labs(x = "Age", y = "Average Marginal Effect of VET") + geom_hline(yintercept=0, color="#A0A0A0", size=0.5) + coord_cartesian(xlim = c(15, 65)) +
  			theme(legend.position="bottom") + theme(legend.title = element_blank()) +
  			theme(panel.background = element_blank(), axis.line = element_line(colour = "black"))
panel_b
print(panel_b)
dev.off()


#-------------------------------------------------------------------------------------------
# APPENDIX: Figure A3: Average Marginal Effects of VET on Employment for Countries with Low and
# Dual System Enrollment (Including Interactions with Age Squared)
#-------------------------------------------------------------------------------------------

#men
pdf("04_graphs/Appendix_A3a.pdf", width=8, height=6.4)
app_a2_dual_men$upr <- app_a2_dual_men$b + (1.96 * app_a2_dual_men$se)
app_a2_dual_men$lwr <- app_a2_dual_men$b - (1.96 * app_a2_dual_men$se)

panel_a <- 	ggplot(app_a2_dual_men, aes(Age, b)) +
  			geom_ribbon(aes(ymin = lwr, ymax = upr, fill = vet), alpha = .25) +
  			geom_line(aes(colour = vet, linetype = vet), size = 1) +
  			labs(x = "", y = "Average Marginal Effect of VET") + geom_hline(yintercept=0, color="#A0A0A0", size=0.5) + coord_cartesian(xlim = c(15, 65)) +
  			theme(legend.position="bottom") + theme(legend.title = element_blank()) +
  			theme(panel.background = element_blank(), axis.line = element_line(colour = "black"))
panel_a
print(panel_a)
dev.off()

#women
pdf("04_graphs/Appendix_A3b.pdf", width=8, height=6.4)
app_a2_dual_women$upr <- app_a2_dual_women$b + (1.96 * app_a2_dual_women$se)
app_a2_dual_women$lwr <- app_a2_dual_women$b - (1.96 * app_a2_dual_women$se)

panel_b <- 	ggplot(app_a2_dual_women, aes(Age, b)) +
  			geom_ribbon(aes(ymin = lwr, ymax = upr, fill = vet), alpha = .25) +
  			geom_line(aes(colour = vet, linetype = vet), size = 1) +
  			labs(x = "Age", y = "Average Marginal Effect of VET") + geom_hline(yintercept=0, color="#A0A0A0", size=0.5) + coord_cartesian(xlim = c(15, 65)) +
  			theme(legend.position="bottom") + theme(legend.title = element_blank()) +
  			theme(panel.background = element_blank(), axis.line = element_line(colour = "black"))
panel_b
print(panel_b)
dev.off()

#-------------------------------------------------------------------------------------------
# APPENDIX: Figure B1: Predicted Probabilities of Employment per Country (Women)
#-------------------------------------------------------------------------------------------

summary(app_b1_women)
describe(app_b1_women)

app_b1_women$upr <- app_b1_women$b + (1.96 * app_b1_women$se)
app_b1_women$lwr <- app_b1_women$b - (1.96 * app_b1_women$se)

  #Austria
  austria <- app_b1_women[ which(app_b1_women$country=='Austria'),]

  a1 <-  ggplot(austria, aes(Age, b)) +
        geom_ribbon(aes(ymin = lwr, ymax = upr, fill = vet), alpha = .25) +
        geom_line(aes(colour = vet, linetype = vet), size = 0.6) + 
        labs(x = "", y = "") + coord_cartesian(xlim = c(15, 65), ylim = c(0,1)) +
        theme(legend.position="bottom") + theme(legend.title = element_blank()) +
        ggtitle("Austria") + theme(panel.background = element_blank(), axis.line = element_line(colour = "black")) +
        theme(plot.title=element_text(size=8)) + theme(axis.text=element_text(size=6))

  #Belgium
  belgium <- app_b1_women[ which(app_b1_women$country=='Belgium'),]

  a2 <-  ggplot(belgium, aes(Age, b)) +
        geom_ribbon(aes(ymin = lwr, ymax = upr, fill = vet), alpha = .25) +
        geom_line(aes(colour = vet, linetype = vet), size = 0.6) + 
        labs(x = "", y = "") + coord_cartesian(xlim = c(15, 65), ylim = c(0,1)) +
        theme(legend.position="none") + theme(legend.title = element_blank()) +
        ggtitle("Belgium") + theme(panel.background = element_blank(), axis.line = element_line(colour = "black")) +
        theme(plot.title=element_text(size=8)) + theme(axis.text=element_text(size=6))

  #Canada
  can <- app_b1_women[ which(app_b1_women$country=='Canada'),]

  a3 <-  ggplot(can, aes(Age, b)) +
        geom_ribbon(aes(ymin = lwr, ymax = upr, fill = vet), alpha = .25) +
        geom_line(aes(colour = vet, linetype = vet), size = 0.6) + 
        labs(x = "", y = "") + coord_cartesian(xlim = c(15, 65), ylim = c(0,1)) +
        theme(legend.position="none") + theme(legend.title = element_blank()) +
        ggtitle("Canada") + theme(panel.background = element_blank(), axis.line = element_line(colour = "black")) +
        theme(plot.title=element_text(size=8)) + theme(axis.text=element_text(size=6))

  #Czech Republic
  cze <- app_b1_women[ which(app_b1_women$country=='Czech Republic'),]

  a4 <-  ggplot(cze, aes(Age, b)) +
        geom_ribbon(aes(ymin = lwr, ymax = upr, fill = vet), alpha = .25) +
        geom_line(aes(colour = vet, linetype = vet), size = 0.6) + 
        labs(x = "", y = "") + coord_cartesian(xlim = c(15, 65), ylim = c(0,1)) +
        theme(legend.position="none") + theme(legend.title = element_blank()) +
        ggtitle("Czech Rep.") + theme(panel.background = element_blank(), axis.line = element_line(colour = "black")) +
        theme(plot.title=element_text(size=8)) + theme(axis.text=element_text(size=6))

  #Denmark
  den <- app_b1_women[ which(app_b1_women$country=='Denmark'),]

  a5 <-  ggplot(den, aes(Age, b)) +
        geom_ribbon(aes(ymin = lwr, ymax = upr, fill = vet), alpha = .25) +
        geom_line(aes(colour = vet, linetype = vet), size = 0.6) + 
        labs(x = "", y = "") + coord_cartesian(xlim = c(15, 65), ylim = c(0,1)) +
        theme(legend.position="none") + theme(legend.title = element_blank()) +
        ggtitle("Denmark") + theme(panel.background = element_blank(), axis.line = element_line(colour = "black")) +
       theme(plot.title=element_text(size=8)) + theme(axis.text=element_text(size=6))

  #Estonia
  est <- app_b1_women[ which(app_b1_women$country=='Estonia'),]

  a6 <-  ggplot(est, aes(Age, b)) +
        geom_ribbon(aes(ymin = lwr, ymax = upr, fill = vet), alpha = .25) +
        geom_line(aes(colour = vet, linetype = vet), size = 0.6) + 
        labs(x = "", y = "") + coord_cartesian(xlim = c(15, 65), ylim = c(0,1)) +
        theme(legend.position="none") + theme(legend.title = element_blank()) +
        ggtitle("Estonia") + theme(panel.background = element_blank(), axis.line = element_line(colour = "black")) +
         theme(plot.title=element_text(size=8)) + theme(axis.text=element_text(size=6))

  #Finland
  fin <- app_b1_women[ which(app_b1_women$country=='Finland'),]

  a7 <-  ggplot(fin, aes(Age, b)) +
        geom_ribbon(aes(ymin = lwr, ymax = upr, fill = vet), alpha = .25) +
        geom_line(aes(colour = vet, linetype = vet), size = 0.6) + 
        labs(x = "", y = "") + coord_cartesian(xlim = c(15, 65), ylim = c(0,1)) +
        theme(legend.position="none") + theme(legend.title = element_blank()) +
        ggtitle("Finland") + theme(panel.background = element_blank(), axis.line = element_line(colour = "black")) +
         theme(plot.title=element_text(size=8)) + theme(axis.text=element_text(size=6))

  #France
  fra <- app_b1_women[ which(app_b1_women$country=='France'),]

  a8 <-  ggplot(fra, aes(Age, b)) +
        geom_ribbon(aes(ymin = lwr, ymax = upr, fill = vet), alpha = .25) +
        geom_line(aes(colour = vet, linetype = vet), size = 0.6) + 
        labs(x = "", y = "") + coord_cartesian(xlim = c(15, 65), ylim = c(0,1)) +
        theme(legend.position="none") + theme(legend.title = element_blank()) +
        ggtitle("France") + theme(panel.background = element_blank(), axis.line = element_line(colour = "black")) +
        theme(plot.title=element_text(size=8)) + theme(axis.text=element_text(size=6))

  #Germany
  ger <- app_b1_women[ which(app_b1_women$country=='Germany'),]

  a9 <-  ggplot(ger, aes(Age, b)) +
        geom_ribbon(aes(ymin = lwr, ymax = upr, fill = vet), alpha = .25) +
        geom_line(aes(colour = vet, linetype = vet), size = 0.6) + 
        labs(x = "", y = "") + coord_cartesian(xlim = c(15, 65), ylim = c(0,1)) +
        theme(legend.position="none") + theme(legend.title = element_blank()) +
        ggtitle("Germany") + theme(panel.background = element_blank(), axis.line = element_line(colour = "black")) +
         theme(plot.title=element_text(size=8)) + theme(axis.text=element_text(size=6))   

  #Ireland
  ire <- app_b1_women[ which(app_b1_women$country=='Ireland'),]

  a10 <-  ggplot(ire, aes(Age, b)) +
        geom_ribbon(aes(ymin = lwr, ymax = upr, fill = vet), alpha = .25) +
        geom_line(aes(colour = vet, linetype = vet), size = 0.6) + 
        labs(x = "", y = "") + coord_cartesian(xlim = c(15, 65), ylim = c(0,1)) +
        theme(legend.position="none") + theme(legend.title = element_blank()) +
        ggtitle("Ireland") + theme(panel.background = element_blank(), axis.line = element_line(colour = "black")) +
         theme(plot.title=element_text(size=8)) + theme(axis.text=element_text(size=6))   

  #Italy
  it <- app_b1_women[ which(app_b1_women$country=='Italy'),]

  a11 <-  ggplot(it, aes(Age, b)) +
        geom_ribbon(aes(ymin = lwr, ymax = upr, fill = vet), alpha = .25) +
        geom_line(aes(colour = vet, linetype = vet), size = 0.6) + 
        labs(x = "", y = "") + coord_cartesian(xlim = c(15, 65), ylim = c(0,1)) +
        theme(legend.position="none") + theme(legend.title = element_blank()) +
        ggtitle("Italy") + theme(panel.background = element_blank(), axis.line = element_line(colour = "black")) +
         theme(plot.title=element_text(size=8)) + theme(axis.text=element_text(size=6))   

  #Japan
  jap <- app_b1_women[ which(app_b1_women$country=='Japan'),]

  a12 <-  ggplot(jap, aes(Age, b)) +
        geom_ribbon(aes(ymin = lwr, ymax = upr, fill = vet), alpha = .25) +
        geom_line(aes(colour = vet, linetype = vet), size = 0.6) + 
        labs(x = "", y = "") + coord_cartesian(xlim = c(15, 65), ylim = c(0,1)) +
        theme(legend.position="none") + theme(legend.title = element_blank()) +
        ggtitle("Japan") + theme(panel.background = element_blank(), axis.line = element_line(colour = "black")) +
         theme(plot.title=element_text(size=8)) + theme(axis.text=element_text(size=6))   

  #Korea, Republic of
  kor <- app_b1_women[ which(app_b1_women$country=='Korea, Republic of'),]

  a13 <-  ggplot(kor, aes(Age, b)) +
        geom_ribbon(aes(ymin = lwr, ymax = upr, fill = vet), alpha = .25) +
        geom_line(aes(colour = vet, linetype = vet), size = 0.6) + 
        labs(x = "", y = "") + coord_cartesian(xlim = c(15, 65), ylim = c(0,1)) +
        theme(legend.position="none") + theme(legend.title = element_blank()) +
        ggtitle("Korea Rep.") + theme(panel.background = element_blank(), axis.line = element_line(colour = "black")) +
         theme(plot.title=element_text(size=8)) + theme(axis.text=element_text(size=6))   

  #Netherlands
  net <- app_b1_women[ which(app_b1_women$country=='Netherlands'),]

  a14 <-  ggplot(net, aes(Age, b)) +
        geom_ribbon(aes(ymin = lwr, ymax = upr, fill = vet), alpha = .25) +
        geom_line(aes(colour = vet, linetype = vet), size = 0.6) + 
        labs(x = "", y = "") + coord_cartesian(xlim = c(15, 65), ylim = c(0,1)) +
        theme(legend.position="none") + theme(legend.title = element_blank()) +
        ggtitle("Netherlands") + theme(panel.background = element_blank(), axis.line = element_line(colour = "black")) +
         theme(plot.title=element_text(size=8)) + theme(axis.text=element_text(size=6))   

  #Norway
  nor <- app_b1_women[ which(app_b1_women$country=='Norway'),]

  a15 <-  ggplot(nor, aes(Age, b)) +
        geom_ribbon(aes(ymin = lwr, ymax = upr, fill = vet), alpha = .25) +
        geom_line(aes(colour = vet, linetype = vet), size = 0.6) + 
        labs(x = "", y = "") + coord_cartesian(xlim = c(15, 65), ylim = c(0,1)) +
        theme(legend.position="none") + theme(legend.title = element_blank()) +
        ggtitle("Norway") + theme(panel.background = element_blank(), axis.line = element_line(colour = "black")) +
       theme(plot.title=element_text(size=8)) + theme(axis.text=element_text(size=6))   

  #Poland
  pol <- app_b1_women[ which(app_b1_women$country=='Poland'),]

  a16 <-  ggplot(pol, aes(Age, b)) +
        geom_ribbon(aes(ymin = lwr, ymax = upr, fill = vet), alpha = .25) +
        geom_line(aes(colour = vet, linetype = vet), size = 0.6) + 
        labs(x = "", y = "") + coord_cartesian(xlim = c(15, 65), ylim = c(0,1)) +
        theme(legend.position="none") + theme(legend.title = element_blank()) +
        ggtitle("Poland") + theme(panel.background = element_blank(), axis.line = element_line(colour = "black")) +
         theme(plot.title=element_text(size=8)) + theme(axis.text=element_text(size=6))   

  #Russian Federation
  rus <- app_b1_women[ which(app_b1_women$country=='Russian Federation'),]

  a17 <-  ggplot(rus, aes(Age, b)) +
        geom_ribbon(aes(ymin = lwr, ymax = upr, fill = vet), alpha = .25) +
        geom_line(aes(colour = vet, linetype = vet), size = 0.6) + 
        labs(x = "", y = "") + coord_cartesian(xlim = c(15, 65), ylim = c(0,1)) +
        theme(legend.position="none") + theme(legend.title = element_blank()) +
        ggtitle("Russia") + theme(panel.background = element_blank(), axis.line = element_line(colour = "black")) +
         theme(plot.title=element_text(size=8)) + theme(axis.text=element_text(size=6))   

  #Slovak Republic
  slo <- app_b1_women[ which(app_b1_women$country=='Slovak Republic'),]

  a18 <-  ggplot(slo, aes(Age, b)) +
        geom_ribbon(aes(ymin = lwr, ymax = upr, fill = vet), alpha = .25) +
        geom_line(aes(colour = vet, linetype = vet), size = 0.6) + 
        labs(x = "", y = "") + coord_cartesian(xlim = c(15, 65), ylim = c(0,1)) +
        theme(legend.position="none") + theme(legend.title = element_blank()) +
        ggtitle("Slovakia") + theme(panel.background = element_blank(), axis.line = element_line(colour = "black")) +
      theme(plot.title=element_text(size=8)) + theme(axis.text=element_text(size=6))   

  #Spain
  esp <- app_b1_women[ which(app_b1_women$country=='Spain'),]

  a19 <-  ggplot(esp, aes(Age, b)) +
        geom_ribbon(aes(ymin = lwr, ymax = upr, fill = vet), alpha = .25) +
        geom_line(aes(colour = vet, linetype = vet), size = 0.6) + 
        labs(x = "", y = "") + coord_cartesian(xlim = c(15, 65), ylim = c(0,1)) +
        theme(legend.position="none") + theme(legend.title = element_blank()) +
        ggtitle("Spain") + theme(panel.background = element_blank(), axis.line = element_line(colour = "black")) +
        theme(plot.title=element_text(size=8)) + theme(axis.text=element_text(size=6))   

  #Sweden
  swe <- app_b1_women[ which(app_b1_women$country=='Sweden'),]

  a20 <-  ggplot(swe, aes(Age, b)) +
        geom_ribbon(aes(ymin = lwr, ymax = upr, fill = vet), alpha = .25) +
        geom_line(aes(colour = vet, linetype = vet), size = 0.6) + 
        labs(x = "", y = "") + coord_cartesian(xlim = c(15, 65), ylim = c(0,1)) +
        theme(legend.position="none") + theme(legend.title = element_blank()) +
        ggtitle("Sweden") + theme(panel.background = element_blank(), axis.line = element_line(colour = "black")) +
        theme(plot.title=element_text(size=8)) + theme(axis.text=element_text(size=6))    

  #United Kingdom
  uk <- app_b1_women[ which(app_b1_women$country=='United Kingdom'),]

  a21 <-  ggplot(uk, aes(Age, b)) +
        geom_ribbon(aes(ymin = lwr, ymax = upr, fill = vet), alpha = .25) +
        geom_line(aes(colour = vet, linetype = vet), size = 0.6) + 
        labs(x = "", y = "") + coord_cartesian(xlim = c(15, 65), ylim = c(0,1)) +
        theme(legend.position="none") + theme(legend.title = element_blank()) +
        ggtitle("United Kingdom") + theme(panel.background = element_blank(), axis.line = element_line(colour = "black")) +
        theme(plot.title=element_text(size=8)) + theme(axis.text=element_text(size=6))

  #United States
  us <- app_b1_women[ which(app_b1_women$country=='United States'),]

  a22 <-  ggplot(us, aes(Age, b)) +
        geom_ribbon(aes(ymin = lwr, ymax = upr, fill = vet), alpha = .20) +
        geom_line(aes(colour = vet, linetype = vet), size = 0.6) + 
        labs(x = "", y = "") + coord_cartesian(xlim = c(15, 65), ylim = c(0,1)) +
        theme(legend.position="none") + theme(legend.title = element_blank()) + 
        ggtitle("United States") + theme(panel.background = element_blank(), axis.line = element_line(colour = "black")) +
        theme(plot.title=element_text(size=8)) + theme(axis.text=element_text(size=6))
  
  #create legend
  g_legend<-function(a.gplot){
  tmp <- ggplot_gtable(ggplot_build(a.gplot))
  leg <- which(sapply(tmp$grobs, function(x) x$name) == "guide-box")
  legend <- tmp$grobs[[leg]]
  return(legend)}

  mylegend<-g_legend(a1)

  #create blank plot
  blankPlot <- ggplot()+geom_blank(aes(1,1)) + cowplot::theme_nothing()


  pdf("04_graphs/Appendix_B1.pdf", width=14, height=9)


  #create figure
  app_b1 <- grid.arrange(a1+ theme(legend.position="none"), a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12,
                        a13, a14, a15, a16, a17, a18, a19, a20, a21, a22, blankPlot, mylegend, nrow=4,
                        bottom=textGrob("Age"), left=textGrob("Predicted probability (pr=Employed", rot = 90, vjust = 1))
  app_b1
  print(app_b1)
  dev.off()