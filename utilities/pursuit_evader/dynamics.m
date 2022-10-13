function [next_l,next_v ,next_c] = dynamics(l, v, c, u_state, u_starts, vis_set, neigh_set)
    n_pursuers = size(u_starts, 2);
    u_starts = u_starts - u_starts(1) + 1;

    for i =1:length(l)
        next_l{i} =logicalZonotope.enclosePoints([0]);
    end
    for i =1:length(v)
        next_v{i} =logicalZonotope.enclosePoints([0]);
    end
    for i =1:length(c)
        next_c{i} =logicalZonotope.enclosePoints([0]);
    end
    for region = 1:length(l)
        % update pursuer location
        for pursuer = 1:n_pursuers
            next_l{region} = or(next_l{region}, u_state{u_starts(pursuer) + region-1});
        end
        % update visibility
        vis_regions = vis_set{region};
        for v_region = 1:size(vis_regions,2)
            next_v{region} = or( next_v{region}, l{vis_regions(v_region)});
        end
        % update cleared
        neigh = neigh_set{region};
        surrounded = or(v{neigh(1)}, c{neigh(1)});
        for n_region = 2:size(neigh, 2)
            surrounded = and(surrounded, or(v{neigh(n_region)}, c{neigh(n_region)}));
        end
        next_c{region}= or(v{region}, surrounded);
    end
    % create k+1 state
   % next_state = [next_l; next_v; next_c; u_state];
end
