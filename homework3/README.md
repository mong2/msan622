Homework 3: Multivariate
==============================

| **Name**  | MongYun Lee |
|----------:|:-------------|
| **Email** | mlee37@dons.usfca.edu |

## Instructions ##

```
library(shiny)
library(ggplot)
library(reshape)
library(rCharts)
runGitHub("msan622", "mong2", subdir = "homework3")
```
## Discussion ##

[DISCUSSION: Include a discussion here if required by the assignment.]

**Parallel Coordinates**

Since the topic of my page is the importance of high school education. I beleive that it will be fun to 
know the correlation between variables like, Income, Illeteracy, Murder and Life Expectancy. Also, Population is 
kind of the base of the whole comparison. I used D3 to set up the coordinates. Since this is my first time using D3,
I have to admit that I'm still not very familiar with it and have been trying to group the `Region` and color `Region` 
in different colors (I failed). 

For the coordinates, I added Brushing as the interavtive interface. So you can filter the data by brushing each column and you will also be able to change order of the column.

**Bubble Chart**
I choose to have Bubble Chart because I like the way it looks a lot. For me Heat Map is really hard to understand and 
hard to interpretate. For this chart, I choose Income, Illeteracy and Murder as the variables to compare with High School Graduate. Basically the Bubble Chart is doing pretty much the same thing as the Parallel Coordinates. However, this time I was able to group Region and color them in different color. The size of the bubble is base on the population of each state.Beside that I'm able to control more customization features, I believe that Bubble Chart gives viewers a quicker and clearer view on the dataset than parallel coordinates. 

The whole chart was created through rCharts which provides tooltip as defualt. Therefore, viewers will have a chance to get the actual numbers of the dataset rather than the relative comparison the chart provides.  

**ScatterPlot Matrix**
I choose to have ScatterPlor Matrix because I think is cooler than the small scatterPlot. It looks more perfessional to m. In the graph, I choose the same variables as for Parallel Coordinates. Again, I tried D3 on this grapgh. I actually had a very pretty scatterPlot matrix from `GGally` `ggpairs`, however I found it a difficult to add interaction on it. The four different colors onthe scatterplot matrix represent the four different regions in the dataset. (I understand they don't match witht the colors in Bubble Chart) I have to say, I think `ggpairs` provides a better plot, it's easier and it provides more statistical informations. Still, I choose to use D3 just to try to learn some new ways to make data visualization. 
Again, I added brushing on the scatterplot matrix, since that's the only interactivity that suits for the plot. 

**Need to Improve**
I understand there is still a lot to improve in all three graphs! Like I should try to figure out how to color the parallel coordinates and should let show the data that's under brushing. For Bubble Chart and ScatterPlot Matrix, I need to find a way to make the color of the group identical so that it will be easier for the viewers to determine which is which without looking at a legend. And yes, there should be a legend for ScatterPlot Matrix and I believe it will be nice is my Bubble Chart can show the name of the State in the tooltip. 
This is my first time trying to play in `D3` and `rCharts`, I understand that there's a lot need to improve on the graphs. 

I did it on purpose to make the three graphs showing similar information of the dataset such that in the future for final project, 
it will be easier for me to determine which technique should I use. 


