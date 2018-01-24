library(tidyverse)

----------
# SECTION 12 [Chapter 9 hardcopy]
# 12.2.1 Exercises

# Q1. Using prose, describe how the variables and observations are organised in each of the sample tables.

# A1.
?table1
# s12.2 Tidy data : "Each dataset shows the same values of four variables country, year, population, and cases"
# table1:     TIDY: Each variable has its own column. Each observation has its own row. By 'country', by 'year'
# table2: NOT TIDY: 2 rows per observation : 'cases' & 'population' are rows in 'type' column, instead of their own cols
# table3: NOT TIDY: 'cases' & 'population' are combined in 'rate' column (ie. Each value doesn't have its own cell)
# table4: NOT TIDY: 2 observations per row : '1999' & '2000' cols, instead of 'year'. 2 tables for 'cases' & 'population'


# Q2.
# Compute the rate for table2, and table4a + table4b. You will need to perform four operations:
# 1. Extract the number of TB cases per country per year
# 2. Extract the matching population per country per year
# 3. Divide cases by population, and multiply by 10000
# 4. Store back in the appropriate place

# Which representation is easiest to work with? Which is hardest? Why?

# A2.
# s5.2 Filter rows with filter() : "filter() allows you to subset observations based on their values"
# s5.4 Select columns with select() : "select() allows you to rapidly zoom in on a useful subset"
# s10.3.2 Subsetting : "If you want to pull out a single variable, you need some new tools, $ and [["
# s10.4 Interacting with older code : "We don’t use [ much in this book because dplyr::filter() and dplyr::select()
# allow you to solve the same problems with clearer code"

# TABLE2 failed attempt - thinking it would be easy
cases <- table2 %>% filter(type == "cases")
population <- table2 %>% filter(type == "population")
rate <- cases / population # FAIL : "Error in FUN(left, right) : non-numeric argument to binary operator"

# TABLE2 building a tibble up from pieces. Assumes initial 4 rows for each country, all sorted
cases <- filter(table2, type == "cases")$count
population <- filter(table2, type == "population")$count
country <- filter(table2, type == "cases")$country
year <- filter(table2, type == "cases")$year
table2_new <- tibble(country = country,
                        year = year,
                       cases = cases,
                  population = population,
                        rate = cases / population * 10000)
table2_new

# TABLE4 building a tibble up from pieces. Assumes table4a & table4b are the same length, and sorted in the same order
table4_new <- tibble(country = table4a$country,
       `1999` = table4a$`1999` / table4b$`1999` * 10000,
       `2000` = table4a$`2000` / table4b$`2000` * 10000)
table4_new

# As seen in s12.2, the easiest to work with is table1. (It is TIDY.) Doesn't need filtering and adds to existing tibble
table1 %>% 
  mutate(rate = cases / population * 10000)


# Q3. Recreate the plot showing change in cases over time using table2 instead of table1. What do you need to do first?

# A3.
# Replacing 'table1' with 'table2_new'. (No other changes made)
# Compute cases per year
table2_new %>% 
  count(year, wt = cases)
# Visualise changes over time
  ggplot(table2_new, aes(year, cases)) + 
  geom_line(aes(group = country), colour = "grey50") + 
  geom_point(aes(colour = country))
# This gave the same results as with table1 (which is same data, so ok). But seems too easy, (and the first 2 lines
# aren't even needed), so probably not what Q meant

# Starting with table2 (instead of table2_new). Need to filter the "cases" rows, and use "count" column on y-axis
table2 %>% 
  filter(type == "cases") %>%
  ggplot(aes(year, count)) + 
  geom_line(aes(group = country), colour = "grey50") + 
  geom_point(aes(colour = country))


----------
# SECTION 12 [Chapter 9 hardcopy]
# 12.3.3 Exercises

# Q1.
# Why are gather() and spread() not perfectly symmetrical?
# Carefully consider the following example:
stocks <- tibble(
  year   = c(2015, 2015, 2016, 2016),
  half  = c(   1,    2,     1,    2),
  return = c(1.88, 0.59, 0.92, 0.17)
)
stocks %>% 
  spread(year, return) %>% 
  gather("year", "return", `2015`:`2016`)
# (Hint: look at the variable types and think about column names.)

# Both spread() and gather() have a convert argument. What does it do?

# A1.
# In the example, the 'stocks' tibble is created with 3 columns : year, half, return. Doing spread() and then gather()
# one may expect to return to the same tibble ...but 'year' began as type <dbl> and is now of type <chr>
# ...(And columns are now ordered half, year, return)

# gather() will convert numeric variable names to strings ...(And cols not involved in the spread/gather 'move left')

?spread
?gather
stocks %>% 
  spread(year, return) %>%
  gather("year", "return", `2015`:`2016`, convert = TRUE)
# convert=TRUE will change a variable's class from <chr> to numeric/integer/logical, if it was that before the gather().
# (Doesn't work for factor or date.) 'Help' reads similarly for spread(), but I think its use is more nuanced/complicated
# ..."Use 'convert = TRUE' to produce variables of mixed type".
# In example above 'year' ends up converted to <int> (it started as <dbl>, and would have become <chr>)


# Q2.
# Why does this code fail?
table4a %>% 
  gather(1999, 2000, key = "year", value = "cases")

# A2.
# "Error in combine_vars(vars, ind_list) : Position must be between 0 and n" -- error message
# "Note that “1999” and “2000” are non-syntactic names (because they don’t start with a letter) so we have to surround
# them in backticks" -- s12.3.1
# "The tidyverse functions will interpret 1999 and 2000 without quotes as looking for the 1999th and 2000th column
# of the data frame" -- https://jrnold.github.io/e4qf/tidy-data.html#exercises-15


# Q3.
# Why does spreading this tibble fail? How could you add a new column to fix the problem?
people <- tribble(
  ~name,             ~key,    ~value,
  #-----------------|--------|------
  "Phillip Woods",   "age",       45,
  "Phillip Woods",   "height",   186,
  "Phillip Woods",   "age",       50,
  "Jessica Cordero", "age",       37,
  "Jessica Cordero", "height",   156
)

# A3.
people
spread(people, key = key, value = value)
# "Error: Duplicate identifiers for rows (1, 3)" -- error message
# Spreading fails because rows 1 & 3 both have “age” for “Phillip Woods”
# To fix could add a new column, where rows 1 & 3 have different values for a new categorical variable (eg. person who
# collected the data?), to distinguish them. In this example the spread tibble will have 'NA' for "height"


# Q4.
# Tidy the simple tibble below. Do you need to spread or gather it? What are the variables?
preg <- tribble(
  ~pregnant, ~male, ~female,
  "yes",     NA,    10,
  "no",      20,    12
)

# A4.
# The variables are ('pregnant' and) 'sex' and 'count'. Need to gather it. key = "sex" and value = "count"
preg %>%
  gather(male, female, key = "sex", value = "count") # I assume 'count' is 'baby_qty', but safer to leave as 'count'


----------
# SECTION 12 [Chapter 9 hardcopy]
# 12.4.3 Exercises

# Q1.
# What do the extra and fill arguments do in separate()?
# Experiment with the various options for the following two toy datasets.
tibble(x = c("a,b,c", "d,e,f,g", "h,i,j")) %>% 
  separate(x, c("one", "two", "three")) # ---> "Warning message: Too many values at 1 locations: 2". 3x3 tibble

tibble(x = c("a,b,c", "d,e", "f,g,i")) %>% 
  separate(x, c("one", "two", "three")) # ---> "Warning message: Too few values at 1 locations: 2". 3x3 tibble

# A1.
?tibble
?separate
# extra : controls what happens when there are too many pieces. Three valid options:
#          "warn" (the default): emit a warning and drop extra values.
#          "drop": drop any extra values without a warning.
#          "merge": only splits at most 'length(into)' times

tibble(x = c("a,b,c", "d,e,f,g", "h,i,j")) %>% 
  separate(x, c("one", "two", "three"), extra = "merge") # ---> extra values not split, so “f,g” is in col "three" row 2

# fill :  controls what happens when there are not enough pieces. Three valid options:
#          "warn" (the default): emit a warning and fill from the right.
#          "right": fill with missing values on the right.
#          "left": fill with missing values on the left

tibble(x = c("a,b,c", "d,e", "f,g,i")) %>% 
  separate(x, c("one", "two", "three"), fill = "left") # ---> col “one” has the <NA>, instead of col "three" (row 2)


# Q2. Both unite() and separate() have a remove argument. What does it do? Why would you set it to FALSE?

# A2.
?unite # "If TRUE, remove input columns from output data frame"
?separate # "If TRUE, remove input column from output data frame"
# You would set it to FALSE if you want to *also* keep the old column(s)


# Q3.
# Compare and contrast separate() and extract().
# Why are there three variations of separation (by position, by separator, and with groups), but only one unite?

# A3.
?extract
# "Given a regular expression with capturing groups, extract() turns each group into a new column.
# If the groups don't match, or the input is NA, the output will be NA"
# -- Help

# extract() uses a regular expression to find *groups* and split into columns.
# separate() : relation is one:many (cols), multiple ways to split the string. Each of 3 might be most useful tool for it.
# unite() : relation is many:one (cols). Once cols are specified, there is only one way, (only choice is the 'sep')
# -- based on https://jrnold.github.io/e4qf/tidy-data.html#exercises-15

# NOTE : Still not sure about how extract() works, nor how it does/not differ from separate()


----------
# SECTION 12 [Chapter 9 hardcopy]
# 12.5.1 Exercises

# Q1. Compare and contrast the fill arguments to spread() and complete()
?spread
?complete

# A1.
# spread() :  'fill' sets the value. ("missing values [both explicit & implicit] will be replaced with this value")
# complete() : 'fill' sets a value from a named list. ("for each variable supplies a single value") [implicit & explicit missing values]


# Q2. What does the direction argument to fill() do?
?fill

# A2.
# "Direction in which to fill missing values. Currently either 'down' (the default) or 'up'" -- Help
# ...ie. Replace with the most recent non-missing value ("down") or the next non-missing value ("up")


----------
# SECTION 12 [Chapter 9 hardcopy]
# 12.6.1 Exercises

# Q1.
# In this case study I set na.rm = TRUE just to make it easier to check that we had the correct values.
# Is this reasonable? Think about how missing values are represented in this dataset. Are there implicit missing values?
# What’s the difference between an NA and zero?

# A1.
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX


# Q2.
# What happens if you neglect the mutate() step? (mutate(key = stringr::str_replace(key, "newrel", "new_rel")))

# A2.
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX


# Q3.
# I claimed that iso2 and iso3 were redundant with country. Confirm this claim

# A3.
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX


# Q4.
# For each country, year, and sex compute the total number of cases of TB. Make an informative visualisation of the data

# A4.
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX


----------
# SECTION 13 [Chapter 10 hardcopy]
# 13.2.1 Exercises

library(nycflights13)

# Q1.
# Imagine you wanted to draw (approximately) the route each plane flies from its origin to its destination.
# What variables would you need? What tables would you need to combine?

# A1.
flights # look at table to see the variables
# origin airport ---> destination airport. (This is just the endpoints, but assume it's what 'approximate route' meant)
origin, dest ...['flights' table]
lat, lon ...['airports' table]
# Combine 'flights' table ('origin') with 'airports' table ('faa') to get lat&lon of origin airport
# Combine 'flights' table ('dest') with 'airports' table ('faa') to get lat&lon of destination airport


# Q2.
# I forgot to draw the relationship between 'weather' and 'airports'.
# What is the relationship and how should it appear in the diagram?

# A2.
# Similarly to Q1, 'origin' (in 'weather') could combine with 'faa' (in 'airports')
# (As Q3 says, 'weather' only contains data for the NYC airports, not for the destinations)


# Q3.
# 'weather' only contains information for the origin (NYC) airports.
# If it contained weather records for all airports in the USA, what additional relation would it define with 'flights'?

# A3.
# Similarly to Q1, 'origin' (in 'weather') could combine with 'origin' or 'dest' (in 'flights') ...'dest' is additional
# Could also (maybe, depending on frequency/accuracy of readings) match the 'year', 'month', 'day', 'hour' in each
# Does that answer the question?


# Q4.
# We know that some days of the year are “special”, and fewer people than usual fly on them.
# How might you represent that data as a data frame? What would be the primary keys of that table?
# How would it connect to the existing tables?

# A4.
# Inference is that these 'special' days would be in a new dataframe/ table. They might be on different dates each year
# So 'year', 'month', 'day' in the dataframe would combine for a primary key of date
# It would connect to 'flights' via 'year', 'month', 'day'


----------
# SECTION 13 [Chapter 10 hardcopy]
# 13.3.1 Exercises

# Q1.
# Add a surrogate key to 'flights'

# A1.
# "If a table lacks a primary key, it’s sometimes useful to add one with mutate() and row_number().  
# ... This is called a surrogate key" -- s13.3
flights %>%
  mutate(flight_id = row_number())


# Q2.
# Identify the keys in the following datasets

# Q2.1 Lahman::Batting
# Q2.2 babynames::babynames
# Q2.3 nasaweather::atmos
# Q2.4 fueleconomy::vehicles
# Q2.5 ggplot2::diamonds
# (You might need to install some packages and read some documentation.)

# A2.
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX


# Q3.
# Draw a diagram illustrating the connections between the Batting, Master, and Salaries tables in the Lahman package.
# Draw another diagram that shows the relationship between Master, Managers, AwardsManagers.
# How would you characterise the relationship between the Batting, Pitching, and Fielding tables?

# A3.
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX


----------
# SECTION 13 [Chapter 10 hardcopy]
# 13.4.6 Exercises

# Q1.
# Compute the average delay by destination, then join on the airports data frame so you can show the spatial
# distribution of delays. Here’s an easy way to draw a map of the United States:
airports %>%
  semi_join(flights, c("faa" = "dest")) %>%
  ggplot(aes(lon, lat)) +
  borders("state") +
  geom_point() +
  coord_quickmap()
# (Don’t worry if you don’t understand what semi_join() does — you’ll learn about it next.)
# You might want to use the size or colour of the points to display the average delay for each airport

# A1.
# (Why doesn't it work if I use 'avg-delay' instead of 'avg_delay'?)
flights %>%
  group_by(dest) %>% # group_by() in order to then take the group average
  summarise(avg_delay = mean(arr_delay, na.rm = TRUE)) %>% # Choose to exclude NA's from the average
  left_join(airports, by = c(dest = "faa")) %>% # Join using flight destination, not flight origin

# This next part is same as in the question, but colours each airport (by avg_delay)
ggplot(aes(lon, lat, colour = avg_delay)) +
  borders("state") +
  geom_point() +
  coord_quickmap()

# "The left join should be your default join: use it unless you have a strong reason to prefer one of the others" -- s13.4.3
# "Warning message: Removed 4 rows containing missing values (geom_point)". So did it plot as if I'd chosen 'inner_join'?


# Q2.
# Add the location of the origin and destination (i.e. the lat and lon) to flights

# A2.
# Answer combines 2 pieces of example code at the end of s13.4.5. Looks as if it worked, but is it the right way?
# ...(ie. one after the other in the 'and then' pipe, rather than some sort of parallel? ...if that is even possible)
flights %>%
  left_join(airports, by = c(origin = "faa")) %>% # Looks like the join used in A1
  left_join(airports, by = c(dest = "faa")) %>% # 'airports' table doesn't distinguish between origin & destination
View()
# There are name duplications from the 2 joins, but each has a suffix (assume .x is origin and .y is dest)
# ...re. "disambiguated in the output with a suffix" (s13.4.5, where 2 tables each had same name for different variable)


# Q3.
# Is there a relationship between the age of a plane and its delays?

# A3.
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX


# Q4. What weather conditions make it more likely to see a delay?
# A4.
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX


# Q5.
# What happened on June 13 2013?
# Display the spatial pattern of delays, and then use Google to cross-reference with the weather

# A5.
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX


----------
# SECTION 13 [Chapter 10 hardcopy]
# 13.5.1 Exercises

# Q1.
# What does it mean for a flight to have a missing tailnum?
# What do the tail numbers that don’t have a matching record in planes have in common?
# (Hint: one variable explains ~90% of the problems.)

# A1.
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX


# Q2.
# Filter flights to only show flights with planes that have flown at least 100 flights

# A2.
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX


# Q3.
# Combine fueleconomy::vehicles and fueleconomy::common to find only the records for the most common models

# A3.
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX


# Q4.
# Find the 48 hours (over the course of the whole year) that have the worst delays.
# Cross-reference it with the weather data. Can you see any patterns?

# A4.
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX


# Q5.
# What does anti_join(flights, airports, by = c("dest" = "faa")) tell you?
# What does anti_join(airports, flights, by = c("faa" = "dest")) tell you?

# A5.
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX


# Q6.
# You might expect that there’s an implicit relationship between plane and airline, because each plane is flown
# by a single airline. Confirm or reject this hypothesis using the tools you’ve learned above

# A6.
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
