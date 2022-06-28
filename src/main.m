clc;clear;close all;
dbstop if error
%% parameters (KI_GUItest)
% dataPath='D:\Data\Kenichi\Dropbox\sound researh_HW WZ & KI\KI_GUItest\convertedData';
% % the folder saving the converted data, this folder will also be used to save result;
% 
% parameter.FrameNumBefore=10; 
% % number of frames before stimuli to esitmate F0.  
% % if FrameNumBefore=10, 10 frame before each stimuli will be used to estimate F0
% 
% parameter.FrameNumAfter=9; 
% % number of frames after stimuli for quantification and clustering. 
% % if FrameNumAfter=9, 10 (9+1) frames for each stimuli will be used. 
% % The last frame before stimuli will always be included
% 
% parameter.MAXdFoF0_threshold=0.01;
% % the max dF/F0 threshold. Decided whether the ROI is responsive.
% 
% parameter.clusteringTags=[
%     "*";
%     "A1|A2|A3|A4";
%     "*";
%     "*";
%     "*";
%     "*";
%     "responsive"];
% % use tags to select ROI used for clustering
% % 7 rows, each row is one kind of tags
% % "*" means all tags are allowed
% % "Cell|Sh" means either "Cell" or "Sh" are allowed
% % the last row is responsive or unresponsive.
% 
% parameter.clusteringThreshold=0.1;
% % The threshold to decide if two ROI belong to the same class in Ward's clustering.
% 
% parameter.ClusteringYlim=[-0.005 0.02];
% % dF/F0 (y axis) range in clusteringResult.png. 

%% parameters (HW_GUItest)
dataPath='D:\Data\Kenichi\Dropbox\sound researh_HW WZ & KI\HW_GUItest\convertedData';
% the folder saving the converted data, this folder will also be used to save result;

parameter.FrameNumBefore=10; 
% number of frames before stimuli to esitmate F0.  
% if FrameNumBefore=10, 10 frame before each stimuli will be used to estimate F0

parameter.FrameNumAfter=9; 
% number of frames after stimuli for quantification and clustering. 
% if FrameNumAfter=9, 10 (9+1) frames for each stimuli will be used. 
% The last frame before stimuli will always be included

parameter.MAXdFoF0_threshold=0.1;
% the max dF/F0 threshold. Decided whether the ROI is responsive.

parameter.normalizationMethod="perROI_onlyCareShape";
% avaliable option: "raw", "perROI", "perLarva","perROI_onlyCareShape"

parameter.clusteringTags=[
    "*";
    "*";
    "*";
    "*";
    "1|2|3|4|5";
    "Sh|Cell";
    "responsive"];
% use tags to select ROI used for clustering
% 7 rows, each row is one kind of tags
% "*" means all tags are allowed
% "Cell|Sh" means either "Cell" or "Sh" are allowed
% the last row is responsive or unresponsive.

parameter.clusteringThreshold=2;
% The threshold to decide if two ROI belong to the same class in Ward's clustering.

parameter.ClusteringYlim=[-0.02 0.1];
% dF/F0 (y axis) range in clusteringResult.png. 
%% add path
srcName = mfilename;
srcPath = fileparts(which([srcName '.m']));  
addpath(genpath(srcPath));

%% dF/F0 for each kind of stimuli each ROI
getdFoF0(dataPath,parameter)

%% save result with different normalization methods
getNormalization(dataPath,"raw");
getNormalization(dataPath,"perROI");
getNormalization(dataPath,"perLarva");
getNormalization(dataPath,"perROI_onlyCareShape");

%% clustering
getClusteringResult(dataPath,parameter);