% Author: Etay Hay
% Orientation processing by synaptic integration across first-order tactile neurons (Hay and Pruszynski 2020)

function spike_times = get_spikes_times(stim,sim_param)
	dx = sim_param.dx;
	dy = sim_param.dy;
	data = sim_param.data;
	drum_speed = sim_param.drum_speed;
	dot_xy = sim_param.dot_xy;	

	[x1,x2,ytrial,t] = get_stim_param(stim,sim_param);
	spike_times = get_spikes_times2(stim,sim_param,x1,x2,ytrial);
end
