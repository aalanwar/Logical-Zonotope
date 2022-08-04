classdef Measurement < handle
    %MEASUREMENT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Constant)
        LIGHTSPEED = 299792458; % m/s
        % range var is about 0.05 m, so due to timing that's about 1.67e-10
    end
    
    properties
        index ;
        heading ;
        walltime;
        velocity ; % ROS
        x ; % ROS
        y ;
    end
    
    methods

        % constructor
        function obj = Measurement( varargin )
            % process raw measurement
            % format: time, dest, src, seq, ts0, ..., ts5, fppwr, cirp, fploss
            
%             if nargin >1
                raw =varargin{1};
                obj.index = raw(1); % ROS
                obj.heading = raw(2); % ROS
                obj.walltime = raw(3);
                obj.velocity = raw(4); % ROS
                obj.x = raw(5); % ROS
                obj.y = raw(6);
      %      end
        end

        % get the vectorized measurements
        function z = vectorize(obj)
            z = [obj.x;obj.y;obj.velocity;obj.heading];
        end
        
%         % get the covariance matrix, R
%         function R = getCovariance(obj)
%             r = [];
%             if obj.type == 1 || obj.type == 2 || obj.type == 3
%                 if obj.allow_d
%                     r = [r; obj.var_dij];
%                 end
%             end
%             if obj.type == 2 || obj.type == 3
%                 if obj.allow_r
%                     r = [r; obj.var_rij];
%                 end
%             end
%             if obj.type == 3
%                 if obj.allow_R
%                     r = [r; obj.var_Rij];
%                 end
%             end
%             R = diag(r);
%             
%             % add cross-terms
%             if obj.type == 2
%                 if obj.allow_r && obj.allow_d
%                     R(1,2) = obj.var_dxr;
%                     R(2,1) = obj.var_dxr;
%                 end
%             end
%             if obj.type == 3
%                 if obj.allow_d && obj.allow_r
%                     R(1,2) = obj.var_dxr;
%                     R(2,1) = obj.var_dxr;
%                     if obj.allow_R
%                         R(1,3) = obj.var_dxR;
%                         R(2,3) = obj.var_rxR;
%                         R(3,1) = obj.var_dxR;
%                         R(3,2) = obj.var_rxR;
%                     end
%                 end
%                 if obj.allow_d && obj.allow_R
%                     R(1,2) = obj.var_dxR;
%                     R(2,1) = obj.var_dxR;
%                 end
%                 
%                 if obj.allow_r && obj.allow_R
%                     R(1,2) = obj.var_rxR;
%                     R(2,1) = obj.var_rxR;
%                 end
%             end
%         end
%                 
%         % get measurement type
%         function t = getType(obj)
%             t = obj.type;
%         end
%         
%         function setType(obj, type)
%             obj.type = type;
%         end
        
        % get measurement time
        function t = getTime(obj)
            t = obj.walltime;
        end
%         
%         % get source node
%         function id = getSourceId(obj)
%             id = obj.nodei;
%         end
%         
%         % get destination id
%         function id = getDestId(obj)
%             id = obj.nodej;
%         end
%         
%         % measurement type filters
%         function allowMeasType_d(obj)
%             obj.allow_d = true;
%         end
%         function allowMeasType_r(obj)
%             obj.allow_r = true;
%         end
%         function allowMeasType_R(obj)
%             obj.allow_R = true;
%         end
%         
%         % set measurement covariances
%         function setCovar_dij(obj, v)
%             obj.var_dij = v;
%         end
%         
%         function setCovar_rij(obj, v)
%             obj.var_rij = v;
%         end
%         
%         function setCovar_Rij(obj, v)
%             obj.var_Rij = v;
%         end
    end
    
end

