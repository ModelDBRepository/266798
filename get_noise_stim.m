% Author: Etay Hay
% Orientation processing by synaptic integration across first-order tactile neurons (Hay and Pruszynski 2020)

function stim_n = get_noise_stim(stim,noise_mean,d_ratio)
	if noise_mean > 0
		stim_n = zeros(size(stim));
		noise_level = max(max(stim))*noise_mean/100;
		s1 = ceil(size(stim,1)/d_ratio);
		s2 = ceil(size(stim,2)/d_ratio);
		noise_mat = (-1 + 2*rand(s1,s2))*noise_level;
		for i = 1:s1
			for j = 1:s2
				i1 = 1 + round((i-1)*d_ratio);
				i2 = min(size(stim,1),i1 + round(d_ratio));
				j1 = 1 + round((j-1)*d_ratio);
				j2 = min(size(stim,2),j1 + round(d_ratio));
				stim_n(i1:i2,j1:j2) = noise_mat(i,j);
			end
		end
	else
		stim_n = [];
	end
end

