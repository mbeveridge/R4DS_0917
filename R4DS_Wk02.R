library(tidyverse)

----------
# SECTION 3 [Chapter 1 hardcopy]
# 3.2.4 Exercises

# Q1. Run ggplot(data = mpg). What do you see?
ggplot(data = mpg)
# A1. Grey background. No axes or data visaible


# Q2. How many rows are in mpg? How many columns?
mpg
# A2. 234 rows x 11 columns


# Q3. What does the drv variable describe? Read the help for ?mpg to find out.
?mpg
# A3. f = front-wheel drive, r = rear wheel drive, 4 = 4wd


# Q4. Make a scatterplot of hwy vs cyl [...y v's x]
# A4.
ggplot(data = mpg) +
  geom_point(mapping = aes(x = cyl, y = hwy))


# Q5. What happens if you make a scatterplot of class vs drv? Why is the plot not useful?
ggplot(data = mpg) +
  geom_point(mapping = aes(x = drv, y = class))

# A5. The plot has 2 categorical variables, (but shows no dependency), with an unknown number of points at many intersections (ie. overlap)


-----------
# SECTION 3 [Chapter 1 hardcopy]
# 3.3.1 Exercises

# Q1. What’s gone wrong with this code? Why are the points not blue?
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = "blue"))

# A1. Needs to be outside the aes() to work like that. (Inside, it just creates a 'True' condition, but with no say over what colour represents it in the plot)


# Q2. Which variables in mpg are categorical? Which variables are continuous? How can you see this information when you run mpg?
?mpg
mpg

# A2.
# Categorical : <chr> : manufacturer; model; trans; drv; fl; class ...6
# Continuous : <dbl> or <int> : displ; year; cyl; cty; hwy ...5


# Q3.
# Map a continuous variable to color, size, and shape. [I initially misunderstood the requirement, and mapped them all in one plot]
# How do these aesthetics behave differently for categorical vs. continuous variables?
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy, color = cty))
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy, size = cty))
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy, shape = cty))

ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy, color = drv))
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy, size = drv))
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy, shape = drv))

# A3.
# color : different hues v's tints & shades of a single hue
# size : allocation of size to variable is arbitrary (warning) v's relates to size of variable
# shape : allocation of shape to variable is arbitrary v's error (as 'meaningless')


# Q4. What happens if you map the same variable to multiple aesthetics?
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = displ, size = hwy))

# A4. The plot uses all the aesthetics. But there is redundancy, which can also be confusing (as a reader expects that an aesthetic is added for extra insight)


# Q5. What does the stroke aesthetic do? What shapes does it work with?
?geom_point
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy), shape = 21, colour = "black", fill = "white", size = 5, stroke = 5)

# A5. "For shapes that have a border (like 21), you can colour the inside and outside separately. Use the stroke aesthetic to modify the width of the border"


# Q6. What happens if you map an aesthetic to something other than a variable name, like aes(colour = displ < 5) ?
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = displ < 5))

# A6. Expression is True/False for each point, splitting 'displ' into 2 sets with different colours


-----------
# SECTION 3 [Chapter 1 hardcopy]
# 3.5.1 Exercises

# Q1. What happens if you facet on a continuous variable?
ggplot(data = mpg) +
  geom_point(mapping = aes(x = drv, y = cyl)) +
  facet_wrap(~ displ)

# A1. A cell is created for every value of the continuous variable. (Unlikely to be the most insightful choice)


# Q2. What do the empty cells in plot with facet_grid(drv ~ cyl) mean? How do they relate to this plot?
ggplot(data = mpg) +
  geom_point(mapping = aes(x = drv, y = cyl))
ggplot(data = mpg) +
  geom_point(mapping = aes(x = drv, y = cyl)) +
  facet_grid(drv ~ cyl)

# A2.
# 1st plot maps combinations of 2 categorical variables. No point at an intersection means the data doesn't contain that combination
# 2nd plot has an empty cell when 'the data doesn't contain that combination'


# Q3. What plots does the following code make? What does . do?
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ .)
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(. ~ cyl)

# A3.
# 1st plot has long horizontal cells (3 rows, no cols)
# 2nd plot has tall vertical cells (0 rows, 4 cols)
# . acts as a placeholder in the script (when facet_grid is missing a variable), and causes no faceting in that dimension


# Q4.
# Take the first faceted plot in this section.
# What are the advantages to using faceting instead of the colour aesthetic? What are the disadvantages?
# How might the balance change if you had a larger dataset?
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_wrap(~ class, nrow = 2)
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, colour = class))

# A4.
# Adv : reduces qty of points in a cell, so less overlapping and easier to spot different trends
# Disadv : harder to judge location of points in a cell relative to other cells (ie. overall picture). Squeezes the size of a cell
# Larger dataset has more overlapping, unless faceting used. (Though if the categorical variables used for faceting have many values, the cells will be tiny)


# Q5. 
# Read ?facet_wrap. What does nrow do? What does ncol do?
# What other options control the layout of the individual panels?
# Why doesn’t facet_grid() have nrow and ncol argument?
?facet_wrap
# A5.
# facet_wrap wraps a 1d sequence of panels into 2d. This is generally a better use of screen space than facet_grid because most displays are roughly rectangular
# nrow breaks a single row of cells into the specified number of rows. Similarly ncol specifies number of cols to have in the plot
# as.table [= TRUE or FALSE] determines the starting facet to begin filling the plot. And dir [= "h" or "v"] determines the starting direction for filling in the plot
# facet_grid() has its x and y dimensions determined by its arguments (number of unique values of the 2 variables)


# Q6. When using facet_grid() you should usually put the variable with more unique levels in the columns. Why?
# A6. PC displays are usually landscape format, so a reader can distinguish many columns more easily than many rows (and dependent variable is usually y-axis)


-----------
# SECTION 3 [Chapter 1 hardcopy]
# 3.6.1 Exercises

# Q1. What geom would you use to draw a line chart? A boxplot? A histogram? An area chart?
# A1. geom_line(), geom_boxplot(), geom_histogram(), geom_area()


# Q2. Run this code in your head and predict what the output will look like. Then, run the code in R and check your predictions
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) +
  geom_point() +
  geom_smooth(se = FALSE)


# Q3.
# What does show.legend = FALSE do? What happens if you remove it?
# Why do you think I used it earlier in the chapter?
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) +
  geom_point(show.legend = FALSE) +
  geom_smooth(show.legend = FALSE, se = FALSE)

# A3.
# Plot does not have a legend. Removing 'FALSE' will add a legend (because default is 'TRUE')
# 'FALSE' used earlier, to 'expand' the size of the plot used by data


# Q4.What does the se argument to geom_smooth() do?
?geom_smooth
# A4. "display confidence interval around smooth? (TRUE by default, see level to control" ...ie. adds error bands to a line


# Q5. Will these two graphs look different? Why/why not?
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) +
  geom_point() +
  geom_smooth()
ggplot() +
  geom_point(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) +
  geom_smooth(data = mpg, mapping = aes(x = displ, y = hwy, color = drv))

# A5.
# They will look the same, because the data & mapping settings are the same in each.
# (The settings cascade down ...ie. are inherited, but are superceded by local settings)


# Q6. Recreate the R code necessary to generate the following graphs
# A6.1
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point() +
  geom_smooth(color = "blue", se = FALSE)
# A6.2
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point() +
  geom_smooth(mapping = aes(group = drv), color = "blue", se = FALSE)
# A6.3
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) +
  geom_point() +
  geom_smooth(se = FALSE)
# A6.4
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(color = drv)) +
  geom_smooth(se = FALSE)
# A6.5
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(color = drv)) +
  geom_smooth(mapping = aes(linetype = drv), se = FALSE)
# A6.6
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(color = "white", stroke = 2) +
  geom_point(mapping = aes(color = drv))
# A6.6 Note the white points are in the earlier layer, with the colours then on top
# A6.6 Instead of 'stroke=2' could have used 'size=4' (from seeing someone else's answer)
# A6.6 Actually, why did 'stroke' work? - does it not need to be with a shapetype that can have color+fill?


-----------
# SECTION 3 [Chapter 1 hardcopy]
# 3.7.1 Exercises

# Q1.
# What is the default geom associated with stat_summary()?
#  How could you rewrite the previous plot to use that geom function instead of the stat function?
?stat_summary
?geom_pointrange
ggplot(data = diamonds) +
  stat_summary(mapping = aes(x = cut, y = depth), fun.ymin = min, fun.ymax = max, fun.y = median)

# A1.
# Default geom for stat_summary is geom_pointrange. But default stat for geom_pointrange is identity, so use geom_pointrange(stat = "summary")
ggplot(data = diamonds) +
  geom_pointrange(mapping = aes(x = cut, y = depth), stat = "summary", fun.ymin = min, fun.ymax = max, fun.y = median)


# Q2. What does geom_col() do? How is it different to geom_bar()?
?geom_col
?geom_bar

# A2.
# "geom_bar uses stat_count by default: it counts the number of cases at each x position.
# geom_col uses stat_identity: it leaves the data as is"
# geom_bar(stat = "identity") and geom_col() are equivalent


# Q3.
# Most geoms and stats come in pairs that are almost always used in concert
# Read through the documentation and make a list of all the pairs. What do they have in common?

# A3.
# http://ggplot2.tidyverse.org/reference/
# ?


# Q4. What variables does stat_smooth() compute? What parameters control its behaviour?
?stat_smooth
# A4.
# Four : y [predicted value]; ymin [lower pointwise confidence interval around the mean]; ymax [upper pointwise confidence interval around the mean]; se [standard error]
# Most importantly : method [smoothing method (function) to use]; se [whether to display confidence interval]; level [level of confidence interval to use (0.95 default)]


# Q5.
# In our proportion bar chart, we need to set group = 1. Why?
# In other words what is the problem with these two graphs?
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, y = ..prop..)) # 'prop' is 1.00 for each value of 'cut'
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = color, y = ..prop..)) # 'prop' is 7 for each value of 'cut' (7 colors)

# A5.
# We've relied on other variables to change aggregation (eg. color = drv instead of a separate group = drv)
# cf. s3.6 : "It is convenient to rely on this feature because the group aesthetic by itself does not add a legend or distinguishing features to the geoms"
# But '..prop..' means proportion of group, and that will be 100% unless we force it otherwise
# group=1 means everything is in the same group (named '1'), rather than in different groups (named Fair, Good, etc ...if group=cut) ...Imagine a field called 'group', where every row has the value '1' there
# group=2 or group=X would have the same effect. (Don't know why it has to be inside aes(), since it's a constant)
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, y = ..prop.., group = 1))
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = color, y = ..prop.., group = 1)) # Why isn't chart coloured?


-----------
# SECTION 3 [Chapter 1 hardcopy]
# 3.8.1 Exercises
  
# Q1. What is the problem with this plot? How could you improve it?
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_point()

# A1.
# Many of the data points overlap (overplotting).
# We can jitter the points, to improve the overall visualization (in this case)
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_jitter()


# Q2. What parameters to geom_jitter() control the amount of jittering?
?geom_jitter

# A2. width and height


# Q3. Compare and contrast geom_jitter() with geom_count()
?geom_count
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_count()

# A3.
# "This is a variant geom_point that counts the number of observations at each location, then maps the count to point area"
# It makes larger points where there is overplotting, so the number of visible points is equal to geom_point()


# Q4.
# What’s the default position adjustment for geom_boxplot()?
# Create a visualisation of the mpg dataset that demonstrates it
?geom_boxplot

#A4. position = "dodge" is the default
ggplot(data = mpg, mapping = aes(x = class, y = hwy, color = drv)) +
  geom_boxplot(position = "dodge")


-----------
# SECTION 3 [Chapter 1 hardcopy]
# 3.9.1 Exercises

# Q1. Turn a stacked bar chart into a pie chart using coord_polar()
# A1.
ggplot(data = mpg, mapping = (aes(x = 1, fill = class))) + # Need x. x=1 gave a single stack, centred on '1'. x=factor(1) would get rid of extra scaling marks
  geom_bar(position = "stack")

?coord_polar
ggplot(data = mpg, mapping = (aes(x = 1, fill = class))) + # x=factor(1) would get rid of extra scaling marks
  geom_bar(position = "stack") +
  coord_polar(theta = "y") # theta="y" gave pie segments, (instead of rings)


# Q2. What does labs() do? Read the documentation
?labs
# A2. labs is a shortcut function to add labels to different scales ...title, subtitle, axes, and caption


# Q3. What’s the difference between coord_quickmap() and coord_map()?
?coord_map
# A3.
# "coord_quickmap() sets the aspect ratio correctly for maps" -- R4DS text
# "coord_map projects a portion of the earth, which is approximately spherical, onto a flat 2D plane
# using any projection defined by the mapproj package. Map projections do not, in general, preserve
# straight lines, so this requires considerable computation. coord_quickmap is a quick approximation
# that does preserve straight lines. It works best for smaller areas closer to the equator"


# Q4. What does the plot below tell you about the relationship between city and highway mpg?
# Why is coord_fixed() important? What does geom_abline() do?
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_point() +
  geom_abline() +
  coord_fixed()

# A4. Relationship is positive and approximately linear. Slightly better highway mpg than city mpg
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_point() +
  geom_abline() + # draws a line that, by default, has an intercept of 0 and slope of 1
  coord_fixed() # draws equal intervals on the \(x\) and \(y\) axes so they are directly comparable (so abline is at 45 degrees)


-----------
# Comment & code from @aaron_g in (R4DS Slack) board=02_week on 15/9/17 06:25, in reply to query from @darh78
# Not one of the exercises, but saved here in case useful in future. (Slope charts in a lattice)
# "i think this kind of graph is much more informative (maybe this is what you had in mind to begin with)"
  
mpg1 <- mpg %>% 
  mutate(unique = rownames(mpg)) %>%
  gather("road_type" ,"MPG", c("cty", "hwy"))

ggplot(data = mpg1,mapping = aes(x = road_type, y = MPG, color=drv ,group=unique)) +
  geom_point() +
  facet_wrap(~manufacturer, nrow=3)+
  geom_line(alpha=0.5) +
  theme_linedraw(base_size = 14)