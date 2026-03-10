clear all % variables
clear x
close all % figures

load('coradcp'); % matrix 'bb' with Joyce-corrected flows
a1=bb; % put matrix bb onto a1

tima=a1(:,1); % ADCP time
lona=a1(:,3); % ADCP lon
lata=a1(:,2); % ADCP lat
u=a1(:,4); % ADCP surface 'u' component
v=a1(:,5); % ADCP surface 'v' component
w=a1(:,10)
de=a1(:,7); % ADCP water depth
temp=a1(:,11); % ADCP water depth


%%inputs
c=100; %#columns
xor = -68.661; % set origin for transect
yor = +45.103194; 

rep=13; % # of transect repetitions

dy=fix(a1(1,1)); % day of measurements
load transect_times.txt

hii = [.75 : .25 : 11];
dii = linspace(.0,.25,100)

hii=transpose(hii) ;
ug = zeros(length(hii),length(dii),rep) ;
wg = zeros(length(hii),length(dii),rep) ;
vg = zeros(length(hii),length(dii),rep) ;
tg = zeros(length(hii),length(dii),rep) ;
dg = zeros(1,length(dii),rep) ;
vii=reshape(v,length(v),1);
uii=reshape(u,length(u),1);
slope=regress(vii,uii);
theta=atan(slope)

day=21 %change to day of month
t1=day+transect_times(:,1)/24+transect_times(:,2)/(24*60)+transect_times(:,3)/(24*3600) %convert to fraction of day


   
for k=1:rep
    
    ii=find(tima >= t1(2*k-1) & tima <= t1(2*k)); % identify data for transect
      
    nvar1=lona(ii)
    nvar2=lata(ii)
    jj1=dsearchn(nvar1,-68.661) %change
    kk1=dsearchn(nvar2,45.103194) %change
     %calculate distance to origin and store in variable 'di1'
    xd=(lona(ii)-xor)*60.*1.852*cos(lata(1)*pi/180); 
    yd=(lata(ii)-yor)*60.*1.852 ;
    di1=sqrt(xd.^2+yd.^2);
    depth_max = de(ii);
   [distancep, idx] = unique(di1);
    depth_maxp = depth_max(idx);
    dmax = interp1(distancep, depth_maxp, dii);
            
   %SILVER TO GOLD --- principal component analysis
    ur =  u*cos(theta) + v*sin(theta);
    vr = -u*sin(theta) + v*cos(theta);
    ui = ur; 
    vi = vr;
    ui=griddata(di1,a1(ii,6),ui(ii),dii,hii) ;
    vi=griddata(di1,a1(ii,6),vi(ii),dii,hii) ;
    tt=griddata(di1,a1(ii,6),tima(ii),dii,hii) ;
    ug(:,:,k) = ui ; %across
    vg(:,:,k) = vi ; %along
    tg(:,:,k) = tt ; %time
    dg(:,:,k) = dmax; %bathy
end 

theta=rad2deg(theta)
plot(u,v,'b.')
hold on
plot(ur,vr,'r.')
xlabel('u')
ylabel('v')

save(['gold_mat.mat'],'tg','lata','lona','ug','vg','dii','hii','dg','wg'); 

dgmat=zeros(rep,100)
for i=1:rep
    dgmat(i,:)=dg(:,:,i)
end
bathymean=nanmean(dgmat)
plot(-bathymean)

save bathymean bathymean

contourf(dii,-hii,ug(:,:,1))
colorbar