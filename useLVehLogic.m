clear all

load('cache\L2.mat')


VPl{1} = logicalZonotope.enclosePoints([[0;1],[1;0]]);
VPl{2} = [0;1];
VPl{3} = [1;0];
VPl{4} = [1;0];

CFl{1} = logicalZonotope.enclosePoints([[0;1],[1;0]]);
CFl{2} = [1;0];
CFl{3} = [1;0];
CFl{4} = [1;0];

Ul{1} = logicalZonotope.enclosePoints([[0;1],[1;0]]);
Ul{2} = Ul{1};


xVPl = semiKron(VPl{1},semiKron(VPl{2},semiKron(VPl{3},VPl{4})));
xCFl = semiKron(CFl{1},semiKron(CFl{2},semiKron(CFl{3},CFl{4})));
xl{1} = semiKron(xVPl,xCFl);
ul{1} = semiKron(Ul{1},Ul{2});
%x = reduce(x);
% for i=1:3
%     xl{i+1} = semiKron(semiKron(Lcomp,ul{1}),xl{i});
%     xl{i+1} = reduce(xl{i+1});
% end

%%--------------------%%

VP{1} = [[0;1],[1;0]];
VP{2} = [0;1];
VP{3} = [1;0];
VP{4} = [1;0];

CF{1} = [[0;1],[1;0]];
CF{2} = [1;0];
CF{3} = [1;0];
CF{4} = [1;0];

U{1} = [[0;1],[1;0]];
U{2} = U{1};

xpoints{1}= [];
for i=1:length(VP{1}(1,:))
    for j = 1:length(CF{1}(1,:))
        xVP = semiKron(VP{1}(:,i),semiKron(VP{2},semiKron(VP{3},VP{4})));
        xCF = semiKron(CF{1}(:,i),semiKron(CF{2},semiKron(CF{3},CF{4})));
        xpoints{1} = [ xpoints{1} semiKron(xVP,xCF)];
    end
end


for s = 1:5
    xpoints{s+1} = [];
    for i=1:length(xpoints{s}(1,:))
        for j=1:length(U{1}(1,:))
            for k = 1:length(U{2}(1,:))
                usemi = semiKron(U{1}(:,j),U{2}(:,k));
                newx = semiKron(semiKron(Lcomp,usemi),xpoints{s}(:,i));
                xpoints{s+1} = [ xpoints{s+1} newx];
            end
        end
    end
    xpoints{s+1} = unique(xpoints{s+1}','rows')';
end


