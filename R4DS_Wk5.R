library(tidyverse)

----------
# SECTION 10 [Chapter 7 hardcopy]
# 10.5 Exercises
  
# Q1. How can you tell if an object is a tibble?
# (Hint: try printing mtcars, which is a regular data frame)
print(mtcars)
print(as_tibble(mtcars))

# A1.
# "Tibbles have a refined print method that shows only the first 10 rows, and all the columns that fit
# on screen. This makes it much easier to work with large data. In addition to its name, each column
# reports its type, a nice feature borrowed from str()" -- s10.3.1


# Q2.
# Compare and contrast the following operations on a data.frame and equivalent tibble.
# What is different? Why might the default data frame behaviours cause you frustration?

df <- data.frame(abc = 1, xyz = "a")
df$x                                     # Q2.1
df[, "xyz"]                              # Q2.2
df[, c("abc", "xyz")]                    # Q2.3

dftibb <- as_tibble(data.frame(abc = 1, xyz = "a"))
dftibb$x                                 # Q2.1
dftibb[, "xyz"]                          # Q2.2
dftibb[, c("abc", "xyz")]                # Q2.3

# A2.
# "Compared to a data.frame, tibbles are more strict: they never do partial matching, and they will
# generate a warning if the column you are trying to access does not exist" -- s10.3.2
# So for Q2.1, the tibble says "Unknown or uninitialised column: 'x'", but the data.frame finds 'xyz'.
# This saves keystrokes, but might return (the value of) a 'wrong'/unintended variable

# "With base R data frames, [ sometimes returns a data frame, and sometimes returns a vector <if 1 col>.
# With tibbles, [ always returns another tibble" -- s10.4
# So for Q2.2 & # Q2.3 the tibble returns a tibble. The data.frame returns a vector & data.frame
# Output able to be either vector or data.frame means code acting on it has to determine which (else error)


# Q3.
# If you have the name of a variable stored in an object, e.g. var <- "mpg", how can you extract
# the reference variable from a tibble?

# A3.
# You can use the double bracket, like df[[var]].
# You can't use the dollar sign, because df$var would look for a column named var
# https://jrnold.github.io/e4qf/tibbles.html#exercises-12


# Q4.
# Practice referring to non-syntactic names in the following data frame by:
  
# Q4.1 Extracting the variable called 1
# Q4.2 Plotting a scatterplot of 1 vs 2
# Q4.3 Creating a new column called 3 which is 2 divided by 1
# Q4.4 Renaming the columns to one, two and three
annoying <- tibble(
  `1` = 1:10,
  `2` = `1` * 2 + rnorm(length(`1`))
)

# A4.
# It’s possible for a tibble to have column names that are not valid R variable names, aka non-syntactic
# names. For example, they might not start with a letter, or they might contain unusual characters like
# a space. To refer to these variables, you need to surround them with backticks, ` -- s10.2

# A4.1
annoying$`1`           # OK
annoying[[`1`]]        # not ok ...??
annoying$"1"           # OK ...?
annoying[["1"]]        # OK ...?

# A4.2
ggplot(annoying, aes(`1`,`2`)) + geom_point()

# A4.3
# "To use these in a pipe, you’ll need to use the special placeholder ." -- s10.3.2
(annoying %>% mutate(`3` = `2`/`1`)) # The above comment does NOT seem to apply here - I'm not subsetting

# A4.4
(annoying %>%
    mutate(`3` = `2`/`1`) %>%
    rename(one = `1`, two = `2`, three = `3`))


# Q5. What does tibble::enframe() do? When might you use it?
?tibble::enframe()

# A5.
# "enframe() converts named atomic vectors or lists to two-column data frames" (with names and values).
# "You might use it if you have data stored in a named vector and you want to add it to a data frame
# and preserve both the name attribute and the actual value" -- http://cfss.uchicago.edu/r4ds_solutions.html
enframe(c(a = 1, b = 2, c = 3))


# Q6. What option controls how many additional column names are printed at the footer of a tibble?

# A6.
# "you can explicitly print() the data frame and control the number of rows (n) and the width of the
# display. width = Inf will display all columns" -- s10.3.1
# So, the number of columns displayed will affect how many (others) are printed at the footer

nycflights13::flights %>% print(n = 10, width = 80)    # 'width' in characters (not qty of columns)

# 'n_extra' : columns to print abbreviated information for, if the width is too small for the entire tibble.
# If NULL, the default, it will print information about at most 'tibble.max_extra_cols' extra columns
getOption("tibble.max_extra_cols")                     # Tells current value of tibble.max_extra_cols
options(tibble.max_extra_cols = 100)                   # Set to 100

# "You can also control the default print behaviour by setting options: ...
# Use options(tibble.width = Inf) to always print all columns, regardless of the width of the screen" -- s10.3.1


----------
# SECTION 11 [Chapter 8 hardcopy]
# 11.2.2 Exercises

# Q1. What function would you use to read a file where fields were separated with “|”?
# A1. 'read_delim()' "reads in files with any delimiter" -- s11.2
?read_delim
read_delim(file, delim = "|")


# Q2. Apart from file, skip, and comment, what other arguments do read_csv() and read_tsv() have in common?
?read_csv
?read_tsv

# A2.
# col_names = TRUE, col_types = NULL, locale = default_locale(), na = c("", "NA"), quoted_na = TRUE,
# quote = "\"", trim_ws = TRUE, n_max = Inf, guess_max = min(1000, n_max), progress = show_progress()

# https://jrnold.github.io/e4qf/data-import.html#exercises-13 :
# col_names and col_types are used to specify the column names and how to parse the columns.
# locale is important for determining things like the enecoding and whether “.” or “,” is used as a decimal mark.
# na and quoted_na control which strings are treated as missing values when parsing vectors.
# <quote is ?>
# trim_ws trims whitespace before and after cells before parsing.
# n_max sets how many rows to read.
# guess_max sets how many rows to use when guessing the column type.
# progress determines whether a progress bar is shown.


# Q3. What are the most important arguments to read_fwf()?
? read_fwf

# A3.
# read_fwf() reads fixed width files.
# Most important argument is 'col_positions', which tells the function where data columns begin and end

# Related (s11.2) :
# "You can specify fields either by their widths with fwf_widths() or their position with fwf_positions()"


# Q4.
# Sometimes strings in a CSV file contain commas. To prevent them from causing problems they need
# to be surrounded by a quoting character, like " or '. By convention, read_csv() assumes that the
# quoting character will be ", and if you want to change it you’ll need to use read_delim() instead.
# What arguments do you need to specify to read the following text into a data frame?
"x,y\n1,'a,b'"

# "\n" is a convenient shortcut for adding a new line -- s11.2

# A4.
?read_delim
Q4_string <- "x,y\n1,'a,b'"
read_delim(file = Q4_string, delim = ",", quote = "'")


# Q5.
# Identify what is wrong with each of the following inline CSV files.
# What happens when you run the code?

read_csv("a,b\n1,2,3\n4,5,6")    # Q5.1
read_csv("a,b,c\n1,2\n1,2,3,4")  # Q5.2
read_csv("a,b\n\"1")             # Q5.3
read_csv("a,b\n1,2\na,b")        # Q5.4
read_csv("a;b\n1;3")             # Q5.5

# A5.
# A5.1
# Row1 has two positions, rows2&3 have three positions. Created 2x2 tibble (with no 3 or 6)
# "Only two columns are specified in the header “a” and “b”, but the rows have three columns,
# so the last column in dropped" -- https://jrnold.github.io/e4qf/data-import.html#exercises-13

# A5.2
# Row1 has three positions, row2 two positions, row3 four positions. Created 2x3 tibble (NA, no 4)
# "The numbers of columns in the data do not match the number of columns in the header (three). In row
# one, there are only two values, so column c is set to missing. In row two, there is an extra value,
# and that value is dropped"

# A5.3 Row1 has two positions, row2 has \"1. Created 1x2 tibble (with 1 in first position, NA in second)
# A5.4
# Looks like it will complete ok. But odd to put a number and letter in same column. Created 2x2 tibble
# Both “a” and “b” are treated as character vectors since they contain non-numeric strings

# A5.5 Uses ; [read_csv2 uses ; as a delimiter instead of ,]. Created 1x1 tibble


----------
# SECTION 11 [Chapter 8 hardcopy]
# 11.3.5 Exercises

# Q1. What are the most important arguments to locale()?
?locale

# A1.
# "When parsing numbers, the most important option is the character you use for the decimal mark.
# You can override the default value of . by creating a new locale and setting the decimal_mark argument"
# -- s11.3.1

# The locale broadly controls the following:
# date and time formats: [date_names, date_format, and time_format]
# time_zone: [tz]
# numbers: [decimal_mark, grouping_mark]
# encoding: [encoding]
# -- https://jrnold.github.io/e4qf/data-import.html#exercises-14


# Q2.
# What happens if you try and set decimal_mark and grouping_mark to the same character?
# What happens to the default value of grouping_mark when you set decimal_mark to “,”?
# What happens to the default value of decimal_mark when you set the grouping_mark to “.”?

# A2.
locale(decimal_mark = ".", grouping_mark = ".")
# "Error: `decimal_mark` and `grouping_mark` must be different"

locale(decimal_mark = ",")
# "Numbers:  123.456,78"
# When decimal_mark is set to “," [comma], grouping mark automatically gets set to "." [period]

locale(decimal_mark = ".")
# "Numbers:  123,456.78"
# When decimal_mark is set to “." [period], grouping mark automatically gets set to "," [comma]


# Q3.
# I didn’t discuss the date_format and time_format options to locale(). What do they do?
# Construct an example that shows when they might be useful

# A3.
?locale
# "Default date and time formats"

# Unless a format argument is specified "parse_date() uses the date_format specified by the locale()"
# "parse_time() uses the time_format specified by the locale()"
# "In most cases, you will need to supply a format"
# -- http://readr.tidyverse.org/articles/readr.html

# "Locales also provide default date and time formats. The time format isn’t currently used for anything,
# but the date format is used when guessing column types"
# https://cran.r-project.org/web/packages/readr/vignettes/locales.html


# Q4.
# If you live outside the US, create a new locale object that encapsulates the settings for the
# types of file you read most commonly.

# A4.
?locale

locale(date_names = "en", date_format = "%d/%m/%y", time_format = "%AT",
       decimal_mark = ".", grouping_mark = ",", tz = "UTC",
       encoding = "UTF-8", asciify = FALSE)


# Q5 What’s the difference between read_csv() and read_csv2()?

# A5.
# "read_csv() reads comma delimited files, read_csv2() reads semicolon separated files (common in
# countries where , is used as the decimal place)" -- s11.2


# Q6.
# What are the most common encodings used in Europe? What are the most common encodings used in Asia?
# Do some googling to find out.

# A6.
# https://en.wikipedia.org/wiki/Character_encoding#Common_character_encodings


# Q7.
# Generate the correct format string to parse each of the following dates and times:
d1 <- "January 1, 2010"                         # Q7.1
d2 <- "2015-Mar-07"                             # Q7.2
d3 <- "06-Jun-2017"                             # Q7.3
d4 <- c("August 19 (2015)", "July 1 (2015)")    # Q7.4
d5 <- "12/30/14" # Dec 30, 2014                 # Q7.5
t1 <- "1705"                                    # Q7.6
t2 <- "11:15:10.12 PM"                          # Q7.7

# A7.
# Using codes from section "11.3.4 Dates, date-times, and times" :
parse_date(d1, "%B %d, %Y")                     # A7.1
parse_date(d2, "%Y-%b-%d")                      # A7.2
parse_date(d3, "%d-%b-%Y")                      # A7.3
parse_date(d4, "%B %d (%Y)")                    # A7.4
parse_date(d5, "%m/%d/%y")                      # A7.5
parse_time(t1, "%H%M")                          # A7.6
parse_time(t2, "%I:%M:%OS %p")                  # A7.7
