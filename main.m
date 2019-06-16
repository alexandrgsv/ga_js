%(c) Aleksandr Gusev (alexandrgsv@gmail.com) 2019

%% Clean it up

clear;
clc;

%% Read the domains of functions (alternatives) from domains.m;

domains;

%% Start with the default options
options = optimoptions('ga');
%% Modify options setting
options = optimoptions(options);
options.Display = 'iter';
options.MaxGenerations = 100;
options.MaxStallGenerations=10;
options.PopulationSize=20;
options.EliteCount=1;
options.FunctionTolerance=0.01;
options.PlotFcn = @gaplotbestf;
options.SelectionFcn=@selectionstochunif;

%% Define lower and upper bounds

%lower bound is 1 for all domains as the first function is first
lb=ones(1,ndomains);

%the upper bound is initialized with zeros, than updated with domains
%lengths in the cycle
ub=zeros(1,ndomains);
%integer parameters are specified as intcons vector
%it seems so far that all the parameters are integers (function numbers)
intcon=zeros(1,ndomains);
for c=1:ndomains
    eval(strcat('curr_d=d',int2str(c),';'));
    ub(c)=length(curr_d);
    intcon(c)=c;
end
cd .. ;
! node . run-service-1 
cd ./ga ;
if isfile('../output/service-1/result.json')
    delete '../output/service-1/result.json'
end
! rm -r ../output/results
! mkdir ../output/results
clk1=clock;

%% Start the ga
[x,fval,exitflag,output,population,score] = ...
ga(@penaltyJS,ndomains,[],[],[],[],lb,ub,[],intcon,options);

disp(clock-clk1);

