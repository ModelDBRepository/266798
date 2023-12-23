% Author: Etay Hay
% Orientation processing by synaptic integration across first-order tactile neurons (Hay and Pruszynski 2020)

function stim2 = add_noise_stim(stim,noise_stim)
	if isempty(noise_stim)
		stim2 = stim;
	else
		stim2 = max(0,stim + noise_stim);
	end
end

