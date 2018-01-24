library(tidyverse)
library(forcats)

----------
# SECTION 15 [Chapter 12 hardcopy]
# 15.3.1 Exercises

# Q1.
# Explore the distribution of 'rincome' (reported income).
# What makes the default bar chart hard to understand?
# How could you improve the plot?

# A1.
?gss_cat    # It’s a sample of data from the General Social Survey, which is a long-running US survey -- s15.3

forcats::gss_cat %>%
  ggplot(aes(x = rincome)) +
  geom_bar()

# I think "hard to understand" is referring to the x-axis labels being squashed/overlapping/unreadable
# Usual way to overcome this (unless bars have to be vertical) is to make bars horizontal :
forcats::gss_cat %>%
  ggplot(aes(rincome)) +
  geom_bar() +
  coord_flip()

# Other improvements : descending values (re. reading down list), consistent bin size (but we can't affect that)
# ...and maybe to group together some of the 'no answer' categories, if no values can be got from them


# Q2. What is the most common 'relig' in this survey? What’s the most common 'partyid'?

# A2.
forcats::gss_cat %>%
  count(relig) %>%
  arrange(desc(n))                 # P.50 of hardcopy
# Most common 'relig' is Protestant

forcats::gss_cat %>%
  count(partyid) %>%
  arrange(desc(n))
# Most common 'partyid' is Independent


# Q3.
# Which 'relig' does 'denom' (denomination) apply to? How can you find out with a table?
# How can you find out with a visualisation?

# A3.
forcats::gss_cat$denom             # This listed values for the first 1000 rows. Answer appears to be Protestant
levels(forcats::gss_cat$denom)     # Shows that there are only 30 different values in total. Answer is Protestant

forcats::gss_cat %>%
  ggplot(aes(relig, denom)) +
  geom_point() +
  coord_flip()                     # Incl/exclude this, to read labels on one axis, then other. (Q tells only 1 answer)

# Answer from https://jrnold.github.io/e4qf/factors.html#exercises-35 includes quantities as size, but its most useful
# feature is the rotation of labels on the x-axis :
gss_cat %>%
  count(relig, denom) %>%
  ggplot(aes(x = relig, y = denom, size = n)) +
  geom_point() +
  theme(axis.text.x = element_text(angle = 90))


----------
# SECTION 15 [Chapter 12 hardcopy]
# 15.4.1 Exercises
  
# Q1. There are some suspiciously high numbers in 'tvhours'. Is the mean a good summary?
# A1.
forcats::gss_cat %>%
  ggplot(aes(x = tvhours)) +
  geom_histogram(binwidth = 1)
# Warning message: Removed 10146 rows containing non-finite values (stat_bin)

# Answer from https://jrnold.github.io/e4qf/factors.html#exercises-36 :
gss_cat %>%
  filter(!is.na(tvhours)) %>%      # extra line means no 'Warning message' (but same chart)
  ggplot(aes(x = tvhours)) +
  geom_histogram(binwidth = 1)

# The distribution has a long tail to the right, but most results are <6 hrs, and nothing >24 hrs
# Median might be a 'better' summary, but also 'it depends' (on the reason for wanting a summary)


# Q2. For each factor in 'gss_cat' identify whether the order of the levels is arbitrary or principled.
# A2.
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
# https://jrnold.github.io/e4qf/factors.html#exercises-36


# Q3. Why did moving “Not applicable” to the front of the levels move it to the bottom of the plot?
# A3.
# The question is referring to the last geom_point() chart in s15.4
# Order of the levels in the rincome() factor can be seen with 'levels(gss_cat$rincome)' or 'gss_cat %>% count(rincome)'
# R assigns integers to each level, based on the order. So "1" to the 1st level, "2" to the 2nd level, etc
# When plotting 'rincome' on the y-axis, the level nearest the '0' will be that with integer "1", etc

?fct_relevel
# Using 'fct_relevel' to move "Not applicable" to 1st level gives it integer "1" (and "move it the bottom of the plot")


----------
# SECTION 15 [Chapter 12 hardcopy]
# 15.5.1 Exercises

# Q1.
# How have the proportions of people identifying as Democrat, Republican, and Independent changed over time?

# A1.
forcats::gss_cat %>% 
  count(year, partyid) %>%                         # Without this, 'year' and 'partyid' not recognised in ggplot(). Not sure why
  group_by(year) %>%
  mutate(proportion = n / sum(n)) %>%
  ggplot(aes(year, proportion, colour = partyid)) +
  geom_line()

# Answer from https://jrnold.github.io/e4qf/factors.html#exercises-37 also :
# Grouped the many 'partyid' values into a succinct Democrat/ Republican/ Independent/ Other ...with fct_collapse()
# And reordered the Legend                                                                   ...with fct_reorder2()
# And showed each year's datapoints                                                          ...with geom_point()
# And renamed the Legend from 'partyid' to "Party ID."                                       ...with labs()
gss_cat %>% 
  mutate(partyid = 
           fct_collapse(partyid,
                        other = c("No answer", "Don't know", "Other party"),
                        rep = c("Strong republican", "Not str republican"),
                        ind = c("Ind,near rep", "Independent", "Ind,near dem"),
                        dem = c("Not str democrat", "Strong democrat"))) %>%
  count(year, partyid)  %>%
  group_by(year) %>%
  mutate(p = n / sum(n)) %>%
  ggplot(aes(x = year, y = p,
             colour = fct_reorder2(partyid, year, p))) +
  geom_point() +
  geom_line() +
  labs(colour = "Party ID.")


# Q2.
# How could you collapse rincome into a small set of categories?
forcats::gss_cat$rincome           # This listed values for the first 1000 rows
levels(forcats::gss_cat$rincome)   # Shows that there are only 16 different values in total

# A2.
# Group 'non-responses' together into one category
forcats::gss_cat %>%
  mutate(rincome = fct_collapse(rincome,
                                  `Unknown` = c("No answer", "Don't know", "Refused", "Not applicable"))) %>%
  ggplot(aes(x = rincome)) +
  geom_bar() + 
  coord_flip()

# Answer from https://jrnold.github.io/e4qf/factors.html#exercises-37 [below] also created 'consistent bin size'
# (re. 15.3.1 Exercises Q1) ...with fct_collapse() after using str_c()
library("stringr")
gss_cat %>%
  mutate(rincome = 
           fct_collapse(
             rincome,
             `Unknown` = c("No answer", "Don't know", "Refused", "Not applicable"),
             `Lt $5000` = c("Lt $1000", str_c("$", c("1000", "3000", "4000"),
                                              " to ", c("2999", "3999", "4999"))),
             `$5000 to 10000` = str_c("$", c("5000", "6000", "7000", "8000"),
                                      " to ", c("5999", "6999", "7999", "9999"))
           )) %>%
  ggplot(aes(x = rincome)) +
  geom_bar() + 
  coord_flip()

XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
# (re. Answer above.) I don't follow how piecing together a heading with str_c() will 'grab' the records it relates to.
# So, this answer [below] also works to create 'consistent bin size', and makes sense to me :
library("stringr")
gss_cat %>%
  mutate(rincome = 
           fct_collapse(rincome,
             `Unknown` = c("No answer", "Don't know", "Refused", "Not applicable"),
             `Lt $5000` = c("Lt $1000", "$1000 to 2999", "$3000 to 3999", "$4000 to 4999"),
             `$5000 to 10000` = c("$5000 to 5999", "$6000 to 6999", "$7000 to 7999", "$8000 to 9999")
           )) %>%
  ggplot(aes(x = rincome)) +
  geom_bar() + 
  coord_flip()


----------
library(lubridate)
library(nycflights13)

# SECTION 16 [Chapter 13 hardcopy]
# 16.2.4 Exercises

# Q1.
# What happens if you parse a string that contains invalid dates?
ymd(c("2010-10-10", "bananas"))

# A1.
# Results in an NA with warning message :
[1] "2010-10-10" NA          
Warning message: 1 failed to parse. 


# Q2.
# What does the tzone argument to today() do? Why is it important?
?today

# A2.
# "a character vector specifying which time zone you would like to find the current date of.
# tzone defaults to the system time zone set on your computer" eg. today("GMT") -- Help
# Different time-zones can have different dates, so value of today() might vary


# Q3.
# Use the appropriate lubridate function to parse each of the following dates:
d1 <- "January 1, 2010"                             # Q3.1
d2 <- "2015-Mar-07"                                 # Q3.2
d3 <- "06-Jun-2017"                                 # Q3.3
d4 <- c("August 19 (2015)", "July 1 (2015)")        # Q3.4
d5 <- "12/30/14" # Dec 30, 2014                     # Q3.5

# A3.
mdy(d1)                                             # A3.1
ymd(d2)                                             # A3.2
dmy(d3)                                             # A3.3
mdy(d4)                                             # A3.4
mdy(d5)                                             # A3.5


----------
# SECTION 16 [Chapter 13 hardcopy]
# 16.3.4 Exercises
  
# Q1.
# How does the distribution of flight times within a day change over the course of the year?

# A1.
# Most obvious way to do this would be to compare daily distributions from during the year (either from a sample of
# individual days, or weekly/monthly/quarterly aggregates). Is this what the question means? (Else, if we look at how
# every day changes, I think we'd need to use an average (mean, SD) for the daily distribution, to plot it
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX


# Q2.
# Compare dep_time, sched_dep_time and dep_delay. Are they consistent? Explain your findings

# A2.
nycflights13::flights %>%
  ggplot(aes(dep_time, sched_dep_time)) +
  geom_point()
# This plot shows most points along or near-below a diagonal line, indicating on-time departure (or small delay).
# The question is probably asking whether sched_dep_time + dep_delay = dep_time
# (cf. In a previous Section we found that dep_time + air_time != arr_time ...Delay on tarmac?)
glimpse(flights)
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX


# Q3.
# Compare air_time with the duration between the departure and arrival. Explain your findings.
# (Hint: consider the location of the airport)

# A3.
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX


# Q4.
# How does the average delay time change over the course of a day? Should you use dep_time or sched_dep_time? Why?

# A4.
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX


# Q5.
# On what day of the week should you leave if you want to minimise the chance of a delay?

# A5.
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX


# Q6.
# What makes the distribution of diamonds$carat and flights$sched_dep_time similar?

# A6.
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX


# Q7.
# Confirm my hypothesis that the early departures of flights in minutes 20-30 and 50-60 are caused by scheduled 
# flights that leave early. (Hint: create a binary variable that tells you whether or not a flight was delayed)

# A7.
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX


----------
# SECTION 16 [Chapter 13 hardcopy]
# 16.4.5 Exercises

# Q1. Why is there months() but no dmonths()?
# A1. There is no standard length of month (30, 31 days), so it wouldn't make sense to define it in seconds


# Q2.
# Explain days(overnight * 1) to someone who has just started learning R. How does it work?

# A2.
# This is referring to some code in s16.4.2, designed to add 'days(1) to the arrival time of each overnight flight'
overnight = arr_time < dep_time,
arr_time = arr_time + days(overnight * 1)
# We only want to add 'days(1)' in cases where we omitted it before. 'overnight' is TRUE (1) or FALSE (0).
# So if it is an overnight flight, we add 1 day, and if not, no days are added


# Q3.
# Q3.1 Create a vector of dates giving the first day of every month in 2015.
# Q3.2 Create a vector of dates giving the first day of every month in the current year

# A3.1
ymd(c("2015-01-01", "2015-02-10", "2015-03-01", "2015_04-01", "2015-05-01", "2015-06-01",
                     "2015-07-01", "2015-08-10", "2015-09-01", "2015_10-01", "2015-11-01", "2015-12-01"))
# That worked, but could be done more concisely :
ymd("2015-01-01") + months(0:11)

# A3.2
# Again, could do it the 'long' way or 'concise' way, as above, just replacing 2015 with 2017. BUT that seems trivial.
# INSTEAD, assume that the question is asking us to code for a generic 'current year'

# "I can do that by taking today() and truncating it to the year using floor_date" :
floor_date(today(), unit = "year") + months(0:11)
# -- https://jrnold.github.io/e4qf/dates-and-times.html#exercises-40


# Q4.
# Write a function that given your birthday (as a date), returns how old you are in years

# A4.
# We haven't covered Functions yet (s19). This is from [https://jrnold.github.io/e4qf/dates-and-times.html#exercises-40] :
age <- function(bday) {
  (bday %--% today()) %/% years(1)
}
age(ymd("1969-07-29"))
# The parts between {} were covered in s16.4.3


# Q5.
# Why can’t (today() %--% (today() + years(1)) / months(1) work?
(today() %--% (today() + years(1)) / months(1)

# A5.
# Editor shows a red cross, with "unmatched opening bracket '('" ...but I don't think that was the intended error ...?
(today() %--% (today() + years(1))) / months(1) # This works and gives an answer of 12
(today() %--% (today() + years(1)) / months(1)) # This works and gives an answer of 12