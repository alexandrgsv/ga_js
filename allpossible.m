domains;

%the upper bound is initialized with zeros, than updated with domains
%lengths in the cycle
ub=zeros(1,ndomains);

for c=1:ndomains
    eval(strcat('curr_d=d',int2str(c),';'));
    ub(c)=length(curr_d);
end
cd .. ;
! node . run-service-1 
cd ./abc ;
if isfile('../output/service-1/result.json')
    delete '../output/service-1/result.json'
end
! rm -r ../output/results
! mkdir ../output/results

for c=1:ndomains
    eval(strcat('curr_d=d',int2str(c),';'));
    ub(c)=length(curr_d);
end

A=1111111111;


B=0;
k=0;
while A<=2321133211
    test=1;
    
    for p=1:ndomains

        As=num2str(A);
        Asp=As(p);
        Asp=str2double(Asp);
        if Asp>ub(p)
           for j=p:ndomains
               As(j)='1';
           end
           A=str2double(As);
           A=A+10^(ndomains-p+1);
             test=0;
        end
        
    end
    if test == 1
        k=k+1;
        B(k)=A;
          disp(num2str(A));
          A=A+1;
    end
end

best_quality=Inf;
best_variance=Inf;
solution=num2str(B(1));

for i=1:length(B)
    [quality, variance]=mean_penaltyJS(num2str(B(i)));
%     if ((quality-best_quality) > 0.01) && (variance < best_variance)
    if quality<best_quality 
        best_variance=variance;
        best_quality=quality;
        solution=num2str(B(i));
    end
end

best_quality
solution
    