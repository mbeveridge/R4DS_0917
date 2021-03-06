library(tidyverse)

----------
# SECTION 20 [Chapter 16 hardcopy] : VECTORS
# 20.3.5 Exercises

# Q1. Describe the difference between 'is.finite(x)' and '!is.infinite(x)'
?is.finite()
?is.infinite()
# A1. "Error in file(out, "wt") : cannot open the connection" -- Help


# Q2. Read the source code for 'dplyr::near()' (Hint: to see the source code, drop the ()). How does it work?
?dplyr::near()
?dplyr::near
# A2. "Error in file(out, "wt") : cannot open the connection" -- Help


# Q3.
# A logical vector can take 3 possible values. How many possible values can an integer vector take?
# How many possible values can a double take? Use google to do some research

# A3.


# Q4. Brainstorm at least four functions that allow you to convert a double to an integer. How do they differ? Be precise
# A4.


# Q5. What functions from the readr package allow you to turn a string into logical, integer, and double vector?
# A5.


----------
# SECTION 20 [Chapter 16 hardcopy] : VECTORS
# 20.4.6 Exercises

# Q1. What does 'mean(is.na(x))' tell you about a vector x? What about 'sum(!is.finite(x))' ?
# A1.


# Q2.
# Carefully read the documentation of 'is.vector()'. What does it actually test for?
# Why does is.atomic() not agree with the definition of atomic vectors above?

# A2.


# Q3. Compare and contrast 'setNames()' with 'purrr::set_names()'.
# A3.


# Q4. Create functions that take a vector as input and returns:
# Q4.1 The last value. Should you use [ or [[?
# Q4.2 The elements at even numbered positions
# Q4.3 Every element except the last value
# Q4.4 Only even numbers (and no missing values)

# A4.1
# A4.2
# A4.3
# A4.4

                                  
# Q5. Why is 'x[-which(x > 0)]' not the same as 'x[x <= 0]' ?
# A5.


# Q6.
# What happens when you subset with a positive integer that’s bigger than the length of the vector?
# What happens when you subset with a name that doesn’t exist?

# A6.


----------
# SECTION 20 [Chapter 16 hardcopy] : VECTORS
# 20.5.4 Exercises

# Q1. Draw the following lists as nested sets:
# Q1.1 'list(a, b, list(c, d), list(e, f))'
# Q1.2 'list(list(list(list(list(list(a))))))'

# A1.1
# A1.2


# Q2.
# What happens if you subset a tibble as if you’re subsetting a list?
# What are the key differences between a list and a tibble?

# A2.


----------
# SECTION 20 [Chapter 16 hardcopy] : VECTORS
# 20.7.4 Exercises

# Q1.
# What does 'hms::hms(3600)' return? How does it print?
# What primitive type is the augmented vector built on top of? What attributes does it use?

# A1.


# Q2. Try and make a tibble that has columns with different lengths. What happens?
# A2.


# Q3. Based on the definition above, is it ok to have a list as a column of a tibble?
# A3.

