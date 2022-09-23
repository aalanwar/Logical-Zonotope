
clear all
close all
rng(120)

for i =1:19
    A{i} = randi([0 1]);
end

numOfmessages =144;
[z,~]  =LFSR1Bits(A,numOfmessages);
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
ABCcomb = truth_table(1);
%for kk=1:63
kk=1;
    for i =1:19
        Atest{i} = logicalZonotope.enclosePoints([0 1]);
        
    end



    for j =1:length(ABCcomb(:,1))

%         Atest{19}=logicalZonotope.enclosePoints(ABCcomb(j,1));
%         A19 = Atest{19};
%     
%         Atest{18}=logicalZonotope.enclosePoints(ABCcomb(j,2));
%         A18 = Atest{18};

        Atest{19}=logicalZonotope.enclosePoints(ABCcomb(j,1));
        A19 = Atest{19};

    [testz,~]  =LFSR1(Atest,numOfmessages);

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
      %  sprintf('A19 B22 C23=%d %d %d',A19.c,A18.c,A17.c)
      %   sprintf('TRUE A19 B22 C23=%d %d %d',A{19},A{18},A{17})
         sprintf('A19 B22 C23=%d ',A19.c)
         sprintf('TRUE A19 B22 C23=%d ',A{19})
    end

    end




