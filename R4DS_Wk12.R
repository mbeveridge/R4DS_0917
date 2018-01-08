library(tidyverse)

----------
# SECTION 23 [Chapter 18 hardcopy] : MODEL BASICS
# 23.2.1 Exercises

# Q1.
# One downside of the linear model is that it is sensitive to unusual values because the distance incorporates a
# squared term.
# Fit a linear model to the simulated data below, and visualise the results.
# Rerun a few times to generate different simulated datasets. What do you notice about the model?

sim1a <- tibble(
  x = rep(1:10, each = 3),
  y = x * 1.5 + 6 + rt(length(x), df = 2)
)

# A1.


# Q2.
# One way to make linear models more robust is to use a different distance measure. For example, instead of
# root-mean-squared distance, you could use mean-absolute distance:
  
measure_distance <- function(mod, data) {
  diff <- data$y - make_prediction(mod, data)
  mean(abs(diff))
}
# Use optim() to fit this model to the simulated data above and compare it to the linear model.

# A2.


# Q3.
# One challenge with performing numerical optimisation is that it’s only guaranteed to find one local optima.
# What’s the problem with optimising a three parameter model like this?

model1 <- function(a, data) {
  a[1] + data$x * a[2] + a[3]
}

# A3.


----------
# SECTION 23 [Chapter 18 hardcopy] : MODEL BASICS
# 23.3.3 Exercises

# Q1.
# Instead of using 'lm()' to fit a straight line, you can use 'loess()' to fit a smooth curve. Repeat the process of
# model fitting, grid generation, predictions, and visualisation on 'sim1' using 'loess()' instead of 'lm()'.
# How does the result compare to 'geom_smooth()'?

# A1.


# Q2.
# 'add_predictions()' is paired with 'gather_predictions()' and 'spread_predictions()'.
# How do these three functions differ?

# A2.


# Q3.
# What does geom_ref_line() do? What package does it come from?
# Why is displaying a reference line in plots showing residuals useful and important?

# A3.


# Q4.
# Why might you want to look at a frequency polygon of absolute residuals?
# What are the pros and cons compared to looking at the raw residuals?

# A4.


----------
# SECTION 23 [Chapter 18 hardcopy] : MODEL BASICS
# 23.4.5 Exercises

# Q1.
# What happens if you repeat the analysis of 'sim2' using a model without an intercept.
# What happens to the model equation? What happens to the predictions?

# A1.


# Q2.
# Use 'model_matrix()' to explore the equations generated for the models I fit to 'sim3' and 'sim4'.
# Why is '*' a good shorthand for interaction?

# A2.


# Q3.
# Using the basic principles, convert the formulas in the following two models into functions.
# (Hint: start by converting the categorical variable into 0-1 variables.)
mod1 <- lm(y ~ x1 + x2, data = sim3)
mod2 <- lm(y ~ x1 * x2, data = sim3)

# A3.


# Q4.
# For 'sim4', which of 'mod1' and 'mod2' is better? I think mod2 does a slightly better job at removing patterns,
# but it’s pretty subtle.
# Can you come up with a plot to support my claim?


----------
# SECTION 24 [Chapter 19 hardcopy] : MODEL BUILDING
# 24.2.3 Exercises

# Q1. In the plot of 'lcarat' vs. 'lprice', there are some bright vertical strips. What do they represent?

# A1.


# Q2. If 'log(price) = a_0 + a_1 * log(carat)', what does that say about the relationship between 'price' and 'carat'?

# A2.


# Q3.
# Extract the diamonds that have very high and very low residuals. Is there anything unusual about these diamonds?
# Are theY particularly bad or good, or do you think these are pricing errors?

# A3.


# Q4.
# Does the final model, 'mod_diamonds2', do a good job of predicting diamond prices?
# Would you trust it to tell you how much to spend if you were buying a diamond?

# A4.


----------
# SECTION 24 [Chapter 19 hardcopy] : MODEL BUILDING
# 24.3.5 Exercises

# Q1.
# Use your Google sleuthing skills to brainstorm why there were fewer than expected flights on Jan 20, May 26, and Sep 1.
# (Hint: they all have the same explanation.) How would these days generalise to another year?

# A1.


# Q2.
# What do the three days with high positive residuals represent? How would these days generalise to another year?
daily %>% 
  top_n(3, resid)
#> # A tibble: 3 × 5
#>         date     n  wday resid   term
#>       <date> <int> <ord> <dbl> <fctr>
#> 1 2013-11-30   857   Sat 112.4   fall
#> 2 2013-12-01   987   Sun  95.5   fall
#> 3 2013-12-28   814   Sat  69.4   fall

# A2.


# Q3.
# Create a new variable that splits the 'wday' variable into terms, but only for Saturdays,
# i.e. it should have 'Thurs', 'Fri', but 'Sat-summer', 'Sat-spring', 'Sat-fall'.
# How does this model compare with the model with every combination of wday and term?

# A3.


# Q4.
# Create a new 'wday' variable that combines the day of week, term (for Saturdays), and public holidays.
# What do the residuals of that model look like?

# A4.


# Q5.
# What happens if you fit a day of week effect that varies by month (i.e. 'n ~ wday * month')?
# Why is this not very helpful?

# A5.


# Q6.
# What would you expect the model 'n ~ wday + ns(date, 5)' to look like?
# Knowing what you know about the data, why would you expect it to be not particularly effective?

# A6.


# Q7.
# We hypothesised that people leaving on Sundays are more likely to be business travellers who need to be somewhere
# on Monday. Explore that hypothesis by seeing how it breaks down based on distance and time:
# if it’s true, you’d expect to see more Sunday evening flights to places that are far away

# A7.


# Q8.
# It’s a little frustrating that Sunday and Saturday are on separate ends of the plot.
# Write a small function to set the levels of the factor so that the week starts on Monday


----------
# SECTION 25 [Chapter 20 hardcopy] : MANY MODELS
# 25.2.5 Exercises

# Q1.
# A linear trend seems to be slightly too simple for the overall trend.
# Can you do better with a quadratic polynomial? How can you interpret the coefficients of the quadratic?
# (Hint you might want to transform 'year' so that it has mean zero.)

# A1.


# Q2.
# Explore other methods for visualising the distribution of 'R squared'  per continent.
# You might want to try the 'ggbeeswarm' package, which provides similar methods for avoiding overlaps as jitter,
# but uses deterministic methods

# A2.


# Q3.
# To create the last plot (showing the data for the countries with the worst model fits), we needed two steps:
# we created a data frame with one row per country and then semi-joined it to the original dataset.
# It’s possible avoid this join if we use 'unnest()' instead of 'unnest(.drop = TRUE)'. How?

# A3.


----------
# SECTION 25 [Chapter 20 hardcopy] : MANY MODELS
# 25.4.5 Exercises

# Q1. List all the functions that you can think of that take a atomic vector and return a list

# A1.


# Q2. Brainstorm useful summary functions that, like 'quantile()', return multiple values.

# A2.


# Q3.
# What’s missing in the following data frame?
# How does 'quantile()' return that missing piece? Why isn’t that helpful here?
mtcars %>% 
  group_by(cyl) %>% 
  summarise(q = list(quantile(mpg))) %>% 
  unnest()
#> # A tibble: 15 × 2
#>     cyl     q
#>   <dbl> <dbl>
#> 1     4  21.4
#> 2     4  22.8
#> 3     4  26.0
#> 4     4  30.4
#> 5     4  33.9
#> 6     6  17.8
#> # ... with 9 more rows

# A3.


# Q4.
# What does this code do? Why might might it be useful?
mtcars %>% 
  group_by(cyl) %>% 
  summarise_each(funs(list))

# A4.


----------
# SECTION 25 [Chapter 20 hardcopy] : MANY MODELS
# 25.5.3 Exercises

# Q1. Why might the 'lengths()' function be useful for creating atomic vector columns from list-columns?

# A1.


# Q2. List the most common types of vector found in a data frame. What makes lists different?

# A2.

