#This is a minimal example that opens shrew.tif, a small binary 3D stack,
#and runs intertrabecular angles on it

#Michael Doube
#GPL v3
#2022-07-18

# @CommandService cs
# @TableIOService tios

from ij import IJ
from ij import ImagePlus
from org.scijava.table.io import TableIOOptions
from org.bonej.utilities import SharedTable as table
 
#Set data input-output paths 
input_dir = "/mnt/md0/images/testImages/"
input_image_path = input_dir+"shrew.tif"
outputdir = "/home/mdoube/Desktop/"

#clear old results from the table
IJ.run("Clear BoneJ results");
 
#open input image as IJ1-style ImagePlus to be compatabile with wrapper  
inputImagePlus = IJ.openImage(input_image_path)
#inputImagePlus.show()

#not needed for this script because shrew.tif is already binary [0,255]
# input_image_ij1 = IJ.run(input_Image,"Multiply...", "value=255 stack"); 

#Run Intertrabecular Angles Plugin specifying parameters 
wrapper = cs.run("org.bonej.wrapperPlugins.IntertrabecularAngleWrapper", True, ["inputImage",inputImagePlus, "minimumValence", 3, "maximumValence", 50, "minimumTrabecularLength", 0, "marginCutOff", 10, "iteratePruning", True, "useClusters", True, "printCentroids", True,"printCulledEdgePercentages", False, "showSkeleton", True])

#must call wrapper.get() to populate the result table with data
wrapperInstance = wrapper.get()
#Need to confirm largest skeleton is being processed 
skeleton= wrapperInstance.getOutput("skeleton")
IJ.save(skeleton, outputdir+"skeleton.tif")

#save the result table
tios.save(table.getTable(), outputdir+"ITA.csv", TableIOOptions())
