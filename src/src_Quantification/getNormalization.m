function getNormalization(dataPath,normalizationMethod)

cd(dataPath);
fileLst=dir("#*_dFoF0.mat");
table_curve=[];
table_MAX=[];
table_AUC=[];
header_roiName=[];
backgroundTagLst=[];
backgroundLst=cell(length(fileLst),1);
MaskLst=cell(0,0);
TagLst=cell(0,0);
backgroundNameLst=[];
for i=1:length(fileLst)
    load(fullfile(dataPath,fileLst(i).name));
    %% header
    header_roiName_s=collector.roiNameLst';
    %% curve
    [Nroi,Ntype,Ntime]=size(collector.dFoF0_ROITypeTime);
    dFoF0_ROITimeType=permute(collector.dFoF0_ROITypeTime,[3 2 1]);
    dFoF0_CurveROI=reshape(dFoF0_ROITimeType,Ntype*Ntime,Nroi);
    table_curve_org=permute(dFoF0_CurveROI,[2 1]);
    %% MAX
    table_MAX_org=collector.MAXdFoF0_ROIType;
    %% AUC
    table_AUC_org=collector.AUC_ROIType;

    %% normaliza
    if normalizationMethod=="perLarva"
        table_curve_s=table_curve_org/mean(table_curve_org,"all");
        table_MAX_s=table_MAX_org/mean(table_MAX_org,"all");
        table_AUC_s=table_AUC_org/mean(table_AUC_org,"all");
    elseif normalizationMethod=="perROI"
        table_curve_s=table_curve_org./mean(table_curve_org,2);
        table_MAX_s=table_MAX_org./mean(table_MAX_org,2);
        table_AUC_s=table_AUC_org./mean(table_AUC_org,2);
    else
        table_curve_s=table_curve_org;
        table_MAX_s=table_MAX_org;
        table_AUC_s=table_AUC_org;
    end
    %% combine
    table_curve=[table_curve;table_curve_s];
    table_MAX=[table_MAX;table_MAX_s];
    table_AUC=[table_AUC;table_AUC_s];
    header_roiName=[header_roiName;header_roiName_s];
    %% info for clustering
    backgroundLst{i}=collector.background;
    backgroundTagLst=[backgroundTagLst;ones(size(table_curve_org,1),1)*i];
    MaskLst=[MaskLst; collector.MaskLst'];
    TagLst=[TagLst;collector.roiTagLst'];
    backgroundNameLst=[backgroundNameLst;convertCharsToStrings(fileLst(i).name(1:end-10))];
end

fileName="dFoF0_"+normalizationMethod+".xlsx";
if exist(fileName,"file")
    delete(fileName);
end
Table_temp=[header_roiName num2cell(table_curve)];
writecell(Table_temp,fileName,'Sheet','dFoF0 each Timepoint');
Table_temp=[header_roiName num2cell(table_MAX)];
writecell(Table_temp,fileName,'Sheet','MAX dFoF0');
Table_temp=[header_roiName num2cell(table_AUC)];
writecell(Table_temp,fileName,'Sheet','AUC');
%% save info for clustering
if normalizationMethod=="raw"
    curveLst=table_curve;
    save("clustering_info","TagLst","MaskLst","backgroundTagLst","backgroundLst","curveLst","backgroundNameLst");
end
end