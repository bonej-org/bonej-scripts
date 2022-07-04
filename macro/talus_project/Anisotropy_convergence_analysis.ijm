 //number of directions to draw probes
 nDirsMax = 32768; //<- edit to suit your needs
 //number of lines per direction
 nLinesMax = 1024; //<- edit to suit your needs
 
 // --- No need to edit the rest
 row = 0;
 setBatchMode(true);
 for (nDirs = 16; nDirs <= nDirsMax; nDirs *= 2){
    for (nLines = 1; nLines <= nLinesMax; nLines *= 2){
    startTime = getTime();
    run("Anisotropy", "inputimage=net.imagej.ImgPlus@73956688 directions="+nDirs+" lines="+nLines+" samplingincrement=1.73 recommendedmin=true printradii=true printeigens=true displaymilvectors=false instruction=\"\"");
        endTime = getTime();
        duration = endTime - startTime;
        setResult("nDirs", row, nDirs);
        setResult("nLines", row, nLines);
        setResult("Duration", row, duration);
        updateResults();
        row++;
     }
 }