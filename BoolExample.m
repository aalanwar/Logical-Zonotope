

clear all

rng(100);
steps = 3;
dim =20;
numOfVar = 3;
numOfVarU = 3;
numOfPoints = 10;
for i=1:numOfVar
    Apt{i} = randi([0 1],dim,numOfPoints);
    A{i} = reduce(logicalZonotope.enclosePoints(Apt{i}));
end

for i=1:numOfVarU
    pointsU{i} = randi([0 1],dim,numOfPoints);
    U{i} = reduce(logicalZonotope.enclosePoints(pointsU{i}));
end
x=1;
tic
for i =1:steps
    [A] = boolFun(A,U);
end
execlogicZono = toc

% %%----------- BDD ---------%%
% 
% A={};
% A1points{1}=Apt{1};
% A2points{1}=Apt{2};
% A3points{1}=Apt{3};
% 
% tic
% for s = 1:steps
%     A1points{s+1} = [];
%     A2points{s+1} = [];
%     A3points{s+1} = [];
%     for iVP1=1%:length(A1points{s}(1,:))
%         for iVP2=1%:length(A2points{s}(1,:))
%             for iCF1=1%:length(A3points{s}(1,:))
%                 for j=1%:length(pointsU{1}(1,:))
%                     for j2 = 1%:length(pointsU{2}(1,:))
%                         for j3=1%:length(pointsU{3}(1,:))
% 
%                             
%                             U{1}=pointsU{1}(:,j);
%                             U{2}=pointsU{2}(:,j2);
%                             U{3}=pointsU{3}(:,j3);
% 
%                             A{1}=A1points{s}(:,iVP1);
%                             A{2}=A2points{s}(:,iVP2);
%                             A{3}=A3points{s}(:,iCF1);
% 
% 
%                             [A] = boolFun(A,U);
%                             A1points{s+1} = [ A1points{s+1} A{1}];
%                             A2points{s+1} = [ A2points{s+1} A{2}];
%                             A3points{s+1} = [ A3points{s+1} A{3}];
% 
% 
%                         end
%                     end
%                 end
%             end
%         end
%     end
%     A1points{s+1} = unique(A1points{s+1}','rows')';
%     A2points{s+1} = unique(A2points{s+1}','rows')';
%     A3points{s+1} = unique(A3points{s+1}','rows')';
% end
% execBDD = toc

