# Program to calculate basin-aggregated statistics and plots.

# Logan Karsten
# National Center for Atmospheric Research
# Research Applications Laboratory.

# Load necessary libraries
library(ggplot2)

# Process command line arguments.
args <- commandArgs(trailingOnly = TRUE)
sourceFile <- args[1]

# Source temporary R file. This will load up options necessary
# to run analysis.
source(sourceFile)

# Load input file containing daily snow obs, model values and
# possibly SNODAS values.
load(inFile)

# Establish time information
dUnits <- "days"
diff <- difftime(dateEnd,dateStart,units=dUnits)
nSteps <- diff <- as.numeric(diff)
dt <- 24*3600

bDStr <- strftime(dateStart,'%Y%m%d',tz='UTC')
eDStr <- strftime(dateEnd,'%Y%m%d',tz='UTC')

numBasins <- length(unique(snowBasinData$Basin))
basins <- unique(snowBasinData$Basin)
# Loop through each basin available and calculate plots.
print(basins)
print(numBasins)
for(basin in 1:numBasins){
   basinTmp <- basins[basin]
   print(basinTmp)
   outPath1 <- paste0(jobDir,'/SWE_VOLUME_',basinTmp,'_',bDStr,'_',eDStr,'.png')
   dfTmp <- subset(snowBasinData,Basin == basinTmp)
   dfTmp$snow_volume_acre_feet <- dfTmp$snow_volume_acre_feet/1000.0 # Convert to thousands of acre-feet
   gg <- ggplot(dfTmp,aes(x=Date,y=snow_volume_acre_feet,color=product)) +
         geom_line() + 
         xlab('Date') + 
         ylab('SWE Volume (thousands acre-feet)')
   ggsave(filename=outPath1,plot=gg,units="in", width=8, height=6, dpi=100)
}
