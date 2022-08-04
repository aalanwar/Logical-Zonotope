function [intMatOut] = logIntMatrix(varargin)
%INVMATRIX Summary of this function goes here
%   Detailed explanation goes here
% eAmI = expm(intMatIn + -1* eye(6));
% intMatOut = exp(-1)*(eAmI  + -1*eye(6));
%intMatOut = (eAmI + -1* (intMatIn + -1*eye(6)));

maxOrder =1;
initialOrder = 0;
intMat  = varargin{1};
maxabs = varargin{2};
initialPower =eye(4);% intervalMatrix(eye(6),zeros(6)); %intMat^0;


%compute powers
iPow=powers(intMat,maxOrder);
% 
% if nargin==2
%     intMat = varargin{1};
%     maxOrder = varargin{2};
%     initialOrder = 0;
%     initialPower = intMat^0;
%     
%     %compute powers
%     iPow=powers(intMat,maxOrder);
% elseif nargin==4
%     intMat = varargin{1};
%     maxOrder = varargin{2};
%     initialOrder = varargin{3};
%     initialPower = varargin{4};
%     
%     %compute powers
%     iPow=powers(intMat,maxOrder,initialOrder,initialPower);
% end

%compute finite Taylor series
%initialize matrix zonotope
eI=0;%initialPower*(1/factorial(initialOrder));
    
%compute Taylor series
for i=(initialOrder+2):maxOrder
    eI = eI + iPow{i}*(1/factorial(i));
end

%compute exponential remainder
E = logRemainder(intMat,maxOrder,maxabs);

%final result
%eI = eI+E;

intMatOut = intMat + -1*initialPower +-1*E ;%+ -1*eI ;
%intMatOut = intMat + -1*E ;
end

