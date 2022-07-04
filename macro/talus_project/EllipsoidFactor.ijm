//This ImageJ macro opens 16-bit images and measures the Ellipsoid Factor of the foreground.
//Tabulated summary results are saved to a CSV file EllipsoidFactor.csv
//Image output is saved to a user-defined output directory.
//Basic numerical summaries (e.g. median EF) do not capture the range of geometries present
//so a complete analysis should include comparisons of Flinn plots and EF histograms.
//Felder A, Monzem S, Souza RD, Mills D, Boyde A, Doube M. 2021
//The plate-to-rod transition in trabecular bone loss is elusive.
//Roy. Soc. Open Sci. 8, 201401. (https://doi.org/10.1098/rsos.201401)


//Michael Doube 2022-05-10
//Copyright GNU GPL v.3

//There is a bug in the macro processor which means that image
//outputs are not created if Ellipsoid Factor is called from a macro in batch mode, see e.g.
//https://forum.image.sc/t/save-tiff-stack-from-ellipsoid-factor-in-headless-mode/58811
//This means that it's possible to accidentally break the macro running by clicking or typing 
//when the images are being displayed. Best to let it run overnight or in the weekend, or 
//on a machine that you are not going to touch for a while.

setBatchMode(false);
directory = getDir("Input images");
outputDirectory = getDir("Output images");
if (directory == outputDirectory){
	exit("Input directory cannot be the same as output directory.");
}
inputImageTitle = "";
list = getFileList(directory);
for (i = 0; i < list.length; i++){
	path = directory+list[i];
	
	//directory of stack slices
	if (endsWith(path, "/")){
		print("Opening sequence from "+path);
		run("Image Sequence...", "select=["+path+"] dir=["+path+"] sort");
		inputImageTitle = getTitle();
	}

	//TIFF stack
	else if (endsWith(path, ".tif")){
		print("Opening TIFF stack from "+path);
		open(path);
		inputImageTitle = File.getNameWithoutExtension(path);
	}

	//everything else
	else {
		print("Ignoring "+path);
		continue;
	}

	//autothreshold
    setAutoThreshold("Default dark stack");
    setOption("BlackBackground", false);
    run("Convert to Mask", "method=Default background=Dark");
	
	//get input image ID
	inputImageID = getImageID();

    //measure Ellipsoid Factor
	run("Ellipsoid Factor", "nvectors=100 vectorincrement=0.435 skipratio=1 contactsensitivity=1 maxiterations=50 maxdrift=1.73 runs=8 weightedaveragen=1 seedondistanceridge=true distancethreshold=0.6 seedontopologypreserving=true showflinnplots=true showconvergence=true showsecondaryimages=false");
	close(inputImageID);
	
	//make and save a histogram image
	selectImage(inputImageTitle+"_EF");
	run("Histogram", "bins=256 x_min=-1 x_max=1 y_max=Auto stack");
	saveAs("Tiff", outputDirectory+"Histogram of "+inputImageTitle+"_EF.tif");
	close();
	
	//save and close all the images	
	selectImage(inputImageTitle+"_EF");
	saveAs("Tiff", outputDirectory+inputImageTitle+"_EF.tif");
	close();
		
	selectImage(inputImageTitle+"_unweighted_Flinn_plot");
	saveAs("Tiff", outputDirectory+inputImageTitle+"_unweighted_Flinn_plot.tif");
	close();
	
	selectImage(inputImageTitle+"_Flinn_peak_plot");
	saveAs("Tiff", outputDirectory+inputImageTitle+"_Flinn_peak_plot.tif");
	close();
}

//comment out these lines if you prefer to save and clear the table interactively
run("Table...  ", "writecolheaders=true writerowheaders=true columndelimiter=, outputfile=["+directory+"EllipsoidFactor.csv]");
run("Clear BoneJ results");

