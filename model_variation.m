% Author: Etay Hay
% Orientation processing by synaptic integration across first-order tactile neurons (Hay and Pruszynski 2020)

function model2 = model_variation(model)
	[r_loc,c_loc] = find(model.mr_loc == 1);
	rvec = randperm(length(r_loc));
	model2 = model;
	for k=1:size(model.mr_subset,1)
		model2.mr_subset(k,1) = r_loc(rvec(k));
		model2.mr_subset(k,2) = c_loc(rvec(k));
	end
end