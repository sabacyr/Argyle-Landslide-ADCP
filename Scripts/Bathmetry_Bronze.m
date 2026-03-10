clear all
close all
clc

names = {'Station_0_000_24-09-18_ASC.TXT';'Station_0_001_24-09-18_ASC.TXT';'Station_0_002_24-09-18_ASC.TXT';...
    'Station_0_003_24-09-18_ASC.TXT';'Station_0_004_24-09-18_ASC.TXT';'Station_0_005_24-09-18_ASC.TXT';...
    'Station_0_006_24-09-18_ASC.TXT'; 'Station_0_007_24-09-18_ASC.TXT';'Station_0_009_24-09-18_ASC.TXT';...
    'Station_0_010_24-09-18_ASC.TXT';'Station_0_011_24-09-18_ASC.TXT';'Station_0_012_24-09-18_ASC.TXT'...
    ;'Station_0_013_24-09-18_ASC.TXT'};

addpath ('C:\Users\nickc\Desktop\Greenbush\Station_0')




for j = 1:13

    filn={names{j}}; %these are the names of your ASCII files
    nf=length(filn);
    k=1;  % this is a counter

for i=1:nf
    
fid=fopen(char(filn(i))); % file identifier to get # of fields in file

pos=fseek(fid,0,'eof');% repositions the file position at the end of file
poseof=ftell(fid);%get the # of fields at the end of file
pos=fseek(fid,0,'bof'); % go back to beginning of file to start reading

%read header of each profile
%first line of file; only read at beginning of each file
c=textscan(fid,'%f',7); % read 7 fields

while ftell(fid) < poseof % cycle line by line through entire file

% first line of header
yr=textscan(fid,'%f',1);
mo=textscan(fid,'%f',1);
dy=textscan(fid,'%f',1);
hr=textscan(fid,'%f',1);
mn=textscan(fid,'%f',1);
sc=textscan(fid,'%f',1);
hd=textscan(fid,'%f',1);
c1=textscan(fid,'%f',5);
tem=textscan(fid,'%f',1); tem=tem{1};
tim=dy{1}+hr{1}/24+mn{1}/1440+sc{1}/86400;

%second line of header
btu=textscan(fid,'%f',1); btu=btu{1};
btv=textscan(fid,'%f',1); btv=btv{1};
c1=textscan(fid,'%f',6);
d1=textscan(fid,'%f',1);
d2=textscan(fid,'%f',1);
d3=textscan(fid,'%f',1);
d4=textscan(fid,'%f',1);

%third line of header
c1=textscan(fid,'%f',5);

%fourth line of header
lat=textscan(fid,'%f',1); lat=lat{1};
lon=textscan(fid,'%f',1); lon=lon{1};
c1=textscan(fid,'%f',3);

%fifth line of header
c1=textscan(fid,'%f',9);

%sixth line of header
nr=textscan(fid,'%f',1);nr=nr{1};
c2=textscan(fid,'%s',5);

dep=(d1{1}+d2{1}+d3{1}+d4{1})/4;

% matrix of data
d=textscan(fid,'%f %f %f %f %f %f %f %f %f %f %f %f %f',nr);
% % find indices to depurate
% indx=find(abs(d{1,7}) < 100 & d{1,12} > 0 & abs(d{1,13}) < 100); %this removed suspect data


n=length(d{1});

% rearrange data that we need
u=d{1,4} ; v=d{1,5} ; bin=d{1,1} ; bsc=(d{1,8}+d{1,9}+d{1,10}+d{1,11})/4;
w=d{1,6}; 
nc=11; % # of columns of final matrix
a=zeros(n,nc); % matrix with data to be used
a(:,1)=tim; 
a(:,2)=lat ; 
a(:,3)=lon ;
a(:,4)=NaN ;
a(:,5)=NaN;
a(:,6)=NaN ;
a(:,7)=dep ; 
a(:,8)=btu; 
a(:,9)=btv; 
a(:,10)=NaN;
a(:,11)=tem;

if k ==1 
    a1=a;
else
    a1=[a1 ; a];
end  % if

k=k+1;
end  % while

fclose(fid)
end % for
a1=a1(:,:); % reassign matrix
Data{j} = a1; clear a1;
end; clear j;




save DataDepth Data -v7.3;

