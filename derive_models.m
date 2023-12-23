% Author: Etay Hay
% Orientation processing by synaptic integration across first-order tactile neurons (Hay and Pruszynski 2020)

function [] = derive_models(cellnum,model_type,Nmr)
	warning off
	close all;
	rng(1234);

	% Data of spikes in time and space 
	% 1 - time (s)
	% 2 - position translation (mm)
	% 3 - position rotation (mm)
	% 4 - instantaneous speed (mm/s)
	% 5 - instantaneous contact force

	cellnames = {...
		'ap001FAI_Nerve____VideoCLW_DIR0__Drumpilot3-193.b00',...
		'sx0302FAI_Nerve____VideoCLW_DIR0__Drumpilot3-212.b00',...
		'ra0410FAI_Nerve____VideoCLW_DIR0__Drumpilot3-250.b00',...
		'ra0411FAI_Nerve____VideoCLW_DIR0__Drumpilot3-256.b00_c',...
		'lk0602FAI_Nerve____VideoCLW_DIR0__Drumpilot3-260.b00',...
		'fb1001FAI_Nerve____VideoCLW_DIR0__Drumpilot3-299.b00',...
		'pd1101FAI_Nerve____VideoCCLWDIR0__Drumpilot3-313.b00',... % opposite direction
		'pd1102FAI_Nerve____VideoCLW_DIR0__Drumpilot3-315.b00',...
		'pd1103FAI_Nerve____VideoCCLWDIR0__Drumpilot3-317.b00',... % opposite direction
		'sc1203FAI_Nerve____VideoCCLWDIR0__Drumpilot3-324.b00',... % opposite direction
		'JO1601FAI_Nerve____VideoCCLWDIR0__Drumpilot3-343.b00',... % opposite direction
		'SH1701FAI_Nerve____VideoCCLWDIR90_Drumpilot3-357.b00',... % opposite direction
		'SH1703FAI_Nerve____VideoCCLWDIR90_Drumpilot3-358.b00',... % opposite direction
		'ha28FAI_Nerve____VideoCCLWDIR0__Drumpilot3-444.b00',... % opposite direction , noisy response and between stims
		'ha28FAI_Nerve____VideoCLW_DIR0__Drumpilot3-445.b00',...
		'jk29FAI_Nerve____VideoCLW_DIR0__Drumpilot3-453.b00',...
		'jk29FAI_Nerve____VideoCLW_DIR0__Drumpilot3-456.b00',...
		'ms29FAI_Nerve____VideoCLW_DIR90_Drumpilot3-469.b00',...
		'is3201FAI_Nerve____VideoCLW_DIR0__Drumpilot3-423.b00',... % receptive field larger than dot spacing
	};

	drum_speed = .03; % (mm/ms)
	dx = drum_speed; % RF resolution x-axis (mm)
	dy = 0.4; % RF resolution y-axis (mm)
	data = load(['../../Data/Tactile/',cellnames{cellnum},'.txt']);
	dot_xy = get_dotxy(cellnum);
	patch_length_x = dot_xy(2,1) - dot_xy(1,1);
	patch_length_y = dot_xy(2,2) - dot_xy(1,2);
	sim_param = struct('dx',dx,'dy',dy,'data',data,'drum_speed',drum_speed,'dot_xy',dot_xy,'cellnum',cellnum,'patch_length_x',patch_length_x,'patch_length_y',patch_length_y);
	ga_param = struct(...
		'Nmr',Nmr,...
		'd_mr',0.15,...
		'max_iter',300,...
		'p_mutate',0.1,...
		'p_cross',0.1,...
		'Nmodels',100,...
		'err_tol',5,...
		'model_type',model_type,...
		's_thresh',0.01,...
		'spiking_type','reset');
	stim_list = {};
	s_group = [];
	if strcmp(model_type,'1')
		stim_type = 'lines2';
		ga_param.d_mr = 0.1;
		w_type = 'same';
		r_type = 'variable';
		ga_param.max_iter = 300;
	elseif strcmp(model_type,'2')
		stim_type = 'lines';
		w_type = 'variable';
		r_type = 'fixed';
		ga_param.max_iter = 400;
	end
	if strcmp(stim_type,'lines')
		if ismember(cellnum,[1,2,3,4,5,6,8,15,16,17,18]) 
			linetype = 'line';
		else
			linetype = 'line2';
		end
		stim_list{end+1} = {linetype,0};
		s_group(end+1,1) = 1;
		stim_list{end+1} = {linetype,-22.5};
		s_group(end+1,1) = 2;
		stim_list{end+1} = {linetype,22.5};
		s_group(end+1,1) = 3;
		stim_list{end+1} = {linetype,-45};
		s_group(end+1,1) = 4;
		stim_list{end+1} = {linetype,45};
		s_group(end+1,1) = 5;
	elseif strcmp(stim_type,'lines2')
		if ismember(cellnum,[1,2,3,4,5,6,8,15,16,17,18]) 
			linetype = 'line';
		else
			linetype = 'line2';
		end
		stim_list{end+1} = {linetype,-22.5};
		s_group(end+1,1) = 1;
		stim_list{end+1} = {linetype,22.5};
		s_group(end+1,1) = 2;
		stim_list{end+1} = {linetype,-45};
		s_group(end+1,1) = 3;
		stim_list{end+1} = {linetype,45};
		s_group(end+1,1) = 4;
	elseif strcmp(stim_type,'dots')
		if ismember(cellnum,[1,2,3,4,5,6,8,15,16,17,18]) 
			dottype = 'dot';
		else
			dottype = 'dot2';
		end
		for k=1:(round(patch_length_y/dy))
			stim_list{end+1} = {dottype,k};
			s_group(end+1,1) = 1;
		end
	elseif strcmp(stim_type,'dots+lines')
		if ismember(cellnum,[1,2,3,4,5,6,8,15,16,17,18]) 
			linetype = 'line';
		else
			linetype = 'line2';
		end
		stim_list{end+1} = {linetype,0};
		s_group(end+1,1) = 1;
		stim_list{end+1} = {linetype,-22.5};
		s_group(end+1,1) = 2;
		stim_list{end+1} = {linetype,22.5};
		s_group(end+1,1) = 3;
		stim_list{end+1} = {linetype,-45};
		s_group(end+1,1) = 4;
		stim_list{end+1} = {linetype,45};
		s_group(end+1,1) = 5;
		if ismember(cellnum,[1,2,3,4,5,6,8,15,16,17,18]) 
			dottype = 'dot';
		else
			dottype = 'dot2';
		end
		for k=1:(round(patch_length_y/dy))
			stim_list{end+1} = {dottype,k};
			s_group(end+1,1) = 6;
		end
	end
	ga_param.s_group = s_group;
	o_spike_times = {};
	maxrates = [];
	for stim_i = 1:length(stim_list)
		o_spike_times{stim_i} = get_spikes_times(stim_list{stim_i},sim_param);
		if length(o_spike_times{stim_i})>1
			maxrates(stim_i) = round(1000/min(o_spike_times{stim_i}(2:end) - o_spike_times{stim_i}(1:(end-1))));
		else
			maxrates(stim_i) = 0;
		end
	end
	if strcmp(w_type,'variable')
		ga_param.m_maxrate_min = max(maxrates);
		ga_param.m_maxrate_max = round(1.5*max(maxrates));
		ga_param.mr_wmin = 0;
		ga_param.mr_wmax = 3*max(maxrates);
	elseif strcmp(w_type,'same')
		ga_param.m_maxrate_min = max(maxrates);
		ga_param.m_maxrate_max = max(maxrates);
		ga_param.mr_wmin = 2*max(maxrates);
		ga_param.mr_wmax = 2*max(maxrates);
	end
	if strcmp(r_type,'fixed')
		ga_param.mr_r1_min = 0.05;
		ga_param.mr_r1_max = 0.05;
		ga_param.mr_r2_min = 0.2;
		ga_param.mr_r2_max = 0.2;
	elseif strcmp(r_type,'variable')
		ga_param.mr_r1_min = 0.05;
		ga_param.mr_r1_max = 1;
		ga_param.mr_r2_min = 0.2;
		ga_param.mr_r2_max = 1;
	end
	[models,errs] = derive_model_ga(stim_list,sim_param,ga_param);
end




