% Author: Etay Hay
% Orientation processing by synaptic integration across first-order tactile neurons (Hay and Pruszynski 2020)

function network_classifier = derive_network_classifier_ga(x_train,y_train)
	warning off
	close all;
	Nmodels = 100;
	Niter = 200;
	pmutate = 0.1;
	pcross = 0.1;
	wrange = [-1,1];
	N1 = size(x_train{1},2); 
	N2 = max(y_train)+1;
	performance = zeros(Nmodels,1);
	for i_model = 1:Nmodels
		w = wrange(1) + (wrange(2)-wrange(1))*rand(N1,N2);
		models{i_model} = struct('w',w);
		performance(i_model,1) = calc_performance(run_network_classifier(models{i_model},x_train),y_train);
	end
	[vmax,imax] = max(performance);
	network_classifier = models{imax};
	i_iter = 1;
	while (i_iter <= Niter) && (max(performance) < 1)
		mutation_size = 1 - i_iter/Niter;
		models2 = models;
		for i_model = 1:Nmodels
			if rand() < pmutate
				rvec = randperm(N1);
				i1 = rvec(1);
				rvec = randperm(N2);
				i2 = rvec(1);
				models2{i_model}.w(i1,i2) = max(min(wrange(2),models2{i_model}.w(i1,i2) + (-1 + 2*rand())*(wrange(2)-wrange(1))*mutation_size),wrange(1));
			end
		end
		inds = randperm(Nmodels);
		inds1 = inds(1:round(Nmodels/2));
		inds2 = inds((1+round(Nmodels/2)):Nmodels);
		for k = 1:length(inds1)
			if rand()<pcross
				rvec = randperm(N1);
				i1 = rvec(1);
				rvec = randperm(N2);
				i2 = rvec(1);
				models3 = models2;
				models2{inds1(k)}.w(1:i1,i2) = models3{inds2(k)}.w(1:i1,i2);
				models2{inds2(k)}.w(1:i1,i2) = models3{inds1(k)}.w(1:i1,i2);
			end
		end
		parfor (i_model = 1:Nmodels,3)
			performance2(i_model,1) = calc_performance(run_network_classifier(models2{i_model},x_train),y_train);
		end
		models3 = models;
		for i_model = 1:Nmodels
			models3{end+1} = models2{i_model};
		end
		performance3 = [performance;performance2];
		[vs,is] = sort(performance3,'descend');
		models = models3(is(1:Nmodels));
		performance = performance3(is(1:Nmodels));
		[vmax,imax] = max(performance);
		network_classifier = models{imax};
		%disp(['Iteration ',int2str(i_iter),': best performance = ',num2str(performance(imax))]);
		i_iter = i_iter + 1;
	end
	disp(['Best fit = ',num2str(performance(imax))]);
end



