%����ʵ����������excel�ļ������ڻ�����ͼ�����з���
close all;
clear,clc;

paperTitle = 'Scale_Material';     %��Ϊ�Լ����ļ�����
path = ['.\dataAnaly\',paperTitle,'\data_OPE'];
addpath(path);
cd(path);

data = load('Precision plots of OPE - Precision plots.mat');        %�ļ�������û�ж�Ӧ
for i = 1 : size(data.rankingValues,2)
    A = data.rankingValues{1,i};
    data.rankingValues{1,i} = A(end-3:end);        %ע���޸�12��ʹ��ֻ������������
end
result = data.rankingValues;
s = xlswrite('Precision.xlsx', result);
fprintf('�����ɱ��Precision.xlxs');
fprintf('\n');
close all;

data = load('Success plots of OPE - Success plots.mat');        %�ļ�������û�ж�Ӧ
for i = 1 : size(data.rankingValues,2)
    A = data.rankingValues{1,i};
    data.rankingValues{1,i} = A(end-3:end);        %ע���޸�12��ʹ��ֻ������������
end
result = data.rankingValues;
s = xlswrite('Success.xlsx', result);
fprintf('�����ɱ��Success.xlxs');
fprintf('\n');
close all;

cd('..\..\..');
rmpath(path);