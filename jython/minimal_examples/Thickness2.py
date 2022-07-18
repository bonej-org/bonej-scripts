# @CommandService commandService

# Example code to open an ImagePlus (i.e. an ImageJ1 data structure) and pass it to an BoneJ thickness (an ImageJ2 plugin found through the command service)
#https://forum.image.sc/t/save-tiff-stack-from-ellipsoid-factor-in-headless-mode/58811/43

#Alessandro Felder
#2022-03-25

from ij import IJ #import IJ1 functions needed

output_dir = "D:\\AF-side-projects\\"
input_image_path = output_dir+"bone.tif"

#open input as IJ1-style image
IJ.open(input_image_path)
input_image_ij1 = IJ.getImage() # BoneJ2 Thickness wrapper requires IJ one image data, i.e. an ImagePlus

# Further parameters have to match @Parameter annotations in code : 
# e.g. there is a boolean variables called `showMaps` in the code, annotated with @Parameter, so you can set it by passing the variable as a string and then its value as I have done here
# i.e. "showMaps", True (see https://github.com/bonej-org/BoneJ2/blob/8a325b8121a326a1beee2f62d9d10ef0f1f00cb1/Modern/wrapperPlugins/src/main/java/org/bonej/wrapperPlugins/ThicknessWrapper.java#L111)
# If you don't set it, it will take the default value... if it has one (and crash otherwise, I think).
wrapper = commandService.run("org.bonej.wrapperPlugins.ThicknessWrapper",False,["inputImage", input_image_ij1, "showMaps", True, "maskArtefacts", True])
wrapperInstance = wrapper.get()
trabecular_map = wrapperInstance.getOutput("trabecularMap");

IJ.save(trabecular_map, output_dir+"test_image_new.tif")
