% 续在最后往下添加，尽量不要删除前面的组合，常用的归纳为一组。
% 例如 trackers_common，trackers_hand_crafted，trackers_deep…
% 自己的组合就例如 trackers_ICRA19_LFL （trackers+期刊会议+年份+作者+其他），
% 也可以利用 trackers = [trackers_common, trackers_ICRA19_LFL] 进行组合。
%
% 新建 trackers_ICRA19_LFL_video 用以表示要绘制边框的跟踪器组合。
%
% 避免混乱出现下次找不到
%
% by lfl

function trackers=configTrackers

trackers_all = {
    struct('name','KCF_LinearHog','namePaper','DCF'),...
    struct('name','KCF_GaussHog','namePaper','KCF'),...
    struct('name','DSST','namePaper','DSST'),...
    struct('name','CoKCF','namePaper','CoKCF'),...
    struct('name','BACF','namePaper','BACF'),...
    struct('name','SAMF','namePaper','SAMF'),...
    struct('name','SAMF_CA','namePaper','SAMF\_CA'),...
    struct('name','Staple','namePaper','Staple'),...
    struct('name','Staple_CA','namePaper','Staple\_CA'),...
    struct('name','SRDCF','namePaper','SRDCF'),...
    struct('name','SRDCFdecon','namePaper','SRDCFdecon'),...
    struct('name','CF2','namePaper','CF2'),...
    struct('name','MCCT','namePaper','MCCT'),...
    struct('name','MCCT_H','namePaper','MCCT\_H'),...
    struct('name','CCOT','namePaper','CCOT'),...
    struct('name','CSRDCF','namePaper','CSR-DCF'),...
    struct('name','STRCF','namePaper','STRCF'),...
    struct('name','DeepSTRCF','namePaper','DeepSTRCF'),...
    struct('name','ECO_gpu','namePaper','ECO'),...
    struct('name','ECO_HC','namePaper','ECO-HC'),...
    struct('name','TADT','namePaper','TADT'),...
    struct('name','IBCCF','namePaper','IBCCF'),...
    struct('name','UDT','namePaper','UDT'),...
    struct('name','fDSST','namePaper','fDSST'),...
    struct('name','KCC','namePaper','KCC'),...
    struct('name','UDTplus','namePaper','UDT+'),...
    struct('name','MCPF','namePaper','MCPF'),...
    struct('name','TSD_20L_lr@0.01','namePaper','TSD_20L_lr@0.01'),...
    struct('name','TSD_20L_lr@0.014','namePaper','TSD_20L_lr@0.014'),...
    struct('name','TSD_20L_lr@0.018','namePaper','TSD_20L_lr@0.018'),...
    struct('name','TSD_20L_lr@0.0216','namePaper','TSD_20L_lr@0.0216'),...
    };   
TSD_HC = {
    struct('name','STRCF','namePaper','STRCF'),...
    struct('name','MCCT_H','namePaper','MCCT\_H'),...
    struct('name','KCC','namePaper','KCC'),...
    struct('name','Staple_CA','namePaper','Staple\_CA'),...
    struct('name','SRDCF','namePaper','SRDCF'),...
    struct('name','SAMF_CA','namePaper','SAMF\_CA'),...
 struct('name','fDSST','namePaper','fDSST'),...
    struct('name','ECO_HC','namePaper','ECO-HC'),...
    struct('name','CSRDCF','namePaper','CSR-DCF'),...
    struct('name','BACF','namePaper','BACF'),...
    struct('name','Staple','namePaper','Staple'),...
    struct('name','SRDCFdecon','namePaper','SRDCFdecon'),...
    struct('name','SAMF','namePaper','SAMF'),...
    ...struct('name','KCF_LinearHog','namePaper','DCF'),...
    struct('name','KCF_GaussHog','namePaper','KCF'),...
 struct('name','DSST','namePaper','DSST'),...
    ...struct('name','TSD_10fps_output_sigma_factor@0.055556_nu@0.2','namePaper','\bf{output_sigma_factor}'),...
    ...struct('name','TSD_10fps_search_area_scale@5.31_nu@0.2','namePaper','\bf{search_area_scale}'),...
    ...struct('name','TSD_10fps','namePaper','\bf{TSD}'),...
    ...struct('name','TSD_20L_base@','namePaper','\bf{TSD}'),...
    ...struct('name','TSD_10fps_final_0121','namePaper','\bf{TSD}'),...
    struct('name','TSD_10fps_lr@0.0408_nu@0.201','namePaper','\bf{TSD}'),...
    };

trackers = TSD_HC;