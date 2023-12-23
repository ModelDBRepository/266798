% Author: Etay Hay
% Orientation processing by synaptic integration across first-order tactile neurons (Hay and Pruszynski 2020)

function [] = plot_stim(stim)
	plot(0,0,'.w')
	hold on
	for i = 1:size(stim,1)
		for j = 1:size(stim,2)
			if stim(i,j) == 1
				plot(j,i,'.k')
			end
		end
	end
	xlim([0,size(stim,2)])
	ylim([0,size(stim,1)])
	hold off
	axis off
end
