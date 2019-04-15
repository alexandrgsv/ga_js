function penalty=penaltyJS(varg)
    domains;
    persistent last_result_time
    if isempty(last_result_time)
        last_result_time = 0;
    end

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
  

    %wait for the results
    %to compute the penalty
    
    while 1
        if isfile('../output/service-1/result.json')
            try
                %                 !cp ../output/service-1/result.json ../output/service-1/result_r.json
                copyfile('../output/service-1/result.json','../output/service-1/result_r.json');
                copyfile('../output/service-1/result_r.json',strcat('../output/results/result',int2str(last_result_time),'.json'));
                %                 disp('trying...');
                result = jsondecode(fileread('../output/service-1/result_r.json'));
                delete '../output/service-1/result_r.json';
                %                 disp('did it...');
            catch
                continue
            end
            if result.time > last_result_time
                last_result_time=result.time;
                break;
            end
        end
    end
    toc
    %for convenience
    ex=result.execution;
    init=result.initialization;

% 
%     penalty=init.cpuUsage.user/1000000+init.cpuUsage.system/1000000 + ...
%       init.memoryUsage.rss/100000000+init.memoryUsage.heapTotal/100000000+...
%       init.memoryUsage.heapUsed/100000000+init.memoryUsage.external/10000000+...
%       init.hrtime/10000000000+...
%       ex.cpuUsage.user/1000+ex.cpuUsage.system/1000 + ...
%       ex.memoryUsage.rss/100000+ex.memoryUsage.heapTotal/100000+...
%       ex.memoryUsage.heapUsed/100000+ex.memoryUsage.external/100+...
%       ex.hrtime/1000000;
      res=init.cpuUsage.user/10000+init.cpuUsage.system/10000 + ...
      init.memoryUsage.rss/1000000+init.memoryUsage.heapTotal/1000000+...
      init.memoryUsage.heapUsed/1000000+init.memoryUsage.external/100000+...
      init.hrtime/100000000+...
      ex.cpuUsage.user/1000+ex.cpuUsage.system/1000 + ...
      ex.memoryUsage.rss/100000+ex.memoryUsage.heapTotal/100000+...
      ex.memoryUsage.heapUsed/100000+ex.memoryUsage.external/100+...
      ex.hrtime/1000000;
  
      penalty=round(res/3)/10;
  

        
  
  
  
end