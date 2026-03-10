clear all; close all; clc;

addpath("MAT Data Files\");
addpath("Scripts\");

load("Bounds.mat")
load("Polished_Data.mat")
load("Transect_Data.mat")
load("Distance_Depth.mat")

max_depth = max(All_Data_Polished(:, 7))
min_depth = min(All_Data_Polished(:, 7))

lat = All_Data_Polished(:, 2);
lon = All_Data_Polished(:, 3);
depth = All_Data_Polished(:, 7);

[unique_lon, unique_lat] = meshgrid(unique(lon), unique(lat));
Z = griddata(lon, lat, depth, unique_lon, unique_lat, 'linear');

max_Z = max(Z)
min_Z = min(Z)

windowSize = 35; % Define the size of the moving average window

Z_smooth = Z; 
for i = 1:size(Z, 1)
    Z_smooth(i, :) = movmean(Z(i, :), windowSize, 'Endpoints', 'shrink');
end

for j = 1:size(Z_smooth, 2)
    Z_smooth(:, j) = movmean(Z_smooth(:, j), windowSize, 'Endpoints', 'shrink');
end

nlat = []; nlon = []; nz = [];
[a, b] = size(unique_lat);
for i = 1:b
nlat = [nlat; unique_lat(:, i)];
nlon = [nlon; unique_lon(:, i)];
nz = [nz; -Z_smooth(:, i)];
end
bathymetry = [nlat, nlon, nz];
writematrix(bathymetry,'bathymetrydata.txt');

% bathymetry(isnan(bathymetry(:,3)), 3) = -9999;
% writematrix(bathymetry, 'bathymetrydata_NO_NAN.txt');

%%
figure('Position', [680,50,1022,946]);

% Plot the contour (last layer)
contourf(unique_lon, unique_lat, -Z_smooth, -4:(4/40):0, 'LineStyle', 'none');
cb = colorbar; colormap("jet"); hold on;

% Plot the lines for Left, Sugar Island, and Bottom Island
h1 = plot(SD.Left(:, 2), SD.Left(:, 1), 'k', 'LineWidth', 1.25);
h2 = plot(SD.SugarIsland(:, 2), SD.SugarIsland(:, 1), 'k', 'LineWidth', 1.25);
h3 = plot(SD.BottomIsland(:, 2), SD.BottomIsland(:, 1), 'k', 'LineWidth', 1.25);

% Offset the area next to Sugar Island
fillX = [x1, fliplr(x2)]; % X coordinates for filling
fillY = [y1, fliplr(y2)]; % Y coordinates for filling
fill(fillX, fillY, 'w', 'EdgeColor', 'none'); % Fill area with white

fillX2 = [x1, fliplr(x3)]; % X coordinates for filling
fillY2 = [y1, fliplr(y3)]; % Y coordinates for filling
fill(fillX2, fillY2, 'w', 'EdgeColor', 'none'); % Fill area in green with transparency

% Fill the House area
fill(House(:, 2), House(:, 1), 'm', 'EdgeColor', 'none');

% Bring the other plots to the front
uistack(h1, 'top');
uistack(h2, 'top');
uistack(h3, 'top');

xlim([-68.666, -68.658]); xticks(-68.666:0.002:-68.658)
ylim([45.096, 45.104]); yticks(45.096:0.002:45.104)
clim([-4 0]);

grid minor;
xlabel('Longitude', 'FontSize', 12, 'FontName', 'Times New Roman');
ylabel('Latitude', 'FontSize', 12, 'FontName', 'Times New Roman');
ylabel(cb, 'Depth, m', 'FontSize', 12, 'FontName', 'Times New Roman');
title('Contour Plot of Depth', 'FontSize', 16, 'FontName', 'Times New Roman');

ax = gca; ax.FontName = 'Times New Roman'; ax.FontSize = 12; 
cb.FontSize = 12; cb.FontName = 'Times New Roman'; 

legend('', '', '', 'Slide location', 'Boundary')
hold off;

%%
figure('Position', [680,50,1022,946]);

% Plot the contour (last layer)
contourf(unique_lon, unique_lat, -Z_smooth, -4:(4/40):0, 'LineStyle', 'none');
cb = colorbar; colormap("jet"); hold on;

% Plot the lines for Left, Sugar Island, and Bottom Island
h1 = plot(SD.Left(:, 2), SD.Left(:, 1), 'k', 'LineWidth', 1.5);
h2 = plot(SD.SugarIsland(:, 2), SD.SugarIsland(:, 1), 'k', 'LineWidth', 1.5);
h3 = plot(SD.BottomIsland(:, 2), SD.BottomIsland(:, 1), 'k', 'LineWidth', 1.5);
for i = 1:13
h4 = plot(Data{i}(:,3),Data{i}(:,2),'b','LineWidth', 1.5); hold on;
end; clear i;

% Offset the area next to Sugar Island
fillX = [x1, fliplr(x2)]; % X coordinates for filling
fillY = [y1, fliplr(y2)]; % Y coordinates for filling
fill(fillX, fillY, 'w', 'EdgeColor', 'none'); % Fill area with white

fillX2 = [x1, fliplr(x3)]; % X coordinates for filling
fillY2 = [y1, fliplr(y3)]; % Y coordinates for filling
fill(fillX2, fillY2, 'w', 'EdgeColor', 'none'); % Fill area in green with transparency

% Fill the House area
fill(House(:, 2), House(:, 1), 'm', 'EdgeColor', 'none');

% Bring the other plots to the front
uistack(h1, 'top');
uistack(h2, 'top');
uistack(h3, 'top');
uistack(h4, 'top');

xlim([-68.666, -68.658]); xticks(-68.666:0.002:-68.658)
ylim([45.096, 45.104]); yticks(45.096:0.002:45.104)
clim([-4 0]);

grid minor;
xlabel('Longitude', 'FontSize', 12, 'FontName', 'Times New Roman');
ylabel('Latitude', 'FontSize', 12, 'FontName', 'Times New Roman');
ylabel(cb, 'Depth, m', 'FontSize', 12, 'FontName', 'Times New Roman');
title('Contour Plot of Depth', 'FontSize', 16, 'FontName', 'Times New Roman');

ax = gca; ax.FontName = 'Times New Roman'; ax.FontSize = 12; 
cb.FontSize = 12; cb.FontName = 'Times New Roman'; 

legend('', 'Transect', '', '', '', '', '', '', '','', '', '','', '', '','Slide Location', 'Boundary', '','', '', '')
hold off;
