library(shiny)
library(ggplot2)
library(reshape)
library(gridExtra)
teams <- read.csv("Teams.csv", header = TRUE)
appearance <-read.csv("Appearances.csv", header = TRUE)

players <- read.csv("Master.csv", header = TRUE)
fullName <- paste(players$nameFirst, players$nameLast)
players[,"fullName"] <- fullName

batting <- read.csv("Batting.csv", header = TRUE)
batting[,"BA"] <- batting$H/batting$AB
batting<- subset(batting,!is.na(batting$BA) & batting$BA!=0)
batting<- merge(batting, players, by=c("playerID")) 
batting<- merge(batting, appearance, by=c("playerID","yearID")) 



pitching <- read.csv("Pitching.csv", header = TRUE)
pitching<- merge(pitching, players, by=c("playerID")) 

color <- data.frame(
  Teams = c("BAL","BOS","CHW","CLE","DET","HOU","KCR","ANA","MIN","NYY","OAK","SEA","TBD","TEX","TOR",
            "WSN","STL","SFG","SDP","PIT","PHI","NYM","MIL","FLA","LAD","COL","CIN","CHC","ATL","ARI"),
  
  Team_c1 = c("rgb(222,69,2)", "rgb(185,47,56)","rgb(62,62,62)","rgb(225,25,54)","rgb(9,33,65)",
              "rgb(42,64,106)","rgb(21,80,134)", "rgb(2,50,98)","rgb(29,55,87)","rgb(14,26,53)",
              "rgb(230,166,27)", "rgb(6,44,68)","rgb(4,36,81)", "rgb(4,36,81)","rgb(30,50,112)",
              "rgb(153,0,6)","rgb(181,6,44)","rgb(245,89,11)", "rgb(253,199,12)","rgb(249,171,30)",
              "rgb(222,0,28)","rgb(251,125,87)","rgb(169,128,33)", "rgb(251,77,9)", "rgb(13,68,119)",
              "rgb(37,35,82)", "rgb(182,0,23)","rgb(192,28,38)","rgb(208,17,68)","rgb(148,2,36)"),
  
  Team_c2 = c("rgb(1,1,1)","rgb(35,51,76)","rgb(1,1,1)", "rgb(0,43,91)","rgb(237,107,32)", 
              "rgb(234,109,30)","rgb(185,156,104)", "rgb(242,11,19)","rgb(176,14,57)", "rgb(163,162,160)",
              "rgb(12,62,47)","rgb(3,94,99)","rgb(130,173,213)", "rgb(182,26,39)","rgb(229,61,57)",
              "rgb(112,0,1)","rgb(22,114,214)","rgb(10,10,10)","rgb(1,32,81)","rgb(15,15,14)",
              "rgb(2750,135)","rgb(3,29,95)","rgb(9,24,60)","rgb(12,97,185)","rgb(156,160,170)",
              "rgb(39,40,42)","rgb(16,2,5)","rgb(12,35,114)","rgb(18,39,81)","rgb(7,6,5)"))
  
  

getP <- function(local_color,localFrame,franchiseNames_NL, franchiseNames_AL,league, year){
  
  ## NL or AL ##
  if(league == "National League"){
    localFrame <- subset(localFrame, localFrame$franchID %in% franchiseNames_NL)
    local_color <-subset(local_color, local_color$Teams %in% franchiseNames_NL)
    
  }else{
    localFrame <- subset(localFrame, localFrame$franchID %in% franchiseNames_AL)
    local_color <-subset(local_color, local_color$Teams %in% franchiseNames_AL)
    
  }
  
  ## time range ##
  localFrame <- subset(localFrame, localFrame$yearID >= year[1] & localFrame$yearID <= year[2])
  localFrame <- transform(localFrame, yearID = as.character(yearID))
  local_color <- transform(local_color, Team_c1 = as.character(Team_c1))
  local_color <- transform(local_color, Team_c2 = as.character(Team_c2)) 
  
  
  p<- mPlot(x='yearID', y = 'percentW', data = localFrame, type = "Line")  
  p$set(lineColors =c(local_color$Team_c1, local_color$Team_c2))
  
  p$addParams(dom = 'chart3')
  
  return(p)
  
  
}



getR_RA <- function(local_color,localFrame,franchiseNames_NL, franchiseNames_AL,league, year){
  
  if(league == "National League"){
    localFrame <- subset(localFrame, localFrame$franchID %in% franchiseNames_NL)
    local_color <- subset(local_color, local_color$Teams %in% franchiseNames_NL)
    
  }else{
    localFrame <- subset(localFrame, localFrame$franchID %in% franchiseNames_AL)
    local_color <-subset(local_color, local_color$Teams %in% franchiseNames_AL)
    
  }
  print(local_color)
  localFrame <- subset(localFrame, localFrame$yearID >= year[1] & localFrame$yearID <= year[2])
  mel_R <- melt(localFrame[,c("yearID","RA","R")], id = c("yearID"))
  R_RA <- hPlot(x= 'yearID', y ='value', data = mel_R, group = "variable", type = "column")
  R_RA$colors(local_color$Team_c1,local_color$Team_c2)
  R_RA$addParams(dom = 'chart1')
  
  return(R_RA)
}

getWHIP <- function(local_color,localFrame,franchiseNames_NL, franchiseNames_AL,league, year){
  
  if(league == "National League"){
    localFrame <- subset(localFrame, localFrame$franchID %in% franchiseNames_NL)
    local_color <-subset(local_color, local_color$Teams %in% franchiseNames_NL)
    
  }else{
    localFrame <- subset(localFrame, localFrame$franchID %in% franchiseNames_AL)
    local_color <-subset(local_color, local_color$Teams %in% franchiseNames_AL)
    
    
  }
  
  print(local_color)
  localFrame <- subset(localFrame, localFrame$yearID >= year[1] & localFrame$yearID <= year[2])
  

   localFrame <- transform(localFrame, yearID = as.character(yearID))
   local_color <- transform(local_color, Team_c1 = as.character(Team_c1))
   local_color <- transform(local_color, Team_c2 = as.character(Team_c2))  
  
    WHIP <- mPlot(x='yearID', y = c('WHIP','OPS'), data = localFrame, type = "Line")
    WHIP$set(lineColors =c(local_color$Team_c1, local_color$Team_c2))
    WHIP$set(dom = 'chart2')
  return(WHIP)
}

getTeamPic <- function(franchiseNames_NL, franchiseNames_AL, league){
  if(league == "National League"){
    file.path('./PICS',
              paste(franchiseNames_NL, '.jpg', sep=""))
  }else{
    file.path('./PICS',
              paste(franchiseNames_AL, '.jpg', sep=""))
  }
  
}
getTeamName<- function(localFrame,franchiseNames_NL, franchiseNames_AL,league){
  if(league == "National League"){
    localFrame <- subset(localFrame, localFrame$franchID ==franchiseNames_NL)
    localFrame <- localFrame[14,]
    name<- paste(localFrame$name)
    
    
  }else{
    localFrame <- subset(localFrame, localFrame$franchID == franchiseNames_AL)
    localFrame <- localFrame[14,]
    name<- paste(localFrame$name)
    
  }
  return(name)
  
}
getTable <- function(local_batter,local_pitcher,position,appearance){
  
  if(position == "Batters"){
    if(appearance == "G_1b"){
      local_batter <- subset(local_batter, local_batter$G_1b >=40)
      player_batting <- data.frame(local_batter[,c("fullName","yearID","SO","RBI","H", "HR", "SF", "BB", "HBP","BABIP","OBP","playerID")])
      addRadioButtons <- paste0('<input type="radio" name="batters_G1b" value="',player_batting$playerID[1:nrow(player_batting)],'">',"")
      #Display table with radio buttons
      colnames(player_batting) <- c("Name", "Year","Strike Outs (SO)", "Runs Batted In (RBI)",
                                     "Hits", "Home Run","Sacrifice Flies","Base on Bats","Hit by Pitch")
      cbind(Pick=addRadioButtons, player_batting[1:9])
    }else if (appearance == "G_2b"){
      local_batter <- subset(local_batter, local_batter$G_2b >=40)
      player_batting <- data.frame(local_batter[,c("fullName","yearID","SO","RBI","H", "HR", "SF", "BB", "HBP","BABIP","OBP","playerID")])
      addRadioButtons <- paste0('<input type="radio" name="batters_G2b" value="',player_batting$playerID[1:nrow(player_batting)],'">',"")
      #Display table with radio buttons
      colnames(player_batting) <- c("Name", "Year","Strike Outs (SO)", "Runs Batted In (RBI)",
                                    "Hits", "Home Run","Sacrifice Flies","Base on Bats","Hit by Pitch")
      cbind(Pick=addRadioButtons, player_batting[1:9])
    }else if (appearance == "G_3b"){
      local_batter <- subset(local_batter, local_batter$G_3b >=40)
      player_batting <- data.frame(local_batter[,c("fullName","yearID","SO","RBI","H", "HR", "SF", "BB", "HBP","BABIP","OBP","playerID")])
      addRadioButtons <- paste0('<input type="radio" name="batters_G3b" value="',player_batting$playerID[1:nrow(player_batting)],'">',"")
      #Display table with radio buttons
      colnames(player_batting) <- c("Name", "Year","Strike Outs (SO)", "Runs Batted In (RBI)",
                                    "Hits", "Home Run","Sacrifice Flies","Base on Bats","Hit by Pitch")
      cbind(Pick=addRadioButtons, player_batting[1:9])
    }else if (appearance == "G_ss"){
      local_batter <- subset(local_batter, local_batter$G_ss >=40)
      player_batting <- data.frame(local_batter[,c("fullName","yearID","SO","RBI","H", "HR", "SF", "BB", "HBP","BABIP","OBP","playerID")])
      addRadioButtons <- paste0('<input type="radio" name="batters_Gss" value="',player_batting$playerID[1:nrow(player_batting)],'">',"")
      #Display table with radio buttons
      colnames(player_batting) <- c("Name", "Year","Strike Outs (SO)", "Runs Batted In (RBI)",
                                    "Hits", "Home Run","Sacrifice Flies","Base on Bats","Hit by Pitch")
      cbind(Pick=addRadioButtons, player_batting[1:9])
    }else if (appearance == "G_lf"){
      local_batter <- subset(local_batter, local_batter$G_lf >=40)
      player_batting <- data.frame(local_batter[,c("fullName","yearID","SO","RBI","H", "HR", "SF", "BB", "HBP","BABIP","OBP","playerID")])
      addRadioButtons <- paste0('<input type="radio" name="batters_Glf" value="',player_batting$playerID[1:nrow(player_batting)],'">',"")
      #Display table with radio buttons
      colnames(player_batting) <- c("Name", "Year","Strike Outs (SO)", "Runs Batted In (RBI)",
                                    "Hits", "Home Run","Sacrifice Flies","Base on Bats","Hit by Pitch")
      cbind(Pick=addRadioButtons, player_batting[1:9])
    }else if (appearance == "G_cf"){
      local_batter <- subset(local_batter, local_batter$G_cf >=40)
      player_batting <- data.frame(local_batter[,c("fullName","yearID","SO","RBI","H", "HR", "SF", "BB", "HBP","BABIP","OBP","playerID")])
      addRadioButtons <- paste0('<input type="radio" name="batters_Gcf" value="',player_batting$playerID[1:nrow(player_batting)],'">',"")
      #Display table with radio buttons
      colnames(player_batting) <- c("Name", "Year","Strike Outs (SO)", "Runs Batted In (RBI)",
                                    "Hits", "Home Run","Sacrifice Flies","Base on Bats","Hit by Pitch")
      cbind(Pick=addRadioButtons, player_batting[1:9])
    }else if (appearance == "G_rf"){
      local_batter <- subset(local_batter, local_batter$G_rf >=40)
      player_batting <- data.frame(local_batter[,c("fullName","yearID","SO","RBI","H", "HR", "SF", "BB", "HBP","BABIP","OBP","playerID")])
      addRadioButtons <- paste0('<input type="radio" name="batters_Grf" value="',player_batting$playerID[1:nrow(player_batting)],'">',"")
      #Display table with radio buttons
      colnames(player_batting) <- c("Name", "Year","Strike Outs (SO)", "Runs Batted In (RBI)",
                                    "Hits", "Home Run","Sacrifice Flies","Base on Bats","Hit by Pitch")
      cbind(Pick=addRadioButtons, player_batting[1:9])
    }else if (appearance == "G_of"){
      local_batter <- subset(local_batter, local_batter$G_of >=40)
      player_batting <- data.frame(local_batter[,c("fullName","yearID","SO","RBI","H", "HR", "SF", "BB", "HBP","BABIP","OBP","playerID")])
      addRadioButtons <- paste0('<input type="radio" name="batters_Gof" value="',player_batting$playerID[1:nrow(player_batting)],'">',"")
      #Display table with radio buttons
      colnames(player_batting) <- c("Name", "Year","Strike Outs (SO)", "Runs Batted In (RBI)",
                                    "Hits", "Home Run","Sacrifice Flies","Base on Bats","Hit by Pitch")
      cbind(Pick=addRadioButtons, player_batting[1:9])
    }else if (appearance == "G_dh"){
      local_batter <- subset(local_batter, local_batter$G_dh >=40)
      player_batting <- data.frame(local_batter[,c("fullName","yearID","SO","RBI","H", "HR", "SF", "BB", "HBP","BABIP","OBP","playerID")])
      addRadioButtons <- paste0('<input type="radio" name="batters_Gdh" value="',player_batting$playerID[1:nrow(player_batting)],'">',"")
      #Display table with radio buttons
      colnames(player_batting) <- c("Name", "Year","Strike Outs (SO)", "Runs Batted In (RBI)",
                                    "Hits", "Home Run","Sacrifice Flies","Base on Bats","Hit by Pitch")
      cbind(Pick=addRadioButtons, player_batting[1:9])
    }else{
      local_batter <- subset(local_batter, local_batter$G_c >=40)
      player_batting <- data.frame(local_batter[,c("fullName","yearID","SO","RBI","H", "HR", "SF", "BB", "HBP","BABIP","OBP","playerID")])
      addRadioButtons <- paste0('<input type="radio" name="batters_Gc" value="',player_batting$playerID[1:nrow(player_batting)],'">',"")
      #Display table with radio buttons
      colnames(player_batting) <- c("Name", "Year","Strike Outs (SO)", "Runs Batted In (RBI)",
                                    "Hits", "Home Run","Sacrifice Flies","Base on Bats","Hit by Pitch")
      cbind(Pick=addRadioButtons, player_batting[1:9])
    }
  }else{
    player_pitching <- data.frame(local_pitcher[,c("fullName","yearID", "ERA", "FIP", "WHIP", "IP","playerID")])      
    addRadioButtons <- paste0('<input type="radio" name="pitchers" value="',player_pitching$playerID[1:nrow(player_pitching)],'">',"")
    #Display table with radio buttons
    colnames(player_pitching) <- c("Name", "Year", "Earn Average Run (ERA)", "Fielding Independent Pitching (FIP)", 
                                   "Walks and Hits per Innings Pitched(WHIP)", "Innings Pitched(IP)")
    cbind(Pick=addRadioButtons, player_pitching[1:6])
  
  }
    
}


getBatter <- function(local_batter,batters_G1b,batters_G2b,batters_G3b, batters_Gss,
                      batters_Glf,batters_Gcf, batters_Grf, batters_Gof,
                      batters_Gdh, batters_Gc,
                      appearance, position, local_pitcher, pitchers){

  print("HEEEE")
  print(pitchers)
  
  if(position == "Batters"){
     if(appearance == "G_1b"){
       local_batter <- subset(local_batter, local_batter$playerID == batters_G1b)
     }else if(appearance == "G_2b"){
       local_batter <- subset(local_batter, local_batter$playerID == batters_G2b)
     }else if(appearance == "G_3b"){
       local_batter <- subset(local_batter, local_batter$playerID == batters_G3b)
     }else if(appearance == "G_ss"){
       local_batter <- subset(local_batter, local_batter$playerID == batters_Gss)
     }else if(appearance == "G_lf"){
       local_batter <- subset(local_batter, local_batter$playerID == batters_Glf)
     }else if(appearance == "G_cf"){
       local_batter <- subset(local_batter, local_batter$playerID == batters_Gcf)
     }else if(appearance == "G_rf"){
       local_batter <- subset(local_batter, local_batter$playerID == batters_Grf)
     }else if(appearance == "G_of"){
       local_batter <- subset(local_batter, local_batter$playerID == batters_Gof)
     }else if(appearance == "G_dh"){
       local_batter <- subset(local_batter, local_batter$playerID == batters_Gdh)
     }else{
       local_batter <- subset(local_batter, local_batter$playerID == batters_Gc)
     }      
     
     
    
     BA <- ggplot(data = local_batter, aes(x = factor(yearID), y = BA ))+
       geom_bar(fill= "firebrick3") + xlab("Year")+ theme(
         axis.ticks = element_blank(),
         panel.background = element_blank())
     
     RBI <- ggplot(data = local_batter, aes(x = factor(yearID), y = RBI))+
       geom_bar(fill = "royalblue4") + xlab("Year")+ theme(
         axis.ticks = element_blank(),
         panel.background = element_blank())
    
     BABIP <- ggplot(data = local_batter, aes(x = factor(yearID), y = BABIP)) +
       geom_bar(fill= "firebrick3") + xlab("Year") + theme(
         axis.ticks = element_blank(),
         panel.background = element_blank())
     
     OBP <- ggplot(data = local_batter, aes(x = factor(yearID), y = OBP)) +
       geom_bar(fill = "royalblue4") + xlab("Year")+ theme(
         axis.ticks = element_blank(),
         panel.background = element_blank())

     grid.arrange(BA,RBI, BABIP,OBP, nrow=2,ncol=2)
     
   }else{
     local_pitcher <- subset(local_pitcher, local_pitcher$playerID == pitchers)
  
     mel_Pitch <- melt(local_pitcher[,c("yearID","ERA", "FIP")], id = c("yearID"))
     
     ERA_FIP <- ggplot(mel_Pitch, aes(x = yearID, y = value, color=variable)) +
       geom_line(size = 1,aes(group = variable))+scale_color_manual(values=c("firebrick3", "royalblue4"))+
       xlab("Year")+ylab("") +theme(legend.title = element_blank())
     
     WHIP <- ggplot(data = local_pitcher, aes(x = factor(yearID), y = WHIP)) +
       geom_bar(fill = "darkorange1")+ xlab("Year")+ theme(
         axis.ticks = element_blank(),
         panel.background = element_blank())
     
     grid.arrange(ERA_FIP, WHIP, nrow = 2 )
     
   }
}

getText <- function(local_batter,batters_G1b,batters_G2b,batters_G3b, batters_Gss,
                    batters_Glf,batters_Gcf, batters_Grf, batters_Gof,
                    batters_Gdh, batters_Gc,
                    appearance, position, local_pitcher, pitchers){
  
  if(position == "Batters"){
    if(appearance == "G_1b"){
      local_batter <- subset(local_batter, local_batter$playerID == batters_G1b)
    }else if(appearance == "G_2b"){
      local_batter <- subset(local_batter, local_batter$playerID == batters_G2b)
    }else if(appearance == "G_3b"){
      local_batter <- subset(local_batter, local_batter$playerID == batters_G3b)
    }else if(appearance == "G_ss"){
      local_batter <- subset(local_batter, local_batter$playerID == batters_Gss)
    }else if(appearance == "G_lf"){
      local_batter <- subset(local_batter, local_batter$playerID == batters_Glf)
    }else if(appearance == "G_cf"){
      local_batter <- subset(local_batter, local_batter$playerID == batters_Gcf)
    }else if(appearance == "G_rf"){
      local_batter <- subset(local_batter, local_batter$playerID == batters_Grf)
    }else if(appearance == "G_of"){
      local_batter <- subset(local_batter, local_batter$playerID == batters_Gof)
    }else if(appearance == "G_dh"){
      local_batter <- subset(local_batter, local_batter$playerID == batters_Gdh)
    }else{
      local_batter <- subset(local_batter, local_batter$playerID == batters_Gc)
    }
    local_batter <- local_batter[1,]
    name<-local_batter$fullName
  }
  else{
    local_pitcher <- subset(local_pitcher, local_pitcher$playerID == pitchers)
    local_pitcher <- local_pitcher[1,]
    name<-local_pitcher$fullName
    
  }
  
  

  if(is.na(name)){
    return("Please Select a Player")
  }else{
    return(name)
  }
}

df <- data.frame(
  Name = c("1b",
           "2b",
           "3b",
           "ss",
           "lf",
           "cf",
           "rf",
           "of",
           "dh",
           "c", 
           "Pitcher"),
  Value = NA
)

getFantacy <- function(local_batter,batters_G1b,batters_G2b,batters_G3b, batters_Gss,
                       batters_Glf,batters_Gcf, batters_Grf, batters_Gof,
                       batters_Gdh, batters_Gc, local_pitcher, pitchers){

  if(length(batters_G1b) == 0){
    df$Value[df$Name =="1b"] <- c("need to fill out this position")
  }else{
      name_G1b <-local_batter[grep(batters_G1b, local_batter$playerID),][1,]$fullName
      df$Value[df$Name == "1b"] <- name_G1b
  }
  
  if(length(batters_G2b) == 0){
    df$Value[df$Name =="2b"] <- c("need to fill out this position")
  }else{
    name_G2b <-local_batter[grep(batters_G2b, local_batter$playerID),][1,]$fullName
    df$Value[df$Name == "2b"] <- name_G2b
  }
  
  if(length(batters_G3b) == 0){
    df$Value[df$Name =="3b"] <- c("need to fill out this position")
  }else{
    name_G3b <-local_batter[grep(batters_G3b, local_batter$playerID),][1,]$fullName
    df$Value[df$Name == "3b"] <- name_G3b
  }
  
  if(length(batters_Gss) == 0){
    df$Value[df$Name =="ss"] <- c("need to fill out this position")
  }else{
    name_Gss <-local_batter[grep(batters_Gss, local_batter$playerID),][1,]$fullName
    df$Value[df$Name == "ss"] <- name_Gss
  }
  
  if(length(batters_Glf) == 0){
    df$Value[df$Name =="lf"] <- c("need to fill out this position")
  }else{
    name_Glf <-local_batter[grep(batters_Glf, local_batter$playerID),][1,]$fullName
    df$Value[df$Name == "lf"] <- name_Glf
  }
  
  if(length(batters_Gcf) == 0){
    df$Value[df$Name =="cf"] <- c("need to fill out this position")
  }else{
    name_Gcf <-local_batter[grep(batters_Gcf, local_batter$playerID),][1,]$fullName
    df$Value[df$Name == "cf"] <- name_Gcf
  }
  
  if(length(batters_Grf) == 0){
    df$Value[df$Name =="rf"] <- c("need to fill out this position")
  }else{
    name_Grf <-local_batter[grep(batters_Grf, local_batter$playerID),][1,]$fullName
    df$Value[df$Name == "rf"] <- name_Grf
  }
  
  if(length(batters_Gof) == 0){
    df$Value[df$Name =="of"] <- c("need to fill out this position")
  }else{
    name_Gof <-local_batter[grep(batters_Gof, local_batter$playerID),][1,]$fullName
    df$Value[df$Name == "of"] <- name_Gof
  }
  
  if(length(batters_Gdh) == 0){
    df$Value[df$Name =="dh"] <- c("need to fill out this position")
  }else{
    name_Gdh <-local_batter[grep(batters_Gdh, local_batter$playerID),][1,]$fullName
    df$Value[df$Name == "dh"] <- name_Gdh
  }
  
  if(length(batters_Gc) == 0){
    df$Value[df$Name =="c"] <- c("need to fill out this position")
  }else{
    name_Gc <-local_batter[grep(batters_Gc, local_batter$playerID),][1,]$fullName
    df$Value[df$Name == "c"] <- name_Gc
  }
  
  if(length(pitchers) == 0){
    df$Value[df$Name == "Pitcher"] <- c("need to fill out this position")
  }else{
    name_pitcher <- local_pitcher[grep(pitchers, local_pitcher$playerID),][1,]$fullName
    df$Value[df$Name == "Pitcher"] <- name_pitcher
  }
  
  
  return(df)

    
  }
    

print(df)


global <- teams 
tab_batter <- batting
tab_pitcher <- pitching
### Shiny Server ### 

shinyServer(
  function(input, output){
    
    localFrame <- global
    local_batter <- tab_batter
    local_pitcher <- tab_pitcher
    local_color <- color

    
    output$chart3 <- renderChart({
      
      chart3 <- getP( local_color,
                      localFrame,
                      input$franchiseNames_NL,
                      input$franchiseNames_AL,
                      input$league,
                      input$year
      )
      
    })
    
    
    output$chart1 <- renderChart({
      
      chart1 <- getR_RA(local_color,
                        localFrame,
                        input$franchiseNames_NL,
                        input$franchiseNames_AL,
                        input$league,
                        input$year)
      
    })
    
    output$chart2 <- renderChart({
      
      chart2 <- getWHIP(local_color,
                        localFrame,
                        input$franchiseNames_NL,
                        input$franchiseNames_AL,
                        input$league,
                        input$year)
      
    })
    
    output$plot3 <- renderImage({
      # When input$n is 1, filename is ./images/image1.jpeg
      filename <- getTeamPic(input$franchiseNames_NL,
                             input$franchiseNames_AL,
                             input$league)
      
      # Return a list containing the filename
      list(src = filename)
    }, deleteFile = FALSE)
    
    output$team <- renderText({
      
      team <- getTeamName(localFrame,
                          input$franchiseNames_NL,
                          input$franchiseNames_AL,
                          input$league)
    })

    
    output$plot_table <-renderDataTable({  
    
      plot_table <- getTable(local_batter,
                             local_pitcher,
                             input$position,
                             input$appearance)
      
#       print(plot_table)
    },options = list(bSortClasses = TRUE,aLengthMenu = c(10, 30, 50), iDisplayLength = 10)
    

    )
    
    output$Batter <- renderPlot({
      
  
        plot_Batter <- getBatter(local_batter,
                                 input$batters_G1b,
                                 input$batters_G2b,
                                 input$batters_G3b,
                                 input$batters_Gss,
                                 input$batters_Glf,
                                 input$batters_Gcf,
                                 input$batters_Grf,
                                 input$batters_Gof,
                                 input$batters_Gdh,
                                 input$batters_Gc,
                                 input$appearance,
                                 input$position,
                                 local_pitcher,
                                 input$pitchers)
        print(plot_Batter)
        
    
    
      
    })
    
    
    output$text <-renderText({
      
      text <- getText(local_batter,
                      input$batters_G1b,
                      input$batters_G2b,
                      input$batters_G3b,
                      input$batters_Gss,
                      input$batters_Glf,
                      input$batters_Gcf,
                      input$batters_Grf,
                      input$batters_Gof,
                      input$batters_Gdh,
                      input$batters_Gc,
                      input$appearance,
                      input$position,
                      local_pitcher,
                      input$pitchers)
      
    })
    
    output$fantacy <- renderTable({
      FAT <- getFantacy(local_batter,
                        input$batters_G1b,
                        input$batters_G2b,
                        input$batters_G3b,
                        input$batters_Gss,
                        input$batters_Glf,
                        input$batters_Gcf,
                        input$batters_Grf,
                        input$batters_Gof,
                        input$batters_Gdh,
                        input$batters_Gc,
                        local_pitcher,
                        input$pitchers
                        )
    })

  })