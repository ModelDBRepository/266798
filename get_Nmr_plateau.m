% Author: Etay Hay
% Orientation processing by synaptic integration across first-order tactile neurons (Hay and Pruszynski 2020)

function N_plateau = get_Nmr_plateau(cellnum,Nmrs,model_type)
	paccs = [];
	NuniqueMR = [];
	for k = 1:length(Nmrs)
		[model,ws,perrs] = cell2model(cellnum,Nmrs(k),model_type);
		paccs(k,:) = max(0,round(100 - perrs));
		NuniqueMR(k) = length(model.mr_w);
	end
	best_pacc = 0;
	for k = 1:length(Nmrs)
		if (mean(paccs(k,:)) - best_pacc) >= (5/size(paccs,2))
			N_plateau = NuniqueMR(k);
			best_pacc = mean(paccs(k,:));
		end
	end
