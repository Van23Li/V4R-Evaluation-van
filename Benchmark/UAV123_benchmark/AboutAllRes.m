% 画出所有tracker的 error 和 overlap 表格进行比较，注意如下：
% - 需要和 .\util\configSeqs.m和 .\util\configTrackers 配合实现
% - 需要 .\perfMat\overall\ 里的aveSuccessRatePlot*.mat文件
% - 结果以excel形式进行保存
% by lfl

function AboutAllRes()
clear;
close all;

addpath('.\util\');

paperTitle = 'Scale_Material'; % 针对的会议或期刊名称和作者

%van: 切换三个数据集时只需分别注释即可
dataPath = 'D:\van\UAV123yang\Dataset_UAV123\UAV123\data_seq\UAV123';
annoPath = ['.\anno\', 'UAV123_10fps' , '\']; % % UAV123_10fps, UAV123, UAV20L
type = 'UAV123_10fps'; % % UAV123_10fps, UAV123, UAV20L

% dataPath = 'D:\Van\Matlab\Data_set\Dataset_UAV123\UAV123\data_seq\UAV123';
% annoPath = ['.\anno\', 'UAV123' , '\']; % % UAV123_10fps, UAV123, UAV20L
% type = 'UAV123';
% % 
% dataPath = 'D:\van\UAV123yang\Dataset_UAV123\UAV123\data_seq\UAV123';
% annoPath = ['.\anno\', 'UAV20L' , '\']; % % UAV123_10fps, UAV123, UAV20L
% type = 'UAV123_20L';

Res_path = ['.\dataAnaly\', paperTitle, '\AboutAllRes\'];
if ~exist(Res_path, 'dir')
    mkdir(Res_path);
end

% seqs = configSeqs(dataPath);
% trackers = configTrackers;
if strcmp(type, 'UAV123_10fps')
    seqs = configSeqs_10fps(dataPath);
    trackers = configTrackers_10fps;
elseif strcmp(type, 'UAV123')
    seqs = configSeqs_30fps(dataPath);
    trackers = configTrackers_30fps;
elseif strcmp(type, 'UAV123_20L')
    seqs = configSeqs_20L(dataPath);
    trackers = configTrackers_20L;
end

metricType = {'error', 'overlap'};
rankingType = {'threshold', 'AUC'}; % 排名分别维threshold，AUC
TrkIdx = {21, 11}; % 21代表20pixel处的error, 11代表0.5的overlap

%读入tracker 与 sequence 的名字
numSeq=length(seqs);
numTrk=length(trackers);

nameSeqAll=cell(numSeq,1);
for idxSeq=1:numSeq
    seq = seqs{idxSeq};
    nameSeqAll{idxSeq}=seq.name;
end

nameTrkAll=cell(numTrk,1);
for idxTrk=1:numTrk
    t = trackers{idxTrk};
    nameTrkAll{idxTrk}=t.namePaper;
end

for count = 1 : length(metricType)
    dataName=['.\perfMat\overall\aveSuccessRatePlot_' num2str(numTrk) 'alg_' metricType{count} '_OPE.mat'];
    result = Cal(dataName, nameSeqAll, nameTrkAll, rankingType{count}, TrkIdx{count});
    xlswrite([Res_path metricType{count} '_comp.xlsx'], result);
    fprintf('已生成%s表格，位置 %s\n', metricType{count}, [Res_path metricType{count} '_comp.xlxs'])
end
rmpath('.\util\');

function table = Cal(dataName, nameSeqAll, nameTrkAll, rankingType, TrkIdx)

allTrkSeqData = load(dataName);
allData = allTrkSeqData.aveSuccessRatePlot;

switch rankingType
    case 'threshold'
        temp1 = num2cell(allData(:,:,TrkIdx));
        temp = temp1';
    case 'AUC'
        for idxTrk=1:numel(nameTrkAll)
            tmp = allData(idxTrk, :, :);
            aa=reshape(tmp, [size(tmp, 2), size(tmp, 3)]);
            aa=aa(sum(aa,2)>eps,:);
            
            bb = mean(aa,2);
            temp(:, idxTrk) = bb;
        end
        temp = num2cell(temp);
end

tracker_name_set = nameTrkAll';     
result_up = [' ' tracker_name_set];
result_down = [nameSeqAll temp];
%{
表格形式：
' '   , 'trk1', ..., 'trkn'
'seq1', '1'   , ..., '0.9' 
'seq2', '0.9' , ..., '1'
%}
table = [result_up; result_down];
