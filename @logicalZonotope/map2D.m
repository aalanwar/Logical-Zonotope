function [location2D , hX,hY,numXGrids]= map2D(Z)
%MAP2D Summary of this function goes here
%   Detailed explanation goes here
dim = length(Z.c);

binaryPoints=evaluate(Z);
[rows,cols]=size(binaryPoints);
decPoints=[];
for i =1:cols
    strPoint= num2str( binaryPoints(:,i) );
    temp='';
    for j =1:length(strPoint)
        temp = strcat(temp,strPoint(j));
    end
    d=bin2dec( temp );
    decPoints = [decPoints,d];
end

%adding one to avoid zeros
decPoints = decPoints +1;

ndigit= length(binaryPoints(:,1));
if ndigit <5
numXGrids=ndigit;
numYGrids=ndigit;
else
numXGrids=127;
numYGrids=127;
end

hX=linspace(1,max(decPoints)/2,numXGrids);%for 128 resolution
hY=linspace(1,max(decPoints)/2,numYGrids);%for 128 resolution


for i=1:length(decPoints)
    if(rem(decPoints(i),numXGrids)==0)
        Ydata(i) = decPoints(i)/numXGrids;
    else
        Ydata(i) = floor( decPoints(i)/numXGrids) +1;
    end
end

% [flag, index] = ismember(numYGrids+1,Ydata);
% if flag
% Ydata(index) = length(hY);
% end


Xdata =  decPoints - numXGrids.*(Ydata -1);
location2D = [hX(Xdata) ; hY(Ydata) ];
end
