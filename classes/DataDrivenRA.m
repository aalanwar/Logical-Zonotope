classdef DataDrivenRA < handle
    
    properties (Constant)

        %wfac = 10^-(2);
        %vfac = 10^-(5);
        
        wfac = 0.9;
        vfac = 10^-(2);
        dim_x = 2;
        %amount of noise added to the motion capture
        dataNoiseStateFactor = 0;
        dataNoiseInputFactor = 0;
    end
    
    
    properties
        thetaConstrain =0;
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
        A_con_log;
        B_con_log;
        carLogModel;
        options;
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
            datavector = [1:1000];
            %datavector = [1:100,300:450,900:1000];%[1:2:10,200:360,400:450,900:1000,2000:2100];%[1:2:10,400:450,900:1000,2000:2100];
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
        end
        % get closest input to time for rigid body
        function [angleAndVelocity, latency] = getClosetInput(obj, time)
            %idxs = obj.mocaplogs(:,2) == rb;
            [t, c] = min(abs(obj.inputlogsRA(:,3)-time));
            angleAndVelocity = obj.inputlogsRA(c(1),[2,5]);
            latency = t(1);
        end
        
        function skipTime(obj, tskip)
            meas1 = obj.getNextMeasurement();
            t1 = meas1.getTime();
            t_now = t1;
            while t_now - t1 < tskip
                meas = obj.getNextMeasurement();
                if isempty(meas)
                    break;
                end
                t_now = meas.getTime();
            end 
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
            R_data =R_data_struct.timePoint.set;
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
          R_data{1} = R0;
            for i = 1:steps
                R_data{i+1} = obj.MsigmaCMZ * cartProd(R_data{i},conZonotope(obj.U)) + conZonotope(obj.W) ;%+obj.ZL;
                %R_data{i+1} = obj.Msigma * cartProd(R_data{i},obj.U) + obj.W ;
               
            end
        end
        function Rout =  reachHlinearCZ(obj,R0,t_last,x1,y1,heading)
            
            if obj.thetaConstrain ==1
                fac = 0.3;
                theta = 30;
                x2 = x1+fac * cosd(heading*180/pi - theta);
                y2 = y1+fac * sind(heading*180/pi - theta);
                              
                x3 = x1+fac * cosd(heading*180/pi + theta);
                y3 = y1+fac * sind(heading*180/pi + theta);
                fac2 = 0.3*sind(180-2*theta)/sind(theta);
                x4= x1+fac2*cosd(heading*180/pi);
                y4= y1+fac2*sind(heading*180/pi);
                m1= (y2-y1)/(x2-x1);
                c1 = -m1*x1 +y1 ;
                m2 = (y3-y1)/(x3-x1);
                c2 = -m2*x1 +y1 ;
                
                m3 = (y4-y2)/(x4-x2);
                c3 = -m3*x2 +y2 ;
                m4 = (y3-y4)/(x3-x4);
                c4 = -m4*x3 +y3 ;                
            end
            
            if t_last<=24%20.8
                h{1} = [1 0];
                r{1} = 1.7175;
                y{1}= 0.2805;
                fimplicit(@(x11,x22) abs(h{1}*[x11;x22] - y{1})-r{1},'-.b')
                h{2} = [0 1];
                r{2} = 2.429;%1.504;
                y{2} = 0.839;%0.839;
                fimplicit(@(x11,x22) abs(h{2}*[x11;x22] - y{2})-r{2},'-.b')

               if obj.thetaConstrain ==1
                h{3}= [-m3  1]; %or m2
                r{3} = abs((c2-c3)/2);
                y{3} = ((c2+c3)/2);
                h{4}= [-m4  1]; %or m1
                r{4} = abs((c1-c4)/2);
                y{4} = ((c1+c4)/2);
               end
               % plot(x2,y2,'*')
               % plot(x3,y3,'*')
               % plot(x4,y4,'*')
                % fimplicit(@(x11,x22) abs(h{3}*[x11;x22] - y{3})-r{3},'-.*b')
               % fimplicit(@(x11,x22) abs(h{4}*[x11;x22] - y{4})-r{4},'-.*b')
               Rout =intersectConZonoStrip1(conZonotope(R0),h,r,y);
               %Rout = intersectZonoStrip(R0,h,r,y);
            elseif t_last<=25
                h{1} = [1 0];
                r{1} = 1.7175;
                y{1}= 0.2805;
                fimplicit(@(x11,x22) abs(h{1}*[x11;x22] - y{1})-r{1},'-.b')
                h{2} = [0 1];
                r{2} = 2.429;%1.504;
                y{2} = 0.839;%0.839;
                fimplicit(@(x11,x22) abs(h{2}*[x11;x22] - y{2})-r{2},'-.b')

                h{3} = [1 0];
                r{3} = 1.3045;
                y{3}= -0.3225;
                fimplicit(@(x11,x22) abs(h{3}*[x11;x22] - y{3})-r{3},'-.b')
                h{4} = [0 1];
                r{4} = 0.453;%1.504;
                y{4} = -1.137;%0.839;
                fimplicit(@(x11,x22) abs(h{4}*[x11;x22] - y{4})-r{4},'-.b')                
               if obj.thetaConstrain ==1
                h{5}= [-m3  1]; %or m2
                r{5} = abs((c2-c3)/2);
                y{5} = ((c2+c3)/2);
                h{6}= [-m4  1]; %or m1
                r{6} = abs((c1-c4)/2);
                y{6} = ((c1+c4)/2);
               end
               % plot(x2,y2,'*')
               % plot(x3,y3,'*')
               % plot(x4,y4,'*')
                % fimplicit(@(x11,x22) abs(h{3}*[x11;x22] - y{3})-r{3},'-.*b')
               % fimplicit(@(x11,x22) abs(h{4}*[x11;x22] - y{4})-r{4},'-.*b')
               Rout =intersectConZonoStrip1(conZonotope(R0),h,r,y);                
                
            else   
                h{1} = [0 1];
                r{1} = 1;
                y{1}= -1.665;
%                 h{1} = [0 1];
%                 r{1} = 1.0825;
%                 y{1}= -1.5825;
                 fimplicit(@(x11,x22) abs(h{1}*[x11;x22] - y{1})-r{1},'-.b')
                
                if obj.thetaConstrain ==1
                h{2}= [-m3  1]; %or m2
                r{2} = abs((c2-c3)/2);
                y{2} = ((c2+c3)/2);
                h{3}= [-m4  1]; %or m1
                r{3} = abs((c1-c4)/2);
                y{3} = ((c1+c4)/2); 
                end
                Rout =intersectConZonoStrip1(conZonotope(R0),h,r,y);
                %Rout = intersectZonoStrip(R0,h,r,y);
            end
            
        end

         function Rout =  reachHlinearZono(obj,R0,t_last,x1,y1,heading)
             
            if obj.thetaConstrain ==1
                fac = 0.3;
                theta = 30;
                x2 = x1+fac * cosd(heading*180/pi - theta);
                y2 = y1+fac * sind(heading*180/pi - theta);
                              
                x3 = x1+fac * cosd(heading*180/pi + theta);
                y3 = y1+fac * sind(heading*180/pi + theta);
                fac2 = 0.3*sind(180-2*theta)/sind(theta);
                x4= x1+fac2*cosd(heading*180/pi);
                y4= y1+fac2*sind(heading*180/pi);
                m1= (y2-y1)/(x2-x1);
                c1 = -m1*x1 +y1 ;
                m2 = (y3-y1)/(x3-x1);
                c2 = -m2*x1 +y1 ;
                
                m3 = (y4-y2)/(x4-x2);
                c3 = -m3*x2 +y2 ;
                m4 = (y3-y4)/(x3-x4);
                c4 = -m4*x3 +y3 ;                
            end
            
            if t_last<=24%20.8
                h{1} = [1 0];
                r{1} = 1.7175;
                y{1}= 0.2805;
                fimplicit(@(x11,x22) abs(h{1}*[x11;x22] - y{1})-r{1},'-.b')
                h{2} = [0 1];
                r{2} = 2.429;%1.504;
                y{2} = 0.839;%0.839;
                fimplicit(@(x11,x22) abs(h{2}*[x11;x22] - y{2})-r{2},'-.b')

               if obj.thetaConstrain ==1
                h{3}= [-m3  1]; %or m2
                r{3} = abs((c2-c3)/2);
                y{3} = ((c2+c3)/2);
                h{4}= [-m4  1]; %or m1
                r{4} = abs((c1-c4)/2);
                y{4} = ((c1+c4)/2);
               end
               % plot(x2,y2,'*')
               % plot(x3,y3,'*')
               % plot(x4,y4,'*')
                % fimplicit(@(x11,x22) abs(h{3}*[x11;x22] - y{3})-r{3},'-.*b')
               % fimplicit(@(x11,x22) abs(h{4}*[x11;x22] - y{4})-r{4},'-.*b')
               Rout = intersectZonoStrip(R0,h,r,y);
               %Rout = intersectZonoStrip(R0,h,r,y);
            elseif t_last<=25
                h{1} = [1 0];
                r{1} = 1.7175;
                y{1}= 0.2805;
                fimplicit(@(x11,x22) abs(h{1}*[x11;x22] - y{1})-r{1},'-.b')
                h{2} = [0 1];
                r{2} = 2.429;%1.504;
                y{2} = 0.839;%0.839;
                fimplicit(@(x11,x22) abs(h{2}*[x11;x22] - y{2})-r{2},'-.b')

                h{3} = [1 0];
                r{3} = 1.3045;
                y{3}= -0.3225;
                fimplicit(@(x11,x22) abs(h{3}*[x11;x22] - y{3})-r{3},'-.b')
                h{4} = [0 1];
                r{4} = 0.453;%1.504;
                y{4} = -1.137;%0.839;
                fimplicit(@(x11,x22) abs(h{4}*[x11;x22] - y{4})-r{4},'-.b')                
               if obj.thetaConstrain ==1
                h{5}= [-m3  1]; %or m2
                r{5} = abs((c2-c3)/2);
                y{5} = ((c2+c3)/2);
                h{6}= [-m4  1]; %or m1
                r{6} = abs((c1-c4)/2);
                y{6} = ((c1+c4)/2);
               end
               % plot(x2,y2,'*')
               % plot(x3,y3,'*')
               % plot(x4,y4,'*')
                % fimplicit(@(x11,x22) abs(h{3}*[x11;x22] - y{3})-r{3},'-.*b')
               % fimplicit(@(x11,x22) abs(h{4}*[x11;x22] - y{4})-r{4},'-.*b')
               %Rout =intersectConZonoStrip1(conZonotope(R0),h,r,y);
               Rout = intersectZonoStrip(R0,h,r,y);
            else
                h{1} = [0 1];
                r{1} = 1;
                y{1}= -1.665;
%                 h{1} = [0 1];
%                 r{1} = 1.0825;
%                 y{1}= -1.5825;
                 fimplicit(@(x11,x22) abs(h{1}*[x11;x22] - y{1})-r{1},'-.b')
                
                if obj.thetaConstrain ==1
                h{2}= [-m3  1]; %or m2
                r{2} = abs((c2-c3)/2);
                y{2} = ((c2+c3)/2);
                h{3}= [-m4  1]; %or m1
                r{3} = abs((c1-c4)/2);
                y{3} = ((c1+c4)/2); 
                end
                %Rout =intersectConZonoStrip1(conZonotope(R0),h,r,y);
                Rout = intersectZonoStrip(R0,h,r,y);
            end
            
        end

        function Rout =  reachHRound(obj,R0,t_last,x1,y1,heading)
            % has no effect if the h does not have u
            optionsh.U = obj.U;
            optionsh.p.u = center(optionsh.U) ;%+ options.uTrans;
            %linearization point p.x and p.y
            optionsh.p.x = center(R0);
            
            % dimension of x
            optionsh.dim_x=2;
            optionsh.dim_f=1;
            optionsh.method='radius';%'svd';%'radius';%'normGen',volume;
            optionsh.reductionTechnique = 'girard';
            
            % Reachability Settings
            optionsh.zonotopeOrder = 100;
            optionsh.tensorOrder = 1;
            optionsh.errorOrder =100;
            dt = 0.05; %not used
            %             str = ['hdynamics = @(x,u)', benchmark, '(x,u);'];
            %             eval(str);
            if t_last<=4.2
                
                h{1} = [0 1];
                r{1} =1;
                y{1}= 2.25;
                 fimplicit(@(x11,x22) abs(h{1}*[x11;x22] - y{1})-r{1},'-.r')
                
                %Rout =intersectConZonoStrip1(conZonotope(R0),h,r,y);
                Rout = intersectZonoStrip(R0,h,r,y);                
                
            elseif t_last<= 10.5  
                
                optionsh.dim_h=1;
                optionsh.fun =@(x,u) hRound(x,u);
                hDisc = nonlinearDT('hRound',optionsh.fun,dt,optionsh.dim_x,2,1);
                %a=[0.3225;0.2175];
                %a=[0.09];
                a=[1.429319]^2;
                fimplicit(@(x1,x2) abs(hRound([x1,x2],0))-a,'-.b')
                Rout = intersectNonLinearH(hDisc,a,R0,optionsh);
               % 
%                 optionsh.fun =@(x,u) hNonLinear12(x,u);
%                 hDisc = nonlinearDT('hnon12',optionsh.fun,dt,optionsh.dim_x,2,1);
%                 %a=[0.3225;0.2175];
%                 %a=[0.09];
%                 a=[0.2175];
%                 Rout = intersectCZNonLinearH(hDisc,a,Rout1,optionsh);
               % [Rout]= intersectNonLinearH(hDisc,a,R0,optionsh);
            else%if %t_last<=29
                h{1} = [0 1];
                r{1} = 1;
                y{1} = -2.1694;
                 fimplicit(@(x11,x22) abs(h{1}*[x11;x22] - y{1})-r{1},'-.r')
                
                %Rout =intersectConZonoStrip1(conZonotope(R0),h,r,y);
                Rout = intersectZonoStrip(R0,h,r,y);  
%             else
%                 Rout = R0;
            end

        end
        
       function Rout =  reachHRoundCZ(obj,R0,t_last,x1,y1,heading)
            % has no effect if the h does not have u
            optionsh.U = obj.U;
            optionsh.p.u = center(optionsh.U) ;%+ options.uTrans;
            %linearization point p.x and p.y
            optionsh.p.x = center(R0);
            
            % dimension of x
            optionsh.dim_x=2;
            optionsh.dim_f=1;
            optionsh.method='radius';%'svd';%'radius';%'normGen',volume;
            optionsh.reductionTechnique = 'girard';
            
            % Reachability Settings
            optionsh.zonotopeOrder = 100;
            optionsh.tensorOrder = 1;
            optionsh.errorOrder =100;
            dt = 0.05; %not used
            %             str = ['hdynamics = @(x,u)', benchmark, '(x,u);'];
            %             eval(str);
            if t_last<=4.2
                
                h{1} = [0 1];
                r{1} = 1;
                y{1} = 2.25;
                 fimplicit(@(x11,x22) abs(h{1}*[x11;x22] - y{1})-r{1},'-.b')
                
                Rout =intersectConZonoStrip1(conZonotope(R0),h,r,y);
                %Rout = intersectZonoStrip(R0,h,r,y);                
                
            elseif t_last<= 10.5  
                
                optionsh.dim_h=1;
                optionsh.fun =@(x,u) hRound(x,u);
                hDisc = nonlinearDT('hRound',optionsh.fun,dt,optionsh.dim_x,2,1);
                %a=[0.3225;0.2175];
                %a=[0.09];
                a=[1.429319]^2;
                fimplicit(@(x1,x2) abs(hRound([x1,x2],0))-a,'-.b')
                Rout = intersectCZNonLinearH(hDisc,a,conZonotope(R0),optionsh);
                %Rout = intersectNonLinearH(hDisc,a,R0,optionsh);
               % 
%                 optionsh.fun =@(x,u) hNonLinear12(x,u);
%                 hDisc = nonlinearDT('hnon12',optionsh.fun,dt,optionsh.dim_x,2,1);
%                 %a=[0.3225;0.2175];
%                 %a=[0.09];
%                 a=[0.2175];
%                 Rout = intersectCZNonLinearH(hDisc,a,Rout1,optionsh);
               % [Rout]= intersectNonLinearH(hDisc,a,R0,optionsh);
            else%if t_last<=29
                h{1} = [0 1];
                r{1} =1;
                y{1}= -2.1694;
                 fimplicit(@(x11,x22) abs(h{1}*[x11;x22] - y{1})-r{1},'-.b')
                
                Rout =intersectConZonoStrip1(conZonotope(R0),h,r,y);
                %Rout = intersectZonoStrip(R0,h,r,y);  
%             else
%                 Rout = R0;
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