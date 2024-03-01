function [Zred] = rmZeroGens(Z)
%RMZEROGENS Summary of this function goes here
%   Detailed explanation goes here

zeroVec = logical(zeros(size(Z.c)));


newG = {};
newE = [];
index=1;
for i=1:length(Z.G)
    if ~isequal(Z.G{i},zeroVec) 
        newG{index}= Z.G{i};
        newE(:,index)=Z.E(:,i);
        index = index +1;
    end
end

newE2 = [];
zeroRow = zeros(1,size(newE,2));
index = 1;
for i=1:size(newE,1)
    if  ~isequal(newE(i,:),zeroRow)
        newE2(index,:)=newE(i,:);
        index = index +1;
    end
end


Zred = logicalPolyZonotope(Z.c,newG,newE,Z.id);