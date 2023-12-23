% Author: Etay Hay
% Orientation processing by synaptic integration across first-order tactile neurons (Hay and Pruszynski 2020)

function [] = sim_edge_response(Ntype,model_type,task_type,noise_level,stim_angles)
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

	load(['models/selected_models_',model_type,'.mat']);
	
	drum_speed = .03; % (mm/ms)
	dx = drum_speed; % RF resolution x-axis (mm)
	dy = 0.4; % RF resolution y-axis (mm)
	data = load(['../../Data/Tactile/',cellnames{modeled_cells(1)},'.txt']);
	dot_xy = get_dotxy(modeled_cells(1));
	sim_param = struct('dx',dx,'dy',dy,'data',data,'drum_speed',drum_speed,'dot_xy',dot_xy,'cellnum',modeled_cells(1),'patch_length_x',12,'patch_length_y',12);

	models2 = tile_patch(Ntype,s_models,sim_param);
	if noise_level == 0
		Ntrials = 2;
	else
		Ntrials = 100;
	end
	Ncells = length(models2);
	%stim_angles = [-20:5:-5,-3,-1,1,3,5:5:20];
	for k = 1:length(stim_angles)
		if task_type == 1
			stim_type = 'line';
		elseif task_type == 2
			stim_type = 'linepress';
		elseif task_type == 3
			stim_type = 'line3mm';
		end
		stim_list{k} = {stim_type,stim_angles(k)};
	end
	t_start = 0;
	t_win = 0;
	for k = 1:length(stim_list)
		disp([stim_list{k}{1},' ',num2str(stim_list{k}{2})])
		for k2 = 1:Ntrials
			[stim1, tempo] = get_stim(stim_list{k},sim_param);
			noise_stim = get_noise_stim(stim1,noise_level,dy/dx);
			parfor (i=1:Ncells,3)
				[m_spike_times{i,k,k2},temp] = run_drum_stim(models2{i},stim_list{k},sim_param,t_start,t_win,noise_stim);
			end
		end
		m_t{k} = tempo;
	end
	save(['models/',Ntype,'angles',int2str(task_type),'_',int2str(noise_level)],'m_spike_times','m_t','stim_list','models2','stim_angles');
end



