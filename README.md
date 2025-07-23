## House Price Prediction Project

Hi! I’m Aslınur, an AI engineering student, and this repository is where I share my statistics course project. For one of my classes we were asked to pick a real dataset, explore it using the tools we had learned and tell a story with the numbers. Being a bit of a data nerd, I chose the Ames Housing dataset – a rich collection of almost 3 000 home sales from Ames, Iowa – to see what really drives house prices.

What’s in this repo?
statisticsproject_Rcoding.R – the raw R script I wrote to load the data, sample 30 houses and run a bunch of analyses: plotting histograms, calculating averages and variances, checking whether the data look normal, building confidence intervals, performing hypothesis tests and even fitting a simple regression. The code is heavily commented so you can follow along with my thought process.

*** house-pricing-en.Rmd – an R Markdown version of the same analysis with narrative text sprinkled between the code blocks. If you open this in RStudio and hit Knit, it will produce a neat HTML report with all the plots and explanations in one place.

*** housing_sample_30.csv – the 30‑row sample that my script draws from the full dataset. Including this file ensures anyone can reproduce exactly the same results without downloading the entire dataset.

*** Ameshousing dataset link.rtf – a tiny file with a link to the original data on Kaggle, in case you want to grab the full CSV yourself.

Why the Ames dataset?
I wanted a dataset with enough variables to be interesting but not so many that I’d get lost. Ames Housing includes things like lot area, living space, overall quality, number of bathrooms, garage size and more. It also has a known “house price” target, so it’s perfect for practising both exploratory statistics and basic predictive modelling. Most importantly it is a tidied dataset. You can find the full dataset here: 
https://www.kaggle.com/datasets/shashanknecrothapa/ames-housing-dataset.

?? How to run my analysis
Make sure you have R installed along with these packages: readr, dplyr, e1071, ggplot2, knitr and rmarkdown. You can install any missing ones with install.packages().
Download the full AmesHousing.csv from Kaggle and update the file path in the scripts if needed (I read mine from  
~/Downloads/AmesHousing.csv).

  To see the results as a report, open house-pricing-en.Rmd in RStudio and click Knit. RStudio will run the code and generate an HTML       file that combines the code, output and my commentary.

 If you prefer to run the code line by line, open statisticsproject_Rcoding.R in RStudio or another R IDE and source it. The console       output will guide you through each step.

# Working through this project taught me a lot of practical statistics:
- Exploratory data analysis – the sale prices in Ames are right‑skewed; most houses sell in the mid range with a few very high outliers. -- Using Sturges’ rule helped me choose sensible histogram bins.
- Descriptive measures – calculating the mean, median and an estimated mode gave me a feel for the “typical” house price, while the standard deviation and coefficient of variation showed how spread out prices are.
- Normality and outliers – overlaying a normal curve and running a Shapiro–Wilk test revealed the data aren’t perfectly normal; the skewness statistic backed that up. Boxplots highlighted some unusually expensive homes.
- Inference – I built 95 % confidence intervals for the mean sale price and the proportion of houses with at least one garage, and did a t‑test to see if the mean price differs from a hypothesised value.
- Relationships between variables – plotting living area against sale price and fitting a simple linear regression showed a strong positive relationship (bigger houses cost more!), and I looked at how house style and garage availability affect price using ANOVA and chi‑square tests.
- Overall this was a fun way to apply the statistical techniques I learned in class to a real dataset. If you have any suggestions, spot a mistake or just want to chat about statistics and machine learning, feel free to open an issue or reach out on LinkedIn!
