library(tidyverse)
library(stringr)

----------
# SECTION 14 [Chapter 11 hardcopy]
# 14.2.5 Exercises

# Q1.
# In code that doesn’t use stringr, you’ll often see paste() and paste0().
# What’s the difference between the two functions? What stringr function are they equivalent to?
# How do the functions differ in their handling of NA?

# A1.
?paste
# "paste converts its arguments to character strings, and concatenates them (separating them by the string given by sep)"
# "paste0(..., collapse) is equivalent to paste(..., sep = "", collapse), slightly more efficiently" -- Help

# 'paste separates strings by spaces by default, while paste0 does not separate strings by default. As str_c() does not
# separate strings by default, it is closer in behaviour to paste0' -- based on https://jrnold.github.io/e4qf/strings.html

# str_c() : "missing values are contagious. If you want them to print as "NA", use str_replace_na()" -- s14.2.2
# paste() : "coerces NA, the character missing value, to "NA"" -- Help

# str_c() propagates NA. If any argument is a missing value, it returns a missing value (as do most other functions in R).
# However, the paste functions convert NA to the string "NA" and then treat it as any other character vector -- based on https://jrnold.github.io/e4qf/strings.html


# Q2. In your own words, describe the difference between the sep and collapse arguments to str_c().
# A2.
str_c("x", "y", sep = ", ") # "Use the sep argument to control how they’re separated" -- s14.2.2
str_c(c("x", "y", "z"), collapse = ", ") # "To collapse a vector of strings into a single string, use collapse" -- s14.2.2

# "sep	: String to insert between input vectors.
# collapse : Optional string used to combine input vectors into single string" -- Help

# 'sep' is the string inserted between arguments to str_c()
# 'collapse' is the string used to separate any elements of the character vector into a character vector of length one
# NO, I DON'T REALLY SEE THE DIFFERENCE
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX


# Q3.
# Use str_length() and str_sub() to extract the middle character from a string.
# What will you do if the string has an even number of characters?

# A3.
?ceiling
# To handle an even number of characters, choose formula to 'round' up or down. ('up' is ok with only one character)
x <- c("a", "abc", "abcd", "abcde", "abcdef")
L <- str_length(x)
m <- ceiling(L / 2) # choosing 'floor()' here would give a zero value for the single character "a" string
str_sub(x, m, m) # [1] "a" "b" "b" "c" "c". This isn't really rounding up from middle of "abcd", as it chooses "b" etc
# -- https://jrnold.github.io/e4qf/strings.html


# Q4. What does str_wrap() do? When might you want to use it?
?str_wrap
# A4.
# "Wrap strings into nicely formatted paragraphs ... Implements the Knuth-Plass paragraph wrapping algorithm" -- Help
# "wraps text so that it fits within a certain width ... For wrapping long strings of text to be typeset" -- https://jrnold.github.io/e4qf/strings.html


# Q5. What does str_trim() do? What’s the opposite of str_trim()?
?str_trim
# A5.
# "Trim whitespace from start and end of string" -- Help
# str_pad() adds whitespace to each side


# Q6.
# Write a function that turns (e.g.) a vector c("a", "b", "c") into the string a, b, and c.
# Think carefully about what it should do if given a vector of length 0, 1, or 2

# A6.
# We haven't covered functions yet? [Week 10, Chapter 19]. But this is for 2nd part :
# length 0 : ""
# length 1 : eg. "a"
# length 2 : eg. "a and b"
# length 3 : "a, b, and c"

# However, from https://jrnold.github.io/e4qf/strings.html#exercises-23 :
str_commasep <- function(x, sep = ", ", last = ", and ") {
  if (length(x) > 1) {
    str_c(str_c(x[-length(x)], collapse = sep),
          x[length(x)],
          sep = last)
  } else {
    x
  }
}
# I don't really understand how this is working, particularly code inside the first {}
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX


----------
# SECTION 14 [Chapter 11 hardcopy]
# 14.3.1.1 Exercises

# Q1.
# Explain why each of these strings <in a regexp> don’t match a \ <within strings you're searching> : "\", "\\", "\\\"

# A1.
# If \ is used as an escape character in regular expressions, how do you *match* a literal \? Well you need to escape it,
# creating the regular expression \\. To create that regular expression, you need to use a string, which also needs to
# escape \. That means to match a literal \ you need to write "\\\\" — you need four backslashes to match one! -- s14.3.1

# "\" : will escape the next character in the regexp (whatever that is, but will not resolve to \)
# "\\" : will resolve to \ in the regexp, which will escape the next character in the regexp
# "\\\" : The first two will resolve to a literal backslash in the regexp, the third will escape the next character.
#         So in the regular expression, this will escape some escaped character. ??? EH?
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX


# Q2. How would you match <to> the sequence "'\ <if it exists within a series of strings you're searching> ?

# A2.
# To include a literal single or double quote in a string you can use \ to “escape” it -- s14.2
# Beware that the printed representation of a string is not the same as string itself, because the printed
# representation shows the escapes. To see the raw contents of the string, use writeLines()
?'"' # in order to see list of Character Constants (like \n, \t, etc) on the Help page
?str_view # "str_view shows the first match; str_view_all shows all the matches"

x <- '\"\'\\'
x                  # shows [1] "\"'\\"
writeLines(x)      # shows "'\
# Does that answer the question?


# Q3.
# What patterns will the regular expression \..\..\.. match? How would you represent it as a string?

# A3.
# ...... : This is a literal dot followed by a 'wildcard', 3 times
# It will match any patterns that are a dot followed by any character, 3 times

y <- '\\..\\..\\..'
y                  # shows [1] "\\..\\..\\.."
writeLines(y)      # shows \..\..\..


----------
# SECTION 14 [Chapter 11 hardcopy]
# 14.3.2.1 Exercises

# Q1.
# How would you <write a regexp to> match the literal string "$^$" <if it exists within strings you're searching> ?

# A1.
# "To force a regular expression to only match a complete string, anchor it with both ^ and $" -- s14.3.2

z <- "^\\$\\^\\$$" # Able to take a guess at this, but I still need to check/adjust using writeLines() and str_view()
z                  # shows [1] "^\\$\\^\\$$"
writeLines(z)      # shows ^\$\^\$$

str_view(c("$^$", "pp$^$pp", "$^$qq", "rr$^$"), "^\\$\\^\\$$")


# Q2. Given the corpus of common words in stringr::words, create regular expressions that find all words that:
# Q2.1 Start with “y”.
# Q2.2 End with “x”
# Q2.3 Are exactly three letters long. (Don’t cheat by using str_length()!)
# Q2.4 Have seven letters or more.
# Since this list is long, you might want to use the match argument to str_view() to show only the matching or non-matching words

?str_view
stringr::words

str_view(stringr::words, "^y", match = TRUE)       # A2.1
str_view(stringr::words, "x$", match = TRUE)       # A2.2
str_view(stringr::words, "^...$", match = TRUE)    # A2.3
str_view(stringr::words, "^.......", match = TRUE) # A2.4


----------
# SECTION 14 [Chapter 11 hardcopy]
# 14.3.3.1 Exercises

# Q1. Create regular expressions to find all words that:
# Q1.1 Start with a vowel
# Q1.2 That only contain consonants. (Hint: thinking about matching “not”-vowels)
# Q1.3 End with ed, but not with eed
# Q1.4 End with ing or ise

# A1.1
str_view(stringr::words, "^(a|e|i|o|u)", match = TRUE)
str_view(stringr::words, "^[aeiou]", match = TRUE)     # This is better/clearer than above, to choose from single letters

# A1.2
str_view(stringr::words, "^[^aeiou]", match = TRUE)    # Starts with a consonant. HOW DO I DO THAT FOR THE REST?
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

# A1.3
str_view(stringr::words, "[^e]ed$", match = TRUE)      # There is no 2-letter word "ed" in stringr::words, so this is ok

# A1.4
str_view(stringr::words, "ing$|ise$", match = TRUE)    # or could use "i(ng|se)$", which is shorter (but less clear?)


# Q2. Empirically verify the rule “i before e except after c”
# A2.
str_view(stringr::words, "([^c]ie|cei)", match = TRUE)     # 14 words match the rule
str_view(stringr::words, "([^c]ei|cie)", match = TRUE)     # but 3 (ie. >0) words here show it to actually be wrong


# Q3. Is “q” always followed by a “u”?
# A3.
str_view(stringr::words, "q[^u]", match = TRUE)            # Zero words match, so 'yes' (from this list of words)


# Q4. Write a regular expression that matches a word if it’s probably written in British English, not American English.
# A4.
str_view(stringr::words, "(our$|ise$|^bloke$|^brilliant$|ntre|^chap$|^quid$)", match = TRUE)
# Some false +ves, and came from looking through the list of 'stringr::words' (though I did think of 'our' & 'ise')


# Q5. Create a regular expression that will match telephone numbers as commonly written in your country
# A5.
x <- c("0117 912 3456", "01179123456")
str_view(x, "\\d\\d\\d\\d \\d\\d\\d \\d\\d\\d\\d")       # matches the first one, not the second
str_view(x, "\\d\\d\\d\\d\\s\\d\\d\\d\\s\\d\\d\\d\\d")   # alternate ('better') way, using '\s' for whitespace


----------
# SECTION 14 [Chapter 11 hardcopy]
# 14.3.4.1 Exercises
  
# Q1. Describe the equivalents of ?, +, * in {m,n} form
# A1.
# ? : 0 or 1    -- s14.3.4 : {,1}, matching at most 1
# + : 1 or more -- s14.3.4 : {1,}, matching 1 or more
# * : 0 or more -- s14.3.4 : "There is no direct equivalent of * in {m,n} form since there are no bounds on the matches:
#                              it can be 0 up to infinity matches" -- https://jrnold.github.io/e4qf/strings.html
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX CAN WE USE {0,} or {,} ?


# Q2.
# Describe in words what these regular expressions match:
# (read carefully to see if I’m using a regular expression or a string that defines a regular expression)
# Q2.1 ^.*$
# Q2.2 "\\{.+\\}"
# Q2.3 \d{4}-\d{2}-\d{2}
# Q2.4 "\\\\{4}"

# A2.1 .*             : Would match any string (of any length)
# A2.2 \{.+\}         : Would match curly braces around >= 1 character
# A2.3 eg. 1111-22-33 : 4 digits dash 2 digits dash 2 digits. Could be a date, with Year first
# A2.4 \\{4}          : 4 backslashes


# Q3.
# Create regular expressions to find all words that:
# Q3.1 Start with three consonants
# Q3.2 Have three or more vowels in a row
# Q3.3 Have two or more vowel-consonant pairs in a row

str_view(stringr::words, "^[^aeiou]{3}", match = TRUE)              # A3.1
str_view(stringr::words, "[aeiou]{3,}", match = TRUE)               # A3.2
str_view(stringr::words, "([aeiou][^aeiou]){2,}", match = TRUE)     # A3.3


# Q4. Solve the beginner regexp crosswords at https://regexcrossword.com/challenges/beginner
# A4. (Did the 1st one ok. Then didn't know what \1 was, in the 2nd and 3rd. And gave up)


----------
# SECTION 14 [Chapter 11 hardcopy]
# 14.3.5.1 Exercises

# Q1.
# Describe, in words, what these expressions will match:
# Q1.1 (.)\1\1
# Q1.2 "(.)(.)\\2\\1"
# Q1.3 (..)\1
# Q1.4 "(.).\\1.\\1"
# Q1.5 "(.)(.)(.).*\\3\\2\\1"

# A1.1 Any character (the same one) 3 times in a row. (eg. xxx)
# A1.2 character1, character2, character2, character1. (eg. xyyx)
# A1.3 Two characters, repeated again. (eg. abab)
# A1.4 character1, character_any, character1, character_any, character1. (eg. abaca)
# A1.5 Three characters, then some characters, then the original three in reverse. (eg. xyz45826zyx)


# Q2.
# Construct regular expressions to match words that:
# Q2.1 Start and end with the same character
# Q2.2 Contain a repeated pair of letters (e.g. “church” contains “ch” repeated twice.)
# Q2.3 Contain one letter repeated in at least three places (e.g. “eleven” contains three “e”s.)

str_view(stringr::words, "^(.).*\\1$", match = TRUE)           # A2.1
str_view(stringr::words, "(..).*\\1", match = TRUE)            # A2.2
str_view(stringr::words, "(.).*\\1.*\\1", match = TRUE)        # A2.3


----------
# SECTION 14 [Chapter 11 hardcopy]
# 14.4.2 Exercises

# Q1.
# For each of the following challenges, try solving it by using both a single regular expression, and a combination
# of multiple str_detect() calls:
# Q1.1 Find all words that start or end with x
# Q1.2 Find all words that start with a vowel and end with a consonant
# Q1.3 Are there any words that contain at least one of each different vowel?

# A1.1
str_view(stringr::words, "^x|x$", match = TRUE)                     # (None starts with x.) End: box, sex, six, tax
stringr::words[str_detect(stringr::words, "^x|x$")]                 # Alternative. Same results in Console (not Viewer)
str_subset(stringr::words, "^x|x$")                                 # Alternative. Same results in Console (not Viewer)

start_x <- str_detect(stringr::words, "^x")
end_x <- str_detect(stringr::words, "x$")
stringr::words[start_x | end_x]                                     # Combination. Same results in Console


# A1.2
str_view(stringr::words, "^[aeiou].*[^aeiou]$", match = TRUE)       # In Viewer
stringr::words[str_detect(stringr::words, "^[aeiou].*[^aeiou]$")]   # Alternative. In Console
str_subset(stringr::words, "^[aeiou].*[^aeiou]$")                   # Alternative. In Console

start_vowel <- str_detect(stringr::words, "^[aeiou]")
end_consonant <- str_detect(stringr::words, "[^aeiou]$")
stringr::words[start_vowel & end_consonant]                         # Combination. Same results in Console


# A1.3
str_view(stringr::words, "([aeiou]).*\\1.*\\1.*\\1.*\\1", match = TRUE)
# None has 5 vowels, so none has 5 different. (WRONG - This code looks for the *same* vowel 5 times)
str_view(stringr::words, "[aeiou].*[aeiou].*[aeiou].*[aeiou].*[aeiou]", match = TRUE)
# Returns 8 words with 5 vowels. By *inspection*, none has 5 different. ('associate', 'colleague', 'appropriate' have 4)

contains_a <- str_detect(words, "a")
contains_e <- str_detect(words, "e")
contains_i <- str_detect(words, "i")
contains_o <- str_detect(words, "o")
contains_u <- str_detect(words, "u")
words[contains_a & contains_e & contains_i & contains_o & contains_u]
# Seemed to work ok (no errors). No matches (as expected, but doesn't prove that code works)
# Replaced 'words' with "baeiout", and code worked (matched) -- Suggested by https://jrnold.github.io/e4qf/strings.html


# Q2.
# What word has the highest number of vowels? What word has the highest proportion of vowels?
# (Hint: what is the denominator?)

# A2.
words[str_detect(words, "[aeiou].*[aeiou].*[aeiou].*[aeiou].*[aeiou]")]              # 5 vowels. re. A1.3
words[str_detect(words, "[aeiou].*[aeiou].*[aeiou].*[aeiou].*[aeiou].*[aeiou]")]     # BUT 6 vowels. No match

proportion_vowels <- str_count(words, "[aeiou]") / str_length(words)           # proportion, for each word
words[which(proportion_vowels == max(proportion_vowels))]                      # max is 100%, when the word is a vowel
# -- https://jrnold.github.io/e4qf/strings.html
# str_length() was in s14.2.1 so that's ok ...BUT we haven't coverered which() or max() in the book

proportion_vowels <- str_count(words, "[aeiou]") / str_length(words)           # proportion, for each word
words[proportion_vowels == 1]                                                  # max is 100%, when the word is a vowel


----------
# SECTION 14 [Chapter 11 hardcopy]
# 14.4.3.1 Exercises

# Q1.
# In the previous example, you might have noticed that the regular expression matched “flickered”, which is not a colour.
# Modify the regex to fix the problem

# A1.
# Question is referring to s14.4.3
# regex could have whitespace [\s] each side of each colour word. But I got confused which bits of s14.4.3 code did what.
# https://jrnold.github.io/e4qf/strings.html : "Add the \b before and after the pattern", which is similar but different
# to \s. ("You can also match the boundary between words with \b" -- s14.3.2). Copied from there (but edited 'more2') :

colours <- c("red", "orange", "yellow", "green", "blue", "purple")
colour_match2 <- str_c("\\b(", str_c(colours, collapse = "|"), ")\\b")       # This is the row that answers the question
more2 <- sentences[str_count(sentences, colour_match2) > 1]
str_view_all(more2, colour_match2, match = TRUE)


# Q2.
# From the Harvard sentences data, extract:
# Q2.1 The first word from each sentence
# Q2.2 All words ending in ing
# Q2.3 All plurals

?str_extract
str_extract(stringr::sentences, "^\\b(.+)\\b")      # A2.1 Why does this return whole sentence? - doesn't \b find a word?
str_extract(stringr::sentences, "^\\b.+\\b")        # Returned whole sentence

str_extract(stringr::sentences, "^\\b[a-z]+\\b")
str_extract(stringr::sentences, "^\\b[a-z]+?\\b")

str_extract(stringr::sentences, "^\\b(.+)?\\b")     # Returned whole sentence ***
str_extract(stringr::sentences, "^\\b(.+)\\b?")     # Error
str_extract(stringr::sentences, "^\\b.+?\\b")       # THIS ONE WORKED         ***
str_extract(stringr::sentences, "^\\b.+\\b?")       # Error
str_extract(stringr::sentences, "^\\b.?\\b")
str_extract(stringr::sentences, "^\\b.+?")          # Returned 1st letter
str_extract(stringr::sentences, "^.+?\\b")          # THIS ONE WORKED
str_extract(stringr::sentences, "^.+?")             # Returned 1st letter

str_extract(stringr::sentences, "[A-Za-z]+\\w")     # THIS ONE WORKED
str_extract(stringr::sentences, "[A-Za-z]+")        # THIS ONE WORKED         ***

str_extract(stringr::sentences, ".+?")              # Returned 1st letter
str_extract(stringr::sentences, "(.+)?")            # Returned whole sentence
str_extract(stringr::sentences, "^\\b[A-Za-z]+\\b") # THIS ONE WORKED


# A2.2
# A2.3
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
# Answers to Q2 at https://jrnold.github.io/e4qf/strings.html use things we haven't covered in the book
# ...[a-zA-Z], unique(), unlist()


----------
# SECTION 14 [Chapter 11 hardcopy]
# 14.4.4.1 Exercises
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

# Q1. Find all words that come after a “number” like “one”, “two”, “three” etc. Pull out both the number and the word

# A1.


# Q2. Find all contractions. Separate out the pieces before and after the apostrophe

# A2.


----------
# SECTION 14 [Chapter 11 hardcopy]
# 14.4.5.1 Exercises
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

# Q1. Replace all forward slashes in a string with backslashes

# Q2. Implement a simple version of str_to_lower() using replace_all()

# Q3. Switch the first and last letters in words. Which of those strings are still words?


----------
# SECTION 14 [Chapter 11 hardcopy]
# 14.4.6.1 Exercises
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

# Q1. Split up a string like "apples, pears, and bananas" into individual components

# Q2. Why is it better to split up by boundary("word") than " "?

# Q3. What does splitting with an empty string ("") do? Experiment, and then read the documentation




----------
# SECTION 14 [Chapter 11 hardcopy]
# 14.5.1 Exercises
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

# Q1. How would you find all strings containing \ with regex() vs. with fixed()?


# Q2. What are the five most common words in sentences?




----------
# SECTION 14 [Chapter 11 hardcopy]
# 14.7.1 Exercises

# Q1.
# Find the stringi functions that:
# Q1.1 Count the number of words
# Q1.2 Find duplicated strings
# Q1.3 Generate random text

# A1.
# A1.1 'stri_count_words'
# A1.2 'stri_duplicated'
# A1.3 'stri_rand_strings' generates random strings. ('stri_rand_lipsum' generates lorem ipsum text)


# Q2. How do you control the language that stri_sort() uses for sorting?
?stri_sort
# A2. Use the 'locale' argument to the 'opts_collator' argument. (See also 'stri_opts_collator()')