library(readr)
AmesHousing <- read_csv("Downloads/AmesHousing.csv")
#View(AmesHousing)

library(dplyr)

#colnames(AmesHousing)                       #to see the column names

housing_small <- AmesHousing %>%             #picking the features that we will use
  select(
    SalePrice,            #sale price
    `Gr Liv Area`,        #liveble area
    `TotRms AbvGrd`,      #total room number
    `Year Built`,         #age of the building
    `Overall Qual`,       #general quality
    `House Style`,        #house type
    Neighborhood,         #neighborhood
    `Garage Cars`,        #garage capacity of cars
    `Full Bath`           #number of the bathrooms
  )

set.seed(42)                                       #to import the same houses each time. 
housing_sample <- housing_small %>% sample_n(30)   #take random 30 of them

write.csv(housing_sample, "housing_sample_30.csv", row.names = FALSE)    #creating our new sample dataset for us to use

#View(housing_sample)

#str(housing_small)
#colnames(housing_small)

###3- FREQUENCY DISTRIBUTIONS

#calculating the number of classes with "sturges rule"
n <- nrow(housing_sample)
k <- ceiling(1 + 3.3 * log10(n))                 #sturges rule gives us the appropriate number of classes to divide the dataset.  
cat("appropriate number of classes is:", k, "\n")

#calculating the range of the house prices
range_sp <- range(housing_sample$SalePrice)
range_value <- diff(range_sp)
cat("range is:" , range_value, "\n")

#calculating the class width of the house prices classes. we already found the number of classes with the Sturges Rule. 
width <- ceiling(range_value / k)
cat("class width is:", width, "\n")

#boundaries of "the" classes
breaks <- seq(range_sp[1], range_sp[2] + width, by = width)
cat("boundaries of classes are:" , breaks, "\n")

#plotting the histogram that shows us how many houses are on that price interval
hist(housing_sample$SalePrice,
     breaks = breaks,
     main = "Histogram of Sale Prices",
     xlab = "Sale Price",
     col = "blue")

## drawing frequency polygon
# get midpoints and frequencies
hist_data <- hist(housing_sample$SalePrice, breaks = breaks, plot = FALSE)
midpoints <- hist_data$mids
counts <- hist_data$counts
cat("midpoint of data is:" , midpoints, "\n")

# plot the frequency polygon
plot(midpoints, counts,
     type = "o",                                   #line + points
     col = "red",                    
     main = "Frequency Polygon of Sale Prices",
     xlab = "Sale Price",
     ylab = "Frequency")

###4-DATA DESCRIPTION

##Measures of central tendency
mean_price <- mean(housing_sample$SalePrice)
median_price <- median(housing_sample$SalePrice)
estimated_mode <- midpoints[which.max(counts)]      #the mode which is taken from the histogram

cat("mean:", mean_price, "\n")
cat("median:", median_price, "\n")
cat("estimated Mode from histogram:", estimated_mode, "\n")

##Measures of variation
sd_price <- sd(housing_sample$SalePrice)
cv_price <- sd_price / mean_price                   #coefficient of variation

cat("standard deviation:", sd_price, "\n")
cat("coefficient of Variation:", cv_price, "\n")

##Measures of position
z_scores <- scale(housing_sample$SalePrice)          #scale() computes the z-score
z_scores

quantile(housing_sample$SalePrice, probs = seq(0, 1, 0.1))   

summary(housing_sample$SalePrice)

quartiles <- quantile(housing_sample$SalePrice, probs = c(0.25, 0.5, 0.75)) 
quartiles

boxplot(housing_sample$SalePrice,
        main = "boxplot of sale prices",
        ylab = "sale price",
        col = "pink")

##ceratin ga boxplot to determine Outliers
box_stats <- boxplot.stats(housing_sample$SalePrice)
outliers <- box_stats$out

cat("outliers:", outliers, "\n")


###5-NORMAL DISTRIBUTION

##plotting a histogram. probability=TRUE because we want the Y-plane to be density instead of frequency
hist(housing_sample$SalePrice,
     breaks = breaks,
     probability = TRUE,
     col = "lightblue",
     main = "Histogram of Sale Prices with Normal Curve",
     xlab = "Sale Price")

curve(dnorm(x, mean = mean_price, sd = sd_price),
      col = "darkblue",
      lwd = 2,
      add = TRUE) 

##shapiro wilk test for normality. this test is appropriate for small sample size we have n=30 size
shapiro_test <- shapiro.test(housing_sample$SalePrice)
shapiro_test
#if p-value < 0.05 we reject the null hypothesis ,data is not normally distributed.
#if p-value > 0.05 we fail to reject the null ,data is approximately norma.

##pearson skewness coefficient
library(e1071)  
skewness(housing_sample$SalePrice)    #we can already see from the histogram that this data is rightly skewed. 


set.seed(42)
sample_means <- replicate(1000, {
  sample <- sample(housing_small$SalePrice, size = 30, replace = TRUE)
  mean(sample)
})

#the Central Limit Theorem was shown with the sample average graph.
hist(sample_means,
     probability = TRUE,
     main = "Sample Means Histogram (Central Limit Theorem)",
     xlab = "Sample Means",
     col = "blue")

curve(dnorm(x, mean = mean(mean_price), sd = sd(sd_price)),
      add = TRUE,
      col = "red",
      lwd = 2)


###6-CONFIDENCE INTERVALS & SAMPLE SIZE

##computing t-distribution, degrees of freedom 
n <- nrow(housing_sample)
df <- n - 1
df
t_calculated <- qt(0.975, df)  #critical t-value for 95% confidence interval

##margin of error
error_margin <- qt(0.975, df) * sd_price / sqrt(n)
lower_bound <- mean_price - error_margin
upper_bound <- mean_price + error_margin

##confidence intervals for mean and proportion
mean_price <- mean(housing_sample$SalePrice)        #95% confidence interval for mean
sd_price <- sd(housing_sample$SalePrice)

p_hat <- mean(housing_sample$`Garage Cars` >= 1)
n <- nrow(housing_sample)
z <- qnorm(0.975)                                   #z-value for the 95% confidence intereval

cat("95% confidence interval for mean sale price:",  "\n")
cat("[", lower_bound, ",", upper_bound, "]\n")


error_prop <- z * sqrt((p_hat * (1 - p_hat)) / n)
ci_prop <- c(p_hat - error_prop, p_hat + error_prop)

cat("95% Confidence Interval for Proportion of Houses with Garage:", ci_prop , "\n")


###7-HYPOTHESIS TESTING

##p-value method
p_value <- 2 * pt(-abs(t_calculated), df)
cat("p-value:", p_value, "\n")

if (p_value < 0.05) {
  cat("Reject H0 (p-value < 0.05)\n")
} else {
  cat("Fail to Reject H0 (p-value ≥ 0.05)\n")
}

##confidence interval method
mu_0 <- 200000   #null hypothesis mean

error_margin <- qt(0.975, df) * sd_price / sqrt(n)
lower_bound <- mean_price - error_margin
upper_bound <- mean_price + error_margin

cat("95% Confidence Interval for Mean:\n")
cat("[", lower_bound, ",", upper_bound, "]\n")

#Decision:
if (mu_0 < lower_bound | mu_0 > upper_bound) {
  cat("Reject H0: 200,000 is NOT in the interval\n")
} else {
  cat("Fail to Reject H0: 200,000 is in the interval\n")
}

##traditional method
alpha <- 0.05
t_critical <- qt(1 - alpha / 2, df)   #critical t-value for two tailed test

cat("Test Statistic (t_calculated):", t_calculated, "\n")
cat("Critical Value (±t):", -t_critical, "to", t_critical, "\n")

#decision
if (abs(t_calculated) > t_critical) {
  cat("Reject H0: |t_calculated| > t_critical\n")
} else {
  cat("Fail to Reject H0: |t_calculated| ≤ t_critical\n")
}


###8-TESTING THE DIFFFERENCE BETWEEN TWO MEANS
##independent sample tests
colnames(housing_sample)[colnames(housing_sample) == "House Style"] <- "HouseStyle"

#selecting just 1Story and 2Story houses from the dataset 
subset_data <- housing_sample %>%
  filter(HouseStyle %in% c("1Story", "2Story"))    #filtering out the others
t_test_result <- t.test(SalePrice ~ HouseStyle, data = subset_data) #is there any statistical difference between the prices of 1story and 2story houses
t_test_result

table(subset_data$HouseStyle, subset_data$`Garage Cars` >= 1) #Is the ratio of having garages or not is different with 1story and 2story houses
garage_table <- table(subset_data$HouseStyle, subset_data$`Garage Cars` >= 1)
garage_table

x1 <- garage_table["1Story", "TRUE"]    #1Story houses wit garage
x2 <- garage_table["2Story", "TRUE"]    #2Story houses with garage
n1 <- sum(garage_table["1Story", ])     #number of all 1Story houses
n2 <- sum(garage_table["2Story", ])     #number of all 2Sory houses

#Prop test to test "proportion of 1Storu houses with garage≠ 2Story houses with garage"
prop_test_result <- prop.test(x = c(x1, x2), n = c(n1, n2))
prop_test_result

#Variance Test to "proportion of 1Story houses with garage≠ 2Story houses with garage"
var_test_result <- var.test(SalePrice ~ HouseStyle, data = subset_data)
var_test_result


###9-CORRELATION AND REGRESSION

#correlation analysis with Pearson CC
correlation <- cor(housing_sample$`Gr Liv Area`, housing_sample$SalePrice) #close to +1 → strong positive
correlation                                                                #close to 0 → no relationship

#applying cor.test() to analyse hypothesis test too. 
cor_test_result <- cor.test(housing_sample$`Gr Liv Area`, housing_sample$SalePrice)
cor_test_result

                                                                           
#Regression Line (Simple Linear Regression)
model <- lm(SalePrice ~ `Gr Liv Area`, data = housing_sample)
summary(model)

#Scatter Plot + Regression Line
plot(housing_sample$`Gr Liv Area`, housing_sample$SalePrice,
     main = "Scatter Plot with Regression Line",
     xlab = "Gr Liv Area", ylab = "Sale Price",
     col = "blue", pch = 19)
abline(model, col = "red", lwd = 2)

#residuals plotting
plot(model$residuals,
     main = "Residual Plot",
     ylab = "Residuals",
     xlab = "Observation Index",
     col = "purple", pch = 16)
abline(h = 0, col = "red", lty = 2)

#calculating coefficient of determination(R^2), adjusted R^2, and standard error of estimate
model_summary <- summary(model)
r_squared <- model_summary$r.squared
adjusted_r_squared <- model_summary$adj.r.squared
standard_error <- model_summary$sigma  # Residual standard error

cat("R-squared:", r_squared, "\n")
cat("Adjusted R-squared:", adjusted_r_squared, "\n")
cat("Standard Error of Estimate:", standard_error, "\n")


###10-OTHER CHI SQUARE TESTS

##Chi-Square Goodness of Fit Test
garage_counts <- table(housing_sample$`Garage Cars`)  
chisq.test(garage_counts)

##Chi-Square Test for Independence
garage_binary <- ifelse(housing_sample$`Garage Cars` >= 1, "Yes", "No")
contingency_table <- table(housing_sample$Neighborhood, garage_binary)
chisq.test(contingency_table)


###11-ANALYSIS OF VARIANCE ANOVA

##tidying the column names and make it categorical
colnames(housing_sample)[which(names(housing_sample) == "House Style")] <- "HouseStyle"
housing_sample$HouseStyle <- as.factor(housing_sample$HouseStyle)

##applying one way anova
oneway <- aov(SalePrice ~ HouseStyle, data = housing_sample)
summary(oneway)
#we didnt get a meaningful result with anova but still we applied Tukey test for explanatory
TukeyHSD(oneway)

table(housing_sample$`HouseStyle`)


###12-NON PARAMETRIC STATISTICS

##spearman rank correlation
spearman <- cor.test(housing_sample$`Gr Liv Area`, housing_sample$SalePrice, method = "spearman")
spearman
##wilcoxon signed rank Test
wilcox <- wilcox.test(housing_sample$`Gr Liv Area`, housing_sample$`TotRms AbvGrd`, paired = TRUE)
wilcox
