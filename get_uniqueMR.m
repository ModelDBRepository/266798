% Author: Etay Hay
% Orientation processing by synaptic integration across first-order tactile neurons (Hay and Pruszynski 2020)

function mr_unique = get_uniqueMR(model)
	Nmr = size(model.mr_subset,1);
	mr_unique = [];
	if Nmr>1
		mr_unique = [1];
		for i = 2:Nmr
			if ~ismember(model.mr_subset(i,:),model.mr_subset(1:(i-1),:),'rows')
				mr_unique = [mr_unique;i];
			end			
		end
	end
	mr_unique = mr_unique(find(model.mr_w(mr_unique)>0));
end

