function Zred = reduce(Z)
% reduce - Reduces the number of generators of a logical zonotope
%
% Syntax:
%    Zred = reduce(Z)
%
% Inputs:
%    Z - zonotope object
%
% Outputs:
%    Zred - reduced zonotope
%
% Example:
%
%
% See also: none

% Author:        Amr Alanwar
% Written:       16-October-2022
% Last update:   16-October-2022
%                
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

end
%------------- END OF CODE --------------
