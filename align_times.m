% Author: Etay Hay
% Orientation processing by synaptic integration across first-order tactile neurons (Hay and Pruszynski 2020)

function [aligned_times,aligned_times2] = align_times(spike_times,spike_times2,t)
	if length(spike_times)>1 && length(spike_times2)>1
		% center the first spike train
		spike_times = spike_times - ((spike_times(1)-t(1)) - (t(end)-spike_times(end)))/2;
		align_shifts = -spike_times2(1):(t(end)-spike_times2(end));
		for k = 1:length(align_shifts)
			align_shift2 = align_shifts(k);
			errs(k) = calc_err(get_spike_rate(spike_times,t),get_spike_rate(spike_times2 + align_shift2,t));
		end
		[vmin,imin] = min(errs);
		aligned_times = spike_times;
		aligned_times2 = spike_times2 + align_shifts(imin);
	else
		aligned_times = spike_times;
		aligned_times2 = spike_times2;
	end
end

