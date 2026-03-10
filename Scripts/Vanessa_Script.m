
close all; clc; clear all;

load("DataDepth.mat")
load("Bounds.mat")

%% Put on sigma grid
% New Grid Values
nbyi = NaN(21, 305640);
sigma_bins = linspace(0, 1, 21); % populate with real values for sigma bins
% Create Sigma Bins
for i = 1:305640
    nbyi(:, i) = sigma_bins; % need to have real values here to interpolate (No NaNs)
end
%mimic = linspace(hii(first),hii(last),20);
%nb_test = interp(hii,backscatter, mimic);
% Variables
hii = depth_ranges; %original depth grid
dii = time; %datetime
for i = 1:305640
    % variables
    yi = hii; 
    max_depth = ADCP1_depth(:,i); % max depth
    xi = dii(:,i); % row
    nyi = yi/max_depth; % new y axis grid of normalized depth
    nnyi = nbyi(:,i); % placeholder for new data
    b = backscatter(:,i); % data to analyze
    
    % NaN values deeper than depth
    pp = find(nyi > 1);
    nyi(pp)= NaN;
    
    % FInd NaNs
    oo = isnan(b);
    nyi(oo) = NaN;
    bb = isnan(nyi);
    b(bb) = NaN;
    % Remove NaNs from original MeshGrid
    b(isnan(b))=[];
    nyi(isnan(nyi))=[];
    % Interpolate and Store New Mesh Grid
    first = 1;            % Starting index
    last = length(nyi); % Ending index
    
    % Even spaced rows
    mimic = linspace(nyi(first), nyi(last), 21);
    % Interpolate
    nb = interp1(nyi,b,mimic);
    nbyi(:,i) = nb;
end
%% 
dn_time = datenum(time);
% Create the first contour plot for backscatter with no contour lines
figure;
% First subplot for backscatter
%subplot(2,1,1); % Creates a subplot in the top half of the figure
contourf(dn_time, nnyi, nbyi, 'LineColor', 'none'); % Remove contour lines
% Customize the x-axis with dates
datetick('x', 'dd-mmm-yyyy', 'keepticks'); % Format dates as 'dd-mmm-yyyy'
xlabel('Time');
ylabel('Sigma Bins');
title('Bangor Estimated Inorganic Suspended Sediment');
% Enhance plot appearance
ax = gca;
ax.FontSize = 12; % Increase font size for better readability
colormap(jet); % Set a colormap for better visualization
% Set the color axis limits
caxis([min(nbyi(:)) max(nbyi(:))]); % Set the color axis limits, upper limit is 7
cb1 = colorbar; % Add colorbar
ylabel(cb1, 'Inorganic SSC (mg/L)'); % Label the colorbar with 'Backscatter (dB)'
grid on; % Add grid lines for better readability