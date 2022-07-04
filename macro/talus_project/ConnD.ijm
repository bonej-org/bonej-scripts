//This ImageJ macro opens 16-bit images and measures the connectivity of the binary foreground phase
//and saves the results to a CSV file Connectivity_results.csv
//Images may be provided as .tif stacks (one .tif per volume) or directories of stack slices.
//The first results column is the name of the image, derived from either the filename (for TIFF stacks)
//or the name of the directory containing image slices.
//the second column, is the Euler characteristic, a measure of the number of topological 'handles' in the image & can be ignored
//the 3rd column 'delta chi' is an adjusted value for images where the trabeculae touch the image sides & can be ignored.
//the 4th column is the Connectivity value that you should use in further calculations
//ignore the 5th column, Conn.D, (it uses the stack volume not the sphere volume to calculate the density).

//Michael Doube 2022-03-28
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

	//do a default auto threshold. A blunt tool but maybe OK for our purposes.
	setAutoThreshold("Default dark stack");
	setOption("BlackBackground", false);
	run("Convert to Mask", "method=Default background=Dark");

	//measure connectivity of the whole image
	//note that Conn.D is calculated using the whole stack volume and not the sphere volume, ignore this Conn.D
	//and use Connectivity from this table and divide it by the sphere volume you got from the ROI_Volume script
	//to calculate Conn.D yourself
	run("Purify", " ");
    run("Connectivity");
	close();
}

//comment out these lines if you prefer to save and clear the table interactively
saveAs("Results", directory+"Connectivity_results.csv");
run("Clear Results");
