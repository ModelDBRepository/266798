% Author: Etay Hay
% Orientation processing by synaptic integration across first-order tactile neurons (Hay and Pruszynski 2020)

function [cell_fit,cell_crossval,s_models] = select_model(modeled_cells,Nmrs2,model_type)
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
	stimdir1 = [1,2,3,4,5,6,8,15,16,17,18];
	drum_speed = .03; % (mm/ms)
	dx = drum_speed; % RF resolution x-axis (mm)
	dy = 0.4; % RF resolution y-axis (mm)
	for cellnumi = 1:length(modeled_cells)
		cellnum = modeled_cells(cellnumi);
		data = load(['../../Data/Tactile/',cellnames{cellnum},'.txt']);
		dot_xy = get_dotxy(cellnum);
		patch_length_x = dot_xy(2,1) - dot_xy(1,1);
		patch_length_y = dot_xy(2,2) - dot_xy(1,2);
		sim_param = struct('dx',dx,'dy',dy,'data',data,'drum_speed',drum_speed,'dot_xy',dot_xy,'cellnum',cellnum,...
			'patch_length_x',patch_length_x,'patch_length_y',patch_length_y);
		models2 = {};
		errs2 = [];
		for i = 1:length(Nmrs2)
			load(['models/c',int2str(cellnum),'_models_',model_type,'_',int2str(Nmrs2(i)),'.mat']);
			errs2 = [errs2,errs];
			for k=1:length(models)
				models2{end+1} = models{k};
			end
		end
		inds_nd = get_nondominated_models(models2,errs2);
		errs3 = [];
		models3 = {};
		for i=1:length(inds_nd)
			i_model = inds_nd(i);
			model = models2{i_model};
			models3{end+1} = model;
			cell_fits(cellnumi,i,:) = max(0,round(100-errs2(:,i_model),1));
			if ismember(cellnum,stimdir1)
				linetype = 'line';
			else
				linetype = 'line2';
			end
			teststim = 0;
			stim_list = {{linetype,teststim}};
			[err,m_spike_times,m_spike_rate,o_spike_times,o_spike_rate,m_t] = test_model(model,stim_list,sim_param);
			errs3(1,end+1) = err;
			cell_crossvals(cellnumi,i) = max(0,round(100-err,1));
		end
		inds_nd2 = get_nondominated_models(models3,errs3);
		Nmr = [];
		for k = 1:length(inds_nd2)
			Nmr(end+1,1) = length(get_uniqueMR(models3{inds_nd2(k)}));
		end
		[vmin,imin] = min(Nmr);
		inds_Nmr = inds_nd2(find((Nmr-vmin) < 5));
		[vmin,imin] = min(errs3(:,inds_Nmr));
		ibest = inds_Nmr(imin);
		cell_fit(cellnumi,1) = mean(squeeze(cell_fits(cellnumi,ibest,:)));
		cell_crossval(cellnumi,1) = mean(cell_crossvals(cellnumi,inds_nd2));
		s_models{cellnumi} = models3{ibest};
	end
