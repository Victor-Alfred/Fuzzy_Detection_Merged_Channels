% Loop through each subfolder

clear variables; close all; clc;

addpath '/Users/valfred/Desktop/OneDrive - sheffield.ac.uk/Paolo_Tracking/FuzzyColor/FuzzyColor'

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
    if exist([split_tifs_individual, '../../Yellow_binary_dilated'],'dir') == 0
        mkdir(split_tifs_individual,'../../Yellow_binary_dilated');
    end
    Yellow_binary_dilated = [split_tifs_individual,'../../Yellow_binary_dilated'];

     % create individual folders for thresholded images
    if exist ([filedir, ['/Yellow_binary_dilated/', num2str(ww)], 'dir']) == 0
        mkdir (filedir, ['/Yellow_binary_dilated/', num2str(ww)]);
    end
    Yellow_binary_dilated_files = [filedir, ['/Yellow_binary_dilated/', num2str(ww)]];

    % Isolating merged yellow spots
    for kk = 1:numel(files_split)
        cd(split_tifs_individual)
        I = [num2str(kk),'.tif'];
        imrgb = imread(I);
        figure, imshow(imrgb)
        % for yellow overlapping channel
        indy = find(fuzzycolor(double(imrgb)/255,'yellow')<0.5);
        n = size(imrgb,1)*size(imrgb,2);
        img = imrgb;
        img([indy;indy+n;indy+2*n]) = 255;
        figure, imshow(img)

        img2 = uint8(255) - img; 
        img2 = rgb2gray(img2);
        img2 = imbinarize(img2); 
        % dilated to eliminate halo effect after removing green channel
        SE = strel('sphere',2);
        img2 = imdilate(img2, SE); 
        img2 = imfill(img2, 'holes'); figure, imshow(img2)
        final_img = im2double(img2);


        % rgbImage = img;
        % %Split image into color components
        % redChannel = rgbImage(:, :, 1);
        % greenChannel = rgbImage(:, :, 2);
        % blueChannel = rgbImage(:, :, 3);
        % % Construct the rgb image with swapped red and green channels.
        % thresholdValue = 5; % How much greener does it need to be?
        % greenishPixels = (0.5*single(greenChannel) - (single(redChannel) + single(blueChannel))) > thresholdValue;
        % newRed = 255-greenChannel;
        % newRed(greenishPixels) = 255;
        % newGreen = 255-greenChannel;
        % newGreen(greenishPixels) = 0;
        % newBlue = 255-blueChannel;
        % newBlue(greenishPixels) = 0;
        % rgbImage2 = cat(3, newRed, newGreen, newBlue);
        % figure, imshow(rgbImage2)
        % final_img = rgbImage2;
        % final_img = rgb2gray(final_img);
        % final_img = imbinarize(final_img);
        % final_img = im2double(final_img);

        % write binary data to subfolder
        cd(Yellow_binary_dilated_files)
        imwrite(final_img, [num2str(kk),'.tif'], 'Compression', 'none');
        close all
        kk
    end
end