### Get Skyrim (base) Census

# Starting point:
# https://en.uesp.net/wiki/Category:Skyrim-Male_NPCs
# https://en.uesp.net/wiki/Category:Skyrim-Female_NPCs
# from here get links and sub links 

library(rvest)
library(dplyr)

# 'not in' function
'%ni%' <- Negate('%in%')

# List of npc pages
npc_pages <- c(
  'https://en.uesp.net/wiki/Category:Skyrim-Male_NPCs'
  ,'https://en.uesp.net/w/index.php?title=Category:Skyrim-Male_NPCs&pagefrom=Dark+Brotherhood+Initiate#mw-pages'
  ,'https://en.uesp.net/w/index.php?title=Category:Skyrim-Male_NPCs&pagefrom=Halvar#mw-pages'
  ,'https://en.uesp.net/w/index.php?title=Category:Skyrim-Male_NPCs&pagefrom=Mikael#mw-pages'
  ,'https://en.uesp.net/w/index.php?title=Category:Skyrim-Male_NPCs&pagefrom=Sinding#mw-pages'
  ,'https://en.uesp.net/wiki/Category:Skyrim-Female_NPCs'
  ,'https://en.uesp.net/w/index.php?title=Category:Skyrim-Female_NPCs&pagefrom=Gormlaith+Golden-Hilt#mw-pages'
  ,'https://en.uesp.net/w/index.php?title=Category:Skyrim-Female_NPCs&pagefrom=Seren#mw-pages'
  )

all_npc_urls <- c()
for(i in 1:length(npc_pages)){
  Sys.sleep(10)
  npc_html <- read_html(npc_pages[i])
  npc_urls <- npc_html %>% html_nodes(".mw-category-group li a") %>% html_attr('href')
  all_npc_urls <- c(all_npc_urls,npc_urls)
}

all_npc_urls <- all_npc_urls[!grepl('Category',all_npc_urls)]
all_npc_urls <- paste0('https://en.uesp.net',all_npc_urls)

npc <- read_html(all_npc_urls[1])
npc %>% html_nodes('table') %>% html_table()