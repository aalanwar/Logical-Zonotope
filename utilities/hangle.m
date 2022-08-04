function h = hangle(x,u)

% y = r cos theta
% x = r sin theta
% So 
%| acos( x(2)/r) - pi | < pi/12
% r= sqrt(x(1)^2 + x(2)^2) ;
%h = acos( x(2)/r) - pi ;
% r = sqrt((x(1)-100.14)^2+(x(2)-100.7)^2);
% h = (x(2)-100.7)/r- 0.9829;
 r= sqrt(x(1)^2 + x(2)^2) ;
sinn = x(1) /r;
coss = x(2)/r;
tann = sinn/sqrt(1-sinn^2);
end

