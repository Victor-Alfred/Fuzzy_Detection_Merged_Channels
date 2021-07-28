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