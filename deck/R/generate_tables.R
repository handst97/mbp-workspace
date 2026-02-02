#!/usr/bin/env Rscript
# generate_tables.R
# Generates all tables for the Data Science Introduction deck
# Outputs: TeX files for direct inclusion in Beamer

# Load required packages
required_packages <- c("xtable", "knitr", "kableExtra")

for (pkg in required_packages) {
  if (!require(pkg, character.only = TRUE, quietly = TRUE)) {
    install.packages(pkg, repos = "https://cloud.r-project.org/")
    library(pkg, character.only = TRUE)
  }
}

# Set output directory
output_dir <- "../tables"
if (!dir.exists(output_dir)) dir.create(output_dir, recursive = TRUE)

# =============================================================================
# Table 1: Data Types Overview
# =============================================================================
cat("Generating Table 1: Data types...\n")

data_types <- data.frame(
  Type = c("Structured", "Semi-structured", "Unstructured"),
  Description = c("Organized in tables/rows", "Tagged or marked up", "No predefined format"),
  Examples = c("SQL databases, CSV", "JSON, XML, HTML", "Text, images, video"),
  Percentage = c("20\\%", "10\\%", "70\\%")
)

# Generate LaTeX table
sink(file.path(output_dir, "table_data_types.tex"))
cat("\\begin{tabular}{@{}llll@{}}\n")
cat("\\toprule\n")
cat("\\textbf{Type} & \\textbf{Description} & \\textbf{Examples} & \\textbf{Share} \\\\\n")
cat("\\midrule\n")
for (i in 1:nrow(data_types)) {
  cat(paste(data_types$Type[i], "&",
            data_types$Description[i], "&",
            data_types$Examples[i], "&",
            data_types$Percentage[i], "\\\\\n"))
}
cat("\\bottomrule\n")
cat("\\end{tabular}\n")
sink()

# =============================================================================
# Table 2: Machine Learning Algorithms Comparison
# =============================================================================
cat("Generating Table 2: ML algorithms comparison...\n")

ml_algorithms <- data.frame(
  Algorithm = c("Linear Reg.", "Logistic Reg.", "Decision Trees", "Random Forest", "Neural Nets"),
  Task = c("Regression", "Classification", "Both", "Both", "Both"),
  Interpretable = c("High", "High", "Medium", "Low", "Low"),
  Scalability = c("Excellent", "Excellent", "Good", "Good", "Varies")
)

sink(file.path(output_dir, "table_ml_algorithms.tex"))
cat("\\begin{tabular}{@{}llcc@{}}\n")
cat("\\toprule\n")
cat("\\textbf{Algorithm} & \\textbf{Task} & \\textbf{Interpret.} & \\textbf{Scale} \\\\\n")
cat("\\midrule\n")
for (i in 1:nrow(ml_algorithms)) {
  cat(paste(ml_algorithms$Algorithm[i], "&",
            ml_algorithms$Task[i], "&",
            ml_algorithms$Interpretable[i], "&",
            ml_algorithms$Scalability[i], "\\\\\n"))
}
cat("\\bottomrule\n")
cat("\\end{tabular}\n")
sink()

# =============================================================================
# Table 3: Programming Languages for Data Science
# =============================================================================
cat("Generating Table 3: Programming languages...\n")

languages <- data.frame(
  Language = c("Python", "R", "SQL", "Julia"),
  Strengths = c("General purpose, ML", "Statistics, visualization", "Data querying", "High performance"),
  Adoption = c("1st", "2nd", "3rd", "Growing")
)

sink(file.path(output_dir, "table_languages.tex"))
cat("\\begin{tabular}{@{}lll@{}}\n")
cat("\\toprule\n")
cat("\\textbf{Language} & \\textbf{Key Strengths} & \\textbf{Rank} \\\\\n")
cat("\\midrule\n")
for (i in 1:nrow(languages)) {
  cat(paste(languages$Language[i], "&",
            languages$Strengths[i], "&",
            languages$Adoption[i], "\\\\\n"))
}
cat("\\bottomrule\n")
cat("\\end{tabular}\n")
sink()

# =============================================================================
# Table 4: Key Metrics by Domain
# =============================================================================
cat("Generating Table 4: Domain metrics...\n")

domains <- data.frame(
  Domain = c("Healthcare", "Finance", "Marketing", "Manufacturing"),
  Metric = c("Patient outcomes", "ROI, Risk", "Conversion rate", "Defect rate"),
  Challenge = c("Privacy (HIPAA)", "Regulation", "Attribution", "Real-time data")
)

sink(file.path(output_dir, "table_domains.tex"))
cat("\\begin{tabular}{@{}lll@{}}\n")
cat("\\toprule\n")
cat("\\textbf{Domain} & \\textbf{Key Metric} & \\textbf{Challenge} \\\\\n")
cat("\\midrule\n")
for (i in 1:nrow(domains)) {
  cat(paste(domains$Domain[i], "&",
            domains$Metric[i], "&",
            domains$Challenge[i], "\\\\\n"))
}
cat("\\bottomrule\n")
cat("\\end{tabular}\n")
sink()

# =============================================================================
# Table 5: Course Roadmap
# =============================================================================
cat("Generating Table 5: Course roadmap...\n")

roadmap <- data.frame(
  Week = c("1--3", "4--6", "7--9", "10--12", "13--15"),
  Topic = c("Foundations", "Data Wrangling", "Machine Learning", "Deep Learning", "Capstone"),
  Skills = c("Python, Stats basics", "pandas, cleaning", "scikit-learn", "PyTorch basics", "Full pipeline")
)

sink(file.path(output_dir, "table_roadmap.tex"))
cat("\\begin{tabular}{@{}cll@{}}\n")
cat("\\toprule\n")
cat("\\textbf{Weeks} & \\textbf{Topic} & \\textbf{Key Skills} \\\\\n")
cat("\\midrule\n")
for (i in 1:nrow(roadmap)) {
  cat(paste(roadmap$Week[i], "&",
            roadmap$Topic[i], "&",
            roadmap$Skills[i], "\\\\\n"))
}
cat("\\bottomrule\n")
cat("\\end{tabular}\n")
sink()

# =============================================================================
# Table 6: Evaluation Metrics Summary
# =============================================================================
cat("Generating Table 6: Evaluation metrics...\n")

metrics <- data.frame(
  Metric = c("Accuracy", "Precision", "Recall", "F1-Score", "AUC-ROC"),
  Formula = c("$\\frac{TP+TN}{Total}$", "$\\frac{TP}{TP+FP}$",
              "$\\frac{TP}{TP+FN}$", "$\\frac{2 \\cdot P \\cdot R}{P+R}$", "Area under curve"),
  UseCase = c("Balanced data", "Cost of FP high", "Cost of FN high", "Imbalanced data", "Threshold tuning")
)

sink(file.path(output_dir, "table_metrics.tex"))
cat("\\begin{tabular}{@{}lll@{}}\n")
cat("\\toprule\n")
cat("\\textbf{Metric} & \\textbf{Formula} & \\textbf{Best For} \\\\\n")
cat("\\midrule\n")
for (i in 1:nrow(metrics)) {
  cat(paste(metrics$Metric[i], "&",
            metrics$Formula[i], "&",
            metrics$UseCase[i], "\\\\\n"))
}
cat("\\bottomrule\n")
cat("\\end{tabular}\n")
sink()

cat("\n========================================\n")
cat("All tables generated successfully!\n")
cat("Output directory:", normalizePath(output_dir), "\n")
cat("========================================\n")
