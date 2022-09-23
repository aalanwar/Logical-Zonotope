function [z,A,B,C] = AStreamCipher(K,N)
%TRIVIUM Summary of this function goes here
%   Detailed explanation goes here

index =1;
for i=1:19
    A{i} = K{index};
    index = index +1;
end

for i=1:22
    B{i} = K{index};
    index = index +1;
end

for i=1:23
    C{i} = K{index};
    index = index +1;
end





for ii =1:N

    
    cpA = A;
    for i =2:19
        A{i}=cpA{i-1};
    end
    A{1}=xor(cpA{19},xor(cpA{18},xor(cpA{17},cpA{14})));
    cpB = B;
    for i =2:22
        B{i}=cpB{i-1};
    end
    B{1}=xor(cpB{21},cpB{22});

    cpC =C;
    for i =2:23
        C{i}=cpC{i-1};
    end
    C{1}=xor(cpC{23},xor(cpC{22},xor(cpC{21},cpC{7})));
    z{ii} = xor(A{19},xor(B{22},C{23}));
end



end

