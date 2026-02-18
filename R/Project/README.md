# Statistical Test Example

## Overview

This directory contains an example implementation of a statistical test, demonstrating best practices for reproducible data analysis in R.

## Files

- **01_statistical_test_example.R** - Main analysis script that:
  - Loads and validates data
  - Calculates descriptive statistics
  - Performs an independent samples t-test
  - Creates visualizations
  - Saves results in multiple formats

## Statistical Test

**Test Type:** Independent Samples t-test (Welch's t-test)

**Research Question:** Is there a significant difference in values between the control and treatment groups?

**Hypotheses:**
- Null Hypothesis (H₀): The mean values are equal between groups (μ_control = μ_treatment)
- Alternative Hypothesis (H₁): The mean values are different between groups (μ_control ≠ μ_treatment)

**Significance Level:** α = 0.05

## Data

The analysis uses sample data from `Data/Input/sample_data.csv` containing:
- **group**: categorical variable (control or treatment)
- **value**: numeric variable (the measured outcome)

Sample size: 10 observations per group (n = 20 total)

## How to Run

1. Ensure you have completed the setup in `R/___Init_project___.R`
2. Source the configuration file: `source("R/00_Confiq_file.R")`
3. Run the analysis script: `source("R/Project/01_statistical_test_example.R")`

Or run all at once:
```r
source("R/00_Confiq_file.R")
source("R/Project/01_statistical_test_example.R")
```

## Outputs

The script generates:

1. **Console Output:**
   - Data structure and validation
   - Descriptive statistics
   - Test results and interpretation

2. **Visualization:**
   - `Data/Processed/group_comparison.png` - Boxplot comparing groups

3. **Results Files:**
   - `Data/Processed/test_results.rds` - R data structure (for R users)
   - `Data/Processed/test_results.json` - JSON format (for interoperability)

## Reproducibility Features

This example demonstrates several reproducibility best practices:

1. **Clear Structure:** Organized code with numbered sections
2. **Documentation:** Comments explaining each step
3. **Modularity:** Statistical test function separated in `R/Functions/`
4. **Data Validation:** Checks for missing values and data structure
5. **Explicit Paths:** Uses `here::here()` for reliable file paths
6. **Version Control:** All code and data can be tracked with Git
7. **Multiple Output Formats:** Results saved in both R and JSON formats
8. **Visualization:** Clear plots with informative labels
9. **Statistical Reporting:** Complete reporting of test statistics

## Expected Results

Based on the sample data:
- Control group: mean ≈ 24.4 (SD ≈ 1.0)
- Treatment group: mean ≈ 29.1 (SD ≈ 0.9)

The t-test should show a statistically significant difference (p < 0.05) between the groups, with the treatment group having higher values than the control group.

## Function Documentation

See `R/Functions/statistical_tests.R` for the `perform_t_test()` function, which includes:
- Input validation
- Flexible parameters
- Summary statistics calculation
- Comprehensive documentation

## Learning Objectives

This example teaches:
- How to structure a reproducible statistical analysis
- Proper documentation and commenting
- Data validation and quality checks
- Statistical test selection and interpretation
- Creating reusable functions
- Saving and sharing results
- Version control integration
