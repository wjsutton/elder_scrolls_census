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
unmapped_characters <- c()

for(i in 1:length(all_npc_urls)){
  print(i)
  sleep <- sample(5:20, 1, replace=TRUE)
  Sys.sleep(sleep)
  
  npc <- read_html(all_npc_urls[i])
  
  infobox_exists <- length(npc %>% html_nodes("table.wikitable.infobox"))
  
  if(infobox_exists == 0){
    unmapped_characters <- c(unmapped_characters,all_npc_urls[i])
    next
  }
  
  wiki_infobox <- npc %>% html_nodes("table.wikitable.infobox") %>% html_table()
  infobox_df <- as.data.frame(wiki_infobox[[1]])
  
  character_df <- rbind(infobox_df[,c(1:2)],infobox_df[,c(3:4)])
  names(character_df) <- c('attribute','value')
  character_df <- filter(character_df,attribute!=value)
  character_df$url <- all_npc_urls[i]
  character_df$name <- names(infobox_df)[1]
  
  if(i == 1){
    all_characters_df <- character_df
  }
  
  if(i > 1){
    all_characters_df <- rbind(all_characters_df,character_df)
  }
  
}

write.csv(all_characters_df,'data/skyrim_npcs_with_infobox.csv',row.names = F)

no_infobox_df <- data.frame(url=unmapped_characters,stringsAsFactors = F)
write.csv(no_infobox_df,'data/skyrim_npcs_urls_without_infobox.csv',row.names = F)
