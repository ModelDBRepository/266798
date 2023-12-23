% Author: Etay Hay
% Orientation processing by synaptic integration across first-order tactile neurons (Hay and Pruszynski 2020)

function stim2 = get_stim_t(stim1,ti,stim_type,sim_param)
	if strcmp(stim_type{1},'linepress')
		stim2 = stim1*(ti-1)/200;
	else
		dx = sim_param.dx;	
		rf_size2 = round(sim_param.patch_length_x/dx);
		if strcmp(stim_type{1},'line2') || strcmp(stim_type{1},'dot2')
			j1 = 1 + (ti-1);
			stim2 = stim1(:,j1:(j1 + rf_size2 - 1));
		else
			j1 = size(stim1,2) - rf_size2 + 1 - (ti-1);
			stim2 = stim1(:,j1:(j1 + rf_size2 - 1));
		end
	end
end
