function readHWdataAll(dataPath)
cd(dataPath);
resultPath=fullfile(dataPath,'convertedData');
if ~exist(resultPath,'dir')
    mkdir(resultPath);
end
file_name=dir("*.xlsx");
stimuliTime = readmatrix(file_name.name);
mainFolderPathLst=dir("#*");
for i=1:length(mainFolderPathLst)

    mainFolderPath=fullfile(dataPath,mainFolderPathLst(i).name);
    collector=readHWdata(mainFolderPath);
    cd(mainFolderPath);
    file_name=dir("*.xlsx");
    stimuliOrder = readmatrix(file_name.name);
    collector.stimuliOrder=stimuliOrder;
    collector.stimuliTime=stimuliTime;
    collector.FPS=size(collector.dat,3)/collector.TimeLength;
    collector.stimuliFrame=ceil(collector.stimuliTime*collector.FPS);
    cd(resultPath);
    save([mainFolderPathLst(i).name '_org.mat'],'collector');

    dat=motionCorrectionBasedother(collector.dat,collector.dat_td);
    tifwrite(mat2gray(double(dat)), [mainFolderPathLst(i).name '_motionCorrected.tif']);
    collector.dat=dat;
    collector = rmfield(collector,'dat_td');
    save([mainFolderPathLst(i).name '_motionCorrected.mat'],"collector");
end
end