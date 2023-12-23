% Author: Etay Hay
% Orientation processing by synaptic integration across first-order tactile neurons (Hay and Pruszynski 2020)

function m_loc = get_valid_locations(sim_param,d_mr)
	data = sim_param.data;
	dy = sim_param.dy;
	rf_length_x = sim_param.dot_xy(2,1) - sim_param.dot_xy(1,1);
	rf_length_y = sim_param.dot_xy(2,2) - sim_param.dot_xy(1,2);
	m_loc = zeros(round(rf_length_y/d_mr),round(rf_length_x/d_mr));
	
	for yi=1:((sim_param.dot_xy(2,2)-sim_param.dot_xy(1,2))/sim_param.dy)
		stim = {'dot',yi};
		[x1,x2,ytrial,t] = get_stim_param(stim,sim_param);
		spike_inds = intersect(intersect(find(data(:,3)>=x1),find(data(:,3)<=x2)),...
			intersect(find(data(:,2)>=(ytrial - dy/2)),find(data(:,2)<=(ytrial + dy/2))));
		if length(spike_inds) > 1
			spike_locs = x2 - data(spike_inds,3);
			j1 = ceil(min(spike_locs)/d_mr);
			j2 = ceil(max(spike_locs)/d_mr);
			i1 = round((yi-1)*sim_param.dy/d_mr) + 1;
			i2 = round(yi*sim_param.dy/d_mr);
			m_loc(i1:i2,j1:j2) = 1;
		end		
	end
end