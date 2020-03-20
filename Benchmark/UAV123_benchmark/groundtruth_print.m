close all;
clear, clc;
warning off all;
addpath('.\util\');


frame = '001412';%画哪一帧
seq_name = 'group3';
image_path = ['D:\van\UAV123_10fpsyang\Dataset_UAV123_10fps\UAV123_10fps\data_seq\UAV123_10fps\' seq_name '\' frame '.jpg'];
groungtruth_path = ['D:\van\UAV123_10fpsyang\Dataset_UAV123_10fps\UAV123_10fps\anno\UAV123_10fps\' seq_name '_3.txt'];


result = load('D:\V4R-Evaluation-master_new\Benchmark\UAV123_benchmark\results\results_OPE_UAV123_10fps\TSD_10fps_lr@0.0408_nu@0.201\group3_3_TSD_10fps_lr@0.0408_nu@0.201.mat');
groundtruth = load(groungtruth_path);
image = imread(image_path);
ownTrakerLineWidth = 4; % 自己的跟踪器线粗点
otherTrakcerLineWidth = 2;

plotDrawStyle = plotSetting();
groundtruth_pos = groundtruth(str2double(frame)-942,:);
tracker_pos = result.results{1}.res(str2double(frame)-942,:);
id = sprintf(frame);

imshow(image);
text(10, 15, ['#' id], 'Color','y', 'FontWeight','bold', 'FontSize',24);
hold on;
%画groundtruth
rectangle('Position', groundtruth_pos  , 'EdgeColor', plotDrawStyle{2}.color, 'LineWidth', otherTrakcerLineWidth ,'LineStyle',plotDrawStyle{2}.lineStyle);
%画自己的tracker
rectangle('Position', tracker_pos  , 'EdgeColor', plotDrawStyle{1}.color, 'LineWidth', ownTrakerLineWidth ,'LineStyle',plotDrawStyle{2}.lineStyle);