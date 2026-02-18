#----------------------------------------------------------#
#
#
#               Reproducibility in Science
#
#                  Example Statistical Test
#
#
#                O. Mottl, Author name
#                         2024
#
#----------------------------------------------------------#
# This script demonstrates a reproducible statistical analysis
# using a t-test to compare two groups.
#
# Research Question:
# Is there a significant difference in values between the control
# and treatment groups?

#----------------------------------------------------------#
# 1. Setup and Configuration -----
#----------------------------------------------------------#

# Source the configuration file
source(here::here("R/00_Confiq_file.R"))

#----------------------------------------------------------#
# 2. Load Data -----
#----------------------------------------------------------#

# Read the sample data
data_raw <- read.csv(
  file = here::here("Data/Input/sample_data.csv"),
  stringsAsFactors = FALSE
)

# Display data structure
cat("Data structure:\n")
str(data_raw)

cat("\nFirst few rows:\n")
head(data_raw)

#----------------------------------------------------------#
# 3. Data Validation -----
#----------------------------------------------------------#

# Check for missing values
if (any(is.na(data_raw))) {
  cat("\nWarning: Missing values detected\n")
  cat("Number of missing values:", sum(is.na(data_raw)), "\n")
} else {
  cat("\nNo missing values detected\n")
}

# Check group levels
cat("\nGroup levels:", unique(data_raw$group), "\n")

#----------------------------------------------------------#
# 4. Descriptive Statistics -----
#----------------------------------------------------------#

# Calculate descriptive statistics
desc_stats <- data_raw %>%
  group_by(group) %>%
  summarise(
    n = n(),
    mean = mean(value, na.rm = TRUE),
    sd = sd(value, na.rm = TRUE),
    min = min(value, na.rm = TRUE),
    max = max(value, na.rm = TRUE),
    .groups = "drop"
  )

cat("\nDescriptive Statistics:\n")
print(desc_stats)

#----------------------------------------------------------#
# 5. Perform Statistical Test -----
#----------------------------------------------------------#

# Perform independent samples t-test
# Using the function from R/Functions/statistical_tests.R
result <- perform_t_test(
  data = data_raw,
  group_col = "group",
  value_col = "value",
  var_equal = FALSE  # Welch's t-test (does not assume equal variances)
)

# Display results
cat("\n" , rep("=", 60), "\n", sep = "")
cat("STATISTICAL TEST RESULTS\n")
cat(rep("=", 60), "\n\n", sep = "")

cat("Two-Sample t-test\n")
cat("Null Hypothesis: The mean values are equal between groups\n\n")

cat("Summary Statistics by Group:\n")
print(result$summary_stats)

cat("\nTest Results:\n")
print(result$test_result)

# Extract key values
t_statistic <- result$test_result$statistic
p_value <- result$test_result$p.value
conf_int <- result$test_result$conf.int
degrees_of_freedom <- result$test_result$parameter

# Interpretation
cat("\n" , rep("-", 60), "\n", sep = "")
cat("INTERPRETATION\n")
cat(rep("-", 60), "\n\n", sep = "")

cat("t-statistic:", round(t_statistic, 3), "\n")
cat("Degrees of freedom:", round(degrees_of_freedom, 2), "\n")
cat("p-value:", format.pval(p_value, digits = 3), "\n")
cat("95% Confidence Interval:", 
    round(conf_int[1], 2), "to", round(conf_int[2], 2), "\n\n")

# Decision based on alpha = 0.05
alpha <- 0.05
if (p_value < alpha) {
  cat("Conclusion: Reject the null hypothesis (p < 0.05)\n")
  cat("There IS a statistically significant difference between the groups.\n")
} else {
  cat("Conclusion: Fail to reject the null hypothesis (p >= 0.05)\n")
  cat("There is NO statistically significant difference between the groups.\n")
}

#----------------------------------------------------------#
# 6. Visualization -----
#----------------------------------------------------------#

# Create a comparison plot
plot_comparison <- ggplot(
  data = data_raw,
  aes(x = group, y = value, fill = group)
) +
  geom_boxplot(alpha = 0.7) +
  geom_jitter(width = 0.2, alpha = 0.5, size = 2) +
  labs(
    title = "Comparison of Values Between Groups",
    subtitle = paste("p-value =", format.pval(p_value, digits = 3)),
    x = "Group",
    y = "Value"
  ) +
  theme_classic() +
  theme(
    legend.position = "none",
    plot.title = element_text(face = "bold"),
    text = element_text(size = 12)
  ) +
  scale_fill_manual(values = c("control" = "#3498db", "treatment" = "#e74c3c"))

# Display plot
print(plot_comparison)

# Save plot
ggsave(
  filename = here::here("Data/Processed/group_comparison.png"),
  plot = plot_comparison,
  width = image_width,
  height = image_height,
  units = image_units,
  dpi = 300
)

cat("\nPlot saved to: Data/Processed/group_comparison.png\n")

#----------------------------------------------------------#
# 7. Save Results -----
#----------------------------------------------------------#

# Create results summary
results_summary <- list(
  analysis_date = Sys.Date(),
  test_type = "Two-sample t-test",
  hypothesis = "Mean values differ between control and treatment groups",
  alpha_level = alpha,
  sample_sizes = result$summary_stats$n,
  descriptive_stats = result$summary_stats,
  t_statistic = t_statistic,
  degrees_of_freedom = degrees_of_freedom,
  p_value = p_value,
  confidence_interval = conf_int,
  conclusion = ifelse(
    p_value < alpha,
    "Significant difference detected",
    "No significant difference detected"
  )
)

# Save as RDS (R data structure)
saveRDS(
  results_summary,
  file = here::here("Data/Processed/test_results.rds")
)

# Save as JSON for interoperability
jsonlite::write_json(
  results_summary,
  path = here::here("Data/Processed/test_results.json"),
  pretty = TRUE,
  auto_unbox = TRUE
)

cat("\nResults saved to:\n")
cat("  - Data/Processed/test_results.rds\n")
cat("  - Data/Processed/test_results.json\n")

cat("\n" , rep("=", 60), "\n", sep = "")
cat("Analysis Complete!\n")
cat(rep("=", 60), "\n", sep = "")
