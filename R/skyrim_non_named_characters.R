library(rvest)
library(dplyr)

# 'not in' function
'%ni%' <- Negate('%in%')

url <- 'https://en.uesp.net/wiki/Skyrim:Northwatch_Prisoner'
npc <- read_html(url)

wiki_infobox <- npc %>% html_nodes("table.wikitable") %>% html_table(fill=TRUE)
for(i in 1:length(wiki_infobox)){
  infobox_df <- as.data.frame(wiki_infobox[[i]])
  infobox_df$name <- names(infobox_df)[1]
  names(infobox_df) <- c('attribute','value','attribute','value','name')
  
  if(i == 1){
    total_infobox <- infobox_df
  }
  if(i > 1){
    total_infobox <- rbind(total_infobox,infobox_df)
  }
}

#df <- total_infobox[,c(1:8)]
character_df <- rbind(total_infobox[,c(1:2,5)],total_infobox[,c(3:4,5)])
names(character_df) <- c('attribute','value','name')
character_df <- filter(character_df,attribute!=value)
character_df$url <- url
#character_df$name <- names(total_infobox)[1]