library(ggplot2)
library(haven)

dyad_b <- read_dta("dyad_b.dta")


### Figure A4
order_plot_h <- ggplot(dyad_b[dyad_b$dyad_order_h <= 50,], aes(x=dyad_order_h, y=ascore))+ 
  stat_summary(geom="ribbon", fun.data=mean_cl_normal, width=0.1, conf.int=0.95, fill="lightblue")+
  stat_summary(geom="line", fun.y=mean, linetype="dashed")+
  stat_summary(geom="point", fun.y=mean, color="red")+
  theme_bw() +
  xlab("Order of Member-Witness Interaction in a Hearing") + ylab("Analytical Score")
order_plot_h

ggsave("figure_a4.pdf", plot = order_plot_h, device = NULL, path = NULL,
       scale = 1, width = 20, height = 10, units = c("cm"), dpi = 500)


### Figure A5
order_plot_hw <- ggplot(dyad_b[dyad_b$dyad_order_hw <= 20,], aes(x=dyad_order_hw, y=ascore))+ 
  stat_summary(geom="ribbon", fun.data=mean_cl_normal, width=0.1, conf.int=0.95, fill="lightblue")+
  stat_summary(geom="line", fun.y=mean, linetype="dashed")+
  stat_summary(geom="point", fun.y=mean, color="red")+
  theme_bw() +
  xlab("Order of Member-Witness Interaction for a Witness") + ylab("Analytical Score")
order_plot_hw

ggsave("figure_a5.pdf", plot = order_plot_hw, device = NULL, path = NULL,
       scale = 1, width = 20, height = 10, units = c("cm"), dpi = 500)
