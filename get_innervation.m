% Author: Etay Hay
% Orientation processing by synaptic integration across first-order tactile neurons (Hay and Pruszynski 2020)

function innervation = get_innervation(models)
	d_mr = models{1}.d_mr;
	mr_loc = models{1}.mr_loc;
	win_size = round(sqrt(size(mr_loc,1)));
	innervation = zeros(size(mr_loc));
	for i=1:size(mr_loc,1)
		for j=1:size(mr_loc,2)
			for k=1:length(models)
				for k2 = 1:size(models{k}.mr_subset,1)
					i1 = models{k}.mr_subset(k2,1);
					j1 = models{k}.mr_subset(k2,2);
					if ((i1 >= (i-win_size/2)) && (i1 <= (i + win_size/2))) && ((j1 >= (j-win_size/2)) && (j1 <= (j + win_size/2)))
						innervation(i,j) = innervation(i,j) + 1;
					end
				end
			end
		end
	end
end
