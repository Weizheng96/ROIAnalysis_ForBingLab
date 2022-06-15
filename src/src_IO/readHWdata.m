function collector=readHWdata(mainFolderPath)

cd(mainFolderPath);
mainFileName=dir('*.lif');
[imgout]=ci_loadLif(mainFileName.name,false,1);
TimeLength=imgout.Info.Dimensions(4).Length;
TimeLength = str2double(TimeLength);

dat=squeeze(max(imgout.Image{1},[],3));
dat=permute(dat,[2 1 3]);

dat_td=squeeze(max(imgout.Image{2},[],3));
dat_td=permute(dat_td,[2 1 3]);

background=max(imgout.Image{2}(:,:,:,1),[],3)';
SZ=size(background);

roiFolderName=dir('RoiSet_*');
cd(roiFolderName.name);
roiFileNames=dir("*.roi");
[roiTagLst,MaskLst,roiNameLst]=readroi(roiFileNames,SZ);


collector.dat=dat;
collector.background=background;
collector.roiTagLst=roiTagLst;
collector.MaskLst=MaskLst;
collector.TimeLength=TimeLength;
collector.dat_td=dat_td;
collector.roiNameLst=roiNameLst;

end