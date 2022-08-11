function Z = mtimes(factor1,factor2)
% mtimes - Overloaded '*' operator for the multiplication of a matrix or an
% interval matrix with a zonotope
%
% Syntax:
%    Z = mtimes(matrix,Z)
%
% Inputs:
%    matrix - numerical or interval matrix
%    Z - zonotope object
%
% Outputs:
%    Z - Zonotpe after multiplication of a matrix with a zonotope
%
% Example:
%    Z=zonotope([1 1 0; 0 0 1]);
%    matrix=[0 1; 1 0];
%    plot(Z);
%    hold on
%    Z=matrix*Z;
%    plot(Z);
%
% References:
%    [1] M. Althoff. "Reachability analysis and its application to the
%        safety assessment of autonomous cars", Dissertation, TUM 2010
%    [2] M. Althoff et al. "Modeling, Design, and Simulation of Systems
%        with Uncertainties". 2011
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: plus

% Author:       Matthias Althoff
% Written:      30-September-2006
% Last update:  07-September-2007
%               05-January-2009
%               06-August-2010
%               01-February-2011
%               08-February-2011
%               18-November-2015
% Last revision:---

%------------- BEGIN CODE --------------

%Find a zonotope object
%Is factor1 a zonotope?
if isa(factor1,'logicalZonotope')
    %initialize resulting zonotope
    Z=factor1;
    %initialize other summand
    matrix=factor2;
    %Is factor2 a zonotope?
elseif isa(factor2,'logicalZonotope')
    %initialize resulting zonotope
    Z=factor2;
    %initialize other summand
    matrix=factor1;
end

%numeric matrix
%if isnumeric(matrix)


[mrows,mcols]=size(matrix);


for k =1:mrows
    temp =0;
    for ii =1:mcols
        temp=temp| (matrix(k,ii) & Z.c(ii) );
    end
    result.c(k,1) = temp;
end
%result.c=matrix * Z.c;

if ~isempty(Z.G)
    for i =1:length(Z.G)

        [mrows,mcols]=size(matrix);
        [grows,gcols]=size(Z.G);

        for j=1:gcols
            
            for k =1:mrows
                temp = 0;
                for ii =1:grows
                    temp=temp| (matrix(k,ii) & Z.G{i}(ii,j) );
                end
                result.G{i}(k,j) = temp;
            end

        end
    end
  
 Z = logicalZonotope(result.c,result.G);
else
   Z = logicalZonotope(result.c,{}); 
end
 
end

%



%------------- END OF CODE --------------