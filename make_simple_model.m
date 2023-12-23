% Author: Etay Hay
% Orientation processing by synaptic integration across first-order tactile neurons (Hay and Pruszynski 2020)

function model2 = make_simple_model(model)
	model2 = model;
	model2.mr_subset = round(size(model.mr_loc)/2);
	model2.mr_r1 = 0.05;
	model2.mr_r2 = 1.45;
	model2.m_maxrate = 200;
	model2.mr_w = 2*model2.m_maxrate;
	model2.spiking_type = 'simple';
end