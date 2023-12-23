% Author: Etay Hay
% Orientation processing by synaptic integration across first-order tactile neurons (Hay and Pruszynski 2020)

function spike_times = get_spikes_times2(stim,sim_param,x1,x2,ytrial)
	dx = sim_param.dx;
	dy = sim_param.dy;
	data = sim_param.data;
	drum_speed = sim_param.drum_speed;
	dot_xy = sim_param.dot_xy;	

	spike_inds = intersect(intersect(find(data(:,3)>=x1),find(data(:,3)<=x2)),...
		intersect(find(data(:,2)>=(ytrial - dy/2)),find(data(:,2)<=(ytrial + dy/2))));
	if strcmp(stim{1},'line2')
		spike_times = 1 + floor((data(spike_inds,3) - x1)/drum_speed);
	else
		spike_times = 1 + floor((x2 - data(spike_inds,3))/drum_speed);
	end
end
