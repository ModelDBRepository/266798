% Author: Etay Hay
% Orientation processing by synaptic integration across first-order tactile neurons (Hay and Pruszynski 2020)

function inds_unique = get_unique_models(models,errs)
	Nmodels = length(models);
	inds_unique = [1];
	for k = 2:Nmodels
		found = 0;
		for k2 = 1:(k-1)
			if isequal(models{k},models{k2})
				found = 1;
			end
		end
		if ~found
			inds_unique = [inds_unique; k];
		end
	end
	%disp([int2str(length(inds_unique)),' unique models'])
end



