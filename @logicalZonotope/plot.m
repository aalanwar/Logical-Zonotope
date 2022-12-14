function han = plot(Z,varargin)
% plot - Plots 2-dimensional projection of a zonotope
%
% Syntax:  
%    h = plot(Z) plots the zonotope Z for the first two dimensions
%    h = plot(Z,dims) plots the zonotope Z for the two dimensions i,j:
%        "dims=[i,j]" and returns handle to line-plot object
%    h = plot(Z,dims,'Color','red',...) adds the standard plotting preferences
%
% Inputs:
%    Z - zonotope object
%    dims - (optional) dimensions that should be projected
%    type - (optional) plot settings (LineSpec and name-value pairs)
%
% Outputs:
%    han - handle of graphics object
%
% Example: 
%    Z=zonotope([1 1 0; 0 0 1]);
%    plot(Z)
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: polygon

% Author:       Matthias Althoff
% Written:      27-July-2016
% Last update:  14-July-2020 (merge with plotFilled)
% Last revision:---

%------------- BEGIN CODE --------------

% default values
dims = [1,2];
linespec = 'b*';
filled = false;
height = [];
NVpairs = {};
cont =0;

%If two arguments are passed    
if nargin==2
    dims=varargin{1};
    
%If three or more arguments are passed
elseif nargin>=3
    dims = varargin{1};
    % parse plot options
    [linespec,NVpairs] = readPlotOptions(varargin(2:end));
    [NVpairs,filled] = readNameValuePair(NVpairs,'Filled','islogical');
    [NVpairs,cont] = readNameValuePair(NVpairs,'Cont','islogical');
    [NVpairs,height] = readNameValuePair(NVpairs,'Height','isscalar');
end

% project zonotope
Z = project(Z,dims);

% convert zonotope to polygon
p = evaluate(Z);

%plot and output the handle
if filled
    if isempty(height) % no 3D plot
        han = fill(p(1,:),p(2,:),linespec,NVpairs{:});
    else
        zCoordinates = height*ones(length(p(1,:)),1); 
        han = fill3(p(1,:),p(2,:),zCoordinates,linespec,NVpairs{:}); 
    end
elseif cont  
    poly=mptPolytope.enclosePoints(p);
    plot(poly,dims,linespec);
else   
    if isempty(height) % no 3D plot
        han = plot(p(1,:),p(2,:),linespec,NVpairs{:});
    else
        zCoordinates = height*ones(length(p(1,:)),1); 
        han = plot3(p(1,:),p(2,:),zCoordinates,linespec,NVpairs{:}); 
    end
    
end

 

%------------- END OF CODE --------------