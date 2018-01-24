# SECTION 4 [Chapter 2 hardcopy]
# 4.4 Practice

# Q1. Why does this code not work?
my_variable <- 10
my_varıable

# A1. typo with 'i'


# Q2. Tweak each of the following R commands so that they run correctly:
library(tidyverse)

ggplot(dota = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))

fliter(mpg, cyl = 8)
filter(diamond, carat > 3)

# A2.
library(tidyverse)

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))

filter(mpg, cyl == 8)
filter(diamonds, carat > 3)


# Q3. Press Alt + Shift + K. What happens?
# How can you get to the same place using the menus?

# A3.
# popup of Keyboard Shortcut Reference
# Help > Keyboard Shortcuts Help

# ------------------------------------------------------------------------------

# SECTION 6 [Chapter 4 hardcopy]
# 6.3 Practice

# Q1. Go to the RStudio Tips twitter account, https://twitter.com/rstudiotips and find one tip
# that looks interesting. Practice using it!


# Q2. What other common mistakes will RStudio diagnostics report?
# Read https://support.rstudio.com/hc/en-us/articles/205753617-Code-Diagnostics to find out