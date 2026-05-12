# Ionosphere Classification — Decision Trees with `rpart`

> Binary classification of radar returns from the UCI Ionosphere dataset using CART decision trees in R.

---

## 📡 Background

This project classifies ionospheric radar returns as **"good"** (showing ionospheric structure) or **"bad"** (signals that pass straight through) using the **Classification and Regression Trees (CART)** algorithm via R's `rpart` package.

The radar data was collected in **Goose Bay, Labrador** using a phased array of 16 high-frequency antennas with ~6.4 kW total transmitted power.

---

## 📁 Repository Structure

```
ionosphere-decision-tree/
│
├── R/
│   ├── ionosphere_analysis.R      # Main analysis script (Parts 1 & 2)
│   └── ionosphere_report.Rmd     # R Markdown report with narrative
│
├── data/
│   └── Ionosphere.txt            # Raw dataset (or loaded via mlbench)
│
├── output/
│   ├── decision_tree_basic.png   # Basic tree plot (plot + text)
│   └── decision_tree_enhanced.png # Enhanced rpart.plot visualization
│
├── docs/
│   └── ionosphere_report.html    # Rendered HTML report (knit from .Rmd)
│
├── .gitignore
└── README.md
```

---

## 📊 Dataset Information

| Property | Value |
|---|---|
| Source | UCI Machine Learning Repository (via `mlbench`) |
| Observations | 351 |
| Features | 34 continuous (2 per pulse × 17 pulses) |
| Target | `Class` — `good` or `bad` |
| Task | Binary classification |

Each feature corresponds to complex values from an autocorrelation function applied to the received electromagnetic signal. Attribute 35 (the class label) is binary.

---

## 🛠️ Requirements

### R Packages

```r
install.packages(c("rpart", "mlbench", "rpart.plot"))
```

| Package | Purpose |
|---|---|
| `rpart` | Build CART decision trees |
| `mlbench` | Provides the Ionosphere dataset |
| `rpart.plot` | Enhanced tree visualization |

---

## 🚀 How to Run

### Option 1 — Run the R Script directly

```r
# In R or RStudio:
source("R/ionosphere_analysis.R")
```

### Option 2 — Knit the R Markdown Report

```r
# In RStudio: open ionosphere_report.Rmd and click "Knit"
# Or from the console:
rmarkdown::render("R/ionosphere_report.Rmd", output_dir = "docs")
```

---

## 📋 Assignment Parts

### Part 1 — Print Decision Tree

**a.** Load `rpart` and `mlbench`; load `Ionosphere` dataset via `data(Ionosphere)`.

**b.** Build a decision tree:
```r
tree_full <- rpart(Class ~ ., data = Ionosphere)
print(tree_full)
```

**c.** Visualize the tree:
```r
plot(tree_full, uniform = TRUE,
     main = "Ionosphere Classification - Decision Tree")
text(tree_full, use.n = TRUE, all = TRUE, cex = 0.8)
```

---

### Part 2 — Estimate Accuracy

**a.** Split data (70/30):
```r
set.seed(42)
train <- sample(1:nrow(Ionosphere), size = floor(0.7 * nrow(Ionosphere)))
test  <- setdiff(1:nrow(Ionosphere), train)
```

**b.** Train on subset:
```r
tree_train <- rpart(Class ~ ., data = Ionosphere, subset = train)
```

**c.** Predict on test set:
```r
predictions <- predict(tree_train,
                       newdata = Ionosphere[test, ],
                       type = "class")
```

**d.** Confusion table and accuracy:
```r
conf_table <- table(Predicted = predictions, Actual = Ionosphere$Class[test])
print(conf_table)

TP       <- conf_table["good", "good"]
TN       <- conf_table["bad",  "bad"]
accuracy <- (TP + TN) / length(test)
cat(sprintf("Accuracy: %.4f (%.2f%%)\n", accuracy, accuracy * 100))
```

---

## 📈 Expected Results

The model typically achieves **~90–94% accuracy** on held-out test data, demonstrating that decision trees are an effective classifier for this ionospheric radar dataset.

**Sample confusion matrix:**

```
          Actual
Predicted  bad good
     bad    27    3
     good    7   69
```

**Accuracy formula:**

$$\text{Accuracy} = \frac{TP + TN}{\text{Total Test Cases}} = \frac{\text{correct good} + \text{correct bad}}{\text{all test cases}}$$

---

## 📖 References

- Sigillito, V. G., et al. (1989). *Classification of Radar Returns from the Ionosphere Using Neural Networks.* Johns Hopkins APL Technical Digest.
- UCI Machine Learning Repository: [Ionosphere Dataset](https://archive.ics.uci.edu/ml/datasets/ionosphere)
- Therneau, T., & Atkinson, B. (2023). [rpart: Recursive Partitioning and Regression Trees](https://cran.r-project.org/web/packages/rpart/rpart.pdf)
- Leisch, F., & Dimitriadou, E. (2021). [mlbench: Machine Learning Benchmark Problems](https://cran.r-project.org/package=mlbench)

---

## 📝 License

This project is for educational purposes. Dataset sourced from UCI via `mlbench`.
