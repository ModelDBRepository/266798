% Author: Etay Hay
% Orientation processing by synaptic integration across first-order tactile neurons (Hay and Pruszynski 2020)

function [mean_response,o_spike_rate] = mean_exp_response(stim,sim_param)
	dx = sim_param.dx;
	dy = sim_param.dy;
	data = sim_param.data;
	drum_speed = sim_param.drum_speed;
	dot_xy = sim_param.dot_xy;	

	[x1,x2,ytrial,t] = get_stim_param(stim,sim_param);
	[stim1,t] = get_stim(stim,sim_param);
	ytrials = [-5.6:-0.4:-8];
	%{
	hold on
	%}
	for i = 1:length(ytrials)
		o_spike_times{i} = get_spikes_times2(stim,sim_param,x1,x2,ytrials(i));
		if length(o_spike_times{1})>0 && length(o_spike_times{i})>0
			[o_spike_times{1},o_spike_times{i}] = align_times(o_spike_times{1},o_spike_times{i},t);
		end
		o_spike_rate{i} = get_spike_rate(o_spike_times{i},t);
		if i==1
			mean_response = o_spike_rate{i};
		else
			mean_response = mean_response + o_spike_rate{i};
		end
		%{
		plot(o_spike_rate{i},'r')
		%}
	end
	mean_response = mean_response/length(ytrials);
	%{
	plot(mean_response,'k')
	hold off
	%}
end
