
clear variables; close all; clc;

% Setting directories
currdir = pwd;
addpath(pwd);
filedir = uigetdir(); 

Green = [filedir, ['/Green_binary/']];
Yellow_dilated = [filedir, ['/Yellow_binary_dilated/']];

cd (Green)
files_no = dir('*.tif')

%Folder to save information 
if exist([filedir, '/Green_only_output'],'dir') == 0
    mkdir(filedir,'/Green_only_output');
end

Green_only_output = [filedir, '/Green_only_output'];

cd (Green)
files_no = dir('*.tif')

for g = 1:numel(files_no)
	cd (Green)
	I =  [num2str(g),'.tif'];
	Im_green = imread(I);
	Im_green = logical(Im_green); figure, imshow(Im_green)

	cd(Yellow_dilated)
	J =  [num2str(g),'.tif'];
	Im_yellow = imread(J);
	Im_yellow = logical(Im_yellow); figure, imshow(Im_yellow)

	Im_green_only = Im_green - Im_yellow; 
	Im_green_only = bwareaopen(Im_green_only, 15);

	% Filtering for most circular objects
	labeledImage = bwlabel(Im_green_only);
    stats = regionprops(labeledImage,'Circularity');
    minCirc = 0.4; 
    keepMask = [stats.Circularity]>minCirc;
    blobsToKeep = find(keepMask);
    Im_green_only = ismember(labeledImage, blobsToKeep) > 0; 

	Im_green_only = medfilt2(Im_green_only); 
	Im_green_only = imfill(Im_green_only, 'holes'); 
	figure, imshow(Im_green_only)
	Im_green_only = im2double(Im_green_only);

	cd(Green_only_output)

	imwrite(Im_green_only, [num2str(g),'.tif'], 'Compression', 'none');

	clear I J Im_yellow Im_green Im_green_only
	close all

end
