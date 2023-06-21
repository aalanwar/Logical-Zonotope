function [Zred] = rmZeroGens(Z)
%RMZEROGENS Summary of this function goes here
%   Detailed explanation goes here

zeroVec = zeros(size(Z.c));
newG = {};
index=1;
for i=1:length(Z.G)
    if  ~isequal(Z.G{i},zeroVec)  
        newG{index}= Z.G{i};
        index = index +1;
    end
end


Zred = logicalZonotope(Z.c,newG);