#----------------------------------------------------------#
#
#               Statistical Test Functions
#
#----------------------------------------------------------#

#' Perform Independent Samples t-test
#'
#' This function performs a two-sample t-test to compare means between
#' two groups.
#'
#' @param data A data frame containing the data
#' @param group_col The name of the column containing group labels
#' @param value_col The name of the column containing numeric values
#' @param var_equal Logical; if TRUE, assumes equal variances (default: FALSE)
#'
#' @return A list containing:
#'   - test_result: The htest object from t.test()
#'   - summary_stats: A data frame with descriptive statistics by group
#'
#' @examples
#' # Load sample data
#' data <- read.csv("Data/Input/sample_data.csv")
#' # Run t-test
#' result <- perform_t_test(data, "group", "value")
#'
perform_t_test <- function(data, group_col, value_col, var_equal = FALSE) {
  # Input validation
  if (!group_col %in% names(data)) {
    stop(paste("Column", group_col, "not found in data"))
  }
  
  if (!value_col %in% names(data)) {
    stop(paste("Column", value_col, "not found in data"))
  }
  
  if (!is.numeric(data[[value_col]])) {
    stop(paste("Column", value_col, "must be numeric"))
  }
  
  # Create formula for t.test
  formula_str <- paste(value_col, "~", group_col)
  formula_obj <- as.formula(formula_str)
  
  # Perform t-test
  test_result <- t.test(formula_obj, data = data, var.equal = var_equal)
  
  # Calculate summary statistics by group
  summary_stats <- data %>%
    group_by(!!sym(group_col)) %>%
    summarise(
      n = n(),
      mean = mean(!!sym(value_col), na.rm = TRUE),
      sd = sd(!!sym(value_col), na.rm = TRUE),
      se = sd / sqrt(n),
      .groups = "drop"
    )
  
  # Return results
  return(
    list(
      test_result = test_result,
      summary_stats = summary_stats
    )
  )
}
