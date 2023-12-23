% Author: Etay Hay
% Orientation processing by synaptic integration across first-order tactile neurons (Hay and Pruszynski 2020)

function err1 = calc_err(o,m)
	if mean(o)==0
		if mean(m)==0
			err1 = 0;
		else
			err1 = 100;
		end
	else
		err1 = 100*(mean((m - o).^2)/mean((o - mean(o)).^2));
	end
end
