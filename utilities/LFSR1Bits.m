function [z,A] = LFSR1Bits(A,N)
%TRIVIUM Summary of this function goes here
%   Detailed explanation goes here

% index =1;
% for i=1:19
%     A{i} = K{index};
%     index = index +1;
% end
% 
% for i=1:22
%     B{i} = K{index};
%     index = index +1;
% end
% 
% for i=1:23
%     C{i} = K{index};
%     index = index +1;
% end





for ii =1:N

    z{ii} = A{length(A)};
    cpA = A;
    tempA = xor(cpA{length(A)},xor(cpA{length(A)-1},xor(cpA{length(A)-2},cpA{14})));
    %if tempA == cpA{8}
        for i =2:length(A)
            A{i}=cpA{i-1};
        end
        A{1}=tempA;

    %end





    
end



end

