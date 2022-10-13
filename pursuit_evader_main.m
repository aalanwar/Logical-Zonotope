
clear all
% get environment constraints
[neigh_set, vis_set] = env();

% state
n_pursuers = 2;
n_regions = 21;
l = cell(n_regions, 1);
v = cell(n_regions, 1);
c = cell(n_regions, 1);
for i =1:n_regions
l{i} =logicalZonotope.enclosePoints([0]);
v{i} =logicalZonotope.enclosePoints([0]);
c{i} =logicalZonotope.enclosePoints([0]);
end
u_state = cell(n_pursuers*n_regions, 1);
for i =1:n_pursuers*n_regions
u_state{i}=logicalZonotope.enclosePoints([0]);
end
%state = [has_pursuer; visible; cleared; inputs];
%size(state)

l_idx = 1:n_regions;
v_idx = n_regions+1:2*n_regions;
c_idx = 2*n_regions+1:3*n_regions;

u_start = 3*n_regions;
u_starts = [];
for i = 1:n_pursuers
   % u_starts = [u_starts u_start + (i-1)*n_regions];
   u_starts = [u_starts  (i-1)*n_regions];
end

% initialization
pursuer_init_locations = [12 15];
for pursuer = 1:n_pursuers
    u_state{ u_starts(pursuer) + pursuer_init_locations(pursuer)}  =logicalZonotope.enclosePoints([1]);
end

% forward simulation w/ randomly chosen u
n_steps = 10;
num_sat_steps=0;
last_num_sat_steps = 0;
for step = 1:n_steps
    % evaluate boolean function until state reaches new steady-state
    last_l = 0;
    last_v = 0 ;
    last_c = 0;
    steps  = 0;
    last_num_sat_steps = max(last_num_sat_steps,num_sat_steps);
    num_sat_steps =0;
    %while ~isequal(last_l,l)|| ~isequal(last_v,v) || ~isequal(last_c,c)
        % dynamics
        %         l = state(l_idx);
        %         v = state(v_idx);
        %         c = state(c_idx);
        %         u = state(u_start+1:end);
        %         last_state = state;
     for i =1:30
        last_l = l;
        last_v = v ;
        last_c = c;
        [l,v ,c]  = dynamics(l, v, c, u_state, u_starts, vis_set, neigh_set);
        steps = steps + 1;
        num_sat_steps = num_sat_steps +1;
        if i ==29
            i
        end
     end
    %end

    % find valid inputs for current inputs
    %u = state(u_start+1:end);
    [valid_u] = input_constraint(u_state, u_starts, neigh_set);

    % set new input (should be replaced by logical zonotopes)
    
    for i =1:length(u_state)
        u_state{i}  =logicalZonotope.enclosePoints([0]);
    end

    for pursuer = 1:n_pursuers
%         u_perm = randperm(size(valid_u{pursuer}, 2));
%         pursuer_u = valid_u{pursuer}(u_perm(1));
%         u_state{u_starts(pursuer) + pursuer_u} = 1;
        for vj = 1:length(valid_u{pursuer})
            pursuer_u = valid_u{pursuer}(vj);
            u_state{u_starts(pursuer) + pursuer_u} = logicalZonotope.enclosePoints([0 1]);
        end

    end



end
