//This ImageJ macro opens 16-bit images and measures the thickness of the foreground
//and saves the results to a CSV file Thickness.csv

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

	//autothreshold
    setAutoThreshold("Default dark stack");
    setOption("BlackBackground", false);
    run("Convert to Mask", "method=Default background=Dark");

    //measure thickness
    run("Thickness", "mapchoice=[Trabecular thickness] showmaps=false maskartefacts=true");
	close();
}

//comment out these lines if you prefer to save and clear the table interactively
run("Table...  ", "writecolheaders=true writerowheaders=true columndelimiter=, outputfile=["+directory+"Thickness.csv]");
run("Clear BoneJ results");

