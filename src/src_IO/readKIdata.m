function collector=readKIdata(mainFolderPath)

cd(mainFolderPath);
mainFileName=dir('*.lif');
[imgout]=ci_loadLif(mainFileName.name,false,3);
TimeLength=imgout.Info.Dimensions(4).Length;
TimeLength = str2double(TimeLength);

dat=squeeze(max(imgout.Image{1},[],3));
dat=permute(dat,[2 1 3]);

[imgout]=ci_loadLif(mainFileName.name,false,1);
background=max(imgout.Image{1},[],3)';
SZ=size(background);

roiFolderName=dir('RoiSet_*');
cd(roiFolderName.name);
roiFileNames=dir("*.roi");
[roiTagLst,MaskLst,roiNameLst]=readroi(roiFileNames,SZ(2:-1:1));


collector.dat=dat;
collector.background=background;
collector.roiTagLst=roiTagLst;
collector.MaskLst=MaskLst;
collector.TimeLength=TimeLength;
collector.roiNameLst=roiNameLst;

end