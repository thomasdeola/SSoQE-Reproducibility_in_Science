# Quick Test Script for Statistical Analysis
# This is a simplified version for quick testing

# Test 1: Check if data file exists and is readable
cat("Test 1: Checking data file...\n")
data_path <- "Data/Input/sample_data.csv"
if (file.exists(data_path)) {
  cat("  ✓ Data file exists\n")
  
  # Read the data
  data <- read.csv(data_path, stringsAsFactors = FALSE)
  
  cat("  ✓ Data loaded successfully\n")
  cat("    Dimensions:", nrow(data), "rows,", ncol(data), "columns\n")
  cat("    Column names:", paste(names(data), collapse = ", "), "\n")
  
  # Check data structure
  if ("group" %in% names(data) && "value" %in% names(data)) {
    cat("  ✓ Expected columns found\n")
  } else {
    cat("  ✗ Missing expected columns\n")
  }
  
  # Check for missing values
  if (any(is.na(data))) {
    cat("  ! Warning: Missing values present\n")
  } else {
    cat("  ✓ No missing values\n")
  }
  
} else {
  cat("  ✗ Data file not found\n")
}

cat("\n")

# Test 2: Check if statistical_tests.R can be sourced
cat("Test 2: Checking statistical test function...\n")
func_path <- "R/Functions/statistical_tests.R"
if (file.exists(func_path)) {
  cat("  ✓ Function file exists\n")
  
  tryCatch({
    source(func_path)
    cat("  ✓ Function file sourced successfully\n")
    
    # Check if function exists
    if (exists("perform_t_test")) {
      cat("  ✓ perform_t_test function available\n")
    } else {
      cat("  ✗ perform_t_test function not found\n")
    }
  }, error = function(e) {
    cat("  ✗ Error sourcing function file:", conditionMessage(e), "\n")
  })
  
} else {
  cat("  ✗ Function file not found\n")
}

cat("\n")

# Test 3: If everything loaded, try running the t-test
cat("Test 3: Running statistical test...\n")
if (exists("data") && exists("perform_t_test")) {
  tryCatch({
    result <- perform_t_test(data, "group", "value", var_equal = FALSE)
    
    cat("  ✓ Statistical test completed successfully\n")
    cat("\n")
    cat("  Summary Statistics:\n")
    print(result$summary_stats)
    cat("\n")
    cat("  Test Results:\n")
    cat("    t-statistic:", round(result$test_result$statistic, 3), "\n")
    cat("    p-value:", format.pval(result$test_result$p.value, digits = 3), "\n")
    cat("    Conclusion:", 
        ifelse(result$test_result$p.value < 0.05, 
               "Significant difference (p < 0.05)", 
               "No significant difference (p >= 0.05)"), "\n")
    
  }, error = function(e) {
    cat("  ✗ Error running test:", conditionMessage(e), "\n")
  })
} else {
  cat("  ⊗ Skipping (prerequisites not met)\n")
}

cat("\n")
cat("All tests completed!\n")
