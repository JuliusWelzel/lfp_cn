%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                       Pilot LFPs
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Load data and visualise
% Author: Julius Welzel (j.welzel@neurologie.uni-kiel.de)

% define paths
PATHIN_conv = [MAIN '03_Data' filesep '01_converted2matlab' filesep];
PATHOUT_prep = [MAIN '03_Data' filesep '02_prep' filesep];
PATHOUT_plot = [MAIN '06_plots' filesep '01_pilot_lfp' filesep];

if ~exist(PATHOUT_prep);mkdir(PATHOUT_prep);end
if ~exist(PATHOUT_plot);mkdir(PATHOUT_plot);end

list = dir(fullfile([PATHIN_conv]));
list = list(contains({list.name},'.mat'));
DEPTH = extractBetween({list.name},'LT1','F'); % Depth is a cell array containing all depth in one participant folder

%% Prep data of all depth

for d = 1:numel(DEPTH)
    clear data
    
    % read data
    cfg = [];
    cfg.dataset = [PATHIN_conv list(d).name];
    data.lfp = ft_preprocessing(cfg);
    
    cfg.resamplefs  = 2000; 
    cfg.detrend     = 'no'; 
    data.resam      = ft_resampledata(cfg,data.lfp);

    %hp filter
    cfg = [];
    cfg.hpfilter = 'yes';
    cfg.hpfiltertype = 'fir';
    cfg.hpfreq = 1;
    data.select = ft_preprocessing(cfg,data.resam);

    %lp-filter
    cfg = [];
    cfg.lpfilter = 'yes';
    cfg.lpfiltertype = 'fir';
    cfg.lpfreq = 100;
    data.select = ft_preprocessing(cfg,data.select);
    
    cfg = [];
    cfg.dftfilter   = 'yes';
    cfg.dftfreq     = [50]; %50hz line noise filter
    data.select     = ft_preprocessing(cfg,data.select);
        
    cfg1 = [];
    cfg1.length  = 1;
    cfg1.overlap = 0.5;
    data.win1   = ft_redefinetrial(cfg1, data.select);

    cfg1.length  = 2;
    cfg1.overlap = 0.5;    
    data.win2    = ft_redefinetrial(cfg1, data.select);

    cfg1.length  = data.select.time{1}(end);
    cfg1.overlap = 0;    
    data.winAll    = ft_redefinetrial(cfg1, data.select);

    cfg2 = [];
    cfg2.output  = 'pow';
    cfg2.channel = 'all';
    cfg2.method  = 'mtmfft';
    cfg2.taper   = 'hanning';
    cfg2.foi     = 1:1:80; % 1/cfg1.length  = 1;
    data.freq1   = ft_freqanalysis(cfg2, data.win1);

    cfg2.foi     = 1:0.5:80; % 1/cfg1.length  = 2;
    data.freq2   = ft_freqanalysis(cfg2, data.win2);

    cfg2.foi     = 1:0.2:80; % 1/cfg1.length  = 5;
    data.freq3   = ft_freqanalysis(cfg2, data.winAll);
  
    figure;
    hold on;
    plot(data.freq1.freq, data.freq1.powspctrm(1,:),'Color',color.con)
    plot(data.freq2.freq, data.freq2.powspctrm(1,:),'Color',color.mod)
    plot(data.freq3.freq, data.freq3.powspctrm(1,:),'Color',color.neu)

    legend('1 sec // 0.5 s overlay','2 sec // 0.5 s overlay','5 sec // 0 s overlay')
    xlabel('Frequency (Hz)');
    ylabel('Absolute power (uV^2)'); 
    
    xlim([0 20])
    
    save_fig(gcf,PATHOUT_plot,['s1_' DEPTH{d}]);
    
 
    % store relevant info for future proecssing
    % ID
    % depth
    % spectra
    
    lfp(d).depth = DEPTH{d};
    lfp(d).freqs = data.freq1.freq;
    lfp(d).spect = data.freq1.powspctrm;
    
    % FOOOF settings
    cfg_foof    = struct();
    f_range     = [1,100];  % Use defaults
    fooof_res   = fooof(data.freq1.freq,data.freq1.powspctrm(1,:),f_range,cfg_foof);
   
    
end % depths