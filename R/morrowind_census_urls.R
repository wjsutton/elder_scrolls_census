
### Get Morrowind (base) Census

# Starting point:
# https://en.uesp.net/wiki/Category:Morrowind-NPCs-by-Race
# from here get links and sub links 

library(rvest)
library(dplyr)

# 'not in' function
'%ni%' <- Negate('%in%')

# read people HTML pages
morrowind <- read_html("https://en.uesp.net/wiki/Category:Morrowind-NPCs-by-Race")
bloodmoon <- read_html("https://en.uesp.net/wiki/Category:Bloodmoon-NPCs-by-Race")
tribunal <- read_html("https://en.uesp.net/wiki/Category:Tribunal-NPCs-by-Race")

# get race URLs and paste full link
mw_race_urls <- morrowind %>% html_nodes(".mw-category-group li a") %>% html_attr('href')
mw_race_urls <- mw_race_urls[grep('Morrowind',mw_race_urls)]

bm_race_urls <- bloodmoon %>% html_nodes(".mw-category-group li a") %>% html_attr('href')
bm_race_urls <- bm_race_urls[grep('Bloodmoon',bm_race_urls)]

tb_race_urls <- tribunal %>% html_nodes(".mw-category-group li a") %>% html_attr('href')
tb_race_urls <- tb_race_urls[grep('Tribunal',tb_race_urls)]

# Morrowind + expansions
mw_race_urls <- c(mw_race_urls,bm_race_urls,tb_race_urls)

# check for multiple pages per race
for(i in 1:length(mw_race_urls)){
  print(mw_race_urls[i])
  Sys.sleep(30)
  check_page <- read_html(paste0('https://en.uesp.net',mw_race_urls[i]))
  
  additional_page <- check_page %>% html_nodes("#mw-pages a") %>% html_attr('href')
  additional_page <- additional_page[grep('pagefrom',additional_page)]
  additional_page <- unique(additional_page)
  additional_page <- additional_page[additional_page %ni% mw_race_urls]
  
  while(length(additional_page)>0){
    print(additional_page)
    mw_race_urls <- c(mw_race_urls,additional_page)
    Sys.sleep(30)
    check_page <- read_html(paste0('https://en.uesp.net',additional_page))
    
    additional_page <- check_page %>% html_nodes("#mw-pages a") %>% html_attr('href')
    additional_page <- additional_page[grep('pagefrom',additional_page)]
    additional_page <- unique(additional_page)
    additional_page <- additional_page[additional_page %ni% mw_race_urls]
    }
}

all_race_pages <- paste0('https://en.uesp.net',mw_race_urls)
write.csv(all_race_pages,"data/morrowind_race_urls.csv",row.names = F)
