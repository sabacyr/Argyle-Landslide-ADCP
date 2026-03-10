clear all; close all; clc;

addpath("MAT Data Files\");
addpath("Scripts\");

load("Bounds.mat")
load("Polished_Data.mat")
load("Transect_Data.mat")
load("Distance_Depth.mat")
%%

lat = transect1(:, 2);
lon = transect1(:, 3);
depth = transect1(:, 7);
time = transect1(:, 1);

bot = [lat(1), lon(1)]; % beginning of the transect location

dis = zeros(1, length(lat));

for i = 1:length(dis)
    dis(i) = 6371 * 2 * asin(sqrt(sin(deg2rad((lat(i)-bot(1))./2)).^2 + cos(deg2rad(bot(1))) .* cos(deg2rad(lat(i))) .* sin(deg2rad((lon(i)-bot(2))./2)).^2));
end

distance = dis'.*1000;

depth_smooth = smoothdata(depth);

figure(2)
plot(t12_distance, -t12_depth_smooth, 'LineWidth', 1.5, 'Color', 'k')
xlabel('Distance, m', 'FontSize', 12, 'FontName', 'Times New Roman');
ylabel('Depth, m', 'FontSize', 12, 'FontName', 'Times New Roman');
ylim([-4 0])
xlim([0 600])
ax = gca; 
ax.FontName = 'Times New Roman'; 
ax.FontSize = 12; 
title('Transect 10', 'FontSize', 14, 'FontName', 'Times New Roman')
grid minor

%%
figure(2)
subplot(211)
plot(t10_distance, -t10_depth_smooth, 'LineWidth', 1.5, 'Color', 'k')
xlabel('Distance, m', 'FontSize', 12, 'FontName', 'Times New Roman');
ylabel('Depth, m', 'FontSize', 12, 'FontName', 'Times New Roman');
ylim([-4 0])
xlim([0 300])
ax = gca; 
ax.FontName = 'Times New Roman'; 
ax.FontSize = 12; 
grid minor
title('Transect 10', 'FontSize', 14, 'FontName', 'Times New Roman')

subplot(212)
plot(t12_distance, -t12_depth_smooth, 'LineWidth', 1.5, 'Color', 'k')
xlabel('Distance, m', 'FontSize', 12, 'FontName', 'Times New Roman');
ylabel('Depth, m', 'FontSize', 12, 'FontName', 'Times New Roman');
ylim([-4 0])
xlim([0 300])
ax = gca; 
ax.FontName = 'Times New Roman'; 
ax.FontSize = 12; 
grid minor
title('Transect 12', 'FontSize', 14, 'FontName', 'Times New Roman')



