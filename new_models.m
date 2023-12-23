% Author: Etay Hay
% Orientation processing by synaptic integration across first-order tactile neurons (Hay and Pruszynski 2020)

function models2 = new_models(models,ga_param,mutation_size)
	models2 = models;
	for i=1:length(models)
		models2{i} = mutate_model(models{i},ga_param,mutation_size);
	end
	models2 = cross_models(models2,ga_param.p_cross);
end
