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
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: none

% Author:       Amr Alanwar
% Written:      16-October-2022
% Last update:  
%               
%               
%           
% Last revision:---

%------------- BEGIN CODE --------------



fprintf(newline);
disp(inputname(1) + " =");
fprintf(newline);


%display center
disp('c: ');
disp(center(Z));



disp('G: ');
if ~isempty(Z.G)
    for i = 1:length(Z.G)
        disp(Z.G{i});
    end
end
    


disp('E: ');
if ~isempty(Z.G)
disp(Z.E);
end

disp('id: ');
if ~isempty(Z.id)
disp(Z.id);
end

disp('A: ');
if ~isempty(Z.A)
disp(Z.A);
end

disp('b: ');
if ~isempty(Z.b)
disp(Z.b);
end

disp('EC: ');
if ~isempty(Z.EC)
disp(Z.EC);
end
%------------- END OF CODE --------------