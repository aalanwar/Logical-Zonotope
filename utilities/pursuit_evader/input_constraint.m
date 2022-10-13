function [valid_u] = input_constraint(u, u_starts, neighbor_set)
n_pursuers = size(u_starts, 2);
u_len = size(u, 1) / n_pursuers;
u_starts = u_starts - u_starts(1) + 1;
valid_u = {};
for pursuer = 1:n_pursuers
    for region = 1:u_len

        tempZonoU= u{u_starts(pursuer)+region-1};
        if isa(tempZonoU,'logicalZonotope')

            if tempZonoU.containsPoint(1)
                valid_u{pursuer} = neighbor_set{region};
            end

        else
            if isequal(tempZonoU,1)
                valid_u{pursuer} = neighbor_set{region};
            end
        end
    end
end
end

