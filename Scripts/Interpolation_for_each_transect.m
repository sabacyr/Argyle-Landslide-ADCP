
close all; clc; clear all;

load("Tranect_Data.mat")
% 2, 3, 4, 10, 11, 12 are the problematic ones
% must first NaN the depth values that are out of range and then
% interpolate to fix them

ogtran = Data{1, 12};
tran = Data{1, 12}; % transect of choice

% Find indices of negative depth values
bad_idx = find(tran(:, 7) < 0);

% Replace negative depth values with NaN
tran(bad_idx, 7) = NaN;

% Interpolate the NaNs (using linear interpolation as an example)
tran(:, 7) = fillmissing(tran(:, 7), 'linear');

%%
figure;
plot(tran(:, 1), tran(:, 7), 'Color', 'k', 'LineWidth', 1.75); 
%hold on
%plot(ogtran(:, 1), ogtran(:, 7), 'Color', 'g', 'LineWidth', 1)
%plot(transect2(:, 1), transect2(:, 7), 'Color', 'r', 'LineWidth', 1); 
xlabel('Time');
ylabel('Depth');
title('Transect Depth');
grid on;

% Find the outliers withing the data using the figure and then NaN them in
% the workspace and then fillmissing 
%tran(:, 7) = fillmissing(tran(:, 7), 'linear');

%%
%save both the new transect file and the original one in All_Data.m
transect12 = tran;
og_transect12 = ogtran;

%%

% Initialize an empty array to hold all data
All_Data_Polished = [];

% Loop through each transect variable
for i = 1:13
    % Construct the variable name as a string
    varName = sprintf('og_transect%d', i);
    
    % Check if the variable exists in the workspace
    if evalin('base', sprintf('exist(''%s'', ''var'')', varName))
        % Get the data from the workspace
        transectData = evalin('base', varName);
        
        % Combine the data into All_Data_Polished
        All_Data_Polished = [All_Data_Polished; transectData];
    else
        warning('Variable %s does not exist in the workspace.', varName);
    end
end
