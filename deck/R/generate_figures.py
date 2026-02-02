#!/usr/bin/env python3
"""
generate_figures.py
Generates all figures for the Data Science Introduction deck
Outputs: PNG files optimized for Beamer integration
"""

import os
import numpy as np

# Try to import matplotlib
try:
    import matplotlib
    matplotlib.use('Agg')  # Non-interactive backend
    import matplotlib.pyplot as plt
    from matplotlib.patches import FancyBboxPatch
    HAS_MATPLOTLIB = True
except ImportError:
    HAS_MATPLOTLIB = False
    print("matplotlib not available - will create placeholder figures")

# Set output directory
output_dir = "../figures"
os.makedirs(output_dir, exist_ok=True)

# Custom colors matching Beamer palette
COLORS = {
    'navy': '#172554',
    'slate': '#334155',
    'coral': '#ef767a',
    'teal': '#2dd4bf',
    'gold': '#eab308',
    'cream': '#fefcf7',
    'lightgray': '#f1f5f9',
    'midgray': '#94a3b8'
}

def setup_style():
    """Configure matplotlib style to match our theme."""
    if not HAS_MATPLOTLIB:
        return
    plt.rcParams.update({
        'figure.facecolor': COLORS['cream'],
        'axes.facecolor': COLORS['cream'],
        'axes.edgecolor': COLORS['midgray'],
        'axes.labelcolor': COLORS['slate'],
        'axes.titlecolor': COLORS['navy'],
        'text.color': COLORS['slate'],
        'xtick.color': COLORS['midgray'],
        'ytick.color': COLORS['midgray'],
        'grid.color': '#e2e8f0',
        'grid.linewidth': 0.3,
        'font.size': 11,
        'axes.titlesize': 14,
        'axes.labelsize': 11,
        'legend.fontsize': 10,
        'figure.dpi': 300,
        'savefig.dpi': 300,
        'savefig.facecolor': COLORS['cream'],
        'savefig.edgecolor': 'none'
    })

if HAS_MATPLOTLIB:
    setup_style()

# =============================================================================
# Figure 1: Data Science Domains
# =============================================================================
print("Generating Figure 1: Data Science domains...")

if HAS_MATPLOTLIB:
    fig, ax = plt.subplots(figsize=(7, 4.5))

    domains = ['Statistics', 'Computer\nScience', 'Domain\nExpertise', 'Data\nScience']
    importance = [85, 90, 75, 95]
    colors = [COLORS['slate'], COLORS['slate'], COLORS['slate'], COLORS['coral']]

    bars = ax.bar(domains, importance, color=colors, width=0.6, edgecolor='none')

    for bar, val in zip(bars, importance):
        ax.text(bar.get_x() + bar.get_width()/2, bar.get_height() + 2,
                f'{val}%', ha='center', va='bottom', fontweight='bold',
                color=COLORS['slate'])

    ax.set_ylim(0, 110)
    ax.set_ylabel('Relevance Score', fontweight='bold')
    ax.set_title('Core Pillars of Data Science', fontweight='bold', pad=15)
    ax.spines['top'].set_visible(False)
    ax.spines['right'].set_visible(False)
    ax.tick_params(axis='x', length=0)

    plt.tight_layout()
    plt.savefig(os.path.join(output_dir, 'fig_ds_domains.png'), bbox_inches='tight')
    plt.close()

# =============================================================================
# Figure 2: Data Growth Over Time
# =============================================================================
print("Generating Figure 2: Data growth timeline...")

if HAS_MATPLOTLIB:
    fig, ax = plt.subplots(figsize=(7, 4.5))

    years = np.arange(2010, 2026)
    data_volume = 2 * (1.4) ** (years - 2010)

    ax.fill_between(years, data_volume, alpha=0.3, color=COLORS['teal'])
    ax.plot(years, data_volume, color=COLORS['teal'], linewidth=2)

    # Color points by era
    era_colors = [COLORS['slate'] if y < 2015 else
                  COLORS['coral'] if y < 2020 else
                  COLORS['navy'] for y in years]
    ax.scatter(years, data_volume, c=era_colors, s=50, zorder=5)

    ax.set_xlabel('Year', fontweight='bold')
    ax.set_ylabel('Data Volume (ZB)', fontweight='bold')
    ax.set_title('Global Data Volume Growth', fontweight='bold', pad=15)
    ax.spines['top'].set_visible(False)
    ax.spines['right'].set_visible(False)

    # Legend
    from matplotlib.lines import Line2D
    legend_elements = [
        Line2D([0], [0], marker='o', color='w', markerfacecolor=COLORS['slate'],
               markersize=8, label='Early Big Data'),
        Line2D([0], [0], marker='o', color='w', markerfacecolor=COLORS['coral'],
               markersize=8, label='Cloud Era'),
        Line2D([0], [0], marker='o', color='w', markerfacecolor=COLORS['navy'],
               markersize=8, label='AI Era')
    ]
    ax.legend(handles=legend_elements, loc='upper left', frameon=False)

    plt.tight_layout()
    plt.savefig(os.path.join(output_dir, 'fig_data_growth.png'), bbox_inches='tight')
    plt.close()

# =============================================================================
# Figure 3: Data Science Pipeline
# =============================================================================
print("Generating Figure 3: Data science pipeline...")

if HAS_MATPLOTLIB:
    fig, ax = plt.subplots(figsize=(7, 4.5))

    stages = ['Collection', 'Cleaning', 'Analysis', 'Modeling', 'Reporting']
    time_pct = [15, 40, 20, 15, 10]
    colors = [COLORS['navy'], COLORS['coral'], COLORS['teal'],
              COLORS['gold'], COLORS['slate']]

    bars = ax.bar(stages, time_pct, color=colors, width=0.65, edgecolor='none')

    for bar, val in zip(bars, time_pct):
        ax.text(bar.get_x() + bar.get_width()/2, bar.get_height() + 1,
                f'{val}%', ha='center', va='bottom', fontweight='bold',
                color=COLORS['slate'])

    ax.set_ylim(0, 50)
    ax.set_ylabel('Time Spent (%)', fontweight='bold')
    ax.set_title('Data Science Workflow', fontweight='bold', pad=15)
    ax.spines['top'].set_visible(False)
    ax.spines['right'].set_visible(False)
    ax.tick_params(axis='x', length=0)

    plt.tight_layout()
    plt.savefig(os.path.join(output_dir, 'fig_pipeline.png'), bbox_inches='tight')
    plt.close()

# =============================================================================
# Figure 4: Analytics Maturity Model
# =============================================================================
print("Generating Figure 4: Analytics types...")

if HAS_MATPLOTLIB:
    fig, ax = plt.subplots(figsize=(7, 5))

    analytics_types = ['Descriptive', 'Diagnostic', 'Predictive', 'Prescriptive']
    complexity = [1, 2, 3, 4]
    value = [2, 3, 4, 5]
    questions = ['What happened?', 'Why did it happen?',
                 'What will happen?', 'What should we do?']
    colors = [COLORS['slate'], COLORS['teal'], COLORS['coral'], COLORS['navy']]

    for i, (x, y, t, q, c) in enumerate(zip(complexity, value, analytics_types, questions, colors)):
        ax.scatter(x, y, s=800, c=c, alpha=0.85, zorder=5)
        ax.text(x, y + 0.45, t, ha='center', va='bottom', fontweight='bold',
                color=c, fontsize=10, zorder=6)
        ax.text(x, y - 0.45, q, ha='center', va='top', fontstyle='italic',
                color=COLORS['midgray'], fontsize=8)

    ax.set_xlim(0.3, 4.7)
    ax.set_ylim(1.2, 5.8)
    ax.set_xlabel('Technical Complexity', fontweight='bold')
    ax.set_ylabel('Business Value', fontweight='bold')
    ax.set_title('The Analytics Maturity Model', fontweight='bold', pad=15)
    ax.set_xticks([1, 4])
    ax.set_xticklabels(['Low', 'High'])
    ax.set_yticks([2, 5])
    ax.set_yticklabels(['Low', 'High'])
    ax.spines['top'].set_visible(False)
    ax.spines['right'].set_visible(False)
    ax.grid(True, alpha=0.3)

    plt.tight_layout()
    plt.savefig(os.path.join(output_dir, 'fig_analytics_types.png'), bbox_inches='tight')
    plt.close()

# =============================================================================
# Figure 5: Machine Learning Categories
# =============================================================================
print("Generating Figure 5: ML categories...")

if HAS_MATPLOTLIB:
    fig, ax = plt.subplots(figsize=(7, 4))

    categories = ['Reinforcement\nLearning', 'Unsupervised\nLearning', 'Supervised\nLearning']
    adoption = [45, 78, 120]
    colors = [COLORS['navy'], COLORS['teal'], COLORS['coral']]

    bars = ax.barh(categories, adoption, color=colors, height=0.5, edgecolor='none')

    for bar, val in zip(bars, adoption):
        ax.text(bar.get_width() + 3, bar.get_y() + bar.get_height()/2,
                str(val), ha='left', va='center', fontweight='bold',
                color=COLORS['slate'])

    ax.set_xlim(0, 145)
    ax.set_xlabel('Adoption Index', fontweight='bold')
    ax.set_title('Machine Learning Paradigms', fontweight='bold', pad=15)
    ax.spines['top'].set_visible(False)
    ax.spines['right'].set_visible(False)
    ax.tick_params(axis='y', length=0)

    plt.tight_layout()
    plt.savefig(os.path.join(output_dir, 'fig_ml_categories.png'), bbox_inches='tight')
    plt.close()

# =============================================================================
# Figure 6: Bias-Variance Tradeoff
# =============================================================================
print("Generating Figure 6: Bias-variance tradeoff...")

if HAS_MATPLOTLIB:
    fig, ax = plt.subplots(figsize=(7, 5))

    complexity = np.linspace(1, 10, 100)
    bias_sq = 10 / complexity
    variance = 0.1 * complexity ** 1.8
    total_error = bias_sq + variance + 0.5

    ax.plot(complexity, bias_sq, color=COLORS['teal'], linewidth=2, label='Bias²')
    ax.plot(complexity, variance, color=COLORS['coral'], linewidth=2, label='Variance')
    ax.plot(complexity, total_error, color=COLORS['navy'], linewidth=2, label='Total Error')

    # Mark optimal point
    optimal_idx = np.argmin(total_error)
    ax.scatter(complexity[optimal_idx], total_error[optimal_idx],
               color=COLORS['gold'], s=100, zorder=5)
    ax.annotate('Optimal\nComplexity',
                xy=(complexity[optimal_idx], total_error[optimal_idx]),
                xytext=(complexity[optimal_idx] + 1.5, total_error[optimal_idx] + 1),
                fontweight='bold', color=COLORS['gold'], fontsize=10,
                arrowprops=dict(arrowstyle='->', color=COLORS['gold']))

    ax.set_xlabel('Model Complexity', fontweight='bold')
    ax.set_ylabel('Error', fontweight='bold')
    ax.set_title('The Bias-Variance Tradeoff', fontweight='bold', pad=15)
    ax.legend(loc='upper right', frameon=False)
    ax.spines['top'].set_visible(False)
    ax.spines['right'].set_visible(False)

    plt.tight_layout()
    plt.savefig(os.path.join(output_dir, 'fig_bias_variance.png'), bbox_inches='tight')
    plt.close()

# =============================================================================
# Figure 7: Data Scientist Skills
# =============================================================================
print("Generating Figure 7: Data scientist skills...")

if HAS_MATPLOTLIB:
    fig, ax = plt.subplots(figsize=(7, 4.5))

    skills = ['Domain Knowledge', 'Visualization', 'Communication',
              'ML/AI', 'Statistics', 'Programming', 'Data Wrangling']
    importance = [70, 72, 75, 80, 85, 90, 95]

    y_pos = np.arange(len(skills))

    ax.hlines(y=y_pos, xmin=0, xmax=importance, color=COLORS['slate'], linewidth=2)
    ax.scatter(importance, y_pos, color=COLORS['coral'], s=100, zorder=5)

    for i, val in enumerate(importance):
        ax.text(val + 2, i, str(val), ha='left', va='center',
                fontweight='bold', color=COLORS['slate'])

    ax.set_yticks(y_pos)
    ax.set_yticklabels(skills)
    ax.set_xlim(0, 110)
    ax.set_xlabel('Importance Score', fontweight='bold')
    ax.set_title('Essential Data Science Skills', fontweight='bold', pad=15)
    ax.spines['top'].set_visible(False)
    ax.spines['right'].set_visible(False)
    ax.tick_params(axis='y', length=0)

    plt.tight_layout()
    plt.savefig(os.path.join(output_dir, 'fig_skills.png'), bbox_inches='tight')
    plt.close()

# =============================================================================
# Figure 8: Sample Analysis (Scatter with Regression)
# =============================================================================
print("Generating Figure 8: Sample analysis visualization...")

if HAS_MATPLOTLIB:
    fig, ax = plt.subplots(figsize=(7, 5))

    np.random.seed(123)
    n = 80
    study_hours = np.random.uniform(1, 10, n)
    grades = 40 + 5 * study_hours + np.random.normal(0, 8, n)
    grades = np.clip(grades, 30, 100)

    colors = [COLORS['teal'] if g >= 70 else COLORS['coral'] for g in grades]
    ax.scatter(study_hours, grades, c=colors, alpha=0.7, s=50)

    # Regression line
    z = np.polyfit(study_hours, grades, 1)
    p = np.poly1d(z)
    x_line = np.linspace(1, 10, 100)
    ax.plot(x_line, p(x_line), color=COLORS['navy'], linewidth=2)
    ax.fill_between(x_line, p(x_line) - 8, p(x_line) + 8,
                    color=COLORS['navy'], alpha=0.1)

    ax.set_xlabel('Weekly Study Hours', fontweight='bold')
    ax.set_ylabel('Exam Score (%)', fontweight='bold')
    ax.set_title('Study Hours vs. Exam Performance', fontweight='bold', pad=15)
    ax.spines['top'].set_visible(False)
    ax.spines['right'].set_visible(False)

    # Legend
    from matplotlib.lines import Line2D
    legend_elements = [
        Line2D([0], [0], marker='o', color='w', markerfacecolor=COLORS['teal'],
               markersize=8, label='High (≥70)'),
        Line2D([0], [0], marker='o', color='w', markerfacecolor=COLORS['coral'],
               markersize=8, label='Developing (<70)')
    ]
    ax.legend(handles=legend_elements, loc='lower right', frameon=False)

    plt.tight_layout()
    plt.savefig(os.path.join(output_dir, 'fig_sample_analysis.png'), bbox_inches='tight')
    plt.close()

print("\n========================================")
if HAS_MATPLOTLIB:
    print("All figures generated successfully!")
else:
    print("matplotlib not available - no figures generated")
print(f"Output directory: {os.path.abspath(output_dir)}")
print("========================================")
