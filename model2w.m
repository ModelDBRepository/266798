% Author: Etay Hay
% Orientation processing by synaptic integration across first-order tactile neurons (Hay and Pruszynski 2020)

function [w,w_pinds] = model2w(model,sim_param)
	dx = sim_param.dx;
	rf_length_y = sim_param.patch_length_y;
	rf_length_x = sim_param.patch_length_x;
	Nmr = size(model.mr_subset,1);
	mr_unique = zeros(Nmr,1);
	mr_unique(1,1) = 1;
	if Nmr>1
		for i = 2:Nmr
			if ~ismember(model.mr_subset(i,:),model.mr_subset(1:(i-1),:),'rows')
				mr_unique(i,1) = 1;
			else
				mr_unique(i,1) = 0;
			end			
		end
	end
	w = {};
	w_pinds = {};
	for k = 1:Nmr
		w{k} = zeros(round(rf_length_y/dx),round(rf_length_x/dx));
		w_pinds{k} = [];
		if mr_unique(k) == 1
			loc_mr = model.mr_subset(k,:)*model.d_mr;
			i_mr = ceil(loc_mr(1)/dx);
			j_mr = ceil(loc_mr(2)/dx);
			i_r = ceil((model.mr_r1+model.mr_r2)/dx);
			inds1 = max(1,min(size(w{k},1),(i_mr + [-i_r:1:i_r])));
			inds2 = max(1,min(size(w{k},2),(j_mr + [-i_r:1:i_r])));
			loc_rf1 = zeros(length(inds1),length(inds2));
			loc_rf2 = zeros(length(inds1),length(inds2));
			for i = 1:length(inds1)
				for j = 1:length(inds2)
					loc_rf1(i,j) = inds1(i)*dx; 
					loc_rf2(i,j) = inds2(j)*dx; 
				end
			end
			d1 = loc_rf1 - loc_mr(1);
			d2 = loc_rf2 - loc_mr(2);
			d = (d1.^2 + d2.^2).^0.5;
			w{k}(inds1,inds2) = mr_response(d,model.mr_r1,model.mr_r2,model.mr_w(k));
			w_pinds{k} = find(w{k}>0);
		end
	end
end