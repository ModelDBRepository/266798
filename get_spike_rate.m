% Author: Etay Hay
% Orientation processing by synaptic integration across first-order tactile neurons (Hay and Pruszynski 2020)

function spike_rate = get_spike_rate(spike_times,t)
	spike_rate = zeros(1,length(t));
	if length(spike_times)>1
		for i1 = 1:(length(spike_times)-1)
			j1 = spike_times(i1) + 1;
			j2 = min(spike_times(i1+1) + 1,length(spike_rate));
			if i1==1
				spike_rate(j1:j2) = 1000/(j2-j1);
			else
				spike_rate((j1+1):j2) = 1000/(j2-j1);
			end
		end
	end
end

