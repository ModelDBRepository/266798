% Author: Etay Hay
% Orientation processing by synaptic integration across first-order tactile neurons (Hay and Pruszynski 2020)

function [] = save_accuracy(task_type,acc_type,nc_type,noise_level,t_win,savemode,networktype,learning_alg,senss)
	warning off
	close all;
	rng(1234);
	if noise_level == 0
		Nrand = 1;
	else
		Nrand = 20;
	end

	load(['models/',networktype,'angles',int2str(task_type),'_',int2str(noise_level),'.mat']);
	Ncells = length(models2);
	Ntrials = size(m_spike_times,3);
	for i=1:Ncells
		for k = 1:length(stim_list)
			for k2 = 1:Ntrials
				m_spike_rate = get_spike_rate(m_spike_times{i,k,k2},m_t{k});
				vmax = max(m_spike_rate);
				if nc_type == 1
					psp{k,i,k2} = st2epsp(m_t{k},m_spike_times{i,k,k2},0.5,3);
				elseif nc_type == 2
					psp{k,i,k2} = st2epsp(m_t{k},m_spike_times{i,k,k2},0.5,65);
				elseif nc_type == 3
					psp{k,i,k2} = st2epsp(m_t{k},m_spike_times{i,k,k2},0.5,3) + st2epsp(m_t{i,k,k2},m_spike_times{i,k,k2},0.5,65);
				end
				if t_win > 0
					ti_middle = round(length(m_t{k})/2);
					ti1 = ti_middle - floor(t_win/2);
					ti2 = ti_middle + ceil(t_win/2) - 1;
					psp{k,i,k2} = psp{k,i,k2}(ti1:ti2);
				end
			end
		end
	end
	%senss = [20:-5:5,3,1];
	
	y = zeros(length(stim_list),length(stim_list),Ntrials);
	for k = 1:length(stim_list)
		for k2 = 1:Ntrials
			y(k,k,k2) = 1;
		end
	end
	performance = zeros(Nrand,length(senss));
	for i_sens = 1:length(senss)
		disp([int2str(senss(i_sens)),' degrees'])
		if acc_type == 1
			stim_angles2 = [-senss(i_sens),senss(i_sens)]; 
		elseif acc_type == 2
			stim_angles2 = [0:-senss(i_sens):min(stim_angles),senss(i_sens):senss(i_sens):max(stim_angles)];
		end
		inds2 = find(ismember(stim_angles,stim_angles2));
		
		ws1 = [];
		ws2 = [];
		for i_rand = 1:Nrand
			rvec = randperm(Ntrials);
			inds_train = rvec(1:round(Ntrials/2));
			inds_test = rvec((1+round(Ntrials/2)):Ntrials);
			y_train = [];
			y_test = [];
			psp_train = {};
			psp_test = {};
			for k2 = 1:length(inds_train)
				y_train = [y_train; squeeze(y(inds2,inds2(1),inds_train(k2)))];
				for k3 = 1:length(inds2)
					temp = [];
					for k4 = 1:Ncells
						temp = [temp, psp{inds2(k3),k4,inds_train(k2)}];
					end
					psp_train{end+1} = temp;
				end
			end
			for k2 = 1:length(inds_test)
				y_test = [y_test; squeeze(y(inds2,inds2(1),inds_test(k2)))];
				for k3 = 1:length(inds2)
					temp = [];
					for k4 = 1:Ncells
						temp = [temp, psp{inds2(k3),k4,inds_test(k2)}];
					end
					psp_test{end+1} = temp;
				end
			end
			if strcmp(learning_alg,'ga')
				network_classifier = derive_network_classifier_ga(psp_train,y_train);
			elseif strcmp(learning_alg,'perc')
				network_classifier = derive_network_classifier_perc(psp_train,y_train);
			end
			ym = run_network_classifier(network_classifier,psp_test);
			performance(i_rand,i_sens) = calc_performance(ym,y_test);
			disp(['Test performance = ',num2str(performance(i_rand,i_sens))])
			if savemode == 2
				ws1 = [ws1, network_classifier.w(:,1)];
				ws2 = [ws2, network_classifier.w(:,2)];
			end
		end
		if savemode == 2
			save(['models/',networktype,'wnc',int2str(task_type),'_',int2str(acc_type),'_nc',int2str(nc_type),'_nz',int2str(noise_level),...
				'_tw',int2str(t_win),'_ang',int2str(senss(i_sens)),'_',learning_alg],'ws1','ws2');
		end
	end
	if savemode ~= 0
		save(['models/',networktype,'acc',int2str(task_type),'_',int2str(acc_type),'_nc',int2str(nc_type),'_nz',int2str(noise_level),...
			'_tw',int2str(t_win),'_',learning_alg],'performance','senss');
	end
end



