close all;
clear all;
fileFolder=fullfile('D:\Van\Matlab\V4R-Evaluation-van\Benchmark\UAV123_benchmark\results\results_OPE_UAV123_10fps\TSD_10fps3\*D_10fps3.mat');
% dirOutput=dir(fullfile(fileFolder,'.mat'));
dirOutput=dir(fileFolder);
fileNames={dirOutput.name};
for i=1:size(fileNames,2)
    load(['D:\Van\Matlab\V4R-Evaluation-van\Benchmark\UAV123_benchmark\results\results_OPE_UAV123_10fps\TSD_10fps3\',fileNames{i}]);
    save(['D:\Van\Matlab\V4R-Evaluation-van\Benchmark\UAV123_benchmark\results\results_OPE_UAV123_10fps\TSD_10fps3\',fileNames{i}(1:end-5),'.mat'],'results');
end