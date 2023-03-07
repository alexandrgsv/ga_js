cd ./generations
gen_n = 0;
x = load(strcat('gen_',sprintf('%04d', gen_n),'.mat'));
gen_n = 1;
while isfile(strcat('gen_',sprintf('%04d', gen_n),'.mat')) 
        y = load(strcat('gen_',sprintf('%04d', gen_n),'.mat'));
        x.Population_gen = [x.Population_gen; y.Population_gen];
        x.Score_gen = [x.Score_gen; y.Score_gen];
        gen_n = gen_n +1;
end
cd ../

x.Population_gen = [x.Population_gen, x.Score_gen];
writematrix(x.Population_gen, 'populations.csv');