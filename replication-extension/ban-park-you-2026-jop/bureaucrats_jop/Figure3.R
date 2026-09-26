library(ggplot2)
library(gridExtra)

load("script_data_for_replication.Rdata")


### Figure 3. Distribution of the analytical score in the training set
dist_train <- ggplot(script[script$train==1,], aes(x=mean)) + 
  geom_histogram() +
  labs(x= "Analytical Score", y = "Number of Paragraphs") +
  theme_bw()


### Distribution of the analytical score in the entire corpus (excluding the training set)  
# Note: This graph can be improved by adding "witness_id" and "type_cleaned" to the script data (now testi_measure has these at the witness-hearing level but not in the script data), and draw the distribution by bureaucrats vs. non-bureaucrat witnesses.
dist_all <- ggplot(script[script$train==0,], aes(x=ascore)) + 
  geom_histogram() +
  labs(x= "Analytical Score (Rescaled)", y = "Number of Testionies") +
  theme_bw()


### Combine the two
dist <- grid.arrange(dist_train, dist_all, ncol=2) # save as pdf with 4 by 8 inches, landscape

ggsave("dist.pdf", plot = dist, device = NULL, path = NULL,
       scale = 1, width = 25, height = 10, units = c("cm"), dpi = 500)
