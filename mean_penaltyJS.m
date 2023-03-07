function [penalty variance]=mean_penaltyJS(varg)
    domains;
    persistent last_result_time
    if isempty(last_result_time)
        last_result_time = 0;
    end

    persistent indnumber
    if isempty(indnumber)
        indnumber = 1;
    end

    disp ('Next individual starting...')
    disp (indnumber);
    tic;
  

    %wait for the results
    %to compute the penalty
    
    for i=1:5
        individual(ndomains)=jsfunc;
        for c=1:ndomains
            eval(strcat('individual(c)=d',int2str(c),'(',varg(c),');'));
        end
        
        jsonoutput=strcat('{"functions": { "service-1": ',jsonencode(individual),"}}");
        fid = fopen('../config/functions.json','wt');
        fprintf(fid,jsonoutput);
        fclose(fid);
        while 1
            if isfile('../output/service-1/result.json')
                try
                    %                 !cp ../output/service-1/result.json ../output/service-1/result_r.json
                    copyfile('../output/service-1/result.json','../output/service-1/result_r.json');
                    copyfile('../output/service-1/result_r.json',strcat('../output/results/result',int2str(last_result_time),'.json'));
                    %                 disp('trying...');
                    result(i) = jsondecode(fileread('../output/service-1/result_r.json'));
                    %                 pause(0.5);
                    %                 delete '../output/service-1/result_r.json';
                    %                 disp('did it...');
                catch
                    continue
                end
                if result(i).time > last_result_time
                    last_result_time=result(i).time;
                    delete '../output/service-1/result.json'
                    break;
                end
            end
        end
    end
    toc
    
    fis=readfis('StackQual');

    
    for i=1:5
        
        ex=result(i).execution;
%         init=result(i).initialization;
        
        norm=[100000; 10000; 10000000;10000000;10000000; 1000000; 100000000; 10000; 10000; 1000000; 1000000; 1000000; 100; 100000000];
%         weights=[0.07; 0.08; 0.07; 0.07; 0.07; 0.07; 0.07; 0.07; 0.07; 0.07; 0.08; 0.07; 0.07; 0.07];
%         res=weights(1)*init.cpuUsage.user/norm(1)+weights(2)*init.cpuUsage.system/norm(2) + ...
%             weights(3)*init.memoryUsage.rss/norm(3)+weights(4)*init.memoryUsage.heapTotal/norm(4)+...
%             weights(5)*init.memoryUsage.heapUsed/norm(5)+weights(6)*init.memoryUsage.external/norm(6)+...
%             weights(7)*init.hrtime/norm(7)+...
%             weights(8)*ex.cpuUsage.user/norm(8)+weights(9)*ex.cpuUsage.system/norm(9) + ...
%             weights(10)*ex.memoryUsage.rss/norm(10)+weights(11)*ex.memoryUsage.heapTotal/norm(11)+...
%             weights(12)*ex.memoryUsage.heapUsed/norm(12)+weights(13)*ex.memoryUsage.external/norm(13)+...
%             weights(14)*ex.hrtime/norm(14);
%         t(i)=ex.hrtime/norm(14);
%         cpu(i)=ex.cpuUsage.user/norm(8);
%         ram(i)=ex.memoryUsage.rss/norm(10);
        
        res=evalfis([ex.hrtime/norm(14) ex.cpuUsage.user/norm(8) ex.memoryUsage.rss/norm(10)], fis);
        fitness(i)=res;
    end
    
%     if var(t)>0.03 || var(cpu) > 0.03 || var (ram) >0.03
%         penalty=0;
%     else
%         penalty=evalfis([mean(t) mean(cpu) mean(ram)],fis);
%     end
%     
    disp(var(fitness));
    penalty=mean(fitness);
    variance = var(fitness);
    indnumber=indnumber+1;
    
        
  
  
  
end