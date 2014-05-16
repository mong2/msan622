Final Project
==============================

| **Name**  | MongYun Lee  |
|----------:|:-------------|
| **Email** | mlee37@dons.usfca.edu |

## Discussion #################

### Technique & Interactivity###

For my first tab, Teams, I have used rCharts to show three of the visualizations. While setting up the `sidebarPanel`, I've used the `conditionalPanel` to show teams that are on National League and teams that are on American League. Also, there's a `silderInput` on seasons so that the viewer will be able to focus on the timeline they want. Since the visualiztions are created through rChart, they will all show detail information while the cursor is on them. The great part about this tab is that the color of the visualizations is based on the color of the teams. 
This tabs shows the overview performaces of each team during the past decade. We can easily tell that teams are doing better when the ***Runs Scored*** exceeds ***Runs Allowed***. From these overview visualiztion, I believe a team's percentage of winning is highly correlated with the ***Runs Scored*** and the ***Runs Allowed** and that ***OPS*** and ***WHIP*** are a better method to evaluate players rather than teams. 

As for my second tab, Fantacy Team, shows a player table that the viewer can fill up and the introduction to the statistic that the viewer will be encouter with later. The technique behind this tab is all on the player table. Since the table output is based on the pick from next tab, it took me a long time to figure out how to plot the player's name on this table. (mainly because there are so many position and that each position needs to have it's own ID). 
This tab is more like an educational tab, therefore it is meant to help and educate viewers about the baseball statistics. 

As for my last tab, Player, shows the information on each player. This tabs contain two part, one is pitcher and the other one is batters. By using `dataTableOutput`, the viwers can filter or find the player that they want. As for the visualiztions, they are produces through `ggplot`. The reason that I use mainly bar charts in this tab is because they looks better and are easier to read. However, I did add an time series multiple line graph to make it a little bit different. This visualiztion gives the viewr a deeper look on the players. 
From this tab, the viewer can easily see how the player has performed. Although the visualizations does not tell you whether or not the player was injured or was sent to minor league, we can still see the absense year for the player. 

### prototype feedback ###

There wasn't much feed back on the prototype meeting, however the people in the meeting did help me out with few of of codes and I am still very thankful. 

