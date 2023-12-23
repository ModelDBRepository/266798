% Author: Etay Hay
% Orientation processing by synaptic integration across first-order tactile neurons (Hay and Pruszynski 2020)

function maxrate = get_maxrate(cellnum)
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
	stim_list = {};
	if ismember(cellnum,[1,2,3,4,5,6,8,15,16,17,18]) 
		linetype = 'line';
	else
		linetype = 'line2';
	end
	stim_list{end+1} = {linetype,0};
	stim_list{end+1} = {linetype,-22.5};
	stim_list{end+1} = {linetype,22.5};
	stim_list{end+1} = {linetype,-45};
	stim_list{end+1} = {linetype,45};
	o_spike_times = {};
	maxrates = [];
	for stim_i = 1:length(stim_list)
		o_spike_times{stim_i} = get_spikes_times(stim_list{stim_i},sim_param);
		maxrates(stim_i) = round(1000/min(o_spike_times{stim_i}(2:end) - o_spike_times{stim_i}(1:(end-1))));
	end
	maxrate = max(maxrates);
end




