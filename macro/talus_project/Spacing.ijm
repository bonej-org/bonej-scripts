//This ImageJ macro opens 16-bit images and measures the thickness of the background (i.e. trabecular spacing, Tb.Sp)
//and saves the results to a CSV file Spacing.csv
//Header titles will say 'Tb.Th' but they mean 'Tb.Sp' in this context.

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
	
	//get the image ID and name
	image_ID = getImageID();
	image_name = getTitle();
	
	//duplicate
	run("Duplicate...", "title=duplicated_image duplicate");
	duplicate_image_ID = getImageID();

	//autothreshold the original image to make trabeculae foreground
	selectImage(image_ID);
    setAutoThreshold("Default dark stack");
    setOption("BlackBackground", false);
    run("Convert to Mask", "method=Default background=Dark");

    //threshold to make spherical mask
    selectImage(duplicate_image_ID);
    setThreshold(1, 65535);
	run("Convert to Mask", "method=Default background=Dark");

    //XOR the trabeculae and the sphere to get the marrow space in the foreground
    imageCalculator("XOR create stack", image_ID, duplicate_image_ID);
    marrow_image_ID = getImageID();

    //close the working images
    selectImage(image_ID);
    close();
    selectImage(duplicate_image_ID);
    close();

    //select the marrow-space-as-foreground image and give it a sensible title
    selectImage(marrow_image_ID);
    rename(image_name);

    //measure thickness
    run("Thickness", "mapchoice=[Trabecular thickness] showmaps=false maskartefacts=true");
	close();
}

//comment out these lines if you prefer to save and clear the table interactively
run("Table...  ", "writecolheaders=true writerowheaders=true columndelimiter=, outputfile=["+directory+"Spacing.csv]");
run("Clear BoneJ results");

