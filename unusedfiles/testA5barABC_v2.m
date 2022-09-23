
clear all
close all
rng(120)

for i =1:19
    A{i} = randi([0 1]);
end
for i =1:22
    B{i} = randi([0 1]);
end
for i =1:23
    C{i} = randi([0 1]);
end
numOfmessages =121;
[z,~,~,~]  =AStreamCipherABCBits(A,B,C,numOfmessages);
for i =1:numOfmessages
    m{i} = randi([0 1]);
    c{i}= xor(z{i},m{i});
end




% for i =1:63
%     testK{i} = logicalZonotope.enclosePoints([0 1]);
% end
% testK{64} = logicalZonotope.enclosePoints([0]);
% 
% [testz,A,B,C]  =AStreamCipher(testK,10);
% 
% for i =1:10
%     m{i} = randi([0 1]);
%     testc{i}= xor(testz{i},logicalZonotope.enclosePoints(m{i}))
% end
% 
% for i =1:10
%     if ~testc{i}.containsPoint(c{i})
%         flag =1;
%     end
% end

index=1;
flag{index}=0;
index=index+1;
ABCcomb = truth_table(15);
%for kk=1:63
kk=1;
    for i =1:19
        Atest{i} = logicalZonotope.enclosePoints([0 1]);    
    end
    for i =1:22
        Btest{i} = logicalZonotope.enclosePoints([0 1]);
    end
    for i =1:23
        Ctest{i} = logicalZonotope.enclosePoints([0 1]);
    end


    for j =1:length(ABCcomb(:,1))

        Atest{19}=logicalZonotope.enclosePoints(ABCcomb(j,1));
        A19 = Atest{19};
        Btest{22}=logicalZonotope.enclosePoints(ABCcomb(j,2));
        B22 = Btest{22};
        Ctest{23}=logicalZonotope.enclosePoints(ABCcomb(j,3));
        C23 = Ctest{23};
    
        Atest{18}=logicalZonotope.enclosePoints(ABCcomb(j,4));
        A18 = Atest{18};
        Btest{21}=logicalZonotope.enclosePoints(ABCcomb(j,5));
        B21 = Btest{21};
        Ctest{22}=logicalZonotope.enclosePoints(ABCcomb(j,6));
        C22 = Ctest{22};

        Atest{17}=logicalZonotope.enclosePoints(ABCcomb(j,7));
        A17 = Atest{17};
        Btest{20}=logicalZonotope.enclosePoints(ABCcomb(j,8));
        B20 = Btest{20};
        Ctest{21}=logicalZonotope.enclosePoints(ABCcomb(j,9));
        C21 = Ctest{21};

        Atest{16}=logicalZonotope.enclosePoints(ABCcomb(j,10));
        %A17 = Atest{17};
        Btest{19}=logicalZonotope.enclosePoints(ABCcomb(j,11));
        %B20 = Btest{20};
        Ctest{20}=logicalZonotope.enclosePoints(ABCcomb(j,12));
        %C21 = Ctest{21};

        Atest{15}=logicalZonotope.enclosePoints(ABCcomb(j,13));
        %A17 = Atest{17};
        Btest{18}=logicalZonotope.enclosePoints(ABCcomb(j,14));
        %B20 = Btest{20};
        Ctest{19}=logicalZonotope.enclosePoints(ABCcomb(j,15));
        %C21 = Ctest{21};

    [testz,~,~,~]  =AStreamCipherABC(Atest,Btest,Ctest,numOfmessages);

    for i=1:numOfmessages
        testc{i}= xor(testz{i},logicalZonotope.enclosePoints(m{i}));
    end
    
%     longZono = testc{1};
%     longC = double(c{1});
%     for i =2:numOfmessages
%         longZono=cartProd(longZono,testc{i});
%         longC = [longC;double(c{i})];
%     end
%     flag{kk} =0;
%     %longZono = reduce(longZono);
%         if ~longZono.containsPoint(longC)
%             flag{kk} =1;
%         %    break;
%         end
    
    flag{kk} =0;
    for i =1:numOfmessages
        if ~testc{i}.containsPoint(c{i})
            flag{kk} =1;
            break;
        end
    end

    if flag{kk} ==0
        sprintf('A19 B22 C23=%d %d %d %d %d %d',A19.c,B22.c,C23.c,A18.c,B21.c,C22.c)
         sprintf('TRUE A19 B22 C23=%d %d %d %d %d %d',A{19},B{22},C{23},A{18},B{21},C{22})

    end

    end




