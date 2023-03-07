% this file is to define sets of functions to call
% all functions are grouped in domains d1, d2, d3, d4,...dn
% where n - is the dimension of the domains set D=[d1, d2, ...., dn]
% each function in the same domain is an alternative to all other functions
% in that domain. The solution to evaluate is an individual combination of particular
% elements (functions) from all the domains. the length of the domain is used
% as the upper bound for the genetic algorithm on the variable representing
% the domain

% for example: solution1 = [d1(23), d2(1), d3(2), ...., dn(1)],
% solution2 = [A(46), B(2), C(14),....,Z(8)]

% (c) Aleksandr Gusev (alexandrgsv@gmail.com), 2019


%read the alternatives.json

alternatives=jsondecode(fileread('alternatives.json'));



%define the members of D:

domain_names=fieldnames(alternatives);

ndomains=numel(domain_names);

for c=1:ndomains
    eval(strcat('nalternatives=numel(alternatives.',char(domain_names(c)),');'));
    eval(strcat('d',int2str(c),'(',int2str(nalternatives),')=jsfunc;'));
    for r=1:nalternatives
        eval(strcat('d',int2str(c),'(',int2str(r),').name=alternatives.',char(domain_names(c)),'(',int2str(r),').name;'));
        eval(strcat('d',int2str(c),'(',int2str(r),').parameters=alternatives.',char(domain_names(c)),'(',int2str(r),').parameters;'));
        eval(strcat('d',int2str(c),'(',int2str(r),').path=alternatives.',char(domain_names(c)),'(',int2str(r),').path;'));
    end
end