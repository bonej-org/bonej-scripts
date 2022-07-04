// This ImageJ macro opens 16-bit images and measures the degree of anisotropy
// of the texture contained within a maximal cube fit to the spherical ROI
// and saves the results to a CSV file Anisotropy.csv


//Michael Doube 2022-04-08
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

	title = getTitle();
	inputImageID = getImageID();

	//spherical ROI radius. There is 1 pixel padding between sphere and image sides
	sphereRadius = getWidth() / 2 - 1;

	//cubic ROI edge length
	cubeEdgeLength = (2 * sphereRadius) / sqrt(3);
	halfCubeEdgeLength = cubeEdgeLength / 2;

    //semi-width of image (needed to find centre)
    centreOffset = getWidth() / 2;

    //make a square ROI
    makeRectangle(centreOffset - cubeEdgeLength/2, centreOffset - cubeEdgeLength/2, cubeEdgeLength, cubeEdgeLength);

    //duplicate the slices to make a cube
    run("Duplicate...", "duplicate range="+centreOffset - halfCubeEdgeLength+"-"+centreOffset + halfCubeEdgeLength);
    cubeImageID = getImageID();

    //close the input image and rename the cube image with the name of the data
    selectImage(inputImageID);
    close();
    selectImage(cubeImageID);
    rename(title);

    //autothreshold
    setAutoThreshold("Default dark stack");
    setOption("BlackBackground", false);
    run("Convert to Mask", "method=Default background=Dark");

    //run anisotropy with directions and lines determined from a convergence analysis
    run("Anisotropy", "directions=1024 lines=1024 samplingincrement=1.73 recommendedmin=false printradii=true printeigens=true displaymilvectors=false");
    close();
}

//comment out these lines if you prefer to save and clear the table interactively
run("Table...  ", "writecolheaders=true writerowheaders=true columndelimiter=, outputfile=["+directory+"Anisotropy.csv]");
run("Clear BoneJ results");