function [result] = mtimesAndOr(M,G)
%MTIMESANDOR Summary of this function goes here
%   Detailed explanation goes here

[mrows,mcols]=size(M);
[grows,gcols]=size(G);

for j=1:gcols
    for k =1:mrows
        temp = 0;
        for ii =1:grows
            %temp=temp + matrix(k,ii) * Z.G{i}(ii,1) ;
            temp=or(temp,(M(k,ii) & G(ii,j) ));
        end
        result(k,j) = temp;
    end
end
end

