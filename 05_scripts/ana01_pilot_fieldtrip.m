inpath = ('/Users/robin/Documents/matlab/matlfp'); % path to the data

cd (inpath);
%for i = 1:numel(DEPTH) 
    
cfg=[];
cfg.dataset='LT2D-1.533F0001.mat';
cfg.trialdef.eventtype= '?';
cfg.chantype="micro";
cfg.headerformat='neuroomega_mat';
cfg.dataformat='neuroomega_mat';
cfg.eventformat='neuroomega_mat';
cfg=ft_definetrial(cfg)

%configuration for preprocessing
cfg.detrend='yes';  %detrend
cfg.hpfilter='yes'; %highpass
cfg.hpfreq=1; 
cfg.hpfilttype='but'; %  Butterworth (IIR)
cfg.hpfiltord=6; 
cfg.lpfilter='yes'; % lowpass
cfg.lpfreq=100; 
cfg.lpfilttype='but'; % Butterworth (IIR)
cfg.lpfiltord=16; 
cfg.dftfilter='yes';
cfg.dftfreq=[50]; %50hz filter

%end

