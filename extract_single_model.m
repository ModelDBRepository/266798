% Author: Etay Hay
% Orientation processing by synaptic integration across first-order tactile neurons (Hay and Pruszynski 2020)

function [model,i_model] = extract_single_model(models,errs)
	inds_unique = get_unique_models(models,errs);
	[vs,is] = sort(mean(errs(:,inds_unique),1),'ascend');
	i_model = inds_unique(is(1));
	model = models{i_model};
end



