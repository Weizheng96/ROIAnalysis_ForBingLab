function dat=motionCorrectionBasedother(dat,dat_td)

dat_i=dat_td(:,:,1);
SZ=size(dat,[1 2]);
GridSZ=round(SZ/1);
options_rigid=NoRMCorreSetParms('d1',size(dat,1),'d2',size(dat,2),'grid_size',GridSZ,'use_parallel',true,'boundary','NaN','upd_template',false);
[~,shifts,~,options,~]=normcorre(dat_td,options_rigid,dat_i);
dat=apply_shifts(dat,shifts,options);
dat(isnan(dat))=0;

end