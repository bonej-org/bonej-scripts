#Minimal example to call Thickness from the ImageJ Jython editor / interpreter
#see also: https://forum.image.sc/t/save-tiff-stack-from-ellipsoid-factor-in-headless-mode/58811/41
#Test data available here: https://bonej.org/images/shrew.tif

#Michael Doube
#2022-07-18
#GPL v3

from ij import IJ
from ij.process import StackStatistics
from sc.fiji.localThickness import LocalThicknessWrapper

#path to the test image
path = "/home/mdoube/Desktop/test_images/shrew.tif"

#open the image as ImageJ1-style ImagePlus object without showing it
imp = IJ.openImage(path)

#show the image (comment out for headless)
imp.show()

#instantiate local thickness and set its options
localThickness = LocalThicknessWrapper();
localThickness.setSilence(True);
localThickness.setShowOptions(False);
localThickness.maskThicknessMap = True;
localThickness.calibratePixels = True;

#run local thickness. mapImp is the thickness map as an ImageJ1 ImagePlus
mapImp = localThickness.processImage(imp)

#show the thickness map (comment out for headless)
mapImp.show()

#calculate some summary statistics on the map
#see also https://imagej.nih.gov/ij/developer/api/ij/ij/process/StackStatistics.html
resultStats = StackStatistics(mapImp);
print(resultStats)

#save the map
IJ.save(mapImp, "/home/mdoube/Desktop/shrewTbTh.tif")

#close the images
imp.close()
mapImp.close()

