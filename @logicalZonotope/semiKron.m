function [C] = semiKron(A,ZB)
%SEMIKRON Summary of this function goes here
%   Detailed explanation goes here

if isa(A,'logicalZonotope')

    %     res{1} =semiKron(A.c,ZB);
    %     index=2;
    %     for i =1:length(A.G)
    %         res{index} =semiKron(A.G{i},ZB);
    %         index=index+1;
    %     end
    %     C= logicalZonotope.encloseMany(res);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [m ,n]=size(A.c);

    [p ,q]=size(ZB.c);

    alpha = lcm(n,p);
    
    newCen = (kron(A.c,eye(alpha/n)) * kron(ZB.c,eye(alpha/p)) );%>1;
    %newCen = mtimesAndOr(kron(A.c,eye(alpha/n)) , kron(ZB.c,eye(alpha/p)));
    %newCen = mod(kron(A.c,eye(alpha/n)) * kron(ZB.c,eye(alpha/p)),2);
    index =1;
    newGen ={};
    for i =1:length(ZB.G)
        
        newGen{index} = (kron(A.c,eye(alpha/n)) * kron(ZB.G{i},eye(alpha/p)) );%>1;
       %newGen{index} = mtimesAndOr(kron(A.c,eye(alpha/n)) , kron(ZB.G{i},eye(alpha/p)));
        %newGen{index} = mod(kron(A.c,eye(alpha/n)) * kron(ZB.G{i},eye(alpha/p)),2);
        index=index+1;
    end
    for i =1:length(A.G)
        newGen{index} = (kron(A.G{i},eye(alpha/n)) * kron(ZB.c,eye(alpha/p)) );%>1;
        %newGen{index} = mtimesAndOr(kron(A.G{i},eye(alpha/n)) , kron(ZB.c,eye(alpha/p)));
        %newGen{index} = mod(kron(A.G{i},eye(alpha/n)) * kron(ZB.c,eye(alpha/p)),2);
        index=index+1;
    end

    for i =1:length(A.G)
        for j=1:length(ZB.G)
            newGen{index} = (kron(A.G{i},eye(alpha/n)) * kron(ZB.G{j},eye(alpha/p)));%>1;
            %newGen{index} = mtimesAndOr(kron(A.G{i},eye(alpha/n)) , kron(ZB.G{j},eye(alpha/p)));
            %newGen{index} = mod(kron(A.G{i},eye(alpha/n)) * kron(ZB.G{j},eye(alpha/p)),2);
            index=index+1;
        end
    end
    C = logicalZonotope(newCen,newGen);
    %C = unique(C);
else
    %     [m ,n]=size(A);
    %
    %     [p ,q]=size(ZB.c);
    %
    %     alpha = lcm(n,p);
    %     %C = kron(eye(alpha/n),A) * tensorMultiplication(eye(alpha/p),ZB);
    %     C = kron(A,eye(alpha/n)) * tensorMultiplication(ZB,eye(alpha/p));
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [m ,n]=size(A);

    [p ,q]=size(ZB.c);

    alpha = lcm(n,p);
    %C = kron(eye(alpha/n),A) * tensorMultiplication(eye(alpha/p),ZB);


    Ccen = (kron(A,eye(alpha/n)) * kron(ZB.c,eye(alpha/p)) );%>1;
    %Ccen = mtimesAndOr(kron(A,eye(alpha/n)) , kron(ZB.c,eye(alpha/p)));
    %Ccen = mod(kron(A,eye(alpha/n)) * kron(ZB.c,eye(alpha/p)),2);

    for i =1:length(ZB.G)
        Cgen{i} = (kron(A,eye(alpha/n)) * kron(ZB.G{i},eye(alpha/p)) );%>1;
        %Cgen{i} = mtimesAndOr(kron(A,eye(alpha/n)) , kron(ZB.G{i},eye(alpha/p)));
        %Cgen{i} = mod(kron(A,eye(alpha/n)) * kron(ZB.G{i},eye(alpha/p)),2);
        
    end
    C = logicalZonotope(Ccen,Cgen);
    %C = unique(C);
end


end

