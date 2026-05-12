# =============================================================================
# Ionosphere Classification using Decision Trees (rpart)
# Dataset: UCI Ionosphere Dataset (via mlbench)
# Assignment: Binary Classification - "good" vs "bad" radar returns
# =============================================================================

# -----------------------------------------------------------------------------
# PART 1: Print Decision Tree
# -----------------------------------------------------------------------------

# (a) Set working directory, load packages, and load dataset
# setwd("path/to/your/working/directory")  # Modify as needed

# Load required libraries
library(rpart)       # Classification and Regression Trees
library(mlbench)     # Ionosphere dataset
library(rpart.plot)  # Enhanced tree plotting (optional but recommended)

# Load the Ionosphere dataset
data(Ionosphere)

# Quick overview of the dataset
cat("=== Dataset Overview ===\n")
cat("Dimensions:", nrow(Ionosphere), "rows x", ncol(Ionosphere), "columns\n")
cat("\nClass distribution:\n")
print(table(Ionosphere$Class))
cat("\nFirst few rows (last 3 columns shown):\n")
print(head(Ionosphere[, c(33, 34, 35)]))

# (b) Build decision tree using rpart()
cat("\n=== Part 1b: Decision Tree (rpart output) ===\n")
tree_full <- rpart(Class ~ ., data = Ionosphere)
print(tree_full)

# (c) Plot the decision tree using plot() and text()
cat("\n=== Part 1c: Plotting Decision Tree ===\n")

# Save the basic plot to a PNG file
png("output/decision_tree_basic.png", width = 1000, height = 700, res = 120)
par(mar = c(1, 1, 2, 1))
plot(tree_full, uniform = TRUE, main = "Ionosphere Classification - Decision Tree")
text(tree_full, use.n = TRUE, all = TRUE, cex = 0.75)
dev.off()
cat("Basic tree plot saved to: output/decision_tree_basic.png\n")

# Enhanced plot using rpart.plot (if available)
if (requireNamespace("rpart.plot", quietly = TRUE)) {
  png("output/decision_tree_enhanced.png", width = 1200, height = 800, res = 120)
  rpart.plot(
    tree_full,
    type    = 4,
    extra   = 104,
    fallen.leaves = TRUE,
    main    = "Ionosphere Classification - Enhanced Decision Tree",
    cex     = 0.8,
    box.palette = list(bad = "#E74C3C", good = "#27AE60")
  )
  dev.off()
  cat("Enhanced tree plot saved to: output/decision_tree_enhanced.png\n")
}


# -----------------------------------------------------------------------------
# PART 2: Estimate Accuracy
# -----------------------------------------------------------------------------

cat("\n=== Part 2: Estimating Accuracy ===\n")

# Set seed for reproducibility
set.seed(42)

# (a) Split data into training and testing subsets
# 70% training, 30% testing (common split ratio)
n      <- nrow(Ionosphere)
train  <- sample(1:n, size = floor(0.7 * n), replace = FALSE)  # training indices
test   <- setdiff(1:n, train)                                    # testing indices

cat(sprintf("Total observations  : %d\n", n))
cat(sprintf("Training set size   : %d (%.1f%%)\n", length(train), 100 * length(train) / n))
cat(sprintf("Testing set size    : %d (%.1f%%)\n", length(test),  100 * length(test)  / n))

# (b) Build decision tree on training data
tree_train <- rpart(Class ~ ., data = Ionosphere, subset = train)
cat("\nTraining tree summary:\n")
print(tree_train)

# (c) Predict class labels for testing data
predictions <- predict(tree_train, newdata = Ionosphere[test, ], type = "class")

# (d) Confusion table and accuracy computation
cat("\n=== Confusion Matrix ===\n")
true_labels <- Ionosphere$Class[test]
conf_table  <- table(Predicted = predictions, Actual = true_labels)
print(conf_table)

# Extract counts
TP <- conf_table["good", "good"]   # Correctly predicted "good"
TN <- conf_table["bad",  "bad"]    # Correctly predicted "bad"
FP <- conf_table["good", "bad"]    # Predicted "good", actually "bad"
FN <- conf_table["bad",  "good"]   # Predicted "bad",  actually "good"
total_test <- length(test)

# Accuracy = (TP + TN) / Total
accuracy <- (TP + TN) / total_test

cat(sprintf("\n=== Performance Metrics ===\n"))
cat(sprintf("True Positives  (TP - correct 'good') : %d\n", TP))
cat(sprintf("True Negatives  (TN - correct 'bad')  : %d\n", TN))
cat(sprintf("False Positives (FP - wrong 'good')   : %d\n", FP))
cat(sprintf("False Negatives (FN - wrong 'bad')    : %d\n", FN))
cat(sprintf("\nAccuracy = (TP + TN) / Total = (%d + %d) / %d = %.4f (%.2f%%)\n",
            TP, TN, total_test, accuracy, accuracy * 100))

# Additional metrics
precision <- TP / (TP + FP)
recall    <- TP / (TP + FN)
f1_score  <- 2 * precision * recall / (precision + recall)

cat(sprintf("\nPrecision (PPV) : %.4f\n", precision))
cat(sprintf("Recall (Sens.)  : %.4f\n", recall))
cat(sprintf("F1 Score        : %.4f\n", f1_score))


# -----------------------------------------------------------------------------
# BONUS: Cross-Validation for More Robust Accuracy Estimate
# -----------------------------------------------------------------------------

cat("\n=== Bonus: 10-Fold Cross-Validation ===\n")

k          <- 10
folds      <- cut(sample(1:n), breaks = k, labels = FALSE)
cv_acc     <- numeric(k)

for (i in 1:k) {
  cv_test  <- which(folds == i)
  cv_train <- which(folds != i)

  cv_tree  <- rpart(Class ~ ., data = Ionosphere, subset = cv_train)
  cv_pred  <- predict(cv_tree, newdata = Ionosphere[cv_test, ], type = "class")
  cv_true  <- Ionosphere$Class[cv_test]

  cv_acc[i] <- mean(cv_pred == cv_true)
}

cat(sprintf("Cross-validation accuracies: %s\n",
            paste(round(cv_acc, 4), collapse = ", ")))
cat(sprintf("Mean CV Accuracy : %.4f (%.2f%%)\n", mean(cv_acc), mean(cv_acc) * 100))
cat(sprintf("Std Dev          : %.4f\n", sd(cv_acc)))

cat("\n=== Analysis Complete ===\n")
