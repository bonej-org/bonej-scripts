//This ImageJ macro opens 16-bit images and measures the volume of the non-0 pixels
//and saves the results to a CSV file ROI_volumes.csv
//Images may be provided as .tif stacks (one .tif per volume) or directories of stack slices.
//The first results column is the name of the image, derived from either the filename (for TIFF stacks)
//or the name of the directory containing image slices.
//the second column, 'BV' is the volume of the ROI in calibrated units (mm³ usually). Ignore what it is called; you will use it as 'TV' in other calculations.
//the 3rd & 4th columns can be deleted/ignored.TV is the volume of the cubic image stack; BV/TV is the ratio of the spherical ROI to image stack volumes.
//(in principle 'BV/TV' or volume fraction should be close to the ratio of a sphere to its minimal bounding cube,
//i.e. 4/3 pi r³ : (2r)³ = 4pi/3 : 8 = 0.5236, with some error for the padding)

//Michael Doube 2022-03-11
//Copyright GNU GPL v.3


setBatchMode(true);
directory = getDir("Choose a Directory");
list = getFileList(directory);
for (i = 0; i < list.length; i++){
	path = directory+list[i];
	
	//directory of stack slices
	if (endsWith(path, "/")){
		print("Opening sequence from "+path);
		run("Image Sequence...", "select=["+path+"] dir=["+path+"] sort");		
	}

	//TIFF stack
	else if (endsWith(path, ".tif")){
		print("Opening TIFF stack from "+path);
		open(path);
	}

	//everything else
	else {
		print("Ignoring "+path);
		continue;
	}

	//measure volume of spherical ROI
	//include all pixels greater than 0 (0 appears only outside the ROI)
	setThreshold(1, 65535);
	run("Convert to Mask", "method=Default background=Dark");
	run("Area/Volume fraction");
	close();
}

//comment out these lines if you prefer to save and clear the table interactively
run("Table...  ", "writecolheaders=true writerowheaders=true columndelimiter=, outputfile=["+directory+"ROI_volumes.csv]");
run("Clear BoneJ results");

