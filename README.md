<!-- badges: start -->
  [![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)
  [![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
  <!-- badges: end -->

# AthSlpBehaviouR <img src="man/logos/hex_logo.png" width="140px" height="165px" align="right" style="padding-left:10px;background-color:white;" />

`AthSlpBehaviouR` is intended to retrieve, clean and visualize Athlete Sleep Behaviour Questionnaire (ASBQ) and Pittsburgh Sleep Quality Index (PSQI) data collected on Google Sheets, through a Google Form template.

## Installation - Latest Development Version from Github

Version 0.1.0

```{r}
#Install the development version from GitHub  
install.packages("devtools")
devtools::install_github("hareshsuppiah/athslpbehaviour")
```

# Usage

`AthSlpBehaviouR` currently has two main functions - cleaning and scoring ASBQ and PSQI data, as well as creating a Shiny dashboard to aid practitioners in categorising athlete sleep characteristics and behaviours using a k-means cluster analysis. The data is collected using a standard Google Forms template (see below), which is eventually stored onto a Google Sheet.

* `clean_sheet_data()`
* `create_dashboard()`

### ASBQ-PSQI Google Form Questionnaire Template

A Google Form template for use with `AthSlpBehaviouR` can be dowloaded [here](https://docs.google.com/forms/d/16T_0vbpiZdNipz14kSZiGCrqVgSQ3ULNbIxYYZg0y90/template/preview).

### Cleaning data - clean_sheet_data():

To clean and score PSQI and ASBQ data collected from a Google Form (and stored in a Google Sheet) use:

```
clean_sheet_data("https://docs.google.com/spreadsheets/d/1cnb_5DUQsbee96lL_5MVtf_nI8XmJqKmYQKFP9_INJY/edit?usp=sharing")                
```
The `clean_sheet_data()` function accepts 1 argument:

* **urlstring**: A url for the (shared) Google Sheet containing data using the ASBQ-PSQI Google Form template.

The url from the Google Sheet can be obtained using the **Share** option and copying the url link of the sheet.

<img src="man/images/copylink.PNG" width="500" />

It returns a csv file `asbq_psqi_df.csv` in an `output` folder within the working directory.

### Create Shiny Dashboard

To create a Shiny dashboard app to aid in the categorisation and visualisation of different sleep characteristics and behaviours use:

```
create_dashboard("https://docs.google.com/spreadsheets/d/1cnb_5DUQsbee96lL_5MVtf_nI8XmJqKmYQKFP9_INJY/edit?usp=sharing")                
```
The `clean_sheet_data()` function accepts 1 argument:

* **urlstring**: A url for the (shared) Google Sheet containing data using the ASBQ-PSQI Google Form template.
