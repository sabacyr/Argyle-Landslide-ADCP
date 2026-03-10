
%%

close all; clc; clear all;

load("DataDepth.mat")
load("Bounds.mat")

% Create a grid for the surface plot
% You may need to use unique lat/lon values for grid creation
[unique_lon, unique_lat] = meshgrid(unique(lon), unique(lat));
Z = griddata(lon, lat, depth, unique_lon, unique_lat, 'linear');
Z(Z > 3.6) = 0.5;
Z(Z < 0 ) = 0.5;

% Assuming Z is your interpolated data
windowSize = 10; % Define the size of the moving average window

% Smooth the data using a moving average filter
Z_smooth = Z; % Initialize the smoothed array
for i = 1:size(Z, 1)
    Z_smooth(i, :) = movmean(Z(i, :), windowSize, 'Endpoints', 'shrink');
end

for j = 1:size(Z_smooth, 2)
    Z_smooth(:, j) = movmean(Z_smooth(:, j), windowSize, 'Endpoints', 'shrink');
end



% Create the contour plot
figure
for i = 1:13
plot3(Data{i}(:,3),Data{i}(:,2),-Data{i}(:,7),'b'); hold on;
end; clear i;
plot3(SD.Left(:,2),SD.Left(:,1),SD.Left(:,3),'k'); hold on;
plot3(SD.SugarIsland(:,2),SD.SugarIsland(:,1),SD.SugarIsland(:,3),'k'); hold on;
plot3(SD.BottomIsland(:,2),SD.BottomIsland(:,1),SD.BottomIsland(:,3),'k'); hold on;

xlim([xbounds(1) xbounds(2)]);
ylim([ybounds(1) ybounds(2)]);
zlim([zbounds(1) zbounds(2)]);

contourf(unique_lon, unique_lat, -Z_smooth, [-3.6:(3.6/20):0], 'LineStyle', 'none');
colorbar; 
xlabel('Longitude');
ylabel('Latitude');
title('Contour Plot of Depth');
