% Author: Etay Hay
% Orientation processing by synaptic integration across first-order tactile neurons (Hay and Pruszynski 2020)

function w = mr_response(d,r1,r2,mr_w)
	w = zeros(size(d));
	inds = find(d <= (r1+r2));
	w(inds) = mr_w * (1 - 1 ./ (1 + exp(-(d(inds)-r1)/(r1/5))));
end
