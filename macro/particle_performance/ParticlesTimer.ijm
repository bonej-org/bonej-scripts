//Performance test script used to benchmark BoneJ's connected components
//sequential region labelling.
//In each loop a full region labelling and particle analysis is performed 5 times in batch mode

//the s10up dataset is available here:
//Doube, Michael (2020): Test images for connected components sequential region labelling.
//figshare. Dataset. https://doi.org/10.6084/m9.figshare.11860542.v3
//and the findings were published here
//Doube M. 2021 Multithreaded two-pass connected components labelling and particle analysis in ImageJ.
//Royal Society Open Science 8, 201784. https://doi.org/10.1098/rsos.201784

//users will need to replace the path in the call to open() to
//match the image location on their machine.

//Michael Doube
//Copyright GPL v3
//2022-07-18

setBatchMode(true);
//warm up
open("/mnt/md0/images/testImages/s10up_16MB.tif");
connect();
close();
print("\\Clear");

open("/mnt/md0/images/testImages/s10up_2MB.tif");
connect();
close();

open("/mnt/md0/images/testImages/s10up_16MB.tif");
connect();
close();


open("/mnt/md0/images/testImages/s10up-128MB.tif");
connect();
close();


open("/mnt/md0/images/testImages/s10up-1GB.tif");
connect();
close();


open("/mnt/md0/images/testImages/s10up_big.tif");
connect();
close();

function connect() {
  for (i = 0; i < 5; i++){
    run("Particle Analyser", "  min=0.000 max=Infinity");
  }
}
