function updatePlotZono(varargin)

%If only two  argument is passed
if nargin==2
    h = varargin{1};
    CZ=varargin{2};
    dims=[1,2];
    type{1}='b';
    
%If three arguments are passed    
elseif nargin==3
    h = varargin{1};
    CZ=varargin{2};
    dims=varargin{3};
    type{1}='b';
    
%If four or more arguments are passed
elseif nargin>=4
    h = varargin{1};
    CZ=varargin{2};
    dims=varargin{3};   
    type(1:length(varargin)-3)=varargin(4:end);
end

% % project zonotope
% Z = project(Z,dims);
% 
% % delete zero generators
% p = polygon(Z);
newh= plot(CZ,[1 2],'r','Template',256);
p1=get(newh,'XData');
p2=get(newh,'YData');
%plot and output the handle
set(h,'XData', p1, 'YData',p2);

%------------- END OF CODE --------------