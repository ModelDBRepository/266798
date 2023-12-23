% Author: Etay Hay
% Orientation processing by synaptic integration across first-order tactile neurons (Hay and Pruszynski 2020)

function st2 = jitter_spiketrain(st,jitter_window)
	inds = find(st == 1);
	st2 = zeros(size(st));
	for k=1:length(inds)
		i1 = inds(k);
		i2 = i1 + round(-1 + 2*rand()*jitter_window);
		if (i2 > 0) && (i2 <= length(st))
			st2(i2) = 1;
		end
	end
end