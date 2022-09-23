
clear all
close all
%rng(254)

Aleng = 60;
for i =1:Aleng
    A{i} = randi([0 1]);
end

numOfmessages =121;
[z,~]  =LFSR1(A,numOfmessages);
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
disp('start')
index=index+1;
setIndex =1;
compA=truth_table(setIndex);
for j =1:length(compA(:,1))
    for i=1:setIndex
        testA{i} = logicalZonotope.enclosePoints(compA(j,i));
        tempA{i} = compA(j,i);
    end

    % try first the chosen bits and other are logical zonotope
    for i=setIndex+1:Aleng
        testA{i} = logicalZonotope.enclosePoints([0 1]);
    end
    [testz,~]  =LFSR1(testA,numOfmessages);

    for i =1:numOfmessages
        testc{i}= xor(testz{i},logicalZonotope.enclosePoints(m{i}));
    end



    flagChosenBits =0;
    for i =1:numOfmessages
        if ~testc{i}.containsPoint(c{i})
            flagChosenBits =1;
            break;
        end
    end

    if flagChosenBits ==1
        % do not continue with chosen bits
        continue;
    end

    % the chosen bits are correct, let's continue 
    for kk=setIndex+1:Aleng
        testA{kk} = logicalZonotope.enclosePoints([0]);
        for i=kk+1:Aleng
            testA{i} = logicalZonotope.enclosePoints([0 1]);
        end
        [testz,~]  =LFSR1(testA,numOfmessages);

        for i =1:numOfmessages
            testc{i}= xor(testz{i},logicalZonotope.enclosePoints(m{i}));
        end



        flag{kk} =0;
        for i =1:numOfmessages
            if ~testc{i}.containsPoint(c{i})
                flag{kk} =1;                
                break;
            end
        end

        for i=setIndex+1:kk
            if flag{i}==1
                testA{i} = logicalZonotope.enclosePoints([1]);
                tempA{kk}=1;
            else
                testA{i} = logicalZonotope.enclosePoints([0]);
                tempA{kk}=0;
            end
        end

    end

    
    

    sum=0;
    for i =1:Aleng
        sum = sum + abs(tempA{i}-A{i}) ;
    end
    %if sum == 0
    sprintf("sum key =%d , j =%d ",sum,j)
    %end

    [testz2,~]  =LFSR1(tempA,numOfmessages);
    sum2=0;
    for i =1:numOfmessages
        cRecover{i}= xor(testz2{i},m{i});
        sum2 = sum2 + abs(cRecover{i} - c{i});
    end
    sprintf("sum message =%d",sum2)

end




