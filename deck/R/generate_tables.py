#!/usr/bin/env python3
"""
generate_tables.py
Generates all tables for the Data Science Introduction deck
Outputs: TeX files for direct inclusion in Beamer
"""

import os

# Set output directory
output_dir = "../tables"
os.makedirs(output_dir, exist_ok=True)

# =============================================================================
# Table 1: Data Types Overview
# =============================================================================
print("Generating Table 1: Data types...")

table1 = r"""\begin{tabular}{@{}llll@{}}
\toprule
\textbf{Type} & \textbf{Description} & \textbf{Examples} & \textbf{Share} \\
\midrule
Structured & Organized in tables/rows & SQL databases, CSV & 20\% \\
Semi-structured & Tagged or marked up & JSON, XML, HTML & 10\% \\
Unstructured & No predefined format & Text, images, video & 70\% \\
\bottomrule
\end{tabular}"""

with open(os.path.join(output_dir, "table_data_types.tex"), "w") as f:
    f.write(table1)

# =============================================================================
# Table 2: Machine Learning Algorithms Comparison
# =============================================================================
print("Generating Table 2: ML algorithms comparison...")

table2 = r"""\begin{tabular}{@{}llcc@{}}
\toprule
\textbf{Algorithm} & \textbf{Task} & \textbf{Interpret.} & \textbf{Scale} \\
\midrule
Linear Regression & Regression & High & Excellent \\
Logistic Regression & Classification & High & Excellent \\
Decision Trees & Both & Medium & Good \\
Random Forest & Both & Low & Good \\
Neural Networks & Both & Low & Varies \\
\bottomrule
\end{tabular}"""

with open(os.path.join(output_dir, "table_ml_algorithms.tex"), "w") as f:
    f.write(table2)

# =============================================================================
# Table 3: Programming Languages for Data Science
# =============================================================================
print("Generating Table 3: Programming languages...")

table3 = r"""\begin{tabular}{@{}lll@{}}
\toprule
\textbf{Language} & \textbf{Key Strengths} & \textbf{Rank} \\
\midrule
Python & General purpose, ML libraries & 1st \\
R & Statistics, visualization & 2nd \\
SQL & Data querying, databases & 3rd \\
Julia & High performance computing & Growing \\
\bottomrule
\end{tabular}"""

with open(os.path.join(output_dir, "table_languages.tex"), "w") as f:
    f.write(table3)

# =============================================================================
# Table 4: Key Metrics by Domain
# =============================================================================
print("Generating Table 4: Domain metrics...")

table4 = r"""\begin{tabular}{@{}lll@{}}
\toprule
\textbf{Domain} & \textbf{Key Metric} & \textbf{Challenge} \\
\midrule
Healthcare & Patient outcomes & Privacy (HIPAA) \\
Finance & ROI, Risk & Regulation \\
Marketing & Conversion rate & Attribution \\
Manufacturing & Defect rate & Real-time data \\
\bottomrule
\end{tabular}"""

with open(os.path.join(output_dir, "table_domains.tex"), "w") as f:
    f.write(table4)

# =============================================================================
# Table 5: Course Roadmap
# =============================================================================
print("Generating Table 5: Course roadmap...")

table5 = r"""\begin{tabular}{@{}cll@{}}
\toprule
\textbf{Weeks} & \textbf{Topic} & \textbf{Key Skills} \\
\midrule
1--3 & Foundations & Python, Statistics basics \\
4--6 & Data Wrangling & pandas, data cleaning \\
7--9 & Machine Learning & scikit-learn \\
10--12 & Deep Learning & PyTorch basics \\
13--15 & Capstone Project & Full pipeline \\
\bottomrule
\end{tabular}"""

with open(os.path.join(output_dir, "table_roadmap.tex"), "w") as f:
    f.write(table5)

# =============================================================================
# Table 6: Evaluation Metrics Summary
# =============================================================================
print("Generating Table 6: Evaluation metrics...")

table6 = r"""\begin{tabular}{@{}lll@{}}
\toprule
\textbf{Metric} & \textbf{Formula} & \textbf{Best For} \\
\midrule
Accuracy & $\frac{TP+TN}{\text{Total}}$ & Balanced data \\
Precision & $\frac{TP}{TP+FP}$ & Cost of FP high \\
Recall & $\frac{TP}{TP+FN}$ & Cost of FN high \\
F1-Score & $\frac{2 \cdot P \cdot R}{P+R}$ & Imbalanced data \\
AUC-ROC & Area under curve & Threshold tuning \\
\bottomrule
\end{tabular}"""

with open(os.path.join(output_dir, "table_metrics.tex"), "w") as f:
    f.write(table6)

print("\n========================================")
print("All tables generated successfully!")
print(f"Output directory: {os.path.abspath(output_dir)}")
print("========================================")
