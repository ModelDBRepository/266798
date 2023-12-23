% Author: Etay Hay
% Orientation processing by synaptic integration across first-order tactile neurons (Hay and Pruszynski 2020)

function model2 = model_rotation(model)
	[r_loc,c_loc] = find(model.mr_loc == 1);
	center(1,1) = (max(r_loc)+min(r_loc))/2;
	center(1,2) = (max(c_loc)+min(c_loc))/2;
	model2 = model;
	theta = rand()*2*pi;
	R = [cos(theta) -sin(theta); sin(theta) cos(theta)];
	s = model.mr_subset - center;
	so = s*R;
	model2.mr_subset = round(so + center);
end