function getdFoF0(dataPath,parameter) 

FrameNumBefore=parameter.FrameNumBefore; 
FrameNumAfter=parameter.FrameNumAfter; 
MAXdFoF0_threshold=parameter.MAXdFoF0_threshold;

cd(dataPath);
fileLst=dir("#*_motionCorrected.mat");
for i=1:length(fileLst)
    load(fullfile(dataPath,fileLst(i).name));
    stimuliKindNumber=max(collector.stimuliOrder);
    trialNumber=length(collector.stimuliOrder);
    ROInumber=length(collector.MaskLst);
    N=trialNumber/stimuliKindNumber;

    dFoF0_ROITypeTime=zeros(ROInumber,stimuliKindNumber,FrameNumAfter+1);
    MAXdFoF0_ROIType=zeros(ROInumber,stimuliKindNumber);
    AUC_ROIType=zeros(ROInumber,stimuliKindNumber);

    for roiCnt=1:ROInumber
        for stimuliKindCnt=1:stimuliKindNumber
            stiLst=find(collector.stimuliOrder==stimuliKindCnt);
            temp_trial_time=zeros(N,FrameNumBefore+FrameNumAfter);
            for timeCnt=-FrameNumBefore:FrameNumAfter-1
                for trialCnt=1:N
                    temp=collector.dat(:,:,timeCnt+collector.stimuliFrame(stiLst(trialCnt)));
                    temp_trial_time(trialCnt,timeCnt+FrameNumBefore+1)=mean(temp(collector.MaskLst{roiCnt}));
                end
            end
            temp_time=mean(temp_trial_time,1);
            F0=mean(temp_time(1:FrameNumBefore));
            dFoF0_ROITypeTime(roiCnt,stimuliKindCnt,:)=(temp_time(FrameNumBefore:end)-F0)./F0;
            MAXdFoF0_ROIType(roiCnt,stimuliKindCnt)=max(dFoF0_ROITypeTime(roiCnt,stimuliKindCnt,:));
            AUC_ROIType(roiCnt,stimuliKindCnt)=sum(abs(dFoF0_ROITypeTime(roiCnt,stimuliKindCnt,:)));
        end
        if max(MAXdFoF0_ROIType(roiCnt,:))>MAXdFoF0_threshold
            collector.roiTagLst{roiCnt}{7}='responsive';
            collector.roiNameLst{roiCnt}=[collector.roiNameLst{roiCnt} '_responsive"'];
        else
            collector.roiTagLst{roiCnt}{7}='unresponsive';
            collector.roiNameLst{roiCnt}=[collector.roiNameLst{roiCnt} '_unresponsive'];
        end
    end
    collector.dFoF0_ROITypeTime=dFoF0_ROITypeTime;
    collector.MAXdFoF0_ROIType=MAXdFoF0_ROIType;
    collector.AUC_ROIType=AUC_ROIType;
    collector = rmfield(collector,'dat');

    save([fileLst(i).name(1:end-20) '_dFoF0.mat'],"collector");
end

end