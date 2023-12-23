% Author: Etay Hay
% Orientation processing by synaptic integration across first-order tactile neurons (Hay and Pruszynski 2020)

function [model,ws,model_errs] = cell2model(cellnum,Nmr,model_type)
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
		'ha28FAI_Nerve____VideoCCLWDIR0__Drumpilot3-444.b00',... % opposite direction
		'ha28FAI_Nerve____VideoCLW_DIR0__Drumpilot3-445.b00',...
		'jk29FAI_Nerve____VideoCLW_DIR0__Drumpilot3-453.b00',...
		'jk29FAI_Nerve____VideoCLW_DIR0__Drumpilot3-456.b00',...
		'ms29FAI_Nerve____VideoCLW_DIR90_Drumpilot3-469.b00',...
	};
	drum_speed = .03; % (mm/ms)
	dx = drum_speed; % RF resolution x-axis (mm)
	dy = 0.4; % RF resolution y-axis (mm)
	data = load(['../../Data/Tactile/',cellnames{cellnum},'.txt']);
	dot_xy = get_dotxy(cellnum);
	patch_length_x = dot_xy(2,1) - dot_xy(1,1);
	patch_length_y = dot_xy(2,2) - dot_xy(1,2);
	sim_param = struct('dx',dx,'dy',dy,'data',data,'drum_speed',drum_speed,'dot_xy',dot_xy,'cellnum',cellnum,'patch_length_x',patch_length_x,'patch_length_y',patch_length_y);
	load(['models/c',int2str(cellnum),'_models_',model_type,'_',int2str(Nmr),'.mat']);
	[model,i_model] = extract_single_model(models,errs);
	MR_unique = get_uniqueMR(model);
	model.mr_subset = model.mr_subset(MR_unique,:);
	model.mr_w = model.mr_w(MR_unique);
	ws = model2w(model,sim_param);
	model_errs = errs(:,i_model);
end

