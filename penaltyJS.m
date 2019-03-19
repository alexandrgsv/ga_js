function penalty=penaltyJS(varg)
    domains;
    individual(ndomains)=jsfunc;
    for c=1:ndomains
        eval(strcat('individual(c)=d',int2str(c),'(',int2str(varg(c)),');'));
    end

    jsonoutput=strcat('{"functions": { "service-1": ',jsonencode(individual),"}}");
    fid = fopen('../config/functions.json','wt');
    fprintf(fid,jsonoutput);
    fclose(fid);
    
    disp ('Next individual starting...');
    tic;
    delete '../output/service-1/result.json';

    %execute the external evaluator and wait for the results
    %to compute the penalty
    
    cd .. ;
    ! node . run-service-1
    cd ./ga ;
    while 1
        if isfile('../output/service-1/result.json')
            break
        end
    end
    
    result = jsondecode(fileread('../output/service-1/result.json'));
    toc
    
    penalty=result.execution.hrtime;
end