
%% load data
clear variables;
close all;
clc;
% This is for pre-processing EEG signal generating from Traumschreiber
% based on fildtrip codes which are adjusted to our data and device
% written by Paria Samimi & Debora Nolte

%
restoredefaultpath
addpath('/Users/pariasamimi/Downloads/MATLAB/fieldtrip-20211008')
addpath('/Users/pariasamimi/Downloads/MATLAB/xdf')
addpath('/Users/pariasamimi/Downloads/MATLAB/fieldtrip-20211008/external/brewermap')
addpath('/Users/pariasamimi/Downloads/MATLAB/fieldtrip-20211008/external/matplotlib')
addpath('/Users/pariasamimi/Downloads/MATLAB/fieldtrip-20211008/external/cmocean')
addpath('/Users/pariasamimi/Documents/PhD/Sainty check/2022-04-13 Eyes open_closed Board 1')
dir_tmp='/Users/pariasamimi/Documents/PhD/Sainty check/2022-04-13 Eyes open_closed Board 1';
A=cd(dir_tmp);
ft_defaults

%% define the filenames, parameters and other information that is subject specific
subjectdata.subjectdir        = 'eyoc-1';
subjectdata.datadir           = '/Users/pariasamimi/Documents/PhD/Sainty check/2022-04-13 Eyes open_closed Board 1';
subjectdata.subjectnr         = 'eyoc-1';
subjectdata.badtrials         = []; % subject made a mistake on the first and third trial

%% XDF Load
subjectdata.subjectdir=cd('/Users/pariasamimi/Documents/PhD/Sainty check/2022-04-13 Eyes open_closed Board 1');
EEG.EEG='eyoc-1.xdf';
namE=erase(EEG.EEG,'.xdf'); %% for removing the xdf name
[Data, Event] = xdf2fieldtrip(EEG.EEG);

%% 1. defining trials
cfg                 = [];
cfg.dataset         = EEG.EEG;
cfg.trialfun        = 'ft_trialfun_trigtraum';
[cfg]                = ft_definetrial(cfg);
addpath('/Users/pariasamimi/Documents/PhD/Sainty check/2022-04-13 Eyes open_closed Board 1')
%% making your data
for i=1:9
    duration_start(i,:)=cfg.trl(i,1);
    duration_end(i,:)=cfg.trl(i,2);
    dtime=Data.time{1}; 
    dtril=Data.trial{1};
    datapreproc.sampleinfo(i,:)=cfg.trl(i,1:2);
    datapreproc.trialinfo(i,:)=cfg.trl(i,3:4);
end
%time
datapreproc=[];
datapreproc.time{:,1}=dtime(1,duration_start(1,1):duration_end(1,1));   
datapreproc.time{:,2}=dtime(1,duration_start(2,1):duration_end(2,1));  
datapreproc.time{:,3}=dtime(1,duration_start(3,1):duration_end(3,1));   
datapreproc.time{:,4}=dtime(1,duration_start(4,1):duration_end(4,1));  
datapreproc.time{:,5}=dtime(1,duration_start(5,1):duration_end(5,1));   
datapreproc.time{:,6}=dtime(1,duration_start(6,1):duration_end(6,1));  
datapreproc.time{:,7}=dtime(1,duration_start(7,1):duration_end(7,1));   
datapreproc.time{:,8}=dtime(1,duration_start(8,1):duration_end(8,1));  
datapreproc.time{:,9}=dtime(1,duration_start(9,1):duration_end(9,1));   
% datapreproc.time{:,10}=dtime(1,duration_start(10,1):duration_end(10,1));  
%trial
datapreproc.trial{:,1}=dtril(:,duration_start(1,:):duration_end(1,:));   
datapreproc.trial{:,2}=dtril(:,duration_start(2,:):duration_end(2,:));  
datapreproc.trial{:,3}=dtril(:,duration_start(3,:):duration_end(3,:));   
datapreproc.trial{:,4}=dtril(:,duration_start(4,:):duration_end(4,:));  
datapreproc.trial{:,5}=dtril(:,duration_start(5,:):duration_end(5,:));   
datapreproc.trial{:,6}=dtril(:,duration_start(6,:):duration_end(6,:));  
datapreproc.trial{:,7}=dtril(:,duration_start(7,:):duration_end(7,:));   
datapreproc.trial{:,8}=dtril(:,duration_start(8,:):duration_end(8,:));  
datapreproc.trial{:,9}=dtril(:,duration_start(9,:):duration_end(9,:));   
% datapreproc.trial{:,10}=dtril(:,duration_start(10,:):duration_end(10,:));  
%
datapreproc.hdr=Data.hdr;
%
datapreproc.label=Data.label;
%
datapreproc.fsample=250;
%
datapreproc.cfg=cfg;
%% 2. preprocessing and referencing 

cfg.padding         = 0; % length (in seconds) to which the trials are padded for filtering (default = 0)
%   cfg.padtype      = string, type of padding (default: 'data' padding or 'mirror', depending on feasibility)
cfg.continuous      = 'yes'; % whether the file contains continuous data

cfg.lpfilter        = 'yes'; % or 'yes'  lowpass filter (default = 'no')
cfg.hpfilter        = 'yes'; % or 'yes'  highpass filter (default = 'no')
cfg.bpfilter        = 'no'; % or 'yes'   bandpass filter (default = 'no')
cfg.bsfilter        = 'no'; % or 'yes'  bandstop filter (default = 'no')
cfg.dftfilter       = 'no'; % or 'yes'  line noise removal using discrete fourier transform (default = 'no')
cfg.medianfilter    = 'no'; % or 'yes'  jump preserving median filter (default = 'no')
cfg.lpfreq        = 50;                %lowpass  frequency in Hz
cfg.hpfreq        = 2;              %highpass frequency in Hz
cfg.baselinewindow  = [-0.1 0.02]; % in seconds, the default is the complete trial (default = 'all')

cfg.detrend         = 'no'; % or 'yes', remove linear trend from the data (done per trial) (default = 'no')
cfg.polyremoval     = 'no'; % or 'yes', remove higher order trend from the data (done per trial) (default = 'no')
cfg.derivative      = 'no'; % or 'yes', computes the first order derivative of the data (default = 'no')
cfg.hilbert         = 'no'; % 'abs', 'complex', 'real', 'imag', 'absreal', 'absimag' or 'angle' (default = 'no')
cfg.rectify         = 'no'; % or 'yes' (default = 'no')
cfg.reref           = 'no'; % re-referencing
cfg.channel         = {'all','-Traumschreiber-EEG_O2','-Traumschreiber-EEG_P7'};
cfg.refmethod       = 'avg'; %'avg', 'median', or 'bipolar' for bipolar derivation of sequential channels (default = 'avg')
cfg.groupchans    = 'no';
cfg.trials        = 'all';
datapreproc         = ft_preprocessing(cfg,datapreproc);
save(strcat((namE),'_Preprocessing','.mat'),'datapreproc') % save the trial definition
load(strcat((namE),'_Preprocessing','.mat'),'datapreproc')
%%
cfg = [];
cfg.viewmode                = 'butterfly'
cfg.channel                 = {'all'};
cfg = ft_databrowser(cfg,datapreproc);

%% Save results of preprocessing 
save([subjectdata.subjectdir filesep [subjectdata.subjectnr '_datapreproc_final']],'datapreproc');


