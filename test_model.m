% Author: Etay Hay
% Orientation processing by synaptic integration across first-order tactile neurons (Hay and Pruszynski 2020)

function [err,m_spike_times,m_spike_rate,o_spike_times,o_spike_rate,m_t] = test_model(model,stim_list,sim_param)
	dx = sim_param.dx;
	dy = sim_param.dy;
	data = sim_param.data;
	drum_speed = sim_param.drum_speed;
	dot_xy = sim_param.dot_xy;	

	err = [];
	for stim_i = 1:length(stim_list)
		o_spike_times{stim_i} = get_spikes_times(stim_list{stim_i},sim_param);
		[m_spike_times{stim_i},m_t{stim_i}] = run_drum_stim(model,stim_list{stim_i},sim_param,0,0,[]);
		if length(m_spike_times{stim_i})>0 && length(o_spike_times{stim_i})>0
			[o_spike_times{stim_i},m_spike_times{stim_i}] = align_times(o_spike_times{stim_i},m_spike_times{stim_i},m_t{stim_i});
		end
		o_spike_rate{stim_i} = get_spike_rate(o_spike_times{stim_i},m_t{stim_i});
		m_spike_rate{stim_i} = get_spike_rate(m_spike_times{stim_i},m_t{stim_i});
		err(stim_i) = calc_err(o_spike_rate{stim_i},m_spike_rate{stim_i});
	end
end
