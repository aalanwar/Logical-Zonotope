classdef DataDrivenRA < handle
    
    properties (Constant)
        %wfac = 0.27e-3;%cmz
        %vfac = 0.25e-3;%cmz
        %wfac = 1e-3;%zono
        %vfac = 1e-5;%zono
        wfac = 10^-(2);
        vfac = 10^-(5);
        dim_x = 2;
        %amount of noise added to the motion capture
        dataNoiseStateFactor = 0;
        dataNoiseInputFactor = 0;
    end
    
    
    properties
        U ;
        W ;
        V ;
        inputlogsRA;
        mocaplogsRA;
        steeringData;
        velocityInputData;
        inputData;
        headingData;
        xData;
        yData;
        timeDataState;
        fpath;
        totalsamples;
        Wmatzono;
        Vmatzono;        
        U_full ;
        X_0T ;
        X_1T ;
        Zeps;
        ZL;
        % flag to add Zeps 0 to skip, 1 to add the Zeps
        ZepsFlag;
        timeStepDataIn; 
        Msigma;
        MsigmaCMZ;
        maxVelocityInput ;
        maxVelocityState ;
        maxXState;
        minXState;
        maxYState;
        minYState;
        maxU1;
        minU1;
        maxU2;
        minU2;
        binX;
        binY;
        binU1;
        binU2;
        numXGrids;
        numYGrids;
        numUGrids;
        binxR;
        binyR;
        hY;
        hX;
        hU1;
        hU2;
        A_con_log;
        B_con_log;
        carLogModel;
        options;
        AB;
        UL;
        X_0TL;
        X_1TL;
        ndigits;
        dataStep;
        ULogicalZono;
    end

    methods

        % constructor
        function obj = DataDrivenRA( varargin )
            obj.fpath = varargin{1};
            obj.V = zonotope(zeros(obj.dim_x,1),obj.vfac*ones(obj.dim_x,1));
            obj.W = zonotope(zeros(obj.dim_x,1),obj.wfac*ones(obj.dim_x,1)); % disturbance

            obj.inputlogsRA = importdata(strcat(obj.fpath ,'svea_data_input.csv' ));
            %obj.steeringData = obj.inputlogsRA(:,2)+10^-2*rand(length(obj.inputlogsRA(:,2)),1);
            %obj.velocityInputData = obj.inputlogsRA(:,5)+10^-2*rand(length(obj.inputlogsRA(:,5)),1);
            %obj.inputData = [obj.steeringData,obj.velocityInputData];
            obj.mocaplogsRA = importdata([obj.fpath 'svea_data_state.csv']);
            obj.headingData = obj.mocaplogsRA(:,2);   
            %randMeasNoise= randPoint(obj.V);
            obj.xData = obj.mocaplogsRA(:,5)+obj.dataNoiseStateFactor*rand(length(obj.mocaplogsRA(:,5)),1);
            obj.yData = obj.mocaplogsRA(:,6)+obj.dataNoiseStateFactor*rand(length(obj.mocaplogsRA(:,6)),1);
            obj.timeDataState = obj.mocaplogsRA(:,3);
            
            obj.dataStep=10;
            %datavector = [1:datastep:10,200:datastep:300,900:datastep:1000,2000:datastep:2100, 3000:datastep:3100];
            datavector= 1:obj.dataStep:3000;%[1:2:10,400:450,900:1000,2000:2100];
            obj.totalsamples=length(datavector);%ceil(length(obj.mocaplogsRA(:,1))-1);
            
            obj.X_0T = [obj.xData(datavector),obj.yData(datavector)]';
            obj.X_1T = [obj.xData(datavector+1),obj.yData(datavector+1)]';
            index=1;
            for i=datavector
                [obj.U_full(:,index), ~]  = obj.getClosetInput(obj.timeDataState(i));
                obj.U_full(:,index) =obj.U_full(:,index).*([180/pi;1])+ obj.dataNoiseInputFactor*rand(2,1);
                index=index+1;
            end
            obj.timeStepDataIn = 5;%big number
            for i=datavector
            stepDataIn(i) = obj.timeDataState(i+1)-obj.timeDataState(i);
            end
            obj.timeStepDataIn = mean(stepDataIn(i));
            obj.maxVelocityInput = max(obj.inputlogsRA(:,5));
            obj.maxVelocityState = max(obj.mocaplogsRA(:,4));
            obj.maxXState = max(obj.xData(datavector));
            obj.minXState = min(obj.xData(datavector));
            obj.maxYState = max(obj.yData(datavector));
            obj.minYState = min(obj.yData(datavector));
            obj.maxU1 = max(obj.U_full(1,:));
            obj.minU1= min(obj.U_full(1,:));
            obj.maxU2 = max(obj.U_full(2,:));
            obj.minU2= min(obj.U_full(2,:));

            obj.numXGrids=1023;
            obj.numYGrids=1023;
            obj.numUGrids=1023;
            obj.ndigits = ceil(log2((obj.numXGrids-1)^2));
            obj.hX=linspace(obj.minXState-1,obj.maxXState+1,obj.numXGrids);%for 128 resolution
            [~,~,obj.binX]=histcounts(obj.xData(datavector),obj.hX);
            obj.hY=linspace(obj.minYState-1,obj.maxYState+1,obj.numYGrids);%for 128 resolution
            [~,~,obj.binY]=histcounts(obj.yData(datavector),obj.hY);
            obj.hU1=linspace(obj.minU1,obj.maxU1,obj.numUGrids);%for 128 resolution
            [~,~,obj.binU1]=histcounts(obj.U_full(1,:),obj.hU1);
            obj.hU2=linspace(obj.minU2,obj.maxU2,obj.numUGrids);%for 128 resolution
            [~,~,obj.binU2]=histcounts(obj.U_full(2,:),obj.hU2);

            points = [];
            for i =1:length(obj.xData(datavector))
                for j =1:length(obj.xData(datavector))
                    points = [points ;((obj.binY(i)-1)*obj.numXGrids + obj.binX(j))];
                end
            end

            pointsU = [];
            for i =1:length(obj.U_full(1,:))
                for j =1:length(obj.U_full(2,:))
                    pointsU = [pointsU ;((obj.binU1(i)-1)*obj.numUGrids + obj.binU2(j))];
                end
            end
            % convert to binary

            pointB = dec2bin(points,obj.ndigits);
            
            [rows,cols]=size(pointB);
            for i =1:rows
                row=[];
                for j =1:cols
                    if j==cols
                        row=[ row, pointB(i,j)];
                    else
                        row=[ row, pointB(i,j), ' '];
                    end
                end
                newpointB(i,:) = row;
            end
            dataBinary=str2num(newpointB)';

            pointBU = dec2bin(pointsU,obj.ndigits);
            [rows,cols]=size(pointBU);
            for i =1:rows
                row=[];
                for j =1:cols
                    if j==cols
                        row=[ row, pointBU(i,j)];
                    else
                        row=[ row, pointBU(i,j), ' '];
                    end
                end
                newpointBU(i,:) = row;
            end
            UBinary=str2num(newpointBU)';
            maxnum = 1000;
            obj.X_0TL = [dataBinary(:,1:end-1)];
            obj.X_1TL = [dataBinary(:,2:end)];
            obj.UL =  [UBinary(:,1:end-1)];
            obj.ULogicalZono = logicalZonotope.enclosePoints(obj.UL);
            obj.AB = obj.X_1TL * pinv([obj.X_0TL;obj.UL ]);

           %obj.AB = X_1TL * pinv([X_0TL]);
        end
        



        % get closest input to time for rigid body
        function [angleAndVelocity, latency] = getClosetInput(obj, time)
            %idxs = obj.mocaplogs(:,2) == rb;
            [t, c] = min(abs(obj.inputlogsRA(:,3)-time));
            angleAndVelocity = obj.inputlogsRA(c(1),[2,5]);
            latency = t(1);
        end
        % prepare U W Lip constant for nonlinear Lip reachability
        function prepareUWLip(obj,ZepsFlag,moreinputdata)
            obj.U = zonotope.enclosePoints([obj.inputData;moreinputdata]');
            obj.W = zonotope(zeros(obj.dim_x,1),obj.wfac*ones(obj.dim_x,1)); % disturbance
            %noise matrix zonotope
            for i=1:size(obj.W.generators,2)
                vec=obj.W.Z(:,i+1);
                for j=0:obj.totalsamples-1
                    GW{j+i}= [ zeros(obj.dim_x,j),vec,zeros(obj.dim_x,obj.totalsamples-j-1)];
                end
            end
            obj.Wmatzono= matZonotope(zeros(obj.dim_x,obj.totalsamples),GW);
            
            %compute Lipschitz constant
            L = 0;
            for i=1:obj.totalsamples
                z1= [obj.X_0T(:,i);obj.U_full(:,i)];
                f1= obj.X_1T(:,i);
                for j=1:obj.totalsamples
                    z2= [obj.X_0T(:,j);obj.U_full(:,i)];
                    f2= obj.X_1T(:,j);
                    
                    newnorm = norm(f1-f2)/norm(z1-z2);
                    if newnorm > L
                        L = newnorm;
                        eps= L * norm(z1-z2);
                    end
                end
            end
            obj.Zeps = zonotope([zeros(2,1),diag(eps*ones(1,obj.dim_x))]);
            % flag to add Zeps 0 to skip, 1 to add the Zeps
            obj.ZepsFlag = ZepsFlag;
            
        end
        
        %function R_data = reachLLogic(obj,loc,steps)
        function R_logic =  reachLogic(obj,loc,steps)
            binaryVector = getGridIndex(obj,loc);
            R0 = logicalZonotope.enclosePoints(binaryVector);
            %R_logic=R0;
            %%%Ulog = logicalZonotope(obj.UL(:,1:end-1),[]);
            if ~isempty(R0.c)
                [rowsR0, colsR0]= size(R0.c);
            else
                [rowsR0, colsR0]= size(R0.G{1});
            end
            
            if obj.ndigits == rowsR0
                %R1 = (obj.AB(1:rowsR0,1:rowsR0)>0.7) * R0;
                %halfWay = obj.hX(ceil(length(obj.hX)/2));
                quant = 0.08;
                R_logic = or((obj.AB(:,1:rowsR0)>quant) * R0,(obj.AB(:,rowsR0+1:end)>quant)* obj.ULogicalZono);
            else
                R_logic=R0;
                disp("error number of bits")
            end

            %R1=R0;
        end

        function  location=getPoints(obj,R_logic)
            binaryPoints=evaluate(R_logic);
            [rows,cols]=size(binaryPoints);
            decPoints=[];
            for i =1:cols
               strPoint= num2str( binaryPoints(:,i) );
               temp='';
               for j =1:length(strPoint)
                    temp = strcat(temp,strPoint(j));
               end
               d=bin2dec( temp );
               decPoints = [decPoints,d];
            end
            % grid number to (x,y)
            % remove zeros added by enclose points
            newdecPoints=[];
            for i=1:length(decPoints)
                if(decPoints(i) ~=0)
                    newdecPoints=[ newdecPoints decPoints(i)];
                end
            end

             Ydata = floor( (newdecPoints)./obj.numXGrids) +1;
             Xdata =  newdecPoints - obj.numXGrids.*(Ydata -1)    ;
             location = [obj.hX(Xdata) ; obj.hY(Ydata) ];
        end

        function binaryVector = getGridIndex(obj,locPoints)

            
            [~,~,obj.binxR]=histcounts(locPoints(1,:),obj.hX);
            [~,~,obj.binyR]=histcounts(locPoints(2,:),obj.hY);

            point = (obj.binyR-1)*obj.numXGrids + obj.binxR;

            % convert to binary

            pointB = dec2bin(point,obj.ndigits);
            

            [rows,cols]=size(pointB);
            for i =1:rows
                row=[];
                for j =1:cols
                    if j==cols
                        row=[ row, pointB(i,j)];
                    else
                        row=[ row, pointB(i,j), ' '];
                    end
                end
                newpointB(i,:) = row;
            end
            binaryVector=str2num(newpointB)';

        end

        function R_data =  reachDataLip(obj,R0,steps)
            R_data{1} = R0;
            for i = 1:steps
                xStar = R_data{i}.center;
                uStar =obj.U.center;
                xStarMat = repmat(xStar,1,size(obj.X_0T,2));
                uStarMat = repmat(uStar,1,size(obj.U_full,2));
                oneMat = repmat([1],1,size(obj.U_full,2));
                IAB = (obj.X_1T )*pinv([oneMat; obj.X_0T+(-1*xStarMat);obj.U_full+-1*uStarMat]);
                
                V =  obj.X_1T + -1*(IAB*[oneMat; obj.X_0T+(-1*xStarMat);obj.U_full+-1*uStarMat] + obj.Wmatzono);
                VInt = intervalMatrix(V);
                leftLimit = VInt.Inf;
                rightLimit = VInt.Sup;
                
                V_one= zonotope(interval(min(leftLimit')',max(rightLimit')'));      
                
                R_data{i+1} = IAB*cartProd([1],cartProd(R_data{i}+(-1*xStar),obj.U+(-1*uStar))) +V_one+ obj.W ;
                
                if obj.ZepsFlag
                    R_data{i+1} = R_data{i+1} + obj.Zeps;
                end
            end
        end
        
        function prepareUWVMeas(obj,moreinputdata)
            obj.U = zonotope.enclosePoints([obj.inputData;moreinputdata]');
                      %noise matrix zonotope
            for i=1:size(obj.W.generators,2)
                vec=obj.W.Z(:,i+1);
                for j=0:obj.totalsamples-1
                    GW{j+i}= [ zeros(obj.dim_x,j),vec,zeros(obj.dim_x,obj.totalsamples-j-1)];
                end
            end
            obj.Wmatzono= matZonotope(zeros(obj.dim_x,obj.totalsamples),GW);
            
            
            %measument noise v
            
            %take care to change the center of Vmatzono if you change V
            %Construct matrix zonotpe \mathcal{M}_v
            index=1;
            for i=1:size(obj.V.generators,2)
                vec=obj.V.Z(:,i+1);
                GV{index}= [ vec,zeros(obj.dim_x,obj.totalsamples-1)];
                for j=1:obj.totalsamples-1
                    GV{j+index}= [GV{index+j-1}(:,2:end) GV{index+j-1}(:,1)];
                end
                index = j+index+1;
            end
            obj.Vmatzono= matZonotope(zeros(obj.dim_x,obj.totalsamples),GV);
            XmM = obj.X_0T +  -1*obj.Vmatzono ;
            newCen = [XmM.center;obj.U_full];
            for i=1:length(XmM.generator)
                newGen{i}=[XmM.generator{i}; zeros(size(obj.U_full))];
            end
            XmMUex = matZonotope(newCen,newGen);
            invXmMUex = invIntMatrixAuto(intervalMatrix(XmMUex));
            XpmV=(obj.X_1T  +  -1*obj.Vmatzono+  -1*obj.Wmatzono);
            obj.Msigma =intervalMatrix(XpmV) * invXmMUex;
        end
        
        function R_data =  reachDataMeas(obj,R0,steps)
            R_data{1} = R0;
            for i = 1:steps
                R_data{i+1} = obj.Msigma * cartProd(R_data{i},obj.U) + obj.W ;
            end
        end
        
        
        function prepareUWVMeasCont(obj,moreinputdata)
            prepareUWVMeas(obj,moreinputdata);
            Msigma_int=obj.Msigma.int;
            % from frank model after differentianiantion 
            ABmax = [ 0 0 -1 obj.maxVelocityState;0 0 1 obj.maxVelocityState];
            maxabs = obj.timeStepDataIn *abs([ABmax;zeros(1,obj.dim_x) 1 1;zeros(1,obj.dim_x) 1 1]);
            
            Msigma_int_cen=([Msigma_int.sup; zeros(1,obj.dim_x) 1 1;zeros(1,obj.dim_x) 1 1]+[Msigma_int.inf; zeros(1,obj.dim_x) 1  1;zeros(1,obj.dim_x) 1 1])/2;
            Msigma_int_wid=([Msigma_int.sup; zeros(1,obj.dim_x) 1 1;zeros(1,obj.dim_x) 1 1]-[Msigma_int.inf; zeros(1,obj.dim_x) 1  1;zeros(1,obj.dim_x) 1 1])/2;
            MsigmaLog =1/obj.timeStepDataIn * logIntMatrixCar( intervalMatrix(Msigma_int_cen,Msigma_int_wid),maxabs);
            MsigmaLog_int=MsigmaLog.int;
            MsigmaLog_int_cen=(MsigmaLog_int.sup+MsigmaLog_int.inf)/2;
            MsigmaLog_int_wid=(MsigmaLog_int.sup-MsigmaLog_int.inf)/2;
            obj.A_con_log = intervalMatrix(MsigmaLog_int_cen(1:obj.dim_x,1:obj.dim_x),MsigmaLog_int_wid(1:obj.dim_x,1:obj.dim_x));
            obj.B_con_log = intervalMatrix(MsigmaLog_int_cen(1:obj.dim_x,end-1:end),MsigmaLog_int_wid(1:obj.dim_x,end-1:end));          
            obj.carLogModel= linParamSys('fiveDimSys',obj.A_con_log,1);; %instantiate system
            obj.options.timeStep = obj.timeStepDataIn;
            obj.options.taylorTerms = 5; %number of taylor terms for reachable sets
            obj.options.zonotopeOrder = 50; %zonotope order
            obj.options.samplingtime = obj.options.timeStep;
            obj.options.intermediateOrder = 2;
        end
        
        function R_data =  reachDataMeasCont(obj,R0,steps)
            params.tFinal = obj.timeStepDataIn * steps;
            params.R0 = R0;
            params.U =   obj.B_con_log*obj.U  ;
            R_data_struct = reach(obj.carLogModel, params, obj.options);
            R_data =R_data_struct.timeInterval.set;
        end
        
        %has a problem :(
         function prepareUWVMeasCMZ(obj,moreinputdata)
            prepareUWVMeas(obj,moreinputdata);
            %% cmz preparation 
            totalsamples_more =4;
            index=1;
            GV ={};
            for i=1:size(obj.V.generators,2)
                vec=obj.V.Z(:,i+1);
                GV{index}= [ vec,zeros(obj.dim_x,totalsamples_more-1)];
                for j=1:totalsamples_more-1
                    GV{j+index}= [GV{index+j-1}(:,2:end) GV{index+j-1}(:,1)];
                end
                index = j+index+1;
            end
            Vmatzono_more= matZonotope(zeros(obj.dim_x,totalsamples_more),GV);
            
            GW ={};
            index=1;
            for i=1:size(obj.W.generators,2)
                vec=obj.W.Z(:,i+1);
                GW{index}= [ vec,zeros(obj.dim_x,totalsamples_more-1)];
                for j=1:totalsamples_more-1
                    GW{j+index}= [GW{index+j-1}(:,2:end) GW{index+j-1}(:,1)];
                end
                index = j+index+1;
            end
            Wmatzono_more= matZonotope(zeros(obj.dim_x,totalsamples_more),GW);
           
                
                
            Msigma_matzono = matZonotope(obj.Msigma) ;
            datavec = [100:103];
            
            xData_more = obj.mocaplogsRA(:,5);
            yData_more = obj.mocaplogsRA(:,6);
            timeDataState_more = obj.mocaplogsRA(:,3);
                      
            X_0T_more = [xData_more(datavec),yData_more(datavec)]';
            X_1T_more = [xData_more(datavec+1),yData_more(datavec+1)]';
            index=1;
            for i=datavec
                [U_full_more(:,index), ~]  = obj.getClosetInput(timeDataState_more(i));
                U_full_more(:,index) =U_full_more(:,index).*([180/pi;1]);
                index=index+1;
            end
            
%             X_0T_more = obj.X_0T(:,datavec);
%             U_full_more = obj.U_full(:,datavec);
%             X_1T_more = obj.X_1T(:,datavec);
            %%

            
            index=1;
            
            for i=1:length(Msigma_matzono.generator)
                A_cmz_more{index} = Msigma_matzono.generator{i}* [X_0T_more;U_full_more];
                index = index+1;
            end
            
            for j=1:length(Vmatzono_more.generator)
                A_cmz_more{index} = Msigma_matzono.center* [-1*Vmatzono_more.generator{j};zeros(size(U_full_more,1),size(Vmatzono_more.generator{j},2))];
                index = index+1;
            end
            
            for i=1:length(Msigma_matzono.generator)
                for j=1:length(Vmatzono_more.generator)
                    A_cmz_more{index} = Msigma_matzono.generator{i}* [-1*Vmatzono_more.generator{j};zeros(size(U_full_more,1),size(Vmatzono_more.generator{j},2))];
                    index = index+1;
                end
            end
            
            
            for j=1:length(Vmatzono_more.generator)
                A_cmz_more{index} =  Vmatzono_more.generator{j};
                index = index+1;
            end
            
            for j=1:length(Wmatzono_more.generator)
                A_cmz_more{index} =  Wmatzono_more.generator{j};
                index = index+1;
            end            
            B_cmz_more =X_1T_more - Msigma_matzono.center*[X_0T_more;U_full_more];
            
            %add zero generators to have same number with A
            gen_more = Msigma_matzono.generator;
            for i =length(Msigma_matzono.generator)+1:length(A_cmz_more)
                gen_more{i} = zeros(size(Msigma_matzono.generator{1}));
            end
            
            obj.MsigmaCMZ = conMatZonotope(Msigma_matzono.center,gen_more,A_cmz_more,B_cmz_more);
         end
        function R_data =  reachDataMeasCMZ(obj,R0,steps)
            
            
%             ML = obj.X_1T+ -1* obj.Wmatzono + -1*obj.Vmatzono + -1* obj.Msigma*[obj.X_1T - R0.center;obj.U_full-obj.U.center];
%             VInt = intervalMatrix(ML);
%             leftLimit = VInt.Inf;
%             rightLimit = VInt.Sup;
%             
%             obj.ZL= zonotope(interval(min(leftLimit')',max(rightLimit')'));
%             
            R_data{1} = R0;
            for i = 1:steps
                R_data{i+1} = obj.MsigmaCMZ * cartProd(R_data{i},obj.U) + obj.W ;%+obj.ZL;
                %R_data{i+1} = obj.Msigma * cartProd(R_data{i},obj.U) + obj.W ;
               
            end
        end         
    end
    
end
%addpath('@nonlinearDT')
% %rand('seed',1);
% dt = 0.015;
% params.tFinal = dt*5;
% 
% %input set
% params.U = zonotope([[0.01;0.01],diag([0.1;0.2])]); 
% 
% %initial set
% params.R0 = zonotope([[-1.9;-20],diag([0.005;0.3])]);
% % dimension of x
% options.dim_x=2;
% 
% %Number of trajectories
% initpoints=50;
% %Number of time steps
% steps=10;
% 
% %Totoal number of samples
% totalsamples = steps*initpoints;
% 
% %noise zonotope
% 
% 
% 
% 
% % Reachability Settings 
% 
% options.zonotopeOrder = 100;
% options.tensorOrder = 2;
% options.errorOrder = 5;
% 
% 
% % System Dynamics  
% fun = @(x,u) cstrDiscr(x,u,dt);
% 
% %input random sample points
% for i=1:totalsamples
%     u(:,i) = randPointExtreme(params.U);
% end
% 
% %get state trajectories
% x(:,1) = randPoint(params.R0);
% index=1;
% for j=1:options.dim_x:initpoints*options.dim_x
%     x(j:j+options.dim_x-1,1) = randPoint(params.R0);
%     for i=1:steps
%         x(j:j+options.dim_x-1,i+1) = fun(x(j:j+options.dim_x-1,i),u(:,index)) +randPoint(options.W);
%         index=index+1;
%     end
% end


% %combine trajectories
% index_0 =1;
% index_1 =1;
% for j=1:options.dim_x:initpoints*options.dim_x
%     for i=2:steps+1
%         x_meas_vec_1(:,index_1) = x(j:j+options.dim_x-1,i);
%         index_1 = index_1 +1;
%     end
%     for i=1:steps
%         x_meas_vec_0(:,index_0) = x(j:j+options.dim_x-1,i);
%         index_0 = index_0 +1;
%     end
% end


% X_+ is X_1T
% X_- is X_0T
% options.U_full = u(:,1:totalsamples);
% options.X_0T = x_meas_vec_0(:,1:totalsamples);
% options.X_1T = x_meas_vec_1(:,1:totalsamples);

% define system 
% sysDisc = nonlinearDT('stirredTankReactor',fun,dt,2,2);
% 
% 
% % Reachability Analysis ---------------------------------------------------
% % compute model based reachability (R) and data driven one (R_data)
% tic
% [R ,R_data]= reach_DT(sysDisc,params,options);
% tComp = toc;
% disp("Computation time: " + tComp);


%------------- END OF CODE --------------