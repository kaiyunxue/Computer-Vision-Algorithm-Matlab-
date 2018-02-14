% Sample use of PointCloud2Image(...)
% 
% The following variables are contained in the provided data file:
%       BackgroundPointCloudRGB,ForegroundPointCloudRGB,K,crop_region,filter_size
% None of these variables needs to be modified


clc
clear all
% load variables: BackgroundPointCloudRGB,ForegroundPointCloudRGB,K,crop_region,filter_size)
load data.mat

data3DC = {BackgroundPointCloudRGB,ForegroundPointCloudRGB};
K(1,1) = K(1,1)*1.6;
K(2,2) = K(2,2)*1.6;
f = (K(1,1)+K(2,2))/2;
R       = eye(3);
move    = [0 0 -0.25]';
% dis = f/400;
dis = 13;


for step=0:15
    tic
    fname       = sprintf('SampleOutput%03d.jpg',step);
    display(sprintf('\nGenerating %s',fname));
    K(1,1)      = (dis+move(3)*step)*K(1,1)/dis+move(3)*(step-1);
    K(2,2)      = (dis+move(3)*step)*K(2,2)/dis+move(3)*(step-1);
    t           = step*move;
    M           = K*[R t];
    im          = PointCloud2Image(M,data3DC,crop_region,filter_size);
    imwrite(im,fname);
    toc    
end
