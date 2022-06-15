function [roiTagLst,MaskLst,roiNameLst]=readroi(roiFileNames,SZ)
N=length(roiFileNames);
roiTagLst=cell(1,N);
roiNameLst=cell(1,N);
MaskLst=cell(1,N);
sz=SZ;
for i=1:N
    Name=roiFileNames(i).name;
    k = strfind(Name,"_");
    k=[k strfind(Name,".")];
    tag=cell(1,6);
    for j=1:6
        tag{j}=Name(k(j)+1:k(j+1)-1);
    end
    roiTagLst{i}=tag;
    roiNameLst{i}=Name(1:k(end)-1);
    sThisROI=ReadImageJROI(Name);
    MaskLst{i}=ROIs2Mask(sThisROI,sz);
end

end