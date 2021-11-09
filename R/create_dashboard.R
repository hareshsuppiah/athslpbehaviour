


#' Generate an interactive Shiny dashboard app with ASBQ & PSQI Google Sheet data k-means clustering
#'
#' @param urlstring Input url string of Google Sheet data. Ensure that sharing is enabled on the GSheet is enabled
#'
#' @return A Shiny interactive app
#' @export
#' @import gsheet
#' @import dplyr
#' @import stringr
#' @import janitor
#' @import lubridate
#' @import weights
#' @import forcats
#' @import rmarkdown
#' @import flexdashboard
#' @import shiny
#' @import tidyverse
#' @import ggrepel
#' @import data.table
#' @import rvest
#' @import DT
#' @import DataExplorer
#' @import recipes
#' @import umap
#' @import factoextra
#' @import kableExtra
#' @import crosstalk
#' @examples
#'
#' create_dashboard("https://docs.google.com/spreadsheets/d/1cnb_5DUQsbee96lL_5MVtf_nI8XmJqKmYQKFP9_INJY/edit?usp=sharing")
#'
#
# library(flexdashboard)
# library(shiny)
# library(shinyWidgets)
# library(tidyverse)
# library(plotly)
# library(tidyverse)
# library(ggrepel)
# library(data.table)
# library(rvest)
# library(DT)
# library(DataExplorer)
# library(recipes)
# library(dplyr)
# library(janitor)
# library(umap)
# library(forcats)
# library(factoextra)
# library(kableExtra)
# library(crosstalk)
# library(gsheet)
# library(weights)
#
# urlstring="https://docs.google.com/spreadsheets/d/1cnb_5DUQsbee96lL_5MVtf_nI8XmJqKmYQKFP9_INJY/edit?usp=sharing"

create_dashboard <- function(urlstring) {

  url_input <- as.character(urlstring)
  # Create variable with Google Sheet URL. Edit the following url to the correct Google Form containing the PSQI responses
  url <- url_input


  data_google_2 <-
    gsheet2tbl(url) # Create original data in a variable called 'data'

  # Variable name cleaning and data preparation ----

  b <- data_google_2 %>%
    dplyr::rename(
      "Name" = "What is your full name?",
      "Age" = "How old are you today?",
      "Gender" = "Please indicate your gender:",
      "Sport" = "What sport do you participate in?",
      "Bedtime" = "During the past month, what time have you usually gone to bed at night?",
      "SOL" = "During the past month, how long (in minutes) has it usually taken you to fall asleep each night?",
      "Waketime" = "During the past month, what time have you usually gotten up in the morning?",
      "TST.hrs" = "Hours",
      "TST.mins" = "Minutes",
      "fivea" = "a. Cannot get to sleep within 30 minutes",
      "fiveb" = "b. Wake up in the middle of the night or early morning",
      "fivec" = "c. Have to get up to use the bathroom",
      "fived" = "d. Cannot breathe comfortably",
      "fivee" = "e. Cough or snore loudly",
      "fivef" = "f. Feel too cold",
      "fiveg" = "g. Feel too hot",
      "fiveh" = "h. Have bad dreams",
      "fivei" = "i. Have pain",
      "fivej" = "j. Other reason(s), please describe:",
      "six" = "6. During the past month, how often have you taken medicine to help you sleep (prescribed or“over the counter”)?",
      "seven" = "7. During the past month, how often have you had trouble staying awake while driving, eating meals, or engaging in social activity?",
      "eight" = "During the past month, how much of a problem has it been for you to keep up enough enthusiasm to get things done?",
      "nine" = "During the past month, how would you rate your sleep quality overall?",
    ) %>%
    # Factorize 'Sport' variable
    mutate(
      Sport = as_factor(Sport)
    ) %>%
    # clean_names()
    # Replace ASBQ responses to numeric
    mutate(
      `I take afternoon naps lasting two or more hours` = recode(
        `I take afternoon naps lasting two or more hours`,
        "Never" = 1,
        "Rarely" = 2,
        "Sometimes" = 3,
        "Frequently" = 4,
        "Always" = 5
      ),
      `I use stimulants when I train/compete (e.g caffeine)` = recode(
        `I use stimulants when I train/compete (e.g caffeine)`,
        "Never" = 1,
        "Rarely" = 2,
        "Sometimes" = 3,
        "Frequently" = 4,
        "Always" = 5
      ),
      `I exercise (train or compete) late at night (after 7pm)` = recode(
        `I exercise (train or compete) late at night (after 7pm)`,
        "Never" = 1,
        "Rarely" = 2,
        "Sometimes" = 3,
        "Frequently" = 4,
        "Always" = 5
      ),
      `I consume alcohol within 4 hours of going to bed` = recode(
        `I consume alcohol within 4 hours of going to bed`,
        "Never" = 1,
        "Rarely" = 2,
        "Sometimes" = 3,
        "Frequently" = 4,
        "Always" = 5
      ),
      `I go to bed at different times each night (more than ±1 hour variation)` = recode(
        `I go to bed at different times each night (more than ±1 hour variation)`,
        "Never" = 1,
        "Rarely" = 2,
        "Sometimes" = 3,
        "Frequently" = 4,
        "Always" = 5
      ),
      `I go to bed feeling thirsty` = recode(
        `I go to bed feeling thirsty`,
        "Never" = 1,
        "Rarely" = 2,
        "Sometimes" = 3,
        "Frequently" = 4,
        "Always" = 5
      ),
      `I go to bed with sore muscles` = recode(
        `I go to bed with sore muscles`,
        "Never" = 1,
        "Rarely" = 2,
        "Sometimes" = 3,
        "Frequently" = 4,
        "Always" = 5
      ),
      `I use light-emitting technology in the hour leading up to bedtime (e.g laptop, phone, television, video games)` = recode(
        `I use light-emitting technology in the hour leading up to bedtime (e.g laptop, phone, television, video games)`,
        "Never" = 1,
        "Rarely" = 2,
        "Sometimes" = 3,
        "Frequently" = 4,
        "Always" = 5
      ),
      `I think, plan and worry about my sporting performance when I am in bed` = recode(
        `I think, plan and worry about my sporting performance when I am in bed`,
        "Never" = 1,
        "Rarely" = 2,
        "Sometimes" = 3,
        "Frequently" = 4,
        "Always" = 5
      ),
      `I think, plan and worry about issues not related to my sport when I am in bed` = recode(
        `I think, plan and worry about issues not related to my sport when I am in bed`,
        "Never" = 1,
        "Rarely" = 2,
        "Sometimes" = 3,
        "Frequently" = 4,
        "Always" = 5
      ),
      `I use sleeping pills/tablets to help me sleep` = recode(
        `I use sleeping pills/tablets to help me sleep`,
        "Never" = 1,
        "Rarely" = 2,
        "Sometimes" = 3,
        "Frequently" = 4,
        "Always" = 5
      ),
      `I wake to go to the bathroom more than once per night` = recode(
        `I wake to go to the bathroom more than once per night`,
        "Never" = 1,
        "Rarely" = 2,
        "Sometimes" = 3,
        "Frequently" = 4,
        "Always" = 5
      ),
      `I wake myself and/or my bed partner with my snoring` = recode(
        `I wake myself and/or my bed partner with my snoring`,
        "Never" = 1,
        "Rarely" = 2,
        "Sometimes" = 3,
        "Frequently" = 4,
        "Always" = 5
      ),
      `I wake myself and/or my bed partner with my muscle twitching` = recode(
        `I wake myself and/or my bed partner with my muscle twitching`,
        "Never" = 1,
        "Rarely" = 2,
        "Sometimes" = 3,
        "Frequently" = 4,
        "Always" = 5
      ),
      `I get up at different times each morning (more than ±1 hour variation)` = recode(
        `I get up at different times each morning (more than ±1 hour variation)`,
        "Never" = 1,
        "Rarely" = 2,
        "Sometimes" = 3,
        "Frequently" = 4,
        "Always" = 5
      ),
      `At home, I sleep in a less than ideal environment (e.g too light, too noisy, uncomfortable bed/pillow, too hot/cold)` = recode(
        `At home, I sleep in a less than ideal environment (e.g too light, too noisy, uncomfortable bed/pillow, too hot/cold)`,
        "Never" = 1,
        "Rarely" = 2,
        "Sometimes" = 3,
        "Frequently" = 4,
        "Always" = 5
      ),
      `I sleep in foreign environments (e.g hotel rooms)` = recode(
        `I sleep in foreign environments (e.g hotel rooms)`,
        "Never" = 1,
        "Rarely" = 2,
        "Sometimes" = 3,
        "Frequently" = 4,
        "Always" = 5
      ),
      `Travel gets in the way of building a consistent sleep-wake routine` = recode(
        `Travel gets in the way of building a consistent sleep-wake routine`,
        "Never" = 1,
        "Rarely" = 2,
        "Sometimes" = 3,
        "Frequently" = 4,
        "Always" = 5
      )
    ) %>%
    # Quantify ASBQ Global score
    mutate(`ASBQ Global` = rowSums(.[5:22])) %>%
    mutate(
      fiveacode = recode(
        fivea,
        "Not during the past month" = 0,
        "Less than once a week" = 1,
        "Once or twice a week" = 2,
        "Three or more times a week" = 3
      ),
      fivebcode = recode(
        fiveb,
        "Not during the past month" = 0,
        "Less than once a week" = 1,
        "Once or twice a week" = 2,
        "Three or more times a week" = 3
      ),
      fiveccode = recode(
        fivec,
        "Not during the past month" = 0,
        "Less than once a week" = 1,
        "Once or twice a week" = 2,
        "Three or more times a week" = 3
      ),
      fivedcode = recode(
        fived,
        "Not during the past month" = 0,
        "Less than once a week" = 1,
        "Once or twice a week" = 2,
        "Three or more times a week" = 3
      ),
      fiveecode = recode(
        fivee,
        "Not during the past month" = 0,
        "Less than once a week" = 1,
        "Once or twice a week" = 2,
        "Three or more times a week" = 3
      ),
      fivefcode = recode(
        fivef,
        "Not during the past month" = 0,
        "Less than once a week" = 1,
        "Once or twice a week" = 2,
        "Three or more times a week" = 3
      ),
      fivegcode = recode(
        fiveg,
        "Not during the past month" = 0,
        "Less than once a week" = 1,
        "Once or twice a week" = 2,
        "Three or more times a week" = 3
      ),
      fivehcode = recode(
        fiveh,
        "Not during the past month" = 0,
        "Less than once a week" = 1,
        "Once or twice a week" = 2,
        "Three or more times a week" = 3
      ),
      fiveicode = recode(
        fivei,
        "Not during the past month" = 0,
        "Less than once a week" = 1,
        "Once or twice a week" = 2,
        "Three or more times a week" = 3
      ),
      fivejcode = recode(
        fivej,
        "Not during the past month" = 0,
        "Less than once a week" = 1,
        "Once or twice a week" = 2,
        "Three or more times a week" = 3
      ),
      sixcode = recode(
        six,
        "Not during the past month" = 0,
        "Less than once a week" = 1,
        "Once or twice a week" = 2,
        "Three or more times a week" = 3
      ),
      sevencode = recode(
        seven,
        "Not during the past month" = 0,
        "Less than once a week" = 1,
        "Once or twice a week" = 2,
        "Three or more times a week" = 3
      ),
      eightcode = recode(
        eight,
        "No problem at all" = 0,
        "Only a slight problem" = 1,
        "Somewhat a problem" = 2,
        "A very big problem" = 3
      ),
      ninecode = recode(
        nine,
        "Very good" = 0,
        "Fairly good" = 1,
        "Fairly bad" = 2,
        "Very bad" = 3
      )
    ) %>%
    # Time variables
    dplyr::mutate(
      bedtime.date = as.POSIXct(Bedtime, tz = "GMT", origin = "1970-01-01 00:00:00"),
      waketime.date = as.POSIXct(Waketime, origin = "1970-01-01 00:00:00") + (24 * 60 * 60),
      # Add a day to waketime
      ## Convert bedtime to integer
      bedtime.int = as.integer(bedtime.date)

    )


  ## Set time cutoff for midnight and six am as integer and object for 12 hours
  midnight <-
    as.integer(as.POSIXct('1970-01-01 00:00:00', tz = "GMT"))
  sixam <-  as.integer(as.POSIXct('1970-01-01 06:00:00', tz = "GMT"))

  ## if converted time is after midnight, add by a day
  # if b$bedtime.int between midnight and sixam then b$bedtime.int +(24*60*60)
  i = 1
  for (i in c(1:nrow(b))) {
    if (b$bedtime.int[i] >= midnight &&  b$bedtime.int[i] < sixam) {
      b$bedtime.int[i] <- b$bedtime.int[i] + (24 * 60 * 60)
      # print(b$bedtime.int[i])
    }
  }


  # Convert corrected integer bedtime values back to POSIXct
  b <- b %>%
    mutate(

      bedtime.conv = as.POSIXct(b$bedtime.int, origin = "1970-01-01 00:00:00", tz = "GMT")
    )

  # If converted time for bedtime indicates a morning time between 06:01am to 1159 am (error in am vs pm), add 12 hours +(12*60*60)
  six.1 <- as.integer(as.POSIXct('1970-01-01 06:01:00', tz = "GMT"))
  eleven.59 <- as.integer(as.POSIXct('1970-01-01 11:59:00', tz = "GMT"))

  j = 1
  for (j in c(1:nrow(b))) {
    if (b$bedtime.int[j] >= six.1 &&  b$bedtime.int[j] <= eleven.59) {
      # b$bedtime.int[j] <- b$bedtime.int[j]+(24*60*60)
      print(b$bedtime.int[j])
    }
  }

  # Calculate remaining PSQI component scores

  b <- b %>%
    dplyr::mutate(

      ## Calculate time TIB difference
      TIB = waketime.date - bedtime.conv,
      TIB= as.numeric(TIB),

      ## Component 1 scoring
      comp1final = b$ninecode,

      ## Component 2 scoring
      comp2a = ifelse(SOL <= 15, 0,
                      ifelse(SOL >= 16 & SOL <= 30, 1,
                             ifelse(SOL >= 31 & SOL <= 60, 2,
                                    3))),
      comp2b = comp2a + fiveacode,

      comp2final = ifelse(comp2b == 0, 0,
                          ifelse(
                            comp2b >= 1 & comp2b <= 2, 1,
                            ifelse(comp2b >= 3 & comp2b <= 4, 2,
                                   3)
                          )),

      ## Component 3 scoring
      ### Concatenate tst hours and mins to a single numeric value
      TST.mins = as.numeric(TST.mins),
      TST.mins.dec = (TST.mins / 60), #  convert mins to decimal point
      TST.mins.dec.rd = rd(TST.mins.dec, digits = 2), # Round value and remove '0' digit from decimal
      TST.final = paste0(TST.hrs, TST.mins.dec.rd),
      TST.final = as.numeric(TST.final),
      comp3final = ifelse(TST.final > 7, 0,
                          ifelse(TST.final >= 6, 1,
                                 ifelse(TST.final >= 5, 2,
                                        3))),

      ## Component 4 scoring
      SE = ((TST.final / TIB) * 100),
      comp4final = ifelse(SE >= 85, 0,
                          ifelse(SE >= 75, 1,
                                 ifelse(SE >= 65, 2,
                                        3))),

      ## Component 5 scoring
      comp5total = (fivebcode + fiveccode + fivedcode + fiveecode + fivefcode + fivegcode +
                      fivehcode + fiveicode + fivejcode),
      comp5final = ifelse(comp5total == 0,
                          0,
                          ifelse(
                            comp5total >= 1 & comp5total <= 9,
                            1,
                            ifelse(comp5total >= 10 &
                                     comp5total <= 18, 2,
                                   3))),
      ## Component 6 scoring
      comp6final = sixcode,

      ## Component 7 scoring
      comp7total = sevencode + eightcode,
      comp7final = ifelse(comp7total == 0,
                          0,
                          ifelse(
                            comp7total >= 1 & comp7total <= 2,
                            1,
                            ifelse(comp7total >= 3 &
                                     comp7total <= 4, 2,
                                   3))),
      ## PSQI total
      psqi.total = (comp1final + comp2final + comp3final + comp4final + comp5final +
                      comp6final + comp7final),


      ## PSQI categories
      psqi.cat = ifelse(psqi.total > 5, "Poor sleep quality",
                        "Good sleep quality"),
      # psqi.cat = as_factor(psqi.cat),
      ## Total sleep time in minutes
      combined_mins = ((TST.hrs*60)+TST.mins),

      ## Sleep efficiency percentage
      bt_wt_diff =  as.numeric((waketime.date - bedtime.conv)*60),
      percentage = (bt_wt_diff/combined_mins) * 100

    )

  # Create new dataframe with necessary columns from ASBQ and PSQI ----

  asbq_psqi_df <- b %>%
    select(
      c(Name,
        Gender,
        Sport,
        psqi.cat,
        `I take afternoon naps lasting two or more hours`,
        `I use stimulants when I train/compete (e.g caffeine)`,
        `I exercise (train or compete) late at night (after 7pm)`,
        `I consume alcohol within 4 hours of going to bed`,
        `I go to bed at different times each night (more than ±1 hour variation)`,
        `I go to bed feeling thirsty`,
        `I go to bed with sore muscles`,
        `I use light-emitting technology in the hour leading up to bedtime (e.g laptop, phone, television, video games)`,
        `I think, plan and worry about my sporting performance when I am in bed`,
        `I think, plan and worry about issues not related to my sport when I am in bed`,
        `I use sleeping pills/tablets to help me sleep`,
        `I wake to go to the bathroom more than once per night`,
        `I wake myself and/or my bed partner with my snoring`,
        `I wake myself and/or my bed partner with my muscle twitching`,
        `I get up at different times each morning (more than ±1 hour variation)`,
        `At home, I sleep in a less than ideal environment (e.g too light, too noisy, uncomfortable bed/pillow, too hot/cold)`,
        `I sleep in foreign environments (e.g hotel rooms)`,
        `Travel gets in the way of building a consistent sleep-wake routine`,
        `ASBQ Global`,
        percentage,
        comp1final,
        comp2final,
        comp3final,
        comp4final,
        comp5final,
        comp6final,
        comp7final,
        psqi.total,
        combined_mins

      )
    )

  my_env <- new.env()
  my_env$athslpbehaviour_df <- asbq_psqi_df

  athslpbehaviour_df <- asbq_psqi_df

  # Create sub-directory 'output' if it does not exist
  main_dir <- getwd()
  sub_dir_exists <- "output"
  dir.create(file.path(main_dir, sub_dir_exists))

  # my_env <- new.env()
  # my_env$athslpbehaviour_df <- asbq_psqi_df
  #
  # .GlobalEnv$athslpbehaviour_df <- asbq_psqi_df

  # Create dashboard file
  rmarkdown::run(system.file("Dashboard_reactive_kmeans.Rmd", package = "athslpbehaviour"))

}
