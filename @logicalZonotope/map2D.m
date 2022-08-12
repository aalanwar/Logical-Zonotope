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

numXGrids=8192;
numYGrids=8192;
hX=linspace(min(decPoints)-4,max(decPoints)+4,numXGrids);%for 128 resolution
hY=linspace(min(decPoints)-4,max(decPoints)+4,numYGrids);%for 128 resolution

Ydata = floor( (decPoints)./numXGrids) +1;


[flag, index] = ismember(numYGrids+1,Ydata);
if flag
Ydata(index) = length(hY);
end


Xdata =  decPoints - numXGrids.*(Ydata -1);
location2D = [hX(Xdata) ; hY(Ydata) ];
end

