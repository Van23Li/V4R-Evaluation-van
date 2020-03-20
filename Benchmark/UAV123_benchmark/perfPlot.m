close all;
clear,clc;

addpath('.\util\');
addpath('.\rstEval\');

%van: �л��������ݼ�ʱֻ��ֱ�ע�ͼ���
dataPath = 'D:\Van\Matlab\Data_set\Dataset_UAV123_10fps\UAV123_10fps\data_seq\UAV123_10fps';
annoPath = ['.\anno\', 'UAV123_10fps' , '\']; % % UAV123_10fps, UAV123, UAV20L
type = 'UAV123_10fps'; % % UAV123_10fps, UAV123, UAV20Lcl

% dataPath = 'D:\Van\Matlab\Data_set\Dataset_UAV123\UAV123\data_seq\UAV123';
% annoPath = ['.\anno\', 'UAV123' , '\']; % % UAV123_10fps, UAV123, UAV20L
% type = 'UAV123';
% 
% dataPath = 'D:\van\UAV123_fpsyang\Dataset_UAV123\UAV123\data_seq\UAV123';
% annoPath = ['.\anno\', 'UAV20L' , '\']; % % UAV123_10fps, UAV123, UAV20L
% type = 'UAV123_20L';

% ��ѡ��
paperTitle = 'Scale_Material'; % ��ԵĻ�����ڿ����ƺ�����

saveOverallPerfPlot = true; % true:����overall performance��ͼ, false:������
AttPerfPlot = false; % true:����att performace����ͼ, false:����ͼ
saveAttPerfPlot = true; % true:����att performance��ͼ, false:������

figWidth = 800; % ͼƬ���
figHeight = 450; % ͼƬ�߶�  

numTrkThre = 20; % ���Ƚϵĸ�������������numTrkThre��
heightIntv = 8; % ��ÿ��һ����������ͼƬ�߶�Ҫ����heightIntv

metricTypeSet = {'error', 'overlap'};
evalTypeSet = {'OPE'}; % 'SRE', 'OPE'

attPath = [annoPath, 'att\']; % The folder that contains the annotation files for sequence attributes

% OTB100
% attName={'illumination variation'	'out-of-plane rotation'	'scale variation'	'occlusion'	'deformation'	'motion blur'	'fast motion'	'in-plane rotation'	'out of view'	'background clutter' 'low resolution'};
% attFigName={'illumination_variations'	'out-of-plane_rotation'	'scale_variations'	'occlusions'	'deformation'	'blur'	'abrupt_motion'	'in-plane_rotation'	'out-of-view'	'background_clutter' 'low_resolution'};

% UAV123
attName={'Scale variation' 'Aspect ratio change' 'Low resolution' 'Fast motion' 'Full occlusion' 'Partial occlusion' 'Out-of-view' 'Background clutter' 'Illumination variation' 'Viewpoint change' 'Camera motion' 'Similar object'};
attFigName={'Scale_variation' 'Aspect_ratio_change' 'Low_resolution' 'Fast_motion' 'Full_occlusion' 'Partial_occlusion' 'Out_of_view' 'Background_clutter' 'Illumination_variation' 'Viewpoint_change' 'Camera_motion' 'Similar_object'};

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

numSeq=length(seqs);
numTrk=length(trackers);

nameTrkAll=cell(numTrk,1);
for idxTrk=1:numTrk
    t = trackers{idxTrk};
    nameTrkAll{idxTrk}=t.namePaper;
end

nameSeqAll=cell(numSeq,1);
numAllSeq=zeros(numSeq,1);

att = zeros(numSeq,length(attName));
for idxSeq=1:numSeq
    s = seqs{idxSeq};
    nameSeqAll{idxSeq}=s.name;
    
    s.len = s.endFrame - s.startFrame + 1;
    numAllSeq(idxSeq) = s.len;
    att(idxSeq,:)=load([attPath s.name '.txt']);
end

attNum = size(att,2);

% rmdir('perfMat\overall','s');
% mkdir('perfMat\overall');

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
    metricType = metricTypeSet{i};% error, overlap
    
    switch metricType
        case 'error'
            thresholdSet = thresholdSetError;
            rankIdx = 21; % 21 ����20pixel����error
            xLabelName = 'Location error threshold';
            yLabelName = 'Precision';
            rankingType = 'threshold'; % ��������: AUC, threshold
        case 'overlap'
            thresholdSet = thresholdSetOverlap;
            rankIdx = 11; % 11 ���� 0.5 ��overlap����Ҫʹ�����ָ�����plotDrawSave�޸ģ�ԭ������mean(bb)
            xLabelName = 'Overlap threshold';
            yLabelName = 'Success rate';
            rankingType = 'AUC'; % ��������: AUC, threshold
    end  
        
    if strcmp(metricType,'error') && strcmp(rankingType,'AUC')
        continue;
    end
    
    tNum = length(thresholdSet);
    
    for j=1:length(evalTypeSet)
        
        evalType = evalTypeSet{j}; % SRE, OPE
        
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
        if ~exist(dataName, 'file')
            genPerfMat(seqs, trackers, evalType, nameTrkAll, perfMatPath, annoPath, type);
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
        ylim([0 0.75]);
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
        for attIdx=1:attNum
            
            if attIdx == 2
                a=2
            end
            
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