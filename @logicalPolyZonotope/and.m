function Z = and(Z1,Z2,varargin)
% and - overloads & operator, computes the AND of two logical poly zonotopes
%
% Syntax:
%    Z = and(Z1,Z2)
%
% Inputs:
%    Z1 - zonotope
%    Z2 - zonotope,
%
% Outputs:
%    Z - zonotope object enclosing the and zonotope
%
% Example:
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: none

% Author:        Amr Alanwar
% Written:       7-Jan-2023
% Last update:
%
%
% Last revision: ---

%------------- BEGIN CODE --------------

if ~isa(Z1,'logicalPolyZonotope') 
Z1=logicalZonotope.enclosePoints(Z1);
Z1=logicalPolyZonotope(Z1.c,Z1.G,{},[]);
end

if ~isa(Z2,'logicalPolyZonotope') 
Z2=logicalZonotope.enclosePoints(Z2);
Z2=logicalPolyZonotope(Z2.c,Z2.G,{},[]);
end

if(~isempty(Z1.c) && ~isempty(Z2.c))
    newcen = Z1.c & Z2.c;
end



% newG1 = Z1.GI;
% for i =1:length(Z1.G)
%     newG1{i+length(Z1.GI)} = Z1.G{i};
% end
% if isempty(Z1.E)
%     newE1 = eye(size(Z1.GI,2));
% elseif isempty(Z1.GI)
%     newE1 =  Z1.E;
% else
%     newE1 = blkdiag(eye(size(Z1.GI,2)),Z1.E);
% end
% 
% newG2 = Z2.GI;
% for i =1:length(Z2.G)
%     newG2{i+length(Z2.GI)} = Z2.G{i};
% end
% if isempty(Z2.E)
%     newE2 = eye(size(Z2.GI,2));
% elseif isempty(Z2.GI)
%     newE2 =  Z2.E;
% else
%     newE2 = blkdiag(eye(size(Z2.GI,2)),Z2.E);
% end
% 
% 
% index =1;
% newE =[];
% newGen ={};
% zeroVec = logical(zeros(size(Z1.c)));
% if(~isempty(Z2.c) && ~isempty(newG1))
%     tempE1=newE1 ;
%     zerosE2=zeros(size(newE2,1),1);
%     tempE = [];
%     indexE = 1;
%     for i=1:length(newG1)
%         vecAnd = Z2.c & newG1{i};
%         if isequal(vecAnd,zeroVec)
%             continue;
%         end    
%         newGen{index} = vecAnd;
%         tempE(:,indexE) = [(tempE1(:,i));(zerosE2)];
%         index=index+1;
%         indexE=indexE+1;
%     end
%     newE = [newE tempE];
% end
% if(~isempty(Z1.c) && ~isempty(newG2))
%     zerosE1=zeros(size(newE1,1),1);
%     tempE2=newE2 ;
%     tempE = [];
%     indexE = 1;    
%     for i=1:length(newG2)
%         vecAnd= Z1.c & newG2{i};
%         if isequal(vecAnd,zeroVec)
%             continue;
%         end   
%         newGen{index} =vecAnd;
%         tempE(:,indexE) = [(zerosE1);(tempE2(:,i))];
%         index=index+1;
%         indexE=indexE+1;
%     end
%     newE = [newE tempE];
% end
% if(~isempty(newG1) && ~isempty(newG2))
%     %G1 * G1
%     tempE1=newE1 ;
%     tempE2=newE2;
%     tempE = [];
%     indexE = 1;
%     for i=1:length(newG1)
%         for k=1:length(newG2)
%             vecAnd = (newG1{i} & newG2{k});
%             if isequal(vecAnd,zeroVec)
%                 continue;
%             end
%             newGen{index} = vecAnd;
%             tempE(:,indexE) = [(tempE1(:,i));(tempE2(:,k))];
%             index=index+1;
%             indexE=indexE+1;
%         end  
%     end
%     newE = [newE tempE];
% end
% Z = logicalPolyZonotope(newcen,{},newGen,newE);
% Z = unique(Z);
% 
% %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

q1=length(Z1.GI);
h1=length(Z1.G);
p1=size(Z1.E,1);

q2=length(Z2.GI);
h2=length(Z2.G);
p2=size(Z2.E,1);
tempE1=eye(size(Z1.GI,2)) ; 
tempE2=eye(size(Z2.GI,2));
zeroVec = logical(zeros(size(Z1.c)));
indexI =1;
newGenI ={};
newE =[];
index =1;
newGen ={};

% there is no generators in Z2 to multiply with Z1
if(~isempty(Z2.c) && ~isempty(Z1.GI) && isempty(Z2.GI) && isempty(Z2.G))
    for i=1:length(Z1.GI)
        vecAnd = Z2.c & Z1.GI{i};
        if isequal(vecAnd,zeroVec)
            continue;
        end
        newGenI{indexI} = vecAnd;
        indexI=indexI+1;
    end
elseif (~isempty(Z2.c) && ~isempty(Z1.GI))
    for i=1:length(Z1.GI)
        vecAnd = Z2.c & Z1.GI{i};
        if isequal(vecAnd,zeroVec)
            continue;
        end
        newGen{index} = vecAnd;
        newE = [newE [zeros(p1,1);tempE1(:,i);zeros(p2,1);zeros(q2,1)]];
        index=index+1;
    end
end

% there is no generators in Z1 to multiply with Z2
if(~isempty(Z1.c) && ~isempty(Z2.GI) && isempty(Z1.GI) && isempty(Z1.G))
    for i=1:length(Z2.GI)
        vecAnd = Z1.c & Z2.GI{i};
        if isequal(vecAnd,zeroVec)
            continue;
        end
        newGenI{indexI} = vecAnd;
        indexI=indexI+1;
    end
elseif (~isempty(Z1.c) && ~isempty(Z2.GI))
    for i=1:length(Z2.GI)
        vecAnd = Z1.c & Z2.GI{i};
        if isequal(vecAnd,zeroVec)
            continue;
        end
        newGen{index} = vecAnd;
        newE = [newE [zeros(p1,1);zeros(q1,1);zeros(p2,1);tempE2(:,i)]];
        index=index+1;
    end
end


if(~isempty(Z1.GI) && ~isempty(Z2.GI))
    %GI1 * GI1
    for i=1:length(Z1.GI)
        for k=1:length(Z2.GI)
            vecAnd = (Z1.GI{i} & Z2.GI{k});
            if isequal(vecAnd,zeroVec)
                continue;
            end
            newGen{index} = vecAnd;
            newE = [newE [zeros(p1,1);tempE1(:,i);zeros(p2,1);tempE2(:,k)]];
            index = index +1;
        end
        
    end
end

%c2 * G1
if(~isempty(Z2.c) && ~isempty(Z1.G))
    for i=1:length(Z1.G)
        vecAnd = Z2.c & Z1.G{i};
        if isequal(vecAnd,zeroVec)
            continue;
        end
        newGen{index} = vecAnd;
        newE = [newE [Z1.E(:,i);zeros(q1,1);zeros(p2,1);zeros(q2,1)]];
        index=index+1;
    end
end

%c1 * G2
if(~isempty(Z1.c) && ~isempty(Z2.G))
    for i=1:length(Z2.G)
        vecAnd = Z1.c & Z2.G{i};
        if isequal(vecAnd,zeroVec)
            continue;
        end
        newGen{index} = vecAnd;
        newE = [newE [zeros(p1,1);zeros(q1,1);Z2.E(:,i);zeros(q2,1)]];        
        index=index+1;
    end
end
%G1 * G2
if(~isempty(Z1.G) && ~isempty(Z2.G))
    for i=1:length(Z1.G)
        for k=1:length(Z2.G)
            vecAnd = (Z1.G{i} & Z2.G{k});
            if isequal(vecAnd,zeroVec)
                continue;
            end
            newGen{index} = vecAnd;
            newE = [newE [Z1.E(:,i);zeros(q1,1);Z2.E(:,k);zeros(q2,1)]]; 
            index=index+1;
        end
    end
end

if(~isempty(Z1.GI) && ~isempty(Z2.G))
    for i=1:length(Z1.GI)
        for k=1:length(Z2.G)
            vecAnd = (Z1.GI{i} & Z2.G{k});
            if isequal(vecAnd,zeroVec)
                continue;
            end
            newGen{index} = vecAnd;
            newE = [newE [zeros(p1,1);tempE1(:,i);Z2.E(:,k);zeros(q2,1)]]; 
            index=index+1;
        end
    end
end

if(~isempty(Z1.G) && ~isempty(Z2.GI))
    for i=1:length(Z1.G)
        for k=1:length(Z2.GI)
            vecAnd = (Z1.G{i} & Z2.GI{k});
            if isequal(vecAnd,zeroVec)
                continue;
            end
            newGen{index} = vecAnd;
            newE = [newE [Z1.E(:,i);zeros(q1,1);zeros(p2,1);tempE2(:,k)]]; 
            index=index+1;
        end
    end
end
Z = logicalPolyZonotope(newcen,newGenI,newGen,newE);
Z = unique(Z);


end

%------------- END OF CODE --------------