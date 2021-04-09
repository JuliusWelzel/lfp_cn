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
ft_defaults

%Change MatLab defaults
set(0,'defaultfigurecolor',[1 1 1]);

%colors
color.con = hex2rgb('#5e3f5d');
color.mod = hex2rgb('#cd4c31');
color.neu = hex2rgb('#f7a51e');