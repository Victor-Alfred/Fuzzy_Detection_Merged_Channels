dir1 = getDirectory("Choose Source Directory ");
dir2 = getDirectory("Choose Destination Directory ");
list = getFileList(dir1);setBatchMode(true);
for (i=0; i<list.length; i++) {    
	showProgress(i+1, list.length);    
	open(dir1+list[i]);

	// INSERT MACRO HERE 
	run("Stack Splitter", "number=194");   

	saveAs("TIFF", dir2+list[i]);    
	close();
}





// get image IDs of all open images
dir = getDirectory("Choose a Directory"); // to save opened images
// split currently opened image
run("Stack Splitter", "number=194");
//ids=newArray(nImages);
for (i=0;i<nImages;i++) {
        selectImage(i+1);
        title = getTitle;
        print(title);
        //ids[i]=getImageID;

        saveAs("tiff", dir+title);
} 
run("Close All");


In EXCEL, use as forumula starting with "="

For Old labels
"slice0"&TEXT(MOD(ROW(A1)-1,194)+1,"000")&"_1.tif"

For New labels
TEXT(MOD(ROW(A1)-1,194)+1, "0")&".tif"



"01P-01A-"&CHAR(ROW(A780)/12)&TEXT(MOD(ROW(A1)-1,12)+1,"00")
01P-01A-A01
01P-01A-A02
01P-01A-A03