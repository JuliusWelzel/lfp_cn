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
PATHOUT_plot = [MAIN '06_plots' filesep '02_pilot_lfp' filesep];

if ~exist(PATHOUT_prep);mkdir(PATHOUT_prep);end
if ~exist(PATHOUT_plot);mkdir(PATHOUT_plot);end

list = dir(fullfile([PATHIN_conv]));
list = list(contains({list.name},'.mat'));
DEPTH = extractBetween({list.name},'LT1','F'); % Depth is a cell array containing all depth in one participant folder

%% Prep data of all depth

for d = 1:numel(DEPTH)
    
    % Daten einlesen
    cfg = [];
    cfg.dataset = [PATHIN_conv list(1).name];
    data_lfp = ft_preprocessing(cfg);
    
    cfg.resamplefs = 1000; 
    cfg.detrend = 'no'; 
    data_resam = ft_resampledata(cfg,data_lfp)

    %hp filter
    cfg = [];
    cfg.hpfilter = 'yes';
    cfg.hpfiltertype = 'fir';
    cfg.hpfreq = 1;
    data_select = ft_preprocessing(cfg,data_resam);

    %lp-filter
    cfg = [];
    cfg.lpfilter = 'yes';
    cfg.lpfiltertype = 'fir';
    cfg.lpfreq = 100;
    data_select = ft_preprocessing(cfg,data_select);
    
    cfg = [];
    cfg.dftfilter   = 'yes';
    cfg.dftfreq     = [50]; %50hz line noise filter
    data_select = ft_preprocessing(cfg,data_select);
        
    cfg1 = [];
    cfg1.length  = 1;
    cfg1.overlap = 0.5;
    data_win05    = ft_redefinetrial(cfg1, data_select);

    cfg1.length  = 2;
    cfg1.overlap = 0.5;    
    data_win2    = ft_redefinetrial(cfg1, data_select);

    cfg1.length  = 5;
    cfg1.overlap = 0;    
    data_win3    = ft_redefinetrial(cfg1, data_select);

    cfg2 = [];
    cfg2.output  = 'pow';
    cfg2.channel = 'all';
    cfg2.method  = 'mtmfft';
    cfg2.taper   = 'hanning';
    cfg2.foi     = 0.5:1:80; % 1/cfg1.length  = 1;
    base_freq1   = ft_freqanalysis(cfg2, data_win05);

    cfg2.foi     = 0.5:0.5:80; % 1/cfg1.length  = 2;
    base_freq2   = ft_freqanalysis(cfg2, data_win2);

    cfg2.foi     = 0.5:0.2:80; % 1/cfg1.length  = 5;
    base_freq3   = ft_freqanalysis(cfg2, data_win3);
  
    figure;
    hold on;
    plot(base_freq1.freq, base_freq1.powspctrm(1,:),'Color',color.con)
    plot(base_freq2.freq, base_freq2.powspctrm(1,:),'Color',color.mod)
    plot(base_freq3.freq, base_freq3.powspctrm(1,:),'Color',color.neu)

    legend('1 sec // 0.5 s overlay','2 sec // 0.5 s overlay','5 sec // 0 s overlay')
    xlabel('Frequency (Hz)');
    ylabel('Absolute power (uV^2)'); 
    
    xlim([0 20])
    
    % store relevant info for future proecssing
    % ID
    % depth
    % spectra
    
end % depths