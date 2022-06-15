function outIm=WriteHeatMapSimpleFcn(roi3d,Background,cmap,varargin)
%%
orgIm3d=mat2gray(double(Background));
roi3d=min(max(round(roi3d),0),size(cmap,1));
roi3d=round(double(roi3d));
% generate a 3D colorful data with ROI overlay
[h,w,z] = size(orgIm3d);

outIm = zeros(h,w,3,z);
colorIntensity = 1;
if length(varargin)==1
    BackgroundIntensity = varargin{1};
else
    BackgroundIntensity = 1;
    orgIm3d(roi3d>0)=0;
end
nParticle = size(cmap,1);

for i=1:z

    tmpROI = roi3d(:,:,i);
    r = zeros(h,w);
    g = zeros(h,w);
    b = zeros(h,w);
    for j=1:nParticle
        try
            r(tmpROI==j) = colorIntensity*cmap(j,1);
        catch
            a=1;
        end
        g(tmpROI==j) = colorIntensity*cmap(j,2);
        b(tmpROI==j) = colorIntensity*cmap(j,3);
    end
%     outIm(:,:,1,i) = r + orgIm3d(:,:,i);
%     outIm(:,:,2,i) = g + orgIm3d(:,:,i);
%     outIm(:,:,3,i) = b + orgIm3d(:,:,i);
    outIm(:,:,1,i) = r + orgIm3d(:,:,i)*(BackgroundIntensity);
    outIm(:,:,2,i) = g + orgIm3d(:,:,i)*(BackgroundIntensity);
    outIm(:,:,3,i) = b + orgIm3d(:,:,i)*(BackgroundIntensity);
end

end