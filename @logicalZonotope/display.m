function display(Z)
% display - Displays the center and generators of a zonotope
%
% Syntax:  
%    display(Z)
%
% Inputs:
%    Z - zonotope object
%
% Outputs:
%    (to console)
%
% Example: 
%    Z=zonotope(rand(2,6));
%    display(Z);
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: none

% Author:       Matthias Althoff
% Written:      8-Sept-2022
% Last update:  
%               
%               
%           
% Last revision:---

%------------- BEGIN CODE --------------

if isempty(Z.G)
    
    dispEmptyObj(Z,inputname(1));
    
else
    
    fprintf(newline);
    disp(inputname(1) + " =");
    fprintf(newline);
    
%     %display id, dimension
%     display(Z.Z);
%     fprintf(newline);
    
    %display center
    disp('c: ');
    disp(center(Z));

    %display generators
    disp('G: ');
%     G = generators(Z);
%     maxGens = 10;
    for i = 1:length(Z.G)
        disp(Z.G{i});
    end
    %displayGenerators(G,maxGens,'G');
    
end

%------------- END OF CODE --------------