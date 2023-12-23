% Author: Etay Hay
% Orientation processing by synaptic integration across first-order tactile neurons (Hay and Pruszynski 2020)

warning off
close all;
clear all;
rng(1234);

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

modeled_cells = [1:6,8:12,15:18];
Nmrs2 = [10,20,30,40];
model_type = '1';
[cell_fit,cell_crossval,s_models] = select_model(modeled_cells,Nmrs2,model_type);
m_fit = mean(cell_fit);
s_fit = std(cell_fit);
m_crossval = mean(cell_crossval);
s_crossval = std(cell_crossval);
disp(['fit = ',num2str(round(m_fit)),' + ',num2str(round(s_fit))])
disp(['crossval = ',num2str(round(m_crossval)),' + ',num2str(round(s_crossval))])

save(['models/selected_models_',model_type],'s_models','cell_fit','cell_crossval','modeled_cells');





