% Author: Etay Hay
% Orientation processing by synaptic integration across first-order tactile neurons (Hay and Pruszynski 2020)

function performance = calc_performance(ym,y)
	performance = length(find(ym == y))/length(y);
end