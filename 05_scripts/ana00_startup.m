%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                       Setup envir
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% lfp foof
% Data: Steffen Paschen, University of Kiel
% Author: Julius Welzel (j.welzel@neurologie.uni-kiel.de)

clc; clear all; close all;

MAIN = [fileparts(pwd) '\'];
addpath(genpath(MAIN));
addpath([userpath '\toolboxes\eeglab2021.0\']);
addpath([userpath '\toolboxes\fieldtrip-20201023\']);


%Change MatLab defaults
set(0,'defaultfigurecolor',[1 1 1]);

