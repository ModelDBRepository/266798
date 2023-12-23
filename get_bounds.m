% Author: Etay Hay
% Orientation processing by synaptic integration across first-order tactile neurons (Hay and Pruszynski 2020)

function [w,lbounds,ubounds] = get_bounds(sim_param)
	dx = sim_param.dx;
	dy = sim_param.dy;
	data = sim_param.data;
	drum_speed = sim_param.drum_speed;
	dot_xy = sim_param.dot_xy;	
	maxrate = sim_param.maxrate;

	rfx = 0:dx:(dot_xy(2,1) - dot_xy(1,1) - dx); % RF x bins
	rfy = (dot_xy(2,2) - dot_xy(1,2)):-dy:0; % RF y bins
	w = zeros(length(rfy),length(rfx));

	stim_list = {};
	for yi=1:size(w,1)
		stim_list{end+1} = {'dot',yi};
	end

	lbounds = zeros(size(w));
	ubounds = zeros(size(w));
	for stim_i = 1:length(stim_list)
		stim = stim_list{stim_i};
		o_spike_times{stim_i} = get_spikes_times(stim,sim_param);
		yi = length(rfy)-stim{2}+1;
		
		if length(o_spike_times{stim_i}) > 0
			for k = 1:length(o_spike_times{stim_i})
				xi = o_spike_times{stim_i}(k);
				if k < length(o_spike_times{stim_i})
					xi2 = o_spike_times{stim_i}(k+1);
					isi = xi2 - xi;
					lbounds(yi,xi2) = 1000/isi;
					ubounds(yi,xi2) = maxrate;
					w(yi,xi2) = 1000/isi;
				else
					isi = round(dy/drum_speed);
				end
				if k == 1
					lbounds(yi,xi) = 1;
					ubounds(yi,xi) = maxrate;
					w(yi,xi) = 1000/isi;
				end
				inds = (xi+1):min(xi + isi - 1, size(w,2));
				isis = inds - xi + 1;
				ubounds(yi,inds) = min(1000./isis,maxrate);
				w(yi,inds) = 1000/isi;
			end
		end
	end	
end
