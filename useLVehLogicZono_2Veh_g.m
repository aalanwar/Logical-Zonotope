clear all

load('cache\L.mat')

steps = 1000;
VPl{1}{1} = 1;
VPl{1}{2} = [0];
% VPl{3} = [1;0];
% VPl{4} = [1;0];

CFl{1}{1} = 1;
CFl{1}{2} = [0];
% CFl{3} = [1;0];
% CFl{4} = [1;0];

Ul{1} = logicalZonotope.enclosePoints([0,1]);
Ul{2} = logicalZonotope.enclosePoints([0,1]);
Ul{3} = logicalZonotope.enclosePoints([0,1]);
Ul{4} = logicalZonotope.enclosePoints([0,1]);

tic
for i=1:steps
    [VPl{i+1},CFl{i+1}] = vehLogicZono(Ul,VPl{i},CFl{i});
end
execlogicZono = toc

%%----------- BCN ---------%%

VP{1} = [[0;1],[1;0]];
VP{2} = [0;1];


CF{1} = [[0;1],[1;0]];
CF{2} = [1;0];


U{1} = [[0;1],[1;0]];
U{2} = U{1};
U{3} = U{1};
U{4} = U{1};
tic
xpoints{1}= [];
for i=1:length(VP{1}(1,:))
    for j = 1:length(CF{1}(1,:))
        xVP = semiKron(VP{1}(:,i),VP{2});
        xCF = semiKron(CF{1}(:,i),CF{2});
        xpoints{1} = [ xpoints{1} semiKron(xVP,xCF)];
    end
end


for s = 1:steps
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
execBCN = toc



%%----------- BDD ---------%%
VPl ={};
CFl={};
Ul={};
VP{1} = [[0],[1]];
VP{2} = [0];


CF{1} = [[0],[1]];
CF{2} = [1];


U{1} = [[0],[1]];
U{2} = U{1};
U{3} = U{1};
U{4} = U{1};


VP1points{1}=VP{1};
VP2points{1}=VP{2};

CF1points{1}=CF{1};
CF2points{1}=CF{2};
tic
for s = 1:steps
    VP1points{s+1} = [];
    VP2points{s+1} = [];
    CF1points{s+1} = [];
    CF2points{s+1} = [];
    for iVP1=1:length(VP1points{s}(1,:))
        for iVP2=1:length(VP2points{s}(1,:))
            for iCF1=1:length(CF1points{s}(1,:))
                for iCF2=1:length(CF2points{s}(1,:))
                    for j=1:length(U{1}(1,:))
                        for j2 = 1:length(U{2}(1,:))
                            for j3=1:length(U{3}(1,:))
                                for j4 = 1:length(U{4}(1,:))
                                    Ul{1}=U{1}(:,j);
                                    Ul{2}=U{2}(:,j2);
                                    Ul{3}=U{3}(:,j3);
                                    Ul{4}= U{4}(:,j4);

                                    VPl{1}=VP1points{s}(:,iVP1);
                                    VPl{2}=VP2points{s}(:,iVP2);
                                    CFl{1}=CF1points{s}(:,iCF1);
                                    CFl{2}=CF2points{s}(:,iCF2);

                                    [VPl,CFl] = vehLogicBDD(Ul,VPl,CFl);
                                    VP1points{s+1} = [ VP1points{s+1} VPl{1}];
                                    VP2points{s+1} = [ VP2points{s+1} VPl{2}];
                                    CF1points{s+1} = [ CF1points{s+1} CFl{1}];
                                    CF2points{s+1} = [ CF2points{s+1} CFl{2}];

                                end
                            end
                        end
                    end
                end
            end
        end
    end
    VP1points{s+1} = unique(VP1points{s+1}','rows')';
    VP2points{s+1} = unique(VP2points{s+1}','rows')';
    CF1points{s+1} = unique(CF1points{s+1}','rows')';
    CF2points{s+1} = unique(CF2points{s+1}','rows')';
end
execBDD = toc



