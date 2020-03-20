clear
close all;
clc;

addpath('.\util\');
addpath('.\rstEval\');

dataPath = 'D:\Van\Matlab\Data_set\VisDrone2018-SOT-test\data_seq\';
annoPath = '.\anno\';
attPath = [annoPath, 'att\']; % The folder that contains the annotation files for sequence attributes

% ��ѡ��
paperTitle = 'ReSL'; 
% ��ԵĻ�����ڿ����ƺ�����

saveOverallPerfPlot = true; % true:����overall performance��ͼ, false:������
AttPerfPlot = true; % true:����att performace����ͼ, false:����ͼ
saveAttPerfPlot = true; % true:����att performance��ͼ, false:������

figWidth = 900; % ͼƬ���
figHeight = 650; % ͼƬ�߶�

 % ͼƬ�߶�
numTrkThre = 20; % ���Ƚϵĸ�������������numTrkThre��
heightIntv = 8; % ��ÿ��һ����������ͼƬ�߶�Ҫ����heightIntv

metricTypeSet = {'error', 'overlap'}; %overlap, error
evalTypeSet = {'OPE'}; % 'SRE', 'OPE'

% OTB100
% attName = {'background clutter','camera motion','object motion','small object','illumination variations','object blur','scale variations','long-term tracking','large occlusion'};
% attFigName = {'background_clutter','camera_motion','object_motion','small_object','illumination_variations','object_blur','scale_variations','long-term_tracking','large_occlusion'};

% VisDrone
attName = {'Aspect Ratio Change','Background Clutter','Camera Motion','Fast Motion','Full Occlusion','Illumination Variation','Low Resolution',...
           'Out-of-View','Partial Occlusion','Similar Object','Scale Variation','Viewpoint Change'};
attFigName = {'Aspect Ratio Change','Background Clutter','Camera Motion','Fast Motion','Full Occlusion','Illumination Variation','Low Resolution',...
           'Out-of-View','Partial Occlusion','Similar Object','Scale Variation','Viewpoint Change'};

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
    att(idxSeq,:) = load([attPath s.name '_attr.txt']);
end

attNum = size(att,2);

perfMatPath = '.\perfMat\overall\'; % ��ͼ����

rankNum = 33; % max number of plots to show����Ϊ��ɫ�����������33������

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
            rankingType = 'threshold';% ��������: AUC, threshold
        case 'overlap'
            thresholdSet = thresholdSetOverlap;
            rankIdx = 11;
            xLabelName = 'Overlap threshold';
            yLabelName = 'Success rate';
            rankingType = 'AUC'; % ��������: AUC, threshold
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
                titleName = ['Success plots of ' evalType ' - ' 'Success plots on VisDrone2018'];
            case 'error'
                titleName = ['Precision plots of ' evalType ' - ' 'Precision plots on VisDrone2018'];
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
                
        % ����ͼƬ��С
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
        tightfig; % ȥ��ͼƬ�ױ�
        if saveOverallPerfPlot == true
            print(gcf, '-dpdf', [figsNameTosave, '.pdf']); % ����� pdf
%             saveas(gcf, [figsNameTosave, '.png']); % ����� png���� tiff
        end
        
        if AttPerfPlot == false % true�Żử������ͼ
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
            set(gca,'fontweight','bold');
            tightfig; % ȥ��ͼƬ�ױ�
            if saveAttPerfPlot == true
                print(gcf, '-dpdf', [attFigsNameTosave, '.pdf']); % ����� pdf
%                 saveas(gcf, [attFigsNameTosave, '.png']); % ����� png���� tiff
            end
        end
    end
end

rmpath('.\util\');
rmpath('.\rstEval\');