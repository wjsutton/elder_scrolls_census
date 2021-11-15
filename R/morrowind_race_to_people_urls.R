library(rvest)
library(dplyr)

all_races <- read.csv('data/morrowind_race_urls.csv',stringsAsFactors = F)

selected_race <- all_races[1,1]
race_html <- read_html(selected_race)

links <- race_html %>% html_nodes(".mw-category-group li a") %>% html_attr('href')

i <- 2
check_page <- read_html(paste0('https://en.uesp.net',links[i]))
wiki_infobox <- check_page %>% html_nodes("table.wikitable.infobox") %>% html_table()


infobox_df <- as.data.frame(wiki_infobox[[1]])

url <- links[i]
name <- names(infobox_df)[1]
gender <- infobox_df[2,4]
race <- infobox_df[2,2]
class <- infobox_df[3,4]
faction <- infobox_df[9,4]
level <- infobox_df[3,2]
health <- infobox_df[7,2]
magicka <- infobox_df[7,4]
alarm <- infobox_df[8,2]
fight <- infobox_df[8,4]
location <- infobox_df[1,2]

character_df <- data.frame(
  URL = url,
  Name = name,
  Gender = gender,
  Race = race,
  Class = class,
  Faction = faction,
  Level = level,
  Health = health,
  Magicka = magicka,
  Alarm = alarm,
  Fight = fight,
  Location = location,
  stringsAsFactors = F
)


#mw-content-text > table.wikitable.infobox