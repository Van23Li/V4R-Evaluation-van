clear
close all;
clc;

addpath('.\util\');
addpath('.\rstEval\');

dataPath = 'D:\Van\Matlab\Data_set\UAVDT\data_seq\';
annoPath = '.\anno\';
attPath = [annoPath, 'att\']; % The folder that contains the annotation files for sequence attributes

% 可选项
paperTitle = 'Scale_Material'; % 针对的会议或期刊名称和作者

saveOverallPerfPlot = true; % true:保存overall performance的图, false:不保存
AttPerfPlot = true; % true:计算att performace并绘图, false:不绘图
saveAttPerfPlot = true; % true:保存att performance的图, false:不保存

% figWidth = 800; % 图片宽度
% figHeight = 510; % 图片高度

% %3x2
% figWidth = 800; % 图片宽度
% figHeight = 480; % 图片高度

% %IROS overall
% figWidth = 1000; % 图片宽度
% figHeight = 480; % 图片高度

% %IROS attribution
% figWidth = 1900; % 图片宽度
% figHeight = 445; % 图片高度

%ECCV overall
figWidth = 900; % 图片宽度
figHeight = 650; % 图片高度

numTrkThre = 20; % 若比较的跟踪器数量超过numTrkThre，
heightIntv = 8; % 则每多一个跟踪器，图片高度要增加heightIntv

metricTypeSet = {'error', 'overlap'}; %overlap, error
evalTypeSet = {'OPE'}; % 'SRE', 'OPE'

% OTB100
% attName = {'background clutter','camera motion','object motion','small object','illumination variations','object blur','scale variations','long-term tracking','large occlusion'};
% attFigName = {'background_clutter','camera_motion','object_motion','small_object','illumination_variations','object_blur','scale_variations','long-term_tracking','large_occlusion'};

% UAVDT
attName = {'Background clutter','Camera motion','Object motion','Small object','Illumination variations','Object blur','Scale variations','Long-term tracking','Large occlusion'};
attFigName = {'Background_clutter','Camera_motion','Object_motion','Small_object','Illumination_variations','Object_blur','Scale_variations','Long_term_tracking','Large_occlusion'};

plotDrawStyleAll = plotSetting;
plotDrawStyle10={   struct('color',[1,0,0],'lineStyle','-'),...
    struct('color',[0,1,0],'lineStyle','--'),...
    struct('color',[0,0,1],'lineStyle',':'),...
    struct('color',[0,0,0],'lineStyle','-'),...%    struct('color',[1,1,0],'lineStyle','-'),...%yellow
    struct('color',[1,0,1],'lineStyle','--'),...%pink
    struct('color',[0,1,1],'lineStyle',':'),...
    struct('color',[0.5,0.5,0.5],'lineStyle','-'),...%gray-25%
    struct('color',[136,0,21]/255,'lineStyle','--'),...%dark red
    struct('color',[255,127,39]/255,'lineStyle',':'),...%orange
    struct('color',[0,162,232]/255,'lineStyle','-'),...%Turquoise
    };

seqs = configSeqs(dataPath);
trackers = configTrackers;

numSeq = length(seqs);
numTrk = length(trackers);

nameTrkAll = cell(numTrk,1);
for idxTrk = 1:numTrk
    t = trackers{idxTrk};
    nameTrkAll{idxTrk}=t.namePaper;
end

nameSeqAll = cell(numSeq,1);
numAllSeq = zeros(numSeq,1);

att = zeros(numSeq,length(attName));
for idxSeq = 1:numSeq
    s = seqs{idxSeq};
    nameSeqAll{idxSeq} = s.name;
    
    s.len = s.endFrame - s.startFrame + 1;
    numAllSeq(idxSeq) = s.len;
    att(idxSeq,:) = load([attPath s.name '_att.txt']);
end

attNum = size(att,2);

perfMatPath = '.\perfMat\overall\'; % 画图数据

rankNum = 33; % max number of plots to show，因为颜色设置里面最多33种线型

if rankNum == 10
    plotDrawStyle = plotDrawStyle10;
else
    plotDrawStyle = plotDrawStyleAll;
end

thresholdSetOverlap = 0:0.05:1;
thresholdSetError = 0:50;

for i=1:length(metricTypeSet)
    metricType = metricTypeSet{i};%error,overlap
    
    switch metricType
        case 'error'
            thresholdSet = thresholdSetError;
            rankIdx = 21;
            xLabelName = 'Location error threshold';
            yLabelName = 'Precision';
            rankingType = 'threshold';% 排名依据: AUC, threshold
        case 'overlap'
            thresholdSet = thresholdSetOverlap;
            rankIdx = 11;
            xLabelName = 'Overlap threshold';
            yLabelName = 'Success rate';
            rankingType = 'AUC'; % 排名依据: AUC, threshold
    end
    
    if(strcmp(metricType,'error') && strcmp(rankingType,'AUC'))
        continue;
    end
    
    tNum = length(thresholdSet);
    
    for j = 1:length(evalTypeSet)
        
        evalType = evalTypeSet{j};%SRE, TRE, OPE
        
        plotType = [metricType '_' evalType];
        
        switch metricType
            case 'overlap'
                titleName = ['Success plots of ' evalType ' - ' 'Success plots'];
            case 'error'
                titleName = ['Precision plots of ' evalType ' - ' 'Precision plots'];
        end
        
        dataName = [perfMatPath 'aveSuccessRatePlot_' num2str(numTrk) 'alg_'  plotType '.mat'];
        
        % If the performance Mat file, dataName, does not exist, it will call
        % genPerfMat to generate the file.
        if(~exist(dataName, 'file'))
            genPerfMat(seqs, trackers, evalType, nameTrkAll, perfMatPath, annoPath);
        end
        
        load(dataName);
        numTrk = size(aveSuccessRatePlot,1);
        
        if rankNum > numTrk || rankNum <0
            rankNum = numTrk;
        end
        
        idxSeqSet = 1:length(seqs);
        
        figsPath = ['.\dataAnaly\', paperTitle, '\figs_', evalTypeSet{j}, '\']; % Data Analysis
        if ~exist(figsPath,'dir')
            mkdir(figsPath);
        end
        
        titleNameTosave = [metricTypeSet{i}, '_', evalTypeSet{j}];
        figsNameTosave = [figsPath titleNameTosave];
                
        % 设置图片大小
        if numTrk <= numTrkThre
            figSize = [0 0 figWidth figHeight];
        else
            figHeight_2 = figHeight + (heightIntv * numTrk - numTrkThre);
            figSize = [0 0 figWidth figHeight_2];
        end
        
        % draw and save the overall performance plot
        figure;
        plotDrawSave(numTrk,plotDrawStyle,aveSuccessRatePlot,idxSeqSet,rankNum,rankingType,rankIdx,nameTrkAll,thresholdSet,titleName, xLabelName,yLabelName,paperTitle,evalType);
        set(gcf, 'position', figSize);
%         axis([0 50 0 0.85]);
        tightfig; % 去除图片白边
        if saveOverallPerfPlot == true
            print(gcf, '-dpdf', [figsNameTosave, '.pdf']); % 保存成 pdf
%             saveas(gcf, [figsNameTosave, '.png']); % 保存成 png，或 tiff
        end
        
        if AttPerfPlot == false % true才会画各属性图
            continue; 
        end
        
        % draw and save the performance plot for each attribute
        attTrld = 0;
        for attIdx=1:9
            
            idxSeqSet=find(att(:,attIdx)>attTrld);
            
            if length(idxSeqSet) < 2
                continue;
            end
            disp([attName{attIdx} ' ' num2str(length(idxSeqSet))])
                     
            switch metricType
                case 'overlap'
                    titleName = ['Success plots of ' evalType ' - ' attName{attIdx} ' (' num2str(length(idxSeqSet)) ')'];
                case 'error'
                    titleName = ['Precision plots of ' evalType ' - ' attName{attIdx} ' (' num2str(length(idxSeqSet)) ')'];
            end
            
            attTitleNameTosave = [attFigName{attIdx} '_' titleNameTosave];
            attFigsNameTosave = [figsPath attTitleNameTosave];

            figure;
            plotDrawSave(numTrk,plotDrawStyle,aveSuccessRatePlot,idxSeqSet,rankNum,rankingType,rankIdx,nameTrkAll,thresholdSet,titleName, xLabelName,yLabelName,paperTitle,evalType);
            set(gcf, 'position', figSize);
            tightfig; % 去除图片白边
            if saveAttPerfPlot == true
                print(gcf, '-dpdf', [attFigsNameTosave, '.pdf']); % 保存成 pdf
%                 saveas(gcf, [attFigsNameTosave, '.png']); % 保存成 png，或 tiff
            end
        end
    end
end

rmpath('.\util\');
rmpath('.\rstEval\');