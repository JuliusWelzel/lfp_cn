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
    load([PATHIN_conv list(1).name]);
    lfp = double(CLFP_01___Central)';

    %Frequenz
    srate   = CLFP_01___Central_KHz_Orig * 1000; % transform srate to sample/sec
    p_raw   = plot(CLFP_01___Central);
    n       = 4; % filter order, % needs rework, compare Wittmann ea., 2015
    
    %Filter (explorativ um die Frequenzbänder zu visualisieren)
    passbands = [0 4;4 8;8 13;13 40;40 100];
    [b,a] = butter(n , 2*passbands(1,2) * 2/srate , "low");
    lfp(:,2) = filtfilt(b,a,lfp(:,1));

    for pb = 2:length(passbands);
        
        lfp(:,pb+1) = bandpass(lfp(:,1),passbands(pb,:)*2/srate);
        
    end
    
    %Chronux params festlegen
    params.Fs = srate ;  
    params.tapers = [3 9];
    params.fpass = [0 50];
    params.err = [1 0.05];
    movingwin =  [0.5 0.05];
    maxDb = 15;

    %Locdetrend und DC removal
    f0 = 50;
    lfp(:,1) = locdetrend(lfp(:,1),srate,movingwin);
    lfp(:,1) = rmlinesc(lfp(:,1),params,f0);

    %Frequenzspektrum
    [S,f,Serr] = mtspectrumc(lfp(:,1),params);
    plot(f,S,"Color","red")
    hold on
    plot(f,Serr,"Color","blue","LineStyle","-.")
    xlim ([0 ,50])
    xlabel("Frequenz in Hz")
    hold off

    %Spektrogramm Frequenz-Zeit
    [s,t,f] = mtspecgramc(lfp(:,1),movingwin,params);
    plot_matrix(s,t,f); xlabel([])
    caxis([0 15])
    colorbar
    
end % depths