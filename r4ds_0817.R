library(tidyverse)

# CHAPTER 1
# Exercises (P.6)
ggplot(data = mpg)
mpg
mtcars
?mtcars
?mpg
ggplot(data = mpg) +
  geom_point(mapping = aes(x = cyl, y = hwy))
ggplot(data = mpg) +
  geom_point(mapping = aes(x = drv, y = class))


# CHAPTER 1
# Exercises (P. 12)
ggplot(data = mpg) +
  geom_point(
    mapping = aes(x = displ, y = hwy, color = "blue"))
?mpg
mpg
ggplot(data = mpg) +
  geom_point(
    mapping = aes(x = displ, y = hwy, color = class, size = cyl, shape = drv))
ggplot(data = mpg) +
  geom_point(
    mapping = aes(x = displ, y = hwy, color = drv, size = cyl, shape = drv))
?geom_point
ggplot(data = mpg) +
  geom_point(
    mapping = aes(x = displ, y = hwy), shape = 21, colour = "black", fill = "white", size = 5, stroke = 5)
ggplot(data = mpg) +
  geom_point(
    mapping = aes(x = displ, y = hwy, color = displ < 5))


# CHAPTER 1
# Exercises (P. 15)
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ cyl)
ggplot(data = mpg) +
  geom_point(mapping = aes(x = drv, y = cyl))
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ .)
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(. ~ cyl)
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_wrap(~ class, nrow = 2)
?facet_wrap


# CHAPTER 1
# Exercises (P. 20)
geom_line(), geom_boxplot(), geom_histogram(), geom_area()
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) +
  geom_point() +
  geom_smooth(se = FALSE)
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) +
  geom_point(show.legend = FALSE) +
  geom_smooth(show.legend = FALSE, se = FALSE)
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) +
  geom_point() +
  geom_smooth()
ggplot() +
  geom_point(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) +
  geom_smooth(data = mpg, mapping = aes(x = displ, y = hwy, color = drv))
# Q6
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point() +
  geom_smooth(color = "blue", se = FALSE)
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point() +
  geom_smooth(mapping = aes(group = drv), color = "blue", se = FALSE)
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) +
  geom_point() +
  geom_smooth(se = FALSE)
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(color = drv)) +
  geom_smooth(se = FALSE)
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(color = drv)) +
  geom_smooth(mapping = aes(linetype = drv), se = FALSE)
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) +
  geom_point()


# CHAPTER 1
# Exercises (P. 26)
ggplot(data = diamonds) +
  stat_summary(mapping = aes(x = cut, y = depth), fun.ymin = min, fun.ymax = max, fun.y = median)
ggplot(data = diamonds) +
  geom_pointrange(mapping = aes(x = cut, y = depth), stat = "summary", fun.ymin = min, fun.ymax = max, fun.y = median)
?geom_col
?geom_bar
? - # Q3
?stat_smooth # http://cfss.uchicago.edu/r4ds_solutions.html
# Q5
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, y = ..prop..))
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = color, y = ..prop..))
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, y = ..prop.., group = 1))
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = color, y = ..prop.., group = 1)) # Why isn't chart coloured?


# CHAPTER 1
# Exercises (P. 31)
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_point()
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_jitter()
?geom_jitter
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_count()
ggplot(data = mpg, mapping = aes(x = class, y = hwy, color = drv)) +
  geom_boxplot(position = "dodge")


# CHAPTER 1
# Exercises (P. 33)
ggplot(data = mpg, mapping = (aes(x = factor(1), fill = class))) +
  geom_bar(position = "stack")
ggplot(data = mpg, mapping = (aes(x = factor(1), fill = class))) + # factor gave single stack
  geom_bar(position = "stack", width = 1) + # width gave us a fully-filled circle in polar
  coord_polar(theta = "y") # theta gave pie segments (map the angle to "y"), instead of rings
?labs()
?coord_map()
# Q4
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_point()
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_point() +
  geom_abline() # draws a line that, by default, has an intercept of 0 and slope of 1
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_point() +
  geom_abline() +
  coord_fixed() # draws equal intervals on the \(x\) and \(y\) axes so they are directly comparable




# CHAPTER 2
# Exercises (P. 40)
my_variable <- 10
my_variable

library(tidyverse)
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy))

filter(mpg, cyl == 8)
filter(diamonds, carat > 3)




# CHAPTER 3
# Exercises (P. 49)
library(nycflights13)
library(tidyverse)
flights

filter(flights, arr_delay >= 120) # Q1a
filter(flights, dest == "IAH" | dest == "HOU")  # Q1b
filter(flights, dest %in% c("IAH", "HOU")) # Q1b alternate
filter(flights, carrier %in% c("UA", "AA", "DL")) # Q1c
filter(flights, month %in% c(7, 8, 9)) # Q1d
filter(flights, arr_delay >= 120, dep_delay <= 0) # Q1e
filter(flights, dep_delay >= 60, dep_delay - arr_delay >= 30) # Q1f
filter(flights, dep_time >= 0000, dep_time <= 0600) # Q1g

filter(flights, between(month, 7, 9)) # Q2d
filter(flights, between(dep_time, 0000, 0600)) # Q2g

filter(flights, dep_time == NA) # doesn't work
filter(flights, is.na(dep_time)) # Q3
# http://cfss.uchicago.edu/r4ds_solutions.html


# CHAPTER 3
# Exercises (P. 51)
arrange(flights, !is.na(dep_time)) # ?Rows with 'dep_time' missing will return a value of FALSE/0, so will be at start

arrange(flights, desc(arr_delay)) # Q2
arrange(flights, dep_delay) # Q2
arrange(flights, desc(distance / air_time)) # Q3
arrange(flights, desc(distance)) # Q4
arrange(flights, distance) # Q4


# CHAPTER 3
# Exercises (P. 54)
select(flights, dep_time, dep_delay, arr_time, arr_delay) # Q1
select(flights, starts_with("dep"), starts_with("arr")) # Q1
select(flights, ends_with("_time"), ends_with("_delay")) # Q1
select(flights, contains("dep_"), contains("arr_")) # Q1

select(flights, dep_time, dep_time, dep_time) # Q2

?one_of() # Q3
vars <- c("year", "month", "day", "dep_delay", "arr_delay")
select(flights, one_of(vars))

select(flights, contains("TIME")) # Q4 ...Can set ignore.case = FALSE in the helper function


# CHAPTER 3
# Exercises (P. 58)
transmute(flights, dep_time = (dep_time %/% 100) * 60 + dep_time %% 100, sched_dep_time = (sched_dep_time %/% 100) * 60 + sched_dep_time %% 100) # Q1

# Q2: My air_time_new values are correct. How are air_time values obtained?? [http://cfss.uchicago.edu/r4ds_solutions.html]
transmute(flights, air_time, arr_time, dep_time, arr_time - dep_time)
transmute(flights, air_time, air_time_new = ((arr_time %/% 100) * 60 + arr_time %% 100) - ((dep_time %/% 100) * 60 + dep_time %% 100))

select(flights, dep_time, sched_dep_time, dep_delay) # Q3
arrange(flights, min_rank(desc(arr_delay))) # Q4
1:3 + 1:10 # Q5
?Trig # Q6


# CHAPTER 3
# Exercises (P. 72)
# Q1: A flight is 15 minutes early 50% of the time, and 15 minutes late 50% of the time.
flights %>%
  group_by(flight) %>%
  summarize(early_15_min = sum(arr_delay <= -15, na.rm = TRUE) / n(),
            late_15_min = sum(arr_delay >= 15, na.rm = TRUE) / n()) %>%
  filter(early_15_min == 0.5, late_15_min == 0.5)

# Q1: A flight is always 10 minutes late.
flights %>%
  group_by(flight) %>%
  summarize(late_10 = sum(arr_delay == 10, na.rm = TRUE) / n()) %>%
  filter(late_10 == 1)

# Q1: A flight is 30 minutes early 50% of the time, and 30 minutes late 50% of the time.
flights %>%
  group_by(flight) %>%
  summarize(early_30_min = sum(arr_delay <= -30, na.rm = TRUE) / n(),
            late_30_min = sum(arr_delay >= 30, na.rm = TRUE) / n()) %>%
  filter(early_30_min == 0.5, late_30_min == 0.5)

# Q1: 99% of the time a flight is on time. 1% of the time it's 2 hours late. [zero records]
flights %>%
  group_by(flight) %>%
  summarize(on_time = sum(arr_delay == 0, na.rm = TRUE) / n(),
            late_2_hours = sum(arr_delay >= 120, na.rm = TRUE) / n()) %>%
  filter(on_time == .99, late_2_hours == .01)

# Q2-7: Review [http://cfss.uchicago.edu/r4ds_solutions.html], sometime. Can't 'take it in' atm


# CHAPTER 3
# Exercises (P. 75)
# Q2,3,5: Review [http://cfss.uchicago.edu/r4ds_solutions.html], sometime. Can't 'take it in' atm




# CHAPTER x
# Exercises (P. xx)