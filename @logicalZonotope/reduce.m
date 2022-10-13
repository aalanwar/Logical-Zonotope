function Zred = reduce(Z,varargin)
% reduce - Reduces the order of a zonotope
%
% Syntax:
%    Zred = reduce(Z,option,order)
%
% Inputs:
%    Z - zonotope object
%    option - string specifying the reduction method. The available options
%             are:
%                   - 'cluster'         Sec. III.B in [3]
%                   - 'combastel'       Sec. 3.2 in [4]
%                   - 'constOpt'        Sec. III.D in [3]
%                   - 'girard'          Sec. 4 in [2]
%                   - 'methA'           Sec. 2.5.5 in [1]
%                   - 'methB'           Sec. 2.5.5 in [1]
%                   - 'methC'           Sec. 2.5.5 in [1]
%                   - 'pca'             Sec. III.A in [3]
%                   - 'scott'           Appendix of [5]
%                   - 'redistribute'
%    order - order of reduced zonotope
%
% Outputs:
%    Zred - reduced zonotope
%
% Example:
%    Z=zonotope(rand(2,10));
%    plot(Z,[1,2],'g');
%    hold on
%    Zred=reduce(Z,'girard',2);
%    plot(Zred,[1,2],'r');
%    Zred=reduce(Z,'combastel',2);
%    plot(Zred,[1,2],'b');
%
%
% See also: none

% Author:        Matthias Althoff
% Written:       24-January-2007
% Last update:   15-September-2007
%                27-June-2018
% Last revision: ---

%------------- BEGIN CODE --------------

%2 inputs

cen = Z.c;
gen = Z.G;

if ~isempty(gen)
    points = evaluate(Z);
    removeGen =[];
    index=1;
    genMat = unique(cell2mat(gen)','rows')';
    gen= mat2cell(genMat,length(cen),ones(1,length(genMat(1,:))));
    for i = 1:length(gen)
        if gen{index} == cell2mat(gen)
            break;
        end
        genMat=cell2mat(gen);
        newgen = mat2cell(setdiff(genMat', gen{index}','rows')',length(cen),ones(1,length(gen(1,:))-1));
        newZ = logicalZonotope(cen,newgen);
        newPoints = evaluate(newZ);
        if ismember(points',newPoints','rows')
            removeGen =[removeGen i];
            gen = newgen;
        else
            index= index +1;
        end
    end
    Zred = logicalZonotope(cen,gen);
else
    Zred = logicalZonotope(cen,{});
end



% [location2D , hX,hY,numXGrids]= map2D(Z);
% zCont= zonotope.enclosePoints(location2D,'stursberg');
% %zCont = reduce(zCont,'girard',3);
% vert = vertices(zCont);
% vert = unique(vert','rows')';
% binaryVector = getGridIndex(vert);
% 
% Zred = logicalZonotope.enclosePoints(binaryVector);
% 
% 
% 
% function binaryVector = getGridIndex(locPoints)
% 
% 
% locPoints = locPoints-1;
% [~,~,binxR]=histcounts(locPoints(1,:),hX);
% [~,~,binyR]=histcounts(locPoints(2,:),hY);
% 
% point = (binyR+1)*numXGrids + binxR+1;
% 
% % convert to binary
% 
% pointB = dec2bin(point);
% 
% 
% [rows,cols]=size(pointB);
% for i =1:rows
%     row=[];
%     for j =1:cols
%         if j==cols
%             row=[ row, pointB(i,j)];
%         else
%             row=[ row, pointB(i,j), ' '];
%         end
%     end
%     newpointB(i,:) = row;
% end
% binaryVector=str2num(newpointB)';
% 
% end
end
%------------- END OF CODE --------------