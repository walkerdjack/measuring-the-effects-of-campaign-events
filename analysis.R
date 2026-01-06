##############################################################################
# Public Replication Archive
#
# Lockhart, M., Huber, G. A., Gerber, A. S., & Walker, J. D. II. [Date].
# "Measuring the Effects of Campaign Events: Specifying and Comparing Estimates
# of the Effect of Trump's Conviction." Political Science Research and Methods.
##############################################################################

##############################################################################
# Table of contents:
# I.    Data preparation    Line 17
# II.   Recode variables    Line 35
# III.  Begin figure        Line 136
##############################################################################

##############################################################################
# I. DATA PREPARATION
##############################################################################

# Load required libraries.
library(haven)
library(dplyr)
library(tibble)
library(tidyr)
library(purrr)
library(broom)
library(sandwich)
library(lmtest)
library(ggplot2)

# Load public dataset from Stata. 
data <- read_dta("psrm_lockhart_etal_public.dta")

##############################################################################
# II. RECODE VARIABLES
##############################################################################

# Recode vote if Trump is guilty variable.
data <- data %>%
  mutate(vote_if_trump_guilty = case_when(
    g4w16_vote_if_trump_guilty %in% c(1, 3) ~ 1,
    g4w16_vote_if_trump_guilty == 2 ~ 2,
    g4w16_vote_if_trump_guilty == 4 ~ 3,
    g4w16_vote_if_trump_guilty == 5 ~ 4,
    TRUE ~ NA_real_
  ))
data$vote_if_trump_guilty <- factor(data$vote_if_trump_guilty, 
                                    levels = c(1, 2, 3, 4),
                                    labels = c("Someone else/Joe Biden", 
                                               "Donald Trump", 
                                               "Not sure", 
                                               "Will not vote"))

# Recode vote if Trump is not guilty variable.
data <- data %>%
  mutate(vote_if_trump_not_guilty = case_when(
    g4w16_vote_if_trump_not_guilty %in% c(1, 3) ~ 1,
    g4w16_vote_if_trump_not_guilty == 2 ~ 2,
    g4w16_vote_if_trump_not_guilty == 4 ~ 3,
    g4w16_vote_if_trump_not_guilty == 5 ~ 4,
    TRUE ~ NA_real_
  ))
data$vote_if_trump_not_guilty <- factor(data$vote_if_trump_not_guilty, 
                                        levels = c(1, 2, 3, 4),
                                        labels = c("Someone else/Joe Biden", 
                                                   "Donald Trump", 
                                                   "Not sure", 
                                                   "Will not vote"))

# Generate voter types. 
data <- data %>%
  mutate(conflicted_voters = as.numeric(
    vote_if_trump_not_guilty == "Donald Trump" & 
      vote_if_trump_guilty %in% c("Someone else/Joe Biden", "Not sure", "Will not vote")),
    unconditional_voters = as.numeric(
      vote_if_trump_not_guilty == "Donald Trump" & 
        vote_if_trump_guilty == "Donald Trump"),
    not_trump = as.numeric(
      vote_if_trump_not_guilty %in% c("Someone else/Joe Biden", "Not sure", "Will not vote") &
        vote_if_trump_guilty %in% c("Someone else/Joe Biden", "Not sure", "Will not vote")))

# Recode vote choice variables.
data <- data %>%
  mutate(week_4_rc = case_when(
    g4w4_heat_biden_trump == 1 ~ 0,
    g4w4_heat_biden_trump == 2 ~ 1,
    g4w4_heat_biden_trump %in% c(11, 12, 13, 88, 98, 99) ~ 0,
    TRUE ~ NA_real_),
    week_8_rc = case_when(
      g4w8_heat_biden_trump == 1 ~ 0,
      g4w8_heat_biden_trump == 2 ~ 1,
      g4w8_heat_biden_trump %in% c(11, 12, 13, 88, 98, 99) ~ 0,
      TRUE ~ NA_real_),
    week_12_rc = case_when(
      g4w12_presvote24 == 1 ~ 0,
      g4w12_presvote24 == 2 ~ 1,
      g4w12_presvote24 %in% c(11, 12, 13, 88, 98, 99) ~ 0,
      TRUE ~ NA_real_),
    week_16_rc = case_when(
      g4w16_presvote24 == 1 ~ 0,
      g4w16_presvote24 == 2 ~ 1,
      g4w16_presvote24 %in% c(11, 12, 13, 88, 98, 99) ~ 0,
      TRUE ~ NA_real_),
    week_20_rc = case_when(
      g4w20_presvote24 == 1 ~ 0,
      g4w20_presvote24 == 2 ~ 1,
      g4w20_presvote24 %in% c(11, 12, 13, 88, 98, 99) ~ 0,
      TRUE ~ NA_real_),
    week_24_rc = case_when(
      deb_presvote24_pre == 1 ~ 0,
      deb_presvote24_pre == 2 ~ 1,
      deb_presvote24_pre %in% c(11, 12, 13, 88, 98, 99) ~ 0,
      TRUE ~ NA_real_),
    week_28_rc = case_when(
      g4w28_presvote24h == 1 ~ 0,
      g4w28_presvote24h == 2 ~ 1,
      g4w28_presvote24h %in% c(11, 12, 13, 88, 98, 99) ~ 0,
      TRUE ~ NA_real_),
    week_32_rc = case_when(
      g4w32_presvote24h == 1 ~ 0,
      g4w32_presvote24h == 2 ~ 1,
      g4w32_presvote24h %in% c(11, 12, 13, 88, 98, 99) ~ 0,
      TRUE ~ NA_real_))

# Create vectors of outcome variables and weights.
outcome_vars <- paste0("week_", c(4, 8, 12, 20, 24, 28, 32), "_rc")
outcome_vars <- paste0("week_", seq(4, 32, 4), "_rc")
weights <- paste0("g4w", c(4, 8, 12, 20, 24, 28, 32), "_weight")
weights <- paste0("g4w", seq(4, 32, 4), "_weight")
weights[5] <- "deb_weight_pre" # Note that week 24 uses deb_weight_pre.

# Subset to respondents who support Trump if not guilty.
df <- subset(data, data$vote_if_trump_not_guilty=="Donald Trump")

##############################################################################
# III. BEGIN FIGURE
##############################################################################

# Regress conflicted voters.
fit_list <- mapply(function(x, y) 
  lm(formula(paste0(x, " ~ conflicted_voters")),
     data = df,
     weights = df[[y]]), outcome_vars, weights)
list2<-lapply(fit_list, function(m) coeftest(m, vcov = vcovHC(m, type="HC1")))

# Tidy results for plotting. 
mods <- list()
for(i in 1:8){
  varx <- outcome_vars[i]
  weightx <- weights[i]
  tidy_results <- tidy(list2[[i]]) %>%
    mutate(outcome = varx)
  mods[[varx]] <- tidy_results
}

# Combine all regression results.
combined_results <- bind_rows(mods) %>%
  filter(term != "(Intercept)") # Filter out intercept.
combined_results$outcome <- factor(combined_results$outcome,
                                   outcome_vars)

# Create plot.
combined_results %>% filter(outcome != "week_16_rc") %>%
  ggplot(aes(x = outcome, y = estimate, 
             ymin = estimate - 1.96 * std.error, 
             ymax = estimate + 1.96 * std.error)) +
  geom_pointrange(position = position_dodge(width = 0.5)) +
  geom_hline(yintercept = 0, linetype = "dashed") +
  labs(title = "Difference in Support for Trump Between Conditional and \nUnconditional Trump Supporters Across Different Weeks",
       x = "Week",
       y = "Coefficient Estimate") +
  theme_minimal() + theme(axis.text.x = element_text(angle = 45)) +
  scale_x_discrete(labels= paste0("Week ", c(4, 8, 12, 20, 24, 28, 32)))

# Save plot.
ggsave("figa1.png", width=6, height=4)