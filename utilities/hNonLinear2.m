function h = hNonLinear2(x,u)

   % h(1,1)= log(exp(-x(1))+exp(-x(2)));
 % h(1,1)= -log(exp(-x(1)));
  %  h(1,1)= log(x(1));
   %h(1,1)= x(1)^2;
   
 %  h(1)=(x(1)+1).^2 + (x(2)-3).^2 - 3;
 a =0.5;%70/2;
 eita= 1;
   h= -(sqrt(x(1)-0.2825))^2;
% 
% % h4= (sqrt(x(2)-0.7815))^2 - 0.5555;
% h5=  1.7175- (sqrt(x(1)-0.2805))^2 ;
% h6 = 1.504 - (sqrt(x(2)-0.839))^2;
% h7 = 1.3045 - (sqrt(x(1)+0.3225))^2;
% h8=1.453 -  (sqrt(x(2)+1.137))^2;

 % h = 1/eita * log(exp(-eita*h3)+exp(-eita*h4));
 
%  h = 1/eita * log(exp(-eita*h3)+exp(-eita*h4)+exp(-eita*h5)+exp(-eita*h6)...
 %               +exp(-eita*h7)+exp(-eita*h8));
%   h = 1/eita * log(exp(-eita*h5)+exp(-eita*h6)...
%                +exp(-eita*h7)+exp(-eita*h8));
end

%------------- END OF CODE --------------