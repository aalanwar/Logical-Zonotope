classdef DataParserROS < handle
    %DATAPARSER parse tcp data logs from NTB nodes
    %   obj = DataParser( config_file, log_folder )
    
    %data_input
    %index,steering angle (rad),t (sec),transmission (0=Low or 1=High),velocity ctrl (m/s)
    % data state
    %index,heading (rad),t (sec),velocity state (m/s),x (m),y (m)
    properties
        fpath = '';
        raw_logs = {};
        nodeinfo = {};
        inputlogs = [];
        mocaplogs = [];
        
        % for speed, map of id to idx and name to idx
        id2idx = zeros(1,128);
        name2idx = containers.Map('KeyType', 'char', 'ValueType', 'int32');
    end
    
    methods
        % Constructor
        function obj = DataParserROS( config, fpath )
            
            % open and parse config data
            fid = fopen(config);
            obj.nodeinfo = textscan(fid, '%s %f %f %f %f %s', 'Delimiter', ',');
            fclose(fid);
            
            % load hash tables for speed
            for i=1:length( obj.nodeinfo{1} )
                name = obj.nodeinfo{1}{i};
                id = obj.nodeinfo{2}(i);
                obj.id2idx(id+1) = i;
                obj.name2idx(name) = i;
            end
            

            % read NTB timing measurements
            obj.fpath = fpath;
            d = importdata([obj.fpath 'svea_data_state.csv']);
            if size(d,1) < 0
                error('svea_data_state log file empty');
            end
            


%             % check to make sure we have info on each node
%             unique_ids = unique([d(:,2); d(:,3)]);
%             for i=1:length(unique_ids)
%                 id = unique_ids(i);
%                 idxs = find(obj.nodeinfo{2} == id);
%                 if isempty(idxs)
%                     warning('No config found for node ID: %d\n', id);
%                     % remove data associated with this ID
%                     toremove = find(d(:,2) == id | d(:,3) == id);
%                     d(toremove,:) = [];
%                 end
%             end
            
            obj.mocaplogs = d;
            
            % load the OptiTrack mocap data
            obj.inputlogs = importdata([obj.fpath '/svea_data_input.csv' ]);
            if isempty(obj.mocaplogs)
                error('No mocap data in log file');
            end
        end
        
        % convert hostname to id
        function id = hostnameToId(obj, name)
            idx = find(strcmp(obj.nodeinfo{1}, name));
            id = obj.nodeinfo{2}(idx);
        end
        
        % convert id to hostname
        function name = idToHostname(obj, id)
            hostidx = find(obj.nodeinfo{2} == id);
            name = obj.nodeinfo{1}(hostidx);
        end
                
        % get node index from alpha or numeric ID
        function idx = getNodeIdx(obj, node)
            if isnumeric(node)
                idx = obj.id2idx( node+1 );
            else
                idx = obj.name2idx( node );
            end
        end
       
        % get the node info
        function info = getNodeInfo(obj)
            info = obj.nodeinfo;
        end
        
        % get the node position x,y,z
        function xyz = getNodePos(obj, id)
            idx = obj.getNodeIdx(id);
            xyz = [obj.nodeinfo{3}(idx) obj.nodeinfo{4}(idx) obj.nodeinfo{5}(idx)];
        end
        
        % number of aligned measurements
        function n = getNumMeasurements(obj)
            n = size(obj.mocaplogs,1);
        end

        function [Xdim, Ydim] = getMaxDimension(obj)
            Xdim{1} = min(obj.mocaplogs(:,5));
            Xdim{2} = max(obj.mocaplogs(:,5));
            Ydim{1} = min(obj.mocaplogs(:,6));
            Ydim{2} = max(obj.mocaplogs(:,6));
        end
        % get a specific measurement
        function meas = getMeasurement(obj, idx)
            meas = obj.mocaplogs(idx,:);
        end
        

        
        % get rigid body ids
        function ids = getRigidBodyIds(obj)
            ids = 1;%unique(obj.mocaplogs(:,2));
        end
        
        % get closest mocap estimate to time for rigid body
        function [xy, latency] = getMocapPos(obj, rb, time)
            %idxs = obj.mocaplogs(:,2) == rb;
            idxs = 1:length(obj.mocaplogs(:,2));
            [t, c] = min(abs(obj.mocaplogs(idxs,1)-time));
            xy = obj.mocaplogs(c(1),5:6);
            latency = t(1);
        end
            
        % deprecated ... don't use
        function t = getTotalTime(obj)
            t = obj.mocaplogs(end,3) - obj.mocaplogs(1,3);
        end
        
       
    end
    
end
