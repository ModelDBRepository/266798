% Author: Etay Hay
% Orientation processing by synaptic integration across first-order tactile neurons (Hay and Pruszynski 2020)

function inds_nd = get_nondominated_models(models,errs)
	inds_nd = [];
	inds_unique = get_unique_models(models,errs);
	for i = 1:length(inds_unique)
		dominated = 0;
		i1 = inds_unique(i);
		for j = 1:length(inds_unique)
			i2 = inds_unique(j);
			if ((max(errs(:,i1)) - max(errs(:,i2))) > 5)
				dominated = 1;
			end
		end
		if ~dominated
			inds_nd(end+1,1) = i1;
		end
	end
	if isempty(inds_nd)
		inds_nd = inds_unique;
	end
end



