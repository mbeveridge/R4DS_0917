library(tidyverse)

----------
# SECTION 7 [Chapter 5 hardcopy]
# 7.3.4 Exercises
  
# Q1.
# Explore the distribution of each of the x, y, and z variables in diamonds. What do you learn?
# Think about a diamond and how you might decide which dimension is the length, width, and depth

# A1.
ggplot(data = diamonds) + 
  geom_histogram(mapping = aes(x = x), binwidth = 0.5)

ggplot(data = diamonds) + 
  geom_histogram(mapping = aes(x = y), binwidth = 0.5) +
  coord_cartesian(xlim = c(0, 10))

ggplot(data = diamonds) + 
  geom_histogram(mapping = aes(x = z), binwidth = 0.5) +
  coord_cartesian(xlim = c(0, 10))

# The distributions are right-skewed, with double peaks. y & z have a few outliers. z is smallest
# average, so I assume is 'depth'. Can't see difference between x & y, so which is length & width ?
?diamonds
# "Prices of 50,000 round cut diamonds"
# "x length in mm (0–10.74), y width in mm (0–58.9), z depth in mm (0–31.8)"


# Q2.
# Explore the distribution of price. Do you discover anything unusual or surprising?
# (Hint: Carefully think about the binwidth and make sure you try a wide range of values)

# A2.
ggplot (data = diamonds, mapping = aes(x = price)) +
  geom_histogram()

ggplot (data = diamonds, mapping = aes(x = price)) +
  geom_histogram(binwidth = 100)

ggplot (filter(diamonds, price < 2000), mapping = aes(x = price)) +
  geom_histogram(binwidth = 10)

# "price in US dollars (\$326–\$18,823)"
# Sharp climb to peak ~$700, then exponential decay, with 'bump' (~$1700 and) at ~$4300
# Zero diamonds in price band  ~$1460-1540

  
# Q3.
# How many diamonds are 0.99 carat? How many are 1 carat?
# What do you think is the cause of the difference?
diamonds %>%
  filter(carat >= 0.9, carat <= 1.1) %>%
  count(carat) %>%
  head(20)

ggplot(data = diamonds, mapping = aes(x = carat)) +
  geom_histogram(binwidth = .01) +
  coord_cartesian(xlim = c(0.9, 1.1))

# 23 diamonds are 0.99 carat. 1558 diamonds are 1 carat
# Diamonds at 1 carat (just 0.01 more, and smallest $increase possible) are disproportionately more
# attractive than 0.99 in 'marketing/label/psychological' terms to the gifter & recipient (demand),
# so more are available to purchase (supply)


# Q4.
# Compare and contrast coord_cartesian() vs xlim() or ylim() when zooming in on a histogram.
# What happens if you leave binwidth unset?
# What happens if you try and zoom so only half a bar shows?

# A4.
# The question relates to using them inside coord_cartesian() v's using them in ggplot()...
# s7.3.3 : coord_cartesian() has xlim() & ylim() arguments for when you need to zoom into the x-axis.
# ggplot2 also has xlim() and ylim() functions that work slightly differently: they throw away the
# data outside the limits

ggplot(data = diamonds, mapping = aes(x = carat)) +
  geom_histogram() +
  coord_cartesian(xlim = c(0.5, 1.5), ylim = c(1000, 2000))
# coord_cartesian simply zooms in on the area specified by the limits. In this example (with binwidth
# unset), 7 of the default 'bins = 30' are visible (as fat 'half' bars)

?ylim
ggplot(data = diamonds, mapping = aes(x = carat)) +
  geom_histogram() +
  xlim(0.5, 1.5)
  ylim(1000, 2000)
# However, the xlim and ylim functions first drop any values outside the limits (the ylim doesn’t
# matter in this case?), then calculates the histogram. So 30 narrow bars are visible at 'full' height
# (but some of the previous counts will now be missing)


----------
# SECTION 7 [Chapter 5 hardcopy]
# 7.4.1 Exercises

# Q1.
# What happens to missing values in a histogram?
# What happens to missing values in a bar chart?
# Why is there a difference?

# A1.
ggplot(data = nycflights13::flights, mapping = aes(x = dep_delay)) +
  geom_histogram()
# "Warning message: Removed 8255 rows containing non-finite values (stat_bin)."
# NA values can't be placed in a particular bin, as their numeric values are unknown. They are removed

ggplot(data = nycflights13::flights, mapping = aes(x = dep_delay)) +
  geom_bar()
# "Warning message: Removed 8255 rows containing non-finite values (stat_count)."
# Same warning. But we'd used a continuous variable again (just not binned). Try categorical...

nycflights13::flights %>%
  mutate(carrier = ifelse(carrier == "AA", NA, carrier)) %>%
  ggplot(mapping = aes(x = carrier)) +
  geom_bar()
# We artificially made one carrier NA. (Easier than finding a categorical variable with NAs already)

# "Histograms omit missing values, whereas bar charts draw them as a separate category. For continuous
# variables, like in a histogram, there is no meaningful location to draw missing values ... But for
# bar charts, which are used for categorical variables, you could draw them as a distinct bar; ...
# (conventionally it is drawn on the right side). You can override this default to completely remove
# missing values from the chart if you prefer" -- http://cfss.uchicago.edu/r4ds_solutions.html


# Q2. What does na.rm = TRUE do in mean() and sum()?
# A2. It removes NA values, before calculating the mean and sum


----------
# SECTION 7 [Chapter 5 hardcopy]
# 7.5.1.1 Exercises

# Q1.
# Use what you’ve learned to improve the visualisation of the departure times of cancelled vs.
# non-cancelled flights

# s7.4
nycflights13::flights %>% 
  mutate(
    cancelled = is.na(dep_time),
    sched_hour = sched_dep_time %/% 100,
    sched_min = sched_dep_time %% 100,
    sched_dep_time = sched_hour + sched_min / 60
  ) %>% 
  ggplot(mapping = aes(sched_dep_time)) + 
  geom_freqpoly(mapping = aes(colour = cancelled), binwidth = 1/4)

# A1.
# "density, which is the count standardised so that the area under each frequency polygon is one"
nycflights13::flights %>% 
  mutate(
    cancelled = is.na(dep_time),
    sched_hour = sched_dep_time %/% 100,
    sched_min = sched_dep_time %% 100,
    sched_dep_time = sched_hour + sched_min / 60
  ) %>% 
  ggplot(mapping = aes(x = sched_dep_time, y = ..density..)) + 
  geom_freqpoly(mapping = aes(colour = cancelled), binwidth = 1/4)

# boxplot
nycflights13::flights %>% 
  mutate(
    cancelled = is.na(dep_time),
    sched_hour = sched_dep_time %/% 100,
    sched_min = sched_dep_time %% 100,
    sched_dep_time = sched_hour + sched_min / 60
  ) %>% 
  ggplot(mapping = aes(x = cancelled, y = sched_dep_time)) +
  geom_boxplot()


# Q2.
# What variable in the diamonds dataset is most important for predicting the price of a diamond?
# How is that variable correlated with cut?
# Why does the combination of those two relationships lead to lower quality diamonds being more expensive?
? diamonds # price, carat, cut, color, clarity, x, y, z, depth, table

# A2. 
ggplot(data = diamonds, mapping = aes(x = carat, y = price)) +
  geom_point() +
  geom_smooth()
# cut, color, clarity are categorical variables. depth and table not visibly correlated with price
# Assume carat/weight is most important for predicting price. (Because haven't done stats yet in R4DS)

ggplot(data = diamonds, mapping = aes(x = cut, y = carat)) +
  geom_boxplot()
# (Median) average size of Fair & Good cuts is higher than VeryGood & Ideal (and close to Premium).
# We said that carat is most important for predicting price, so large lower quality diamonds are more
# expensive than small higher quality. And the same might be true on average (?)


# Q3.
# Install the ggstance package, and create a horizontal boxplot.
# How does this compare to using coord_flip()?

install.packages("ggstance") # Not available in Anaconda Navigator, to install
library(ggstance)
?ggstance # Showed nothing

# s7.5.1 coord_flip()
ggplot(data = mpg) +
  geom_boxplot(mapping = aes(x = reorder(class, hwy, FUN = median), y = hwy)) +
  coord_flip()

# A3.
ggplot(data = mpg) +
  geom_boxploth(mapping = aes(x = hwy, y = reorder(class, hwy, FUN = median)))
# Output is the same, but the order of x & y is different (and 'right' now). With coord_flip(), it
# was the order as if for vertical boxplots


# Q4.
# One problem with boxplots is that they were developed in an era of much smaller datasets and tend
# to display a prohibitively large number of “outlying values”. One approach to remedy this problem
# is the letter value plot. Install the lvplot package, and try using geom_lv() to display the
# distribution of price vs cut. What do you learn? How do you interpret the plots?

install.packages("lvplot") # Not available in Anaconda Navigator, to install
library(lvplot)
?lvplot # Showed nothing

# s7.5.1 boxplot
ggplot(data = diamonds, mapping = aes(x = cut, y = price)) +
  geom_boxplot()

# A5.
ggplot(data = diamonds, mapping = aes(x = cut, y = price)) +
  geom_lv()
# 
# "The boxes of the letter-value plot correspond to many more quantiles. They are useful for larger
# datasets because (1) larger datasets can give precise estiamtes of quantiles beyond the quartiles
# (2) in expectation, larger datasets should have many more outliers"

# The letter-value plot is described in:
# Heike Hofmann, Karen Kafadar, and Hadley Wickham. 2011. “Letter-value plots: Boxplots for large data”
# http://vita.had.co.nz/papers/letter-value-plot.pdf ...<See: P5, 10-12>

# -- https://jrnold.github.io/e4qf/exploratory-data-analysis.html#a-categorical-and-continuous-variable


# Q5.
# Compare and contrast geom_violin() with a facetted geom_histogram(), or a coloured geom_freqpoly().
# What are the pros and cons of each method?

# A5.
# geom_violin()
ggplot(data = diamonds, mapping = aes(x = cut, y = price)) +
  geom_violin() +
  coord_flip()

# geom_histogram() ...faceted
ggplot(data = diamonds, mapping = aes(x = price)) +
  geom_histogram() +
  facet_grid(cut~.)
#The geom_violin and faceted geom_histogram have similar strengths & weaknesses.
# It's easy to visually distinguish differences in the overall shape of distributions (skewness,
# central values, variance, etc). However, it isn't easy to compare their vertical values

# geom_freqpoly() ...coloured
ggplot(data = diamonds, mapping = aes(x = price, y = ..density.., colour = cut)) +
  geom_freqpoly()
# geom_freqpoly is better for look-up: given a price, it's easy to tell which cut has highest density.
# However, overlapping lines make it difficult to see how overall distributions compare

# (They all depend on tuning parameters to determine the smoothness of the distribution)


# Q6.
# If you have a small dataset, it’s sometimes useful to use geom_jitter() to see the relationship
# between a continuous and categorical variable. The ggbeeswarm package provides a number of methods
# similar to geom_jitter(). List them and briefly describe what each one does

install.packages("ggbeeswarm") # Not available in Anaconda Navigator, to install
library(ggbeeswarm)

?ggbeeswarm
# https://github.com/eclarke/ggbeeswarm
# Beeswarm plots (aka column scatter plots or violin scatter plots) are a way of plotting points that
# would ordinarily overlap so that they fall next to each other instead

# ggbeeswarm provides two different methods to create beeswarm-style plots using ggplot2. It does this
# by adding two new ggplot geom objects:
  
# geom_quasirandom: produces plots that resemble something between jitter and violin.There are several
# different methods that determine exactly how the random location of the points is generated.
# (<default>, method="tukey", ="tukeyDense", ="frowney", ="smiley", ="pseudorandom")

# geom_beeswarm: creates a shape similar to a violin plot, but by offsetting the points


----------
# SECTION 7 [Chapter 5 hardcopy]
# 7.5.2.1 Exercises

# Q1.
# How could you rescale the count dataset above to more clearly show the distribution of cut
# within colour, or colour within cut?

# s7.5.2
diamonds %>% 
  count(color, cut) %>%  
  ggplot(mapping = aes(x = color, y = cut)) +
  geom_tile(mapping = aes(fill = n))

# A1.
# "To clearly show the distribution of cut within color, calculate a new variable 'prop' which is the
# proportion of each cut within a color. This is done using a grouped mutate"

# distribution of cut within colour
diamonds %>% 
  count(color, cut) %>%
  group_by(color) %>%                           # Note: group_by() ...sum() of each group is 1
  mutate(prop = n / sum(n)) %>%                 # Note: calculate proportion ...n/sum(n)
  ggplot(mapping = aes(x = color, y = cut)) +
  geom_tile(mapping = aes(fill = prop))         # Note: fill = prop ...instead of count

# distribution of colour within cut
diamonds %>% 
  count(color, cut) %>%
  group_by(cut) %>%                           # Note: group_by() ...cut. Each row totals to 1
  mutate(prop = n / sum(n)) %>%
  ggplot(mapping = aes(x = color, y = cut)) +
  geom_tile(mapping = aes(fill = prop)) 


# Q2.
# Use geom_tile() together with dplyr to explore how average flight delays vary by destination
# and month of year. What makes the plot difficult to read? How could you improve it?

# A2.
library(nycflights13)
nycflights13::flights %>%
  group_by(month, dest) %>%      # Note: without this, got respective'object not found' errors from aes()
  summarise(dep_delay = mean(dep_delay, na.rm = TRUE)) %>%
  ggplot(mapping = aes(x = factor(month), y = dest, fill = dep_delay)) +  # Note: factor(month) for integers on axis
  geom_tile()

# Several things could be done to improve it :
# 1. sort destinations by a meaningful quantity (distance, number of flights, average delay)
# 2. remove missing values (airports which don’t have at least one flight each month from NYC)
# 3. better color scheme (viridis)
# https://jrnold.github.io/e4qf/exploratory-data-analysis.html#two-categorical-variables


# Q3.
# Why is it slightly better to use aes(x = color, y = cut) rather than aes(x = cut, y = color)
# in the example above?

# A3.
# Labels for 'color' are single letters (D, E, F, etc), so no overlapping if they're on x-axis
# (though in this case, there are few enough categories that there is no overlapping anyway).
# Another possibility is that it shows the plot colours in the same order as in legend ...(group_by(color))


----------
# SECTION 7 [Chapter 5 hardcopy]
# 7.5.3.1 Exercises

# Q1.
# Instead of summarising the conditional distribution with a boxplot, you could use a frequency polygon.
# What do you need to consider when using cut_width() vs cut_number()?
# How does that impact a visualisation of the 2d distribution of carat and price?

# A1.
# cut_width(x, width) divides 'x' into bins of width 'width'.
# (...Can make boxplot width proportional to the number of points with varwidth = TRUE.)
# cut_number() displays approximately the same number of points in each bin

# Using cut_width, the number in each bin may be unequal. 'carat' is right skewed so there are few diamonds in those bins <colours>
ggplot(data = diamonds, mapping = aes(x = price, colour = cut_width(carat, 0.3))) + geom_freqpoly()
# Plotting the density instead of counts will make the distributions comparable <same area>, although the bins with few observations will still be hard to interpret
ggplot(data = diamonds, mapping = aes(x = price, y = ..density.., colour = cut_width(carat, 0.3))) + geom_freqpoly()
# <Using cut_number is easy to interpret in this case>
ggplot(data = diamonds, mapping = aes(x = price, colour = cut_number(carat, 10))) + geom_freqpoly()
# (And shape would remains the same if '..density..' was used)
# https://jrnold.github.io/e4qf/exploratory-data-analysis.html#two-continuous-variables


# Q2. Visualise the distribution of carat, partitioned by price

# A2.
# eg. eg. 'cut_number' : 10 bins with the same number of observations
ggplot(diamonds, aes(x = cut_number(price, 10), y = carat)) +
  geom_boxplot() +
  coord_flip()

# eg. 'cut_width' : bins of $2,000; box width related to number of observations. (boundary = 0 ensures first bin is $0–$2,000)
ggplot(diamonds, aes(x = cut_width(price, 2000, boundary = 0), y = carat)) +
  geom_boxplot(varwidth = TRUE) +
  coord_flip()


# Q3.
# How does the price distribution of very large diamonds compare to small diamonds.
# Is it as you expect, or does it surprise you?

# A3.
# From looking at the plots in A2 [above] : small carat values (mostly) sit in specific price bins, but
# v large carats (>3 say) are 'equally' likely to sit in several. For 'v large', other characteristics
# might determine which bin (eg. cut, clarity, colour); but it's also true that the sample size is small,
# the market possibly volatile (scarcity), and a $2000 variation proportionally less significant


# Q4.
# Combine two of the techniques you’ve learned to visualise the combined distribution
# of cut, carat, and price.

# A4.
# There’s lots of options to try -- https://jrnold.github.io/e4qf/exploratory-data-analysis.html#two-continuous-variables
ggplot(diamonds, aes(x = cut_number(carat, 10), y = price, color = cut)) +
  geom_boxplot()
# Relates to A3 [above]. It shows 'cut' affecting price, and most clearly in the 'largest carat bin'
# ...but that includes most diamonds above ~1.5, if we use 'cut_number' (=10 bins)
# ...and it mostly just shows that cut=Fair is a step below the other cuts

ggplot(diamonds, aes(x = cut_width(carat, 1, boundary = 0), y = price, color = cut)) +
  geom_boxplot(varwidth = FALSE)
# Using 'cut_width' (=$2000 bins), there is NOT a clear correlation between 'cut' and price


# Q5.
# Two dimensional plots reveal outliers that are not visible in one dimensional plots.
# For example, some points in the plot below have an unusual combination of x and y values, which
# makes the points outliers even though their x and y values appear normal when examined separately.

ggplot(data = diamonds) +
  geom_point(mapping = aes(x = x, y = y)) +
  coord_cartesian(xlim = c(4, 11), ylim = c(4, 11))
# Why is a scatterplot a better display than a binned plot for this case?

# A5.
# Most data points are along a tight line (which is clear). We are interested in the outliers, and
# whether they reveal more insight/ pattern/ error. By aggregating/binning the (few) outliers, we'd lose
# detail of how much they disagree with the main data, and whether they have clusters