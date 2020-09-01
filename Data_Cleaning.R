library(readxl)
selection <- read_excel("selection.xlsx", 
                        col_types = c("text", "numeric", "numeric", 
                                      "numeric", "numeric"))
View(selection)

#selection <- rename (selection, id = 1)
#selection <- rename (selection, sooner = 2)
#selection <- rename (selection, later = 3)
#selection <- rename (selection, point= 4)
selection <- mutate (selection, switch_point = ifelse(switch_point==0, 10, switch_point))
#selection <- rename (selection, group = 5)
selection <- mutate (selection, gap = later_week - sooner_week)

selection$group <- factor(selection$group, levels=c(1, 2), labels=c("control", "treatment"))

#treatmentgroup <- summarise (selection, id=id, sooner=sooner, later= later, gap= gap, switch_point = switch_point, treatment = ifelse(group==2, 1, 0))
#controlgroup <- summarise (selection, id=id, sooner=sooner, later= later, gap= gap, switch_point = switch_point,control = ifelse(group==1, 1, 0))
#treatmentgroup <- filter(treatmentgroup, treatment == 1)
#contorl <- filter(controlgroup, control ==1)

#plot1 <- ggplot(selection, aes(x=switch_point)) + geom_histogram(aes(colour = factor(sooner_week))) + facet_wrap(~group + id)
#plot1     

#plot2<- ggplot(selection, aes(x=switch_point)) + geom_histogram(aes(colour = factor(sooner_week))) + facet_wrap(~group)
#plot2

#plot3 <- ggplot(selection, aes(x=gap, y=switch_point)) + geom_point(aes(colour = factor(sooner_week))) + facet_wrap(~group + id)
#plot3 
                 
#plot4 <- ggplot(selection, aes(x=gap, y=switch_point)) + geom_smooth(aes(colour = factor(sooner_week)),se = FALSE) + facet_wrap(~group + id)
#plot4    

#plot5 <- ggplot(selection, aes(x=gap, y=switch_point)) + geom_point(aes(colour = factor(id))) + facet_wrap(~group)
#plot5  

#plot6 <- ggplot(selection, aes(x=gap, y=switch_point)) + geom_smooth(aes(colour = factor(id)),se = FALSE) + facet_wrap(~group)
#plot6 

selection$gap <- factor(selection$gap, levels=c(1, 2, 4, 8), labels=c("1 week", "2 weeks", "4 weeks", "8 weeks"))
selection$sooner_week <- factor(selection$sooner_week, levels=c(0, 4), labels=c("immediate", "delayed"))
plot1 <- ggplot(selection, aes(x=gap, y=switch_point, fill = group)) + geom_col(position = "dodge") + facet_wrap(~sooner_week)
plot1



