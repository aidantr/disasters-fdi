
#load required packages
library(ggplot2)
library(rgeos)
library(Cairo) 
library(scales)
library(RColorBrewer)
library(gpclib)
library(sp)
library(maptools)
library(dplyr)
library(rgdal)
library(ggmap)
library(maps)
library(rgdal)
library(scales)
library(maptools)
library(gridExtra)
library(mapproj)
library(viridis)
library(viridisLite)

#load spatial data
states_shape = readOGR("_1data/raw/spatial/shape_files/IND_adm1.shp")
#load FDI data
State_count = length(states_shape$NAME_1)
score_1 = sample(100:1000, State_count, replace = T)
score_2 = runif(State_count, 1,1000)
score = score_1 + score_2
score[1]=350
score[2]=78.9
score[3]=7.3
score[4]=7.3
score[5]=1.66
score[6]=27.88
score[7]=18.9
score[8]=586.5
score[9]=586.5
score[10]=211.66
score[11]=11.63
score[12]=122.4
score[13]=27.88
score[14]=27.88
score[15]=NA
score[16]=1.6
score[17]=476.43
score[18]=18.77
score[19]=18.77
score[20]=18.9
score[21]=586.5
score[22]=7.3
score[23]=7.3
score[24]=7.3
score[25]=7.3
score[26]=2.7
score[27]=209
score[28]=27.88
score[29]=16.69
score[30]=26.65
score[31]=209
score[32]=78.9
score[33]=7.3
score[34]=5
score[35]=5
score[36]=26.65
score_raw=score*1000000
score_log=log(score_raw)
score_ihs=asinh(score)
State_data = data.frame(id=states_shape$ID_1, NAME_1=states_shape$NAME_1, score_log)
names(State_data)[3]='FDI_log'

#create dataset
states <- fortify(states_shape, region = "ID_1")
merged_shape <- merge(states, State_data, by = "id", all.x = TRUE)
final_plot <- merged_shape[order(merged_shape$order),]

final_plot=final_plot %>%
  mutate(affected=ifelse( NAME_1=="Orissa" | NAME_1=="Meghalaya" | NAME_1=="Manipur" | NAME_1=="Mizoram" | NAME_1=="Nagaland" | NAME_1=="Tripura" | NAME_1=="Arunachal Pradesh"| NAME_1=="Assam","b",ifelse(NAME_1=="Delhi" | NAME_1=="Chandigarh"  | NAME_1=="Haryana" | NAME_1=="Himachal Pradesh" | NAME_1=="Punjab" | NAME_1=="Uttaranchal" | NAME_1=="Uttar Pradesh","c",ifelse(NAME_1=="Andhra Pradesh" | NAME_1=="Puducherry" | NAME_1=="Tamil Nadu" ,"d",ifelse(NAME_1=="Kerala" | NAME_1=="Lakshadweep", "e",ifelse(NAME_1=="Bihar" | NAME_1=="Jharkhand" | NAME_1=="Sikkim" | NAME_1=="West Bengal","a",NA))))))

final_plot=final_plot %>%
  mutate(FDI_dis=ifelse(FDI_log>20,"20+",ifelse(FDI_log>19,"19-20",ifelse(FDI_log>18,"18-19",ifelse(FDI_log>17,"17-18",ifelse(FDI_log>16,"16-17",ifelse(FDI_log<16,"15-16", NA)))))))

#create disaster map
pdf(file="_3results/figures/figure2a.pdf")
p=ggplot() +
  geom_polygon(data=final_plot, aes(long, lat, group=group, fill=affected), color = "white", size = 0.05) +
  scale_fill_viridis( na.value="grey81",discrete=TRUE,labels=c("Bihar Flood (Aug 2007) & Eastern Indian \n Storm (Apr 2010):  Kolkata, Patna","Eastern Indian Storm Only (Apr 2010): \n Bhubaneshwar, Guwahati","Northern Indian Floods (Jun 2013): \n Chandigarh, Delhi, Kanpur","South Indian Floods (Nov 2015): \n Hyderabad, Chennai","Kerala Floods (Aug 2018): \n Kochi","Unaffected"))+theme_nothing(legend = TRUE)+ 
  coord_map()+labs(fill = "")

p+ theme(
  legend.text = element_text(color = "black", size = 9),
  legend.position="right",legend.key.size = unit(.9, "cm")
)+ guides(colour = guide_legend(nrow = 2))
dev.off()


#create FDI map
pdf(file="_3results/figures/figure2b.pdf")

nb.cols <- 4
#mycolors <- colorRampPalette(brewer.pal(5, "Blues"))(nb.cols)

mycolors <- c("#C6DBEF" ,"#9ECAE1", "#6BAED6", "#4292C6", "#2171B5", "#08519C", "#08306B")


#scale_fill_brewer(na.value = "grey81",palette="Blues",labels=c("0-2","2-4","4-6","6-8","Not included"))
p=ggplot() +
  geom_polygon(data = final_plot, 
               aes(x = long, y = lat, group = group, fill = FDI_dis), 
               color = "white", size = 0.05) + 
  coord_map()+scale_fill_manual(values = mycolors, na.value="grey81",labels=c("<16","16-17","17-18","18-19","19-20","20+","Not included")) +theme_nothing(legend = TRUE)+labs(fill = "Log Monthly FDI (USD)")
p+ theme(
  legend.text = element_text(color = "black", size = 10 ),
  legend.position="right",legend.key.size = unit(.9, "cm"),
  panel.background = element_rect(fill = "transparent"), # bg of the panel
  plot.background = element_rect(fill = "transparent", color = NA), # bg of the plot
  legend.background = element_rect(fill = "transparent")
  
)

dev.off()










