% Author: Etay Hay
% Orientation processing by synaptic integration across first-order tactile neurons (Hay and Pruszynski 2020)

function [models,errs] = derive_model_ga(stim_list,sim_param,ga_param)
	max_iter = ga_param.max_iter;
	p_mutate = ga_param.p_mutate;
	p_cross = ga_param.p_cross;
	Nmodels = ga_param.Nmodels;
	err_tol = ga_param.err_tol;
	Nmr = ga_param.Nmr;
	s_group = ga_param.s_group;

	mr_loc = get_valid_locations(sim_param,ga_param.d_mr);
	[r_loc,c_loc] = find(mr_loc == 1);
	for k = 1:Nmodels
		mr_subset = [];
		for k2 = 1:Nmr
			rvec = randperm(length(r_loc));
			mr_subset(k2,1) = r_loc(rvec(1));
			mr_subset(k2,2) = c_loc(rvec(1));
			if (ga_param.mr_wmin == ga_param.mr_wmax)
				mr_w(k2,1) = ga_param.mr_wmin; 
			else
				mr_w(k2,1) = ga_param.mr_wmin + rand()*(ga_param.mr_wmax - ga_param.mr_wmin);
			end
		end
		if (ga_param.mr_r1_min == ga_param.mr_r1_max)
			mr_r1 = ga_param.mr_r1_min;
			mr_r2 = ga_param.mr_r2_max;
		else
			mr_r1 = ga_param.mr_r1_min + rand()*(ga_param.mr_r1_max - ga_param.mr_r1_min);
			mr_r2 = ga_param.mr_r2_min + rand()*(ga_param.mr_r2_max - ga_param.mr_r2_min);
		end
		if (ga_param.mr_wmin == ga_param.mr_wmax)
			m_maxrate = ga_param.m_maxrate_min;
		else
			m_maxrate = ga_param.m_maxrate_min + rand()*(ga_param.m_maxrate_max - ga_param.m_maxrate_min);
		end
		models{k} = struct('mr_subset',mr_subset,'mr_w',mr_w,'mr_loc',mr_loc,'mr_r1',mr_r1,'mr_r2',mr_r2,...
						   's_thresh',ga_param.s_thresh,'m_maxrate',m_maxrate,'d_mr',ga_param.d_mr,'spiking_type',ga_param.spiking_type);
		[errs(:,k),m_spike_times,m_spike_rate,o_spike_times,o_spike_rate,m_t] = test_model(models{k},stim_list,sim_param);
	end
	errs_ug = errs;
	for k=1:max(s_group)
		inds = find(s_group == k);
		errs2(k,:) = mean(errs(inds,:),1);
	end
	errs = errs2;
	iter_i = 1;
	while min(max(errs,[],1))>err_tol && iter_i<max_iter
		Nunique = Nmodels;
		for k = 2:Nmodels
			found = 0;
			for k2 = 1:(k-1)
				if isequal(models{k},models{k2})
					found = 1;
				end
			end
			if found
				Nunique = Nunique - 1;
			end
		end
		disp([int2str(Nunique),' unique models'])

		mutation_size = 1 - iter_i/max_iter;
		models2 = new_models(models,ga_param,mutation_size);
		errs2 = [];
		parfor (k=1:Nmodels,3)
			[errs2(:,k),m_spike_times,m_spike_rate,o_spike_times,o_spike_rate,m_t] = test_model(models2{k},stim_list,sim_param);
		end
		errs2_ug = errs2;
		errs2g = [];
		for k=1:max(s_group)
			inds = find(s_group == k);
			errs2g(k,:) = mean(errs2(inds,:),1);
		end
		errs2 = errs2g;
		errs3 = [errs,errs2];
		[vs,is] = sort(mean(errs3,1),'ascend');
		inds = is(1:Nmodels);
		inds1 = inds(find(inds<=Nmodels));
		inds2 = inds(find(inds>Nmodels)) - Nmodels;
		models3 = {models{inds1},models2{inds2}};
		models = models3;
		errs4 = [errs(:,inds1),errs2(:,inds2)];
		errs = errs4;
		errs4_ug = [errs_ug(:,inds1),errs2_ug(:,inds2)];
		errs_ug = errs4_ug;
		[vmin,imin] = min(mean(errs,1));
		disp(['Iteration ',int2str(iter_i),': Minimal average error = ',num2str(round(vmin,2))])
		str = '';
		for k=1:size(errs,1)
			str = [str,'   ',num2str(round(errs(k,imin),2))];
		end
		disp(['Iteration ',int2str(iter_i),': best model errors = ',str])
		str = '';
		for k=1:size(errs_ug,1)
			str = [str,'   ',num2str(round(errs_ug(k,imin),2))];
		end
		disp(['Iteration ',int2str(iter_i),': best model errors, ungrouped = ',str])
		save(['models/c',int2str(sim_param.cellnum),'_models_',ga_param.model_type,'_',int2str(ga_param.Nmr)],'models','errs');
		iter_i = iter_i+1;
	end
end
