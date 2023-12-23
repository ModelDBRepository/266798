% Author: Etay Hay
% Orientation processing by synaptic integration across first-order tactile neurons (Hay and Pruszynski 2020)

function model2 = mutate_model(model,ga_param,mutation_size);
	p_mutate = ga_param.p_mutate;
	model2 = model;

	k = ceil(rand()*size(model2.mr_subset,1));
	row = model2.mr_subset(k,1);
	col = model2.mr_subset(k,2);
	if rand() < 0.5
		lb = find(model2.mr_loc(row,:) == 1, 1, 'first');
		ub = find(model2.mr_loc(row,:) == 1, 1, 'last');
		model2.mr_subset(k,2) = max(min(ub,model2.mr_subset(k,2) + round((-1 + 2*rand())*(ub - lb)*mutation_size)),lb);
	else
		lb = find(model2.mr_loc(:,col) == 1, 1, 'first');
		ub = find(model2.mr_loc(:,col) == 1, 1, 'last');
		new_row = max(min(ub,model2.mr_subset(k,1) + round((-1 + 2*rand())*(ub - lb)*mutation_size)),lb);
		model2.mr_subset(k,1) = new_row;
		if max(model2.mr_loc(new_row,:),[],2)==0
			if model2.mr_subset(k,1) > model.mr_subset(k,1)
				model2.mr_subset(k,1) = new_row + find(max(model2.mr_loc((new_row+1):end,:),[],2) > 0, 1, 'first');
			else
				model2.mr_subset(k,1) = find(max(model2.mr_loc(1:(new_row-1),:),[],2) > 0, 1, 'last');
			end
		end
		if model.mr_loc(model2.mr_subset(k,1),model2.mr_subset(k,2)) == 0
			inds = find(model.mr_loc(model2.mr_subset(k,1),:) == 1);
			if model2.mr_subset(k,2) < inds(1)
				model2.mr_subset(k,2) = inds(1);
			else
				model2.mr_subset(k,2) = inds(end);
			end
		end
	end
	if isequal(model2.mr_subset(k,:),model.mr_subset(k,:))
		[r_loc,c_loc] = find(model.mr_loc == 1);
		rvec = randperm(length(r_loc));
		model2.mr_subset(k,1) = r_loc(rvec(1));
		model2.mr_subset(k,2) = c_loc(rvec(1));
	end
	if (ga_param.mr_wmin ~= ga_param.mr_wmax)
 		if rand() < p_mutate
			k = ceil(rand()*size(model2.mr_subset,1));
			model2.mr_w(k) = max(min(ga_param.mr_wmax,model2.mr_w(k) + (-1 + 2*rand())*(ga_param.mr_wmax - ga_param.mr_wmin)*mutation_size),ga_param.mr_wmin);
		end
		if rand() < p_mutate
			model2.m_maxrate = max(min(ga_param.m_maxrate_max,model2.m_maxrate + (-1 + 2*rand())*(ga_param.m_maxrate_max - ga_param.m_maxrate_min)*mutation_size),ga_param.m_maxrate_min);
		end
	end
	if (ga_param.mr_r1_min ~= ga_param.mr_r1_max)
		if rand() < p_mutate
			model2.mr_r1 = max(min(ga_param.mr_r1_max,model2.mr_r1 + (-1 + 2*rand())*(ga_param.mr_r1_max - ga_param.mr_r1_min)*mutation_size),ga_param.mr_r1_min);
		end
		if rand() < p_mutate
			model2.mr_r2 = max(min(ga_param.mr_r2_max,model2.mr_r2 + (-1 + 2*rand())*(ga_param.mr_r2_max - ga_param.mr_r2_min)*mutation_size),ga_param.mr_r2_min);
		end
	end
end
