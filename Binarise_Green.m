% Loop through each subfolder

clear variables; close all;

addpath '/Users/valfred/Desktop/OneDrive - sheffield.ac.uk/Paolo_Tracking/FuzzyColor/FuzzyColor'

% Setting parameters
thresh_level = 0.6;
min_object_size = 20;

% Setting directories
currdir = pwd;
addpath(pwd);
filedir = uigetdir(); %containing folder split_tifs
cd(filedir);

tifs_no = [filedir,['/split_tifs/']]

files    = dir(tifs_no);
names    = {files.name};% Get a logical vector that tells which is a directory.
dirFlags = [files.isdir] & ~strcmp(names, '.') & ~strcmp(names, '..');
% Extract only those that are directories.
subDirsNames = names(dirFlags);

n_subfolders = numel(subDirsNames);

for ww = 1:n_subfolders
    split_tifs_individual = [filedir, ['/split_tifs/', num2str(ww)]];
    cd(split_tifs_individual)
    files_split = dir('*.tif')

    % Create results subdirectory
    if exist([split_tifs_individual, '../../Green_binary'],'dir') == 0
        mkdir(split_tifs_individual,'../../Green_binary');
    end
    Green_binary = [split_tifs_individual,'../../Green_binary'];

     % create individual folders for thresholded images
    if exist ([filedir, ['/Green_binary/', num2str(ww)], 'dir']) == 0
        mkdir (filedir, ['/Green_binary/', num2str(ww)]);
    end
    Green_binary_files = [filedir, ['/Green_binary/', num2str(ww)]];

    % Isolating merged yellow spots
    for kk = 1:numel(files_split)
        cd(split_tifs_individual)
        I = [num2str(kk),'.tif'];
        Im = imread(I);
        Im = imtophat(Im,strel('disk',10)); 
        Im = imadjust(Im); 
        BW = imbinarize(Im, thresh_level);
        % BW = imbinarize(Im, adaptthresh(Im, thresh_level));
        BW = bwareaopen(BW, min_object_size);
        BW = medfilt2(BW); figure, imshow(BW)
        BW = imfill(BW, 'holes');
        BW = im2double(BW);

        % write binary data to subfolder
        cd(Green_binary_files)
        imwrite(BW, [num2str(kk),'.tif'], 'Compression', 'none');
        close all
        kk
    end

cd(Green_binary_files)
dlmwrite('parameters.txt',[thresh_level, min_object_size])

end