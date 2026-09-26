### Fig A3. Cross validation of the final model on the test set
library(ggplot2)

load("labels_for_test_set.Rdata") # object name: plotdata

ebma_plot <- ggplot(plotdata, aes(label_test, EBMA_test)) +
  geom_point() +
  theme_bw() +
  theme(text = element_text(size=20)) +
  labs(x="Human-coded Analytical Score", y = "Predicted Analytical Score")
ebma_plot


ggsave("model_validation.pdf", plot = ebma_plot, device = NULL, path = NULL,
       scale = 1, width = 25, height = 22, units = c("cm"), dpi = 500)
