clear all

U{1} = [[0;1],[1;0]];
U{2} = U{1};
U{3} = U{1};
U{4} = U{1};

usemi = [];
for j=1:length(U{1}(1,:))
    for j2 = 1:length(U{2}(1,:))
        for j3=1:length(U{3}(1,:))
            for j4 = 1:length(U{4}(1,:))
                usemi = [usemi semiKron(U{1}(:,j),semiKron(U{2}(:,j2),semiKron(U{3}(:,j3),U{4}(:,j4))))];      
            end
        end
    end
end

usemi = unique(usemi','rows')';
upointsL = logicalZonotope.enclosePoints2(usemi);
upointsL = reduce(upointsL);

Ul{1} = logicalZonotope.enclosePoints2([[0;1],[1;0]]);
Ul{2} = Ul{1};
Ul{3} = Ul{1};
Ul{4} = Ul{1};
ul{1} = semiKron(Ul{1},reduce(semiKron(Ul{2},reduce(semiKron(Ul{3},Ul{4})))));
ul{1} = reduce(ul{1});

