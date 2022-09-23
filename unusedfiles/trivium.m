function [s,z] = trivium(K,IV,N)
%TRIVIUM Summary of this function goes here
%   Detailed explanation goes here

for i=1:80
    s{i} = K{i};
end

for i=81:93
    s{i} = [0];
end

endofIV = 94+79;
for i=94:endofIV
    s{i} = IV{i-93};
end

for i=endofIV+1:177
    s{i} = [0];
end

for i=178:285
    s{i} = [0];
end

for i=286:288
    s{i} = [1];
end

for ii =1:4*288
and9192 = and(s{91},s{92});
t1 = xor(s{66},xor(and9192,xor(s{93},s{171})));

and175176 = and(s{175},s{176});
t2 = xor(s{162},xor(and175176,xor(s{177},s{264})));

and286287 = and(s{286},s{287});
t3 = xor(s{243},xor(and286287,xor(s{288},s{69})));


    for i =2:93
        s{i}=s{i-1};
    end
    s{1}=t3;

    for i =95:177
        s{i}=s{i-1};
    end
    s{94}=t1;

    for i =179:288
        s{i}=s{i-1};
    end
    s{178}=t2;
end



for ii =1:N
    t1= xor(s{66},s{93});
    t2= xor(s{162},s{177});
    t3= xor(s{243},s{288});
    z{ii} = xor(t1,xor(t2,t3));

    and9192 = and(s{91},s{92});
    t1 = xor(t1,xor(and9192,s{171}));

    and175176 = and(s{175},s{176});
    t2 = xor(t2,xor(and175176,s{264}));

    and286287 = and(s{286},s{287});
    t3 = xor(t3,xor(and286287,s{69}));

    for i =2:93
        s{i}=s{i-1};
    end
    s{1}=t3;

    for i =95:177
        s{i}=s{i-1};
    end
    s{94}=t1;

    for i =179:288
        s{i}=s{i-1};
    end
    s{178}=t2;



end



end

