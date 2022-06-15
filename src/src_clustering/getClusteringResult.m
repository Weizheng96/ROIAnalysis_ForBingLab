function getClusteringResult(dataPath,parameter)
clusteringTags=parameter.clusteringTags;
ClusteringYlim=parameter.ClusteringYlim;

cd(dataPath);
load("clustering_info.mat");

%% find valid ROI
Nroi=length(TagLst);
Ntag=length(clusteringTags);
validROI=true(Nroi,1);
for roiCnt=1:Nroi
    for tagCnt=1:Ntag
        if clusteringTags(tagCnt)=="*"
            continue;
        else
            C = strsplit(clusteringTags(tagCnt),"|");
            if ~ismember(TagLst{roiCnt}{tagCnt},C)
                validROI(roiCnt)=false;
                break;
            end
        end
    end
end

dat_forClustering_all=curveLst(validROI,:);
MaskLst_valid=MaskLst(validROI,:);
backgroundTagLst_valid=backgroundTagLst(validROI,:);
%% clustering for valid ROI
Z_linkage= linkage(dat_forClustering_all,'ward','euclidean');
ClusterNumber=length(find(Z_linkage(:,3)>parameter.clusteringThreshold))+1;
fig=figure('units','normalized','outerposition',[0 0 0.3 1]);
subplot(1,2,1);
[~,Tree,outperm]=dendrogram(Z_linkage,ClusterNumber,'Orientation','left','ColorThreshold',parameter.clusteringThreshold);

L=size(dat_forClustering_all,2);
L0=(parameter.FrameNumAfter+1);
Onsetticks=1:L0:L;
OnsettickLabel=1:length(Onsetticks);

ResponseTypes=zeros(ClusterNumber,L);
for ClusterCnt=1:ClusterNumber
    ResponseTypes(ClusterCnt,:)=mean(dat_forClustering_all(Tree==ClusterCnt,:),1);
end

ClusterCnt=1:ClusterNumber;
idx=outperm(end-ClusterCnt+1);
Y = tsne(ResponseTypes(idx,:),'NumDimensions',1);
[~,I] = sort(Y);
cMap_over = jet(ClusterNumber);
cMap=cMap_over(I,:);




t=1:size(dat_forClustering_all,2);
for ClusterCnt=1:ClusterNumber
    subplot(ClusterNumber,2,ClusterCnt*2);
    hold off;
    idx=outperm(end-ClusterCnt+1);
    inBetween = [ResponseTypes(idx,:), zeros(size(ResponseTypes(idx,:)))];
    t2 = [t, fliplr(t)];
    patch(t2,inBetween,cMap(idx,:))
    hold on;
    plot(t,zeros(size(t)),'black');
    

    ylim(ClusteringYlim);
    xlim([1 L]);
    xticks(Onsetticks);
    xticklabels(OnsettickLabel)
end

exportgraphics(fig,"clusteringResult.png");
close;
%% ROI map
for cnt=1:length(backgroundLst)
    background=backgroundLst{cnt};
    ClusteringMap=zeros(size(background));
    for ClusterCnt=1:ClusterNumber
        idxOfMap=find(Tree==ClusterCnt);
        for maskCnt=idxOfMap'
            if backgroundTagLst_valid(maskCnt)==cnt
                ClusteringMap(MaskLst_valid{maskCnt})=outperm(end-ClusterCnt+1);
            end
        end
    end
    outIm =WriteHeatMapSimpleFcn(ClusteringMap,background,cMap);
    ImName=backgroundNameLst(cnt)+"_ClusteringROImap.tif";
    imwrite(outIm,ImName)
end
end