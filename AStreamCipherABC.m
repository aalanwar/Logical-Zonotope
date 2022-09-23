function [z,A,B,C] = AStreamCipherABC(A,B,C,N)
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
cpA = A;
for i =1:19
    A{i}=cpA{19-i+1};
end

cpB = B;
for i =1:22
    B{i}=cpB{22-i+1};
end

cpC = C;
for i =1:23
    C{i}=cpC{23-i+1};
end


for ii =1:N

%     Max0 = 0;
%     Max1 = 0;
%     if(A{9}.containsPoint(1))
%         Max1 = Max1 + 1;
%     else
%         MAx0 = Max0 + 1;
%     end
%     if(B{11}.containsPoint(1))
%         Max1 = Max1 + 1;
%     else
%         Max0 = Max0 + 1;
%     end
%     if(C{11}.containsPoint(1))
%         Max1 = Max1 + 1;
%     else
%         Max0 = Max0 + 1;
%     end
% 
%     if(Max1 > Max0)
%         CK = 1;
%     else
%         CK = 0;
%     end


    z{ii} = xor(A{19},xor(B{22},C{23}));
    cpA = A;
    tempA = xor(cpA{19},xor(cpA{18},xor(cpA{17},cpA{14})));
    %if cpA{9}.containsPoint(CK)
        % if (isempty(tempA.G) & isempty(cpA{8}.G) ) || (~isempty(tempA.G) & ~isempty(cpA{8}.G) )
        for i =2:19
            A{i}=cpA{i-1};
        end
        A{1}=tempA;
        %end
    %end


    cpB = B;
    tempB = xor(cpB{21},cpB{22});
    %if cpB{11}.containsPoint(CK)
    %    if (isempty(tempB.G) & isempty(cpB{10}.G) ) || (~isempty(tempB.G) & ~isempty(cpB{10}.G) )
    for i =2:22
        B{i}=cpB{i-1};
    end
    B{1}=tempB;
    %   end
   % end

    cpC =C;
    tempC = xor(cpC{23},xor(cpC{22},xor(cpC{21},cpC{7})));
    %if cpC{10}.containsPoint(CK)
    %    if (isempty(tempC.G) & isempty(cpC{10}.G) ) || (~isempty(tempC.G) & ~isempty(cpC{10}.G) )
    for i =2:23
        C{i}=cpC{i-1};
    end
    C{1}=tempC;
    %   end
   % end

end



end

