#!/usr/bin/env Rscript
# generate_figures.R
# Generates all figures for the Data Science Introduction deck
# Outputs: PNG files optimized for Beamer integration

# Load required packages (install if needed)
required_packages <- c("ggplot2", "dplyr", "tidyr", "scales", "gridExtra", "ggrepel")

for (pkg in required_packages) {
  if (!require(pkg, character.only = TRUE, quietly = TRUE)) {
    install.packages(pkg, repos = "https://cloud.r-project.org/")
    library(pkg, character.only = TRUE)
  }
}

# Set output directory
output_dir <- "../figures"
if (!dir.exists(output_dir)) dir.create(output_dir, recursive = TRUE)

# Custom theme matching Beamer palette
theme_datascience <- function(base_size = 12) {
  theme_minimal(base_size = base_size) +
    theme(
      text = element_text(color = "#334155"),
      plot.title = element_text(color = "#172554", face = "bold", size = rel(1.2)),
      plot.subtitle = element_text(color = "#64748b", size = rel(0.9)),
      axis.title = element_text(color = "#334155", face = "bold", size = rel(0.9)),
      axis.text = element_text(color = "#64748b", size = rel(0.85)),
      legend.title = element_text(color = "#334155", face = "bold", size = rel(0.85)),
      legend.text = element_text(color = "#64748b", size = rel(0.8)),
      panel.grid.major = element_line(color = "#e2e8f0", linewidth = 0.3),
      panel.grid.minor = element_blank(),
      plot.background = element_rect(fill = "#fefcf7", color = NA),
      panel.background = element_rect(fill = "#fefcf7", color = NA),
      legend.background = element_rect(fill = "#fefcf7", color = NA),
      plot.margin = margin(10, 15, 10, 10)
    )
}

# Color palette
ds_colors <- c(
  navy = "#172554",
  slate = "#334155",
  coral = "#ef767a",
  teal = "#2dd4bf",
  gold = "#eab308",
  lightgray = "#f1f5f9"
)

# =============================================================================
# Figure 1: Data Science Venn Diagram Concept
# =============================================================================
cat("Generating Figure 1: Data Science domains...\n")

set.seed(42)
domains <- data.frame(
  Domain = factor(c("Statistics", "Computer\nScience", "Domain\nExpertise", "Data\nScience"),
                  levels = c("Statistics", "Computer\nScience", "Domain\nExpertise", "Data\nScience")),
  Importance = c(85, 90, 75, 95),
  Category = c("Foundation", "Foundation", "Foundation", "Intersection")
)

p1 <- ggplot(domains, aes(x = Domain, y = Importance, fill = Category)) +
  geom_col(width = 0.7) +
  geom_text(aes(label = paste0(Importance, "%")), vjust = -0.5,
            color = "#334155", fontface = "bold", size = 4) +
  scale_fill_manual(values = c("Foundation" = ds_colors["slate"],
                                "Intersection" = ds_colors["coral"])) +
  scale_y_continuous(limits = c(0, 110), expand = c(0, 0)) +
  labs(title = "Core Pillars of Data Science",
       subtitle = "Relative importance of foundational domains",
       x = NULL, y = "Relevance Score") +
  theme_datascience() +
  theme(legend.position = "bottom",
        axis.text.x = element_text(size = 10, lineheight = 0.9))

ggsave(file.path(output_dir, "fig_ds_domains.png"), p1,
       width = 7, height = 4.5, dpi = 300, bg = "#fefcf7")

# =============================================================================
# Figure 2: Data Growth Over Time
# =============================================================================
cat("Generating Figure 2: Data growth timeline...\n")

years <- 2010:2025
data_volume <- 2 * (1.4)^(years - 2010)  # Exponential growth

growth_data <- data.frame(
  Year = years,
  Volume = data_volume,
  Era = ifelse(years < 2015, "Early Big Data",
               ifelse(years < 2020, "Cloud Era", "AI Era"))
)

p2 <- ggplot(growth_data, aes(x = Year, y = Volume)) +
  geom_area(fill = ds_colors["teal"], alpha = 0.3) +
  geom_line(color = ds_colors["teal"], linewidth = 1.2) +
  geom_point(aes(color = Era), size = 3) +
  scale_color_manual(values = c("Early Big Data" = ds_colors["slate"],
                                 "Cloud Era" = ds_colors["coral"],
                                 "AI Era" = ds_colors["navy"])) +
  scale_y_continuous(labels = function(x) paste0(round(x), " ZB")) +
  labs(title = "Global Data Volume Growth",
       subtitle = "Zettabytes of data created annually",
       x = "Year", y = "Data Volume") +
  theme_datascience() +
  theme(legend.position = "bottom")

ggsave(file.path(output_dir, "fig_data_growth.png"), p2,
       width = 7, height = 4.5, dpi = 300, bg = "#fefcf7")

# =============================================================================
# Figure 3: The Data Science Pipeline
# =============================================================================
cat("Generating Figure 3: Data science pipeline...\n")

pipeline <- data.frame(
  Stage = factor(c("Collection", "Cleaning", "Analysis", "Modeling", "Communication"),
                 levels = c("Collection", "Cleaning", "Analysis", "Modeling", "Communication")),
  TimePercent = c(15, 40, 20, 15, 10),
  Position = 1:5
)

p3 <- ggplot(pipeline, aes(x = Stage, y = TimePercent, fill = Stage)) +
  geom_col(width = 0.75) +
  geom_text(aes(label = paste0(TimePercent, "%")), vjust = -0.5,
            color = "#334155", fontface = "bold", size = 4) +
  scale_fill_manual(values = c(
    "Collection" = ds_colors["navy"],
    "Cleaning" = ds_colors["coral"],
    "Analysis" = ds_colors["teal"],
    "Modeling" = ds_colors["gold"],
    "Communication" = ds_colors["slate"]
  )) +
  scale_y_continuous(limits = c(0, 50), expand = c(0, 0)) +
  labs(title = "Data Science Workflow",
       subtitle = "Typical time allocation across pipeline stages",
       x = NULL, y = "Time Spent (%)") +
  theme_datascience() +
  theme(legend.position = "none",
        axis.text.x = element_text(size = 10, angle = 0))

ggsave(file.path(output_dir, "fig_pipeline.png"), p3,
       width = 7, height = 4.5, dpi = 300, bg = "#fefcf7")

# =============================================================================
# Figure 4: Types of Analytics
# =============================================================================
cat("Generating Figure 4: Analytics types...\n")

analytics <- data.frame(
  Type = factor(c("Descriptive", "Diagnostic", "Predictive", "Prescriptive"),
                levels = c("Descriptive", "Diagnostic", "Predictive", "Prescriptive")),
  Complexity = c(1, 2, 3, 4),
  Value = c(2, 3, 4, 5),
  Question = c("What happened?", "Why did it happen?",
               "What will happen?", "What should we do?")
)

p4 <- ggplot(analytics, aes(x = Complexity, y = Value)) +
  geom_point(aes(color = Type), size = 12, alpha = 0.8) +
  geom_text(aes(label = Type), size = 3.2, fontface = "bold", color = "white") +
  geom_text(aes(y = Value - 0.7, label = Question), size = 2.8,
            color = "#64748b", fontface = "italic") +
  scale_color_manual(values = c(
    "Descriptive" = ds_colors["slate"],
    "Diagnostic" = ds_colors["teal"],
    "Predictive" = ds_colors["coral"],
    "Prescriptive" = ds_colors["navy"]
  )) +
  scale_x_continuous(limits = c(0.5, 4.5), breaks = 1:4,
                     labels = c("Low", "", "", "High")) +
  scale_y_continuous(limits = c(1, 6), breaks = 2:5,
                     labels = c("Low", "", "", "High")) +
  labs(title = "The Analytics Maturity Model",
       subtitle = "From hindsight to foresight",
       x = "Technical Complexity", y = "Business Value") +
  theme_datascience() +
  theme(legend.position = "none",
        panel.grid.major = element_line(color = "#e2e8f0", linewidth = 0.2))

ggsave(file.path(output_dir, "fig_analytics_types.png"), p4,
       width = 7, height = 5, dpi = 300, bg = "#fefcf7")

# =============================================================================
# Figure 5: Machine Learning Categories
# =============================================================================
cat("Generating Figure 5: ML categories...\n")

ml_data <- data.frame(
  Category = rep(c("Supervised", "Unsupervised", "Reinfortic"), each = 4),
  Method = c("Classification", "Regression", "Ensemble", "Neural Nets",
             "Clustering", "Dim. Reduction", "Association", "Anomaly Det.",
             "Q-Learning", "Policy Grad.", "Actor-Critic", "Multi-Agent"),
  Usage = c(35, 30, 25, 30, 25, 20, 15, 18, 10, 12, 15, 8)
)

ml_summary <- ml_data %>%
  group_by(Category) %>%
  summarize(Total = sum(Usage), .groups = "drop")

p5 <- ggplot(ml_summary, aes(x = reorder(Category, Total), y = Total, fill = Category)) +
  geom_col(width = 0.6) +
  geom_text(aes(label = paste0(Total, "%")), hjust = -0.2,
            color = "#334155", fontface = "bold", size = 4.5) +
  coord_flip() +
  scale_fill_manual(values = c(
    "Supervised" = ds_colors["coral"],
    "Unsupervised" = ds_colors["teal"],
    "Reinfortic" = ds_colors["navy"]
  )) +
  scale_y_continuous(limits = c(0, 140), expand = c(0, 0)) +
  labs(title = "Machine Learning Paradigms",
       subtitle = "Relative industry adoption by category",
       x = NULL, y = "Adoption Index") +
  theme_datascience() +
  theme(legend.position = "none")

ggsave(file.path(output_dir, "fig_ml_categories.png"), p5,
       width = 7, height = 4, dpi = 300, bg = "#fefcf7")

# =============================================================================
# Figure 6: Bias-Variance Tradeoff
# =============================================================================
cat("Generating Figure 6: Bias-variance tradeoff...\n")

complexity <- seq(1, 10, by = 0.1)
bias_sq <- 10 / complexity
variance <- 0.1 * complexity^1.8
total_error <- bias_sq + variance + 0.5

tradeoff_data <- data.frame(
  Complexity = rep(complexity, 3),
  Error = c(bias_sq, variance, total_error),
  Type = rep(c("Bias²", "Variance", "Total Error"), each = length(complexity))
)

optimal_idx <- which.min(total_error)
optimal_point <- data.frame(
  Complexity = complexity[optimal_idx],
  Error = total_error[optimal_idx]
)

p6 <- ggplot(tradeoff_data, aes(x = Complexity, y = Error, color = Type)) +
  geom_line(linewidth = 1.2) +
  geom_point(data = optimal_point, aes(x = Complexity, y = Error),
             color = ds_colors["gold"], size = 4, inherit.aes = FALSE) +
  annotate("text", x = optimal_point$Complexity + 0.8, y = optimal_point$Error + 0.5,
           label = "Optimal\nComplexity", color = ds_colors["gold"],
           fontface = "bold", size = 3.5, lineheight = 0.9) +
  scale_color_manual(values = c(
    "Bias²" = ds_colors["teal"],
    "Variance" = ds_colors["coral"],
    "Total Error" = ds_colors["navy"]
  )) +
  labs(title = "The Bias-Variance Tradeoff",
       subtitle = "Finding the sweet spot in model complexity",
       x = "Model Complexity", y = "Error") +
  theme_datascience() +
  theme(legend.position = "bottom",
        legend.title = element_blank())

ggsave(file.path(output_dir, "fig_bias_variance.png"), p6,
       width = 7, height = 5, dpi = 300, bg = "#fefcf7")

# =============================================================================
# Figure 7: Skills Radar (simplified as bar chart for clarity)
# =============================================================================
cat("Generating Figure 7: Data scientist skills...\n")

skills <- data.frame(
  Skill = factor(c("Programming", "Statistics", "ML/AI", "Communication",
                   "Domain Knowledge", "Data Wrangling", "Visualization"),
                 levels = c("Programming", "Statistics", "ML/AI", "Communication",
                            "Domain Knowledge", "Data Wrangling", "Visualization")),
  Importance = c(90, 85, 80, 75, 70, 95, 72)
)

p7 <- ggplot(skills, aes(x = reorder(Skill, Importance), y = Importance)) +
  geom_segment(aes(xend = Skill, y = 0, yend = Importance),
               color = ds_colors["slate"], linewidth = 1) +
  geom_point(size = 5, color = ds_colors["coral"]) +
  geom_text(aes(label = Importance), hjust = -0.8, color = "#334155",
            fontface = "bold", size = 3.5) +
  coord_flip() +
  scale_y_continuous(limits = c(0, 110), expand = c(0, 0)) +
  labs(title = "Essential Data Science Skills",
       subtitle = "Ranked by industry demand",
       x = NULL, y = "Importance Score") +
  theme_datascience()

ggsave(file.path(output_dir, "fig_skills.png"), p7,
       width = 7, height = 4.5, dpi = 300, bg = "#fefcf7")

# =============================================================================
# Figure 8: Sample Data Visualization (Scatter with trend)
# =============================================================================
cat("Generating Figure 8: Sample analysis visualization...\n")

set.seed(123)
n <- 80
sample_data <- data.frame(
  StudyHours = runif(n, 1, 10),
  Grade = NA
)
sample_data$Grade <- 40 + 5 * sample_data$StudyHours + rnorm(n, 0, 8)
sample_data$Grade <- pmin(100, pmax(30, sample_data$Grade))
sample_data$Performance <- ifelse(sample_data$Grade >= 70, "High", "Developing")

p8 <- ggplot(sample_data, aes(x = StudyHours, y = Grade)) +
  geom_point(aes(color = Performance), alpha = 0.7, size = 3) +
  geom_smooth(method = "lm", se = TRUE, color = ds_colors["navy"],
              fill = ds_colors["navy"], alpha = 0.15, linewidth = 1) +
  scale_color_manual(values = c("High" = ds_colors["teal"],
                                 "Developing" = ds_colors["coral"])) +
  labs(title = "Study Hours vs. Exam Performance",
       subtitle = "Linear regression reveals the relationship",
       x = "Weekly Study Hours", y = "Exam Score (%)") +
  theme_datascience() +
  theme(legend.position = "bottom")

ggsave(file.path(output_dir, "fig_sample_analysis.png"), p8,
       width = 7, height = 5, dpi = 300, bg = "#fefcf7")

cat("\n========================================\n")
cat("All figures generated successfully!\n")
cat("Output directory:", normalizePath(output_dir), "\n")
cat("========================================\n")
