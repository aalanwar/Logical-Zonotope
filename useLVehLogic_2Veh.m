clear all

load('cache\L2.mat')


VPl{1} = [0;1];%logicalZonotope.enclosePoints([[0;1],[1;0]]);
VPl{2} = [0;1];
% VPl{3} = [1;0];
% VPl{4} = [1;0];

CFl{1} = [1;0];%logicalZonotope.enclosePoints([[0;1],[1;0]]);
CFl{2} = [1;0];
% CFl{3} = [1;0];
% CFl{4} = [1;0];

Ul{1} = logicalZonotope.enclosePoints([[0;1],[1;0]]);
Ul{2} = Ul{1};
Ul{3} = [0;1];
Ul{4} = [0;1];

xVPl = semiKron(VPl{1},VPl{2});
xCFl = semiKron(CFl{1},CFl{2});
xl{1} = semiKron(xVPl,xCFl);
ul{1} = semiKron(Ul{1},reduce(semiKron(Ul{2},semiKron(Ul{3},Ul{4}))));
%xl{1} = reduce(xl{1});
ul{1} = reduce(ul{1});
for i=1:2
    LU = semiKron(Lcomp,ul{1});
    xl{i+1} = semiKron(LU,xl{i});
    xl{i+1} = reduce(xl{i+1});
end

%%--------------------%%

VP{1} = [0;1];%[[0;1],[1;0]];
VP{2} = [0;1];


CF{1} = [1;0];%[[0;1],[1;0]];
CF{2} = [1;0];


U{1} = [[0;1],[1;0]];
U{2} = U{1};
U{3} = [0;1];
U{4} = [0;1];

xpoints{1}= [];
for i=1:length(VP{1}(1,:))
    for j = 1:length(CF{1}(1,:))
        xVP = semiKron(VP{1}(:,i),VP{2});
        xCF = semiKron(CF{1}(:,i),CF{2});
        xpoints{1} = [ xpoints{1} semiKron(xVP,xCF)];
    end
end


for s = 1:5
    xpoints{s+1} = [];
    for i=1:length(xpoints{s}(1,:))
        for j=1:length(U{1}(1,:))
            for j2 = 1:length(U{2}(1,:))
                for j3=1:length(U{3}(1,:))
                    for j4 = 1:length(U{4}(1,:))
                        usemi = semiKron(U{1}(:,j),semiKron(U{2}(:,j2),semiKron(U{3}(:,j3),U{4}(:,j4))));
                        newx = semiKron(semiKron(Lcomp,usemi),xpoints{s}(:,i));
                        xpoints{s+1} = [ xpoints{s+1} newx];
                    end
                end
            end
        end
    end
    xpoints{s+1} = unique(xpoints{s+1}','rows')';
end


