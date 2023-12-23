% Author: Etay Hay
% Orientation processing by synaptic integration across first-order tactile neurons (Hay and Pruszynski 2020)

function ym = run_network_classifier(network_classifier,x)
	N1 = size(network_classifier.w,1);
	N2 = size(network_classifier.w,2);
	ym = zeros(length(x),1);
	Ntrials = length(x);
	for i_trial = 1:Ntrials
		psp_sum = x{i_trial}*network_classifier.w;
		[vmax,ym(i_trial,1)] = max(max(psp_sum));
		ym(i_trial) = ym(i_trial) - 1;
	end
end

