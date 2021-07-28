%% Splitter: Split timelapse into individual frames
% Victor Alfred, 2020

clear variables; close all; clc;

% Setting directories
currdir = pwd;
addpath(pwd);
filedir = uigetdir();
cd(filedir);
object_files = dir('*.tif');

% creating directory for results
if exist([filedir, '/split_tifs'],'dir') == 0
    mkdir(filedir,'/split_tifs');
end
split_folder = [filedir, '/split_tifs'];

% Specify number of frames in timlapse
timeframes = inputdlg('Please enter number of frames in timelapse: ','timeframes');
 while (isnan(str2double(timeframes)) || str2double(timeframes)<0)
     timeframes = inputdlg('Please enter number of frames in timelapse: ','timeframes');
end
timeframes = str2double(timeframes);

% read in and split timelapse
for g = 1:numel(object_files)

    % create individual folders for timelapse frames
    if exist ([filedir, ['/split_tifs/', num2str(g)], 'dir']) == 0
        mkdir (filedir, ['/split_tifs/', num2str(g)]);
    end
    split_tifs_individual = [filedir, ['/split_tifs/', num2str(g)]];

    % read in timelapse image
    I = [num2str(g),'.tif'];
    I_im = imread(I);

    % split timelapse into individual number of frames
    for K = 1 : timeframes
        MyImages(:,:,:,K) = imread([num2str(g),'.tif'], K);
        cd(split_tifs_individual)
        imwrite(MyImages(:,:,:,K), [num2str(K),'.tif'], 'Compression', 'none'); 
        cd(filedir)
    end
end

% '%03.f'