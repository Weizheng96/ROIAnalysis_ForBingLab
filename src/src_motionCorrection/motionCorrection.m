function dat=motionCorrection(dat)

dat_i=dat(:,:,1);
SZ=size(dat,[1 2]);
GridSZ=round(SZ/1);
options_rigid=NoRMCorreSetParms('d1',size(dat,1),'d2',size(dat,2),'grid_size',GridSZ,'use_parallel',true,'boundary','NaN','upd_template',false);
[dat,shifts,~,options,~]=normcorre(dat,options_rigid,dat_i);
mask_motionCorrected=logical(max((isnan(dat)),[],3));
dat(isnan(dat))=0;

end
