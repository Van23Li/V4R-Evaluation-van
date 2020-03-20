%根据实验结果，生成excel文件，便于画曲线图，进行分析
close all;
clear,clc;

paperTitle = 'ICRA19_LFL';     %改为自己的文件夹名
path = ['.\dataAnaly\',paperTitle,'\data_OPE'];
addpath(path);
cd(path);

data = load('Precision plots of OPE - Precision plots.mat');        %文件名可能没有对应
for i = 1 : size(data.rankingValues,2)
    A = data.rankingValues{1,i};
    data.rankingValues{1,i} = A(4:7);        %注意修改12，使得只保留最后的数字
end
result = data.rankingValues;
s = xlswrite('Precision.xlsx', result);
fprintf('已生成表格Precision.xlxs');
fprintf('\n');
close all;

data = load('Success plots of OPE - Success plots.mat');        %文件名可能没有对应
for i = 1 : size(data.rankingValues,2)
    A = data.rankingValues{1,i};
    data.rankingValues{1,i} = A(4:7);        %注意修改12，使得只保留最后的数字
end
result = data.rankingValues;
s = xlswrite('Success.xlsx', result);
fprintf('已生成表格Success.xlxs');
fprintf('\n');
close all;

cd('..\..\..');
rmpath(path);