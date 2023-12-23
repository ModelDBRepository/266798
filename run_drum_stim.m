% Author: Etay Hay
% Orientation processing by synaptic integration across first-order tactile neurons (Hay and Pruszynski 2020)

function [model_spike_times, m_t] = run_drum_stim(model,stim_type,sim_param,t_start,t_win,noise_stim)	
	dx = sim_param.dx;
	dy = sim_param.dy;
	data = sim_param.data;
	drum_speed = sim_param.drum_speed;
	model_spike_times = [];
	[stim1, m_t] = get_stim(stim_type,sim_param);
	if ~isempty(noise_stim)
		stim1 = add_noise_stim(stim1,noise_stim);
	end
	[ws,w_pinds] = model2w(model,sim_param);
	ti0 = 1 + round(t_start*(length(m_t)-1));
	if t_win == 0
		ti1 = length(m_t);
	else
		ti1 = ti0 + t_win;
	end
	w_mrs = zeros(length(ws),1);
	t_lastspike = -1*ones(length(ws),1);
	int_lastspike = -1*ones(length(ws),1);
	for ti = ti0:ti1
		stim = get_stim_t(stim1,ti,stim_type,sim_param);
		%{
		imagesc(rot90(stim)')
		pause()
		%}
		for k=1:length(ws)
			if t_lastspike(k)>=0
				int_lastspike(k) = m_t(ti) - t_lastspike(k);
			end
		end
		[spikes,w_mrs] = cell_response(model,ws,stim,w_mrs,int_lastspike,w_pinds);
		s_inds = find(spikes==1);
		if ~isempty(s_inds)
			t_lastspike(s_inds) = m_t(ti);
			model_spike_times = [model_spike_times; m_t(ti)];
		end
	end
end

