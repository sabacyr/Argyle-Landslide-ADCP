clear all
clear x
addpath('C:\Users\sampa\OneDrive - University of Maine System\Saba Research\Argyle Landslide\Transects\Data Raw 09_18_2024\Process') %add filepath where data matrix from Bronze is saved.
load('rawadcp') ; %load bronze matrix

rep=14; % # of transect repetitions
load transect_times.txt %transect time file

%convert to fraction of day
day=18 %change to day of month
ti=day+transect_times(:,1)/24+transect_times(:,2)/(24*60)+transect_times(:,3)/(24*3600) %convert transec time into fraction of day

tima=a1(:,1); % ADCP time

alpha=zeros(rep,1) ; beta=alpha; % vectors to save alpha and beta values
plot(a1(:,3),a1(:,2),'.y') % plot sampling trajectories

for k=1:rep   % loop through all 'k' transect repetitions
ii=find(tima >= ti(2*k-1) & tima <= ti(2*k)); % extract data of each rep
cn=length(ii); % number of data corresponding to each transect rep
i1=find(a1(ii,6) == a1(1,6)); % select one value per profile for later calculations

lat=a1(ii(i1),2) ; lon=a1(ii(i1),3); % lat and lon (one value) of each profile
ubt=a1(ii(i1),8) ; vbt=a1(ii(i1),9); % bot track vel (one value) of each profile
tsi=tima(ii(i1)) ; % time (one value) of each profile
temp=a1(ii,11)

hold on ; plot(lon,lat) ; hold off % % plot lat & lon of each transect repetition

% joyce correction
%===================
% calculate u and v components of ship's (GPS) velocity
vsp=-(lat-circshift(lat,1))*60*1.852e5./((circshift(tsi,1)-tsi)*86400);
usp=-(lon-circshift(lon,1))*60*cos(lat(1)*pi/180)*1.852e5./((circshift(tsi,1)-tsi)*86400);

doal=mean(ubt.*usp+vbt.*vsp); % denominator for alpha
upal=mean(ubt.*vsp-vbt.*usp) ;% numerator for alpha
dobe=mean(ubt.^2+vbt.^2) ; upbe=mean(usp.^2+vsp.^2); % denominator and numerator for beta

alpha(k)=atan(upal./doal); 
beta(k)=sqrt(upbe./dobe);
%========================  
 b=zeros(cn,9); % silver matrix that will contain only useful data
 u=a1(ii,4) ; v=a1(ii,5); % redefine u and v for Joyce's correction
 a1(ii,4)=beta(k).*(u.*cos(alpha(k))-v.*sin(alpha(k))); % corrected "u"
 a1(ii,5)=beta(k).*(u.*sin(alpha(k))+v.*cos(alpha(k))); % corrected "v"

figure
plot(u,v,'k.')
hold on
plot(a1(ii,4),a1(ii,5),'r.')
xlabel('u')
ylabel('v')

 b(:,1:7)=a1(ii,1:7); % first seven columns same as bronze matrix but with corrected u & v
 b(:,8)=a1(ii,8); % 8th column corresponds to backscatter
 b(:,9)=a1(ii,9); % 9th column correspond to temperature
 b(:,10)=a1(ii,10); % 9th column correspond to temperature
b(:,11)=a1(ii,11)
 % build silver matrix "bb"
 if k == 1  
     bb = b; %  first profile
 else
     bb= [bb;b]; % concatenate subsequent profiles
 end % if   

end % k -- close loop of 'k' transect repetitions

save('coradcp','bb') % save silver matrix