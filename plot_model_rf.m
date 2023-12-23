% Author: Etay Hay
% Orientation processing by synaptic integration across first-order tactile neurons (Hay and Pruszynski 2020)

function [] = plot_model_rf(model,patch_length,sim_param,stimdir1)
	dy = sim_param.dy;
	dx = sim_param.dx;
	drum_speed = sim_param.drum_speed;
	[indsR,indsC] = find(model.mr_loc == 1);
	shifti = (patch_length - model.d_mr*(max(indsR) + min(indsR)))/2; 
	shiftj = (patch_length - model.d_mr*(max(indsC) + min(indsC)))/2;
	if ismember(sim_param.cellnum,stimdir1)
		dottype = 'dot';
	else
		dottype = 'dot2';
	end
	stim_list = {};
	for stim_i = 1:(round(sim_param.patch_length_y/dy))
		stim_list{end+1} = {dottype,stim_i};
		[m_spike_times{stim_i},m_t{stim_i}] = run_drum_stim(model,stim_list{stim_i},sim_param,0,0,[]);
		m_spike_times{stim_i} = m_spike_times{stim_i} + shiftj/drum_speed;
		if (sim_param.patch_length_x > patch_length)
			m_t{stim_i} = m_t{stim_i}(1:(end - round((length(m_t{stim_i})*drum_speed - patch_length)/dx)));
		else
			temp = zeros(round(patch_length/dx),1);
			temp(1:length(m_t{stim_i})) = m_t{stim_i};
			m_t{stim_i} = temp;
		end
		m_spike_rate{stim_i} = get_spike_rate(m_spike_times{stim_i},m_t{stim_i});
	end
	mat1 = zeros(round(patch_length/drum_speed),length(m_spike_rate{1}));
	N1 = round(dy/dx);
	for k = 1:length(m_spike_rate)
		for k2 = 1:N1
			i0 = (k-1)*N1+k2+round(shifti/dx);
			if i0>0 && i0<size(mat1,2)
				mat1(i0,:) = m_spike_rate{k};
			end
		end
	end
	mat1 = imgaussfilt(mat1,5);
	imagesc(rot90(mat1'))
	colormap('hot')
	axis off
end
