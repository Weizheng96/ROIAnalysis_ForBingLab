clc;clear;close all;
dbstop if error
%% parameters
dataPath='D:\Data\Kenichi\Dropbox\sound researh_HW WZ & KI\HW_GUItest';
%% add path
srcName = mfilename;
srcPath = fileparts(which([srcName '.m']));  
addpath(genpath(srcPath));
%%
readHWdataAll(dataPath);