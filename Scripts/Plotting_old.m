
format compact; format long g;
close all; clear; clc;

load DataDepth.mat;

Shore.Left = readtable('Left.csv');
Shore.SugarIsland = readtable('SugarIsland.csv');
Shore.BottomIsland = readtable('BottomIsland.csv');

SD.Left = table2array(Shore.Left);  SD.Left(:,3) = 0;
SD.SugarIsland = table2array(Shore.SugarIsland);  SD.SugarIsland(:,3) = 0;
SD.BottomIsland = table2array(Shore.BottomIsland);  SD.BottomIsland(:,3) = 0;

%% Setup

for i = 1:13
    loc{i} = find(Data{i}(:,7) <= 0.50 );
    Data{i}(loc{i},7) = 0.5;
end; clear i loc;

xbounds = [-68.6648 -68.6588];
ybounds = [45.0970 45.1040];
zbounds = [-4 0];

dt = 7;

for k = 1:13
    loc = 1;
    for i = 1:floor(height(Data{k})./dt)
        x{k}(i,:) = mean(Data{k}(loc:(i.*dt),3));
        y{k}(i,:) = mean(Data{k}(loc:(i.*dt),2));
        z{k}(i,:) = mean(Data{k}(loc:(i.*dt),7));
        loc = loc+dt;
    end; clear i loc;

end; clear k;

detail =  1000;
detZ = 4./400;

xvec = linspace(xbounds(1),xbounds(2),detail);
yvec = linspace(ybounds(1),ybounds(2),detail); 
zvec = linspace(zbounds(1),zbounds(2),400);

% Interp Test
% for k =1:13
%     xn =
% end; clear k;


[X,Y] = meshgrid(xvec,yvec);
Z = nan(detail,detail);

xloc = cell(1,13); yloc = cell(1,13);
for k = 1:13    % Transects
    for i = 1:floor(height(x{k}))

        [~ , xloc{k}(i)] = min(abs(xvec-x{k}(i)));
        [~ , yloc{k}(i)] = min(abs(yvec-y{k}(i)));

        Z(xloc{k}(i),yloc{k}(i)) = z{k}(i);
    end; clear i;
end; clear k;
clear xloc yloc;

% Left
xshore{1} = table2array(Shore.Left(:,2));
yshore{1} = table2array(Shore.Left(:,1));
% Sugar
xshore{2} = table2array(Shore.SugarIsland(:,2));
yshore{2} = table2array(Shore.SugarIsland(:,1));
% BottomIsland
xshore{3} = table2array(Shore.BottomIsland(:,2));
yshore{3} = table2array(Shore.BottomIsland(:,1));

xloc = cell(1,3); yloc = cell(1,3);
for k = 1:3
    for i = 1:height(xshore{k})
    [~ , xloc{k}(i)] = min(abs(xvec-xshore{k}(i)));
    [~ , yloc{k}(i)] = min(abs(yvec-yshore{k}(i)));
    Z(xloc{k}(i),yloc{k}(i)) = 0;
    end; clear i;
end; clear k;
clear yloc xloc;

Z_filled = fillmissing(Z,'nearest');


%% Plot

figure
for i = 1:13
plot3(Data{i}(:,3),Data{i}(:,2),'b'); hold on;
end; clear i;
plot3(SD.Left(:,2),SD.Left(:,1),SD.Left(:,3),'k'); hold on;
plot3(SD.SugarIsland(:,2),SD.SugarIsland(:,1),SD.SugarIsland(:,3),'k'); hold on;
plot3(SD.BottomIsland(:,2),SD.BottomIsland(:,1),SD.BottomIsland(:,3),'k'); hold on;

xlim([xbounds(1) xbounds(2)]);
ylim([ybounds(1) ybounds(2)]);
zlim([zbounds(1) zbounds(2)]);

figure
contourf(X(1,:),Y(:,1),-Z_filled,'edgecolor','none'); hold on;
% xlim([xbounds(1) xbounds(2)]);
% ylim([ybounds(1) ybounds(2)]);
% clim([zbounds(1) zbounds(2)]);

% Interp onto same size vectors ---- interp2?
% Then griddata or fit to make a surface? 


% GPS_1 = array2table(Data{1}(:,2:3));
% GPS_2 = array2table(Data{2}(:,2:3));
% GPS_3 = array2table(Data{3}(:,2:3));
% GPS_4 = array2table(Data{4}(:,2:3));
% GPS_5 = array2table(Data{5}(:,2:3));
% GPS_6 = array2table(Data{6}(:,2:3));
% GPS_7 = array2table(Data{7}(:,2:3));
% GPS_8 = array2table(Data{8}(:,2:3));
% GPS_9 = array2table(Data{9}(:,2:3));
% GPS_10 = array2table(Data{10}(:,2:3));
% GPS_11 = array2table(Data{11}(:,2:3));
% GPS_12 = array2table(Data{12}(:,2:3));
% GPS_13 = array2table(Data{13}(:,2:3));
% 
% writetable(GPS_1,'GPS_1');
% writetable(GPS_2,'GPS_2');
% writetable(GPS_3,'GPS_3');
% writetable(GPS_4,'GPS_4');
% writetable(GPS_5,'GPS_5');
% writetable(GPS_6,'GPS_6');
% writetable(GPS_7,'GPS_7');
% writetable(GPS_8,'GPS_8');
% writetable(GPS_9,'GPS_9');
% writetable(GPS_10,'GPS_10');
% writetable(GPS_11,'GPS_11');
% writetable(GPS_12,'GPS_12');
% writetable(GPS_13,'GPS_13');


