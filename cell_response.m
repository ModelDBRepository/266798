% Author: Etay Hay
% Orientation processing by synaptic integration across first-order tactile neurons (Hay and Pruszynski 2020)

function [spikes,w_mrs] = cell_response(model,ws,stim,w_mrs_prev,int_lastspike,w_pinds)
	spikes = zeros(length(ws),1);
	w_mrs = zeros(length(ws),1);
	for k = 1:length(ws)
		inds = find(stim(w_pinds{k}) > model.s_thresh);
		if length(inds)>0
			w_mrs(k,1) = max(ws{k}(w_pinds{k}(inds)).*stim(w_pinds{k}(inds)));
		end
	end
	if strcmp(model.spiking_type,'simple')
		inds2 = find(w_mrs >= 0);
	else
		inds2 = find(w_mrs > w_mrs_prev);
	end
	if ~isempty(inds2)
		for k=1:length(inds2)
			r = min(model.m_maxrate,w_mrs(inds2(k)));
			if r > 0
				if (int_lastspike(inds2(k))<0)
					spikes(inds2(k)) = 1;
				elseif (r >= (1000/int_lastspike(inds2(k))))
					spikes(inds2(k)) = 1;
				end
			end
		end
	end
	if strcmp(model.spiking_type,'reset')
		if ~isempty(find(spikes==1))
			spikes(:) = 1;
		end
	end
end