
clear all
close all
rng(254)

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

tic

L=2^Aleng;
%T = zeros(L,N);
for i=1:1000

    testAmat = de2bi(i-1,Aleng,'left-msb');

    for j=1:length(testAmat)
        testA{j} = testAmat(j);
    end

    [testz,~]  =LFSR1Bits(testA,numOfmessages);

    for j =1:numOfmessages
        testc{j}= xor(testz{j},m{j});
    end



    flag =0;
    for j =1:numOfmessages
        if ~testc{j} == c{j}
            flag =1;
            break;
        end
    end




    %     sum=0;
    %     for i =1:Aleng
    %         sum = sum + abs(tempA{i}-A{i}) ;
    %     end
    %     %if sum == 0
    %     sprintf("sum key =%d , j =%d ",sum,j)
    %     %end
    %
    %     [testz2,~]  =LFSR1(tempA,numOfmessages);
    %     sum2=0;
    %     for i =1:numOfmessages
    %         cRecover{i}= xor(testz2{i},m{i});
    %         sum2 = sum2 + abs(cRecover{i} - c{i});
    %     end
    %     sprintf("sum message =%d",sum2)

end
execTime = toc/1000



