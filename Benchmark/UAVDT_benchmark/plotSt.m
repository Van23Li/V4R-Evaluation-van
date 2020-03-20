close all
clear
clc

plotDrawStyle = {struct('color',[1,0,0],'lineStyle','p'),...
    struct('color',[0,1,0],'lineStyle','h'),...
    struct('color',[0,0,1],'lineStyle','x'),...
    struct('color',[0,0,0],'lineStyle','s'),...
    struct('color',[1,0,1],'lineStyle','v'),...
    struct('color',[0,1,1],'lineStyle','*'),...
    struct('color',[0.5,0.5,0.5],'lineStyle','d'),...
    struct('color',[136,0,21]/255,'lineStyle','o'),...
    struct('color',[255,127,39]/255,'lineStyle','^'),...
    struct('color',[0,162,232]/255,'lineStyle','+'),...
    struct('color',[163,73,164]/255,'lineStyle','>'),...
    struct('color',[12,73,123]/255,'lineStyle','<'),...
    struct('color',[0,0,0]/255,'lineStyle','x'),...
    struct('color',[139,0,0]/255,'lineStyle','s'),...
    struct('color',[0,162,232]/255,'lineStyle','v'),...
    struct('color',[0,128,128]/255,'lineStyle','*'),...
    struct('color',[255,140,0]/255,'lineStyle','d'),...
    struct('color',[12,73,123]/255,'lineStyle','o'),...
    struct('color',[0,128,128]/255,'lineStyle','^'),...
    struct('color',[30,144,255]/255,'lineStyle','+'),...
    struct('color',[0,0,139]/255,'lineStyle','>'),...
    struct('color',[75,0,130]/255,'lineStyle','<'),...
    struct('color',[128,0,128]/255,'lineStyle','x'),...
    struct('color',[225,20,147]/255,'lineStyle','s'),...
    struct('color',[220,20,30]/255,'lineStyle','v'),...
    struct('color',[167,209,41]/255,'lineStyle','d'),...
    struct('color',[50,219,198]/255,'lineStyle','h'),...
    struct('color',[215,215,0]/255,'lineStyle','+'),...
    };

y = [0.713
    0.700
    0.700
    0.697
    0.695
    0.686
    0.683
    0.681
    0.681
    0.677
    0.674
    0.674
    0.667
    0.666
    0.660
    0.659
    0.658
    0.656
    0.649
    0.643
    0.629
    0.605
    0.603
    0.602
    0.579
    0.571
    0.564
    0.559];

x = [0.445
    0.454
    0.435
    0.416
    0.394
    0.433
    0.429
    0.354
    0.410
    0.431
    0.389
    0.441
    0.437
    0.383
    0.403
    0.420
    0.419
    0.406
    0.389
    0.410
    0.411
    0.319
    0.388
    0.355
    0.312
    0.290
    0.304
    0.288];

TrkSet = {
    'DRCF'
    'ECO_gpu'
    'ASRDCF'
    'UDT+'
    'Staple_CA'
    'BACF'
    'ADNet'
    'DSST'
    'ECO_HC'
    'TADT'
    'CSRDCF'
    'UDT'
    'DeepSTRCF'
    'fDSST'
    'MCPF'
    'DSARCF'
    'SRDCF'
    'CCOT'
    'KCC'
    'SRDCFdecon'
    'STRCF'
    'CoKCF'
    'IBCCF'
    'CF2'
    'SAMF'
    'KCF'
    'SAMF_CA'
    'DCF'
    };

SourceSet = { 'Ours'
    '2017CVPR'
    'ASRDCF'
    '2019CVPR'
    '2017CVPR'
    '2017CVPR'
    '2017CVPR'
    '2014BMVC'
    '2017CVPR'
    '2019CVPR'
    '2018CVPR'
    '2019CVPR'
    '2018CVPR'
    '2016TPAMI'
    '2017CVPR'
    '2019TIP'
    '2015ICCV'
    '2016ECCV'
    '2018AAAI'
    '2016CVPR'
    '2018CVPR'
    '2017PR'
    '2017ICCV'
    '2015ICCV'
    '2014ECCV'
    '2015TPAMI'
    '2017CVPR'
    '2015TPAMI'
    };

FPSSet = { '38.4'
    '16.4'
    '21.29'
    '60.4'
    '64.1'
    '69.1'
    '7.6'
    '148.3'
    '79.2'
    '32.3'
    '13.2'
    '76.4'
    '6.6'
    '218.5'
    '0.67'
    '12,74'
    '17.4'
    '1.1'
    '56.9'
    '8.9'
    '32.3'
    '21.2'
    '3.4'
    '20.2'
    '15.8'
    '956.9'
    '14.7'
    '1454.4'
    };

FontSize = 22;
figure;
for ii = 1:length(x)
    %     plot(x(ii),y(ii),'color',plotDrawStyle{ii}.color, 'Marker', plotDrawStyle{ii}.lineStyle, 'MarkerSize',12, 'LineWidth',2);
    %     scatter(x(ii),y(ii), plotDrawStyle{ii}.color, 'Marker', plotDrawStyle{ii}.lineStyle, 'MarkerSize',12, 'LineWidth',2);
    scatter(x(ii),y(ii),300,plotDrawStyle{ii}.color,plotDrawStyle{ii}.lineStyle, 'LineWidth', 2.5);
    
    %     for i = 1 : str_len
    %         printf("%c", str[i]);
    %         printf("\n");
    %         i = i + 1;
    %     end
    
%         tmpName{ii} = [TrkSet{ii},'  (' FPSSet{ii} ' fps)' ];
    tmpName{ii} = [TrkSet{ii}, '  (' SourceSet{ii} '; ' FPSSet{ii} 'fps)' ];
    %     tmpName{ii} = sprintf('%.*s\n', 20 ,[TrkSet{ii}, ' (' FPSSet{ii} ')' ]);
    
    hold on;
end

legend1=legend(tmpName,'Interpreter', 'none','fontsize',15, 'location', 'eastoutside');
% legend('boxoff')
set(legend1, 'Fontname', 'Times New Roman','FontWeight','normal');
axis([0.28 0.4615 0.55 0.72]);
xlabel('Success rate','Fontname', 'Times New Roman','FontSize',FontSize,'fontweight','bold');
ylabel('Precision','Fontname', 'Times New Roman','FontSize',FontSize,'fontweight','bold');
set(gca,'FontSize',FontSize); % 改变坐标刻度大小
% set(gcf, 'position', [0 0 1400 785]);
set(gcf, 'position', [0 0 1400 790]);
title(  'Overall performance on UAVDT','fontsize',FontSize,'fontname','Times New Roman','fontweight','bold');
grid on; box on;
tightfig;

print(gcf,'-dpdf','StarUAVDT.pdf');