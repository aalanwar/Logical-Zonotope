function [z,A] = LFSR1(A,N)
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


% cpA = A;
% for i =1:length(A)
%     A{i}=cpA{length(A)-i+1};
% end



for ii =1:N
    cpA = A;
    z{ii} = xor(A{length(A)},A{length(A)-1});
    tempA = xor(cpA{length(A)},xor(cpA{length(A)-1},xor(cpA{length(A)-2},cpA{14})));
    %if tempA.c == cpA{8}.c
    %    if (isempty(tempA.G) & isempty(cpA{8}.G) ) || (~isempty(tempA.G) & ~isempty(cpA{8}.G) )
    for i =2:length(A)
        A{i}=cpA{i-1};
    end
    A{1}=tempA;
    %    end
    % end
end



end

