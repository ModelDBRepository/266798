% Author: Etay Hay
% Orientation processing by synaptic integration across first-order tactile neurons (Hay and Pruszynski 2020)

warning off
close all;
clear all;
rng(1234);

savefig = 'y';
filetype = '-dtiff';
ploscb_pwidth = 19.05;
ploscb_pheight = 22.23;

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
stimdir1 = [1,2,3,4,5,6,8,15,16,17,18];
drum_speed = .03; % (mm/ms)
dx = drum_speed; % RF resolution x-axis (mm)
dy = 0.4; % RF resolution y-axis (mm)

ff1 = figure();
set(gcf,'paperunits','centimeters');
pwidth = ploscb_pwidth;
pheight = ploscb_pwidth*0.4;
set(gcf,'papersize',[pwidth pheight]);
set(gcf,'paperposition',[0, 0, pwidth, pheight]);

subplot('position',[0.07 0.5 0.22 0.43])
hold on
text(0,105,{'MR'},'fontname','arial','fontsize',8,'horizontalalignment','center')
for k = 40:10:90;
	plot(0,k,'o','markeredgecolor',[255,219,172]/255,'markerfacecolor',[255,219,172]/255,'markersize',3)
	plot(10,k,'ok','markerfacecolor','k','markersize',2)
	plot([10,80],k*[1,1],'k')
	plot([80,90],[k,65],'k')
end
plot([90,160],[65,65],'k')
st1 = 20:15:70;
st2 = 20:6:70;
for k = st1
	plot(k*[1,1],[60,65],'r')
end
for k = st2
	plot(k*[1,1],[80,85],'r')
end
text(50,110,{'Innervating','Axons'},'fontname','arial','fontsize',8,'horizontalalignment','center')

for k = [st2]
	plot(80+k*[1,1],[65,70],'r')
end
text(120,110,{'Neuron','Output'},'fontname','arial','fontsize',8,'horizontalalignment','center')
xlim([-5,180])
ylim([10,125])
hold off
axis off

model_type = '1';
load(['models/selected_models_',model_type,'.mat']);
m_fit = mean(cell_fit);
s_fit = std(cell_fit);
m_crossval = mean(cell_crossval);
s_crossval = std(cell_crossval);
disp(['fit = ',num2str(round(m_fit)),' + ',num2str(round(s_fit))])
disp(['cross validation = ',num2str(round(m_crossval)),' + ',num2str(round(s_crossval))])
Nmr = [];
for k=1:length(s_models)
	Nmr(k,1) = length(get_uniqueMR(s_models{k}));
end
disp(['Nmr = ',num2str(round(mean(Nmr))),' + ',num2str(round(std(Nmr)))])

% 3,1,18,16
cellex = 1;

cellnum = cellex;
cellnumi = find(modeled_cells==cellnum);
data = load(['../../Data/Tactile/',cellnames{cellnum},'.txt']);
dot_xy = get_dotxy(cellnum);
patch_length_x = dot_xy(2,1) - dot_xy(1,1);
patch_length_y = dot_xy(2,2) - dot_xy(1,2);
sim_param = struct('dx',dx,'dy',dy,'data',data,'drum_speed',drum_speed,'dot_xy',dot_xy,'cellnum',cellnum,'patch_length_x',patch_length_x,'patch_length_y',patch_length_y);

patch_length = max(patch_length_x,patch_length_y);
model = s_models{cellnumi};
model_rand = model_variation(model);
subplot('position',[0.35 0.55 0.35*pheight/pwidth 0.35])
plot_model_innervation(model_rand,patch_length,1)
title('Initial, Random','fontname','arial','fontsize',8,'fontweight','normal')
scalebar_l = (0.35*pheight/pwidth)/patch_length;
annotation('line',[0.36,0.36+scalebar_l],[0.53,0.53],'color','k','linewidth',1.5)
annotation('textbox',[0.35 0.485 0.1 0.05],'edgecolor','none','string','1 mm','fontname','arial','fontsize',8);

annotation('textbox',[0.49 0.75 0.1 0.05],'edgecolor','none','string','Optimization','fontname','arial','fontsize',8);
annotation('arrow',[0.52,0.57],[0.72,0.72],'color','k','linewidth',1)

subplot('position',[0.6 0.55 0.35*pheight/pwidth 0.35])
plot_model_innervation(model,patch_length,2)
title('Model','fontname','arial','fontsize',8,'fontweight','normal')

subplot('position',[0.8 0.55 0.35*pheight/pwidth 0.35])
plot_model_rf(model,patch_length,sim_param,stimdir1);
title('RF Response','fontname','arial','fontsize',8,'fontweight','normal')

if ismember(cellnum,stimdir1)
	linetype = 'line';
else
	linetype = 'line2';
end
stim_list = {{linetype,-22.5},{linetype,22.5},{linetype,-45},{linetype,45}};
[err,m_spike_times,m_spike_rate,o_spike_times,o_spike_rate,m_t] = test_model(model,stim_list,sim_param);
tlim = 0;
for k=1:length(stim_list)
	tlim = max([tlim,max(m_spike_times{k})]);
end
tlim = 50*(ceil(tlim/50)+1);

for i = 1:length(stim_list)
	m_t2{i} = 0:tlim;
	tshift = round(tlim/2 - mean(m_spike_times{i}));
	m_spike_times2{i} = m_spike_times{i} + tshift;
	o_spike_times2{i} = o_spike_times{i} + tshift;
	m_spike_rate2{i} = get_spike_rate(m_spike_times2{i},m_t2{i});
	o_spike_rate2{i} = get_spike_rate(o_spike_times2{i},m_t2{i});
end
annotation('line',[0.15,0.16],[0.445,0.445],'color','k','linewidth',1.5)
annotation('textbox',[0.16 0.43 0.15 0.05],'edgecolor','none','string','Train Data','fontname','arial','fontsize',8);
annotation('line',[0.27,0.28],[0.445,0.445],'color','r','linewidth',1.5)
annotation('textbox',[0.28 0.43 0.15 0.05],'edgecolor','none','string','Model','fontname','arial','fontsize',8);
line_colors = {0.5*[1,1,1],'r',0.5*[0,1,0],0.5*[0,0,1],'m'};
for i = 1:length(stim_list)
	subplot('position',[(0.05+0.11*(i-1)) 0.15 0.1 0.33])
	hold on
	plot(m_t2{i},o_spike_rate2{i},'k')
	plot(m_t2{i},m_spike_rate2{i},'r')
	hold off
	xlim([0 tlim])
	ylim([0,350])
	xl = xlim;
	yl = ylim;
	axis off
	line_length = 0.15*(yl(2)-yl(1));
	line(xl(1)+0.85*(xl(2)-xl(1)) + [-0.5,0.5]*cos(pi/2 - stim_list{i}{2}*2*pi/360)*line_length,yl(1) + 0.6*(yl(2)-yl(1)) + [0,sin(pi/2 - stim_list{i}{2}*2*pi/360)*line_length]...
		,'linewidth',2,'color',line_colors{i});
	if (i == length(stim_list))
		scale_time = 30;
		scale_rate = 50;
		line(xl(2)-[0,scale_time],yl(1) + 0.3*(yl(2) - yl(1)) + [0,0],'linewidth',0.8,'color','k');
		line(xl(2)-[0,0],yl(1) + 0.3*(yl(2)-yl(1)) + [0,scale_rate],'linewidth',0.8,'color','k');
		text(xl(2)-60,yl(1) + 0.2*(yl(2)-yl(1)),[int2str(scale_time),' ms'],'fontname','arial','fontsize',8);
		text(xl(2)+35,yl(1) + 0.33*(yl(2)-yl(1)),[int2str(scale_rate),' Hz'],'fontname','arial','fontsize',8,'rotation',90);
	end
	subplot('position',[(0.05+0.11*(i-1)) 0.1 0.1 0.05])
	hold on
	for spikei=1:length(o_spike_times2{i})
		plot(o_spike_times2{i}(spikei)*[1,1],[0.2,0.4],'k')		
		
	end
	for spikei=1:length(m_spike_times2{i})
		plot(m_spike_times2{i}(spikei)*[1,1],[0.5,0.7],'r')		
	end
	hold off
	axis off
	xlim([0 tlim])
	ylim([0 1])
	annotation('textbox',[(0.06 + 0.11*(i-1)) 0.05 0.15 0.05],'edgecolor','none','string',...
		['R^2 = ',num2str(max(0,round(100-err(i)))),'%'],'color',0.3*[1,1,1],'fontname','arial','fontsize',8);
end

r1s = [];
r2s = [];
for cellnumi = 1:length(modeled_cells)
	cellnum = modeled_cells(cellnumi);
	data = load(['../../Data/Tactile/',cellnames{cellnum},'.txt']);
	dot_xy = get_dotxy(cellnum);
	patch_length_x = dot_xy(2,1) - dot_xy(1,1);
	patch_length_y = dot_xy(2,2) - dot_xy(1,2);
	sim_param = struct('dx',dx,'dy',dy,'data',data,'drum_speed',drum_speed,'dot_xy',dot_xy,'cellnum',cellnum,'patch_length_x',patch_length_x,'patch_length_y',patch_length_y);
	model = s_models{cellnumi};
	r1s(cellnumi,1) = model.mr_r1;
	r2s(cellnumi,1) = model.mr_r2;
	if ismember(cellnum,stimdir1)
		linetype = 'line';
		teststim = 30;
		test2stim = 22.5;
	else
		linetype = 'line2';
		teststim = -30;
		test2stim = -22.5;
	end
	stim_list = {{linetype,teststim}};
	% D
	[err,m_spike_times,m_spike_rate,o_spike_times,o_spike_rate,m_t] = test_model(model,stim_list,sim_param);
	cell_test(cellnumi,1) = max(0,round(100-err,1));
	
	%
	[temp,trial_rates] = mean_exp_response(stim_list{1},sim_param);
	pacc_trials = [];
	for i = 2:length(trial_rates)
		err2 = calc_err(trial_rates{1},trial_rates{i});
		pacc_trials(i-1,1) = max(0,round(100-err2,1));
	end
	cell_test_trials(cellnumi,1) = mean(pacc_trials);
	
	%
	if cellnum == cellex
		m_t2 = 0:tlim;
		tshift = round(tlim/2 - mean(m_spike_times{1}));
		m_spike_times2 = m_spike_times{1} + tshift;
		o_spike_times2 = o_spike_times{1} + tshift;
		m_spike_rate2 = get_spike_rate(m_spike_times2,m_t2);
		o_spike_rate2 = get_spike_rate(o_spike_times2,m_t2);
		corr2(m_spike_rate2,o_spike_rate2);
        subplot('position',[0.62 0.15 0.1 0.33])
		hold on
		plot(m_t2,o_spike_rate2,'k')
		plot(m_t2,m_spike_rate2,'r')
        hold off
		xlim([0 tlim])
		ylim([0,350])
		xl = xlim;
		yl = ylim;
		axis off
		line_length = 0.15*(yl(2)-yl(1));
		line(xl(1)+0.85*(xl(2)-xl(1)) + [-0.5,0.5]*cos(pi/2 - stim_list{1}{2}*2*pi/360)*line_length,yl(1) + 0.6*(yl(2)-yl(1)) +...
		[0,sin(pi/2 - stim_list{1}{2}*2*pi/360)*line_length],'linewidth',2,'color',[255,165,0]/255);

		subplot('position',[0.62 0.1 0.1 0.05])
		hold on
		for spikei=1:length(o_spike_times2)
			plot(o_spike_times2(spikei)*[1,1],[0.2,0.4],'k')		
			
		end
		for spikei=1:length(m_spike_times2)
			plot(m_spike_times2(spikei)*[1,1],[0.5,0.7],'r')		
		end
		hold off
		axis off
		xlim([0 tlim])
		ylim([0 1])
		annotation('textbox',[0.63 0.05 0.15 0.05],'edgecolor','none','string',['R^2 = ',num2str(max(0,round(100-err))),'%'],'color',0.3*[1,1,1],'fontname','arial','fontsize',8);
		
		annotation('line',[0.6,0.61],[0.445,0.445],'color','k','linewidth',1.5)
		annotation('textbox',[0.61 0.43 0.3 0.05],'edgecolor','none','string','Test Data','fontname','arial','fontsize',8);
		annotation('line',[0.6,0.61],[0.395,0.395],'color','r','linewidth',1.5)
		annotation('textbox',[0.61 0.38 0.3 0.05],'edgecolor','none','string','Model','fontname','arial','fontsize',8);
	end
	stim_list = {{linetype,test2stim}};
	clear o_spike_times2;
	o_spike_times2{1} = get_spikes_times(stim_list{1},sim_param);
	tvec = 1:max([max(o_spike_times{1});max(o_spike_times2{1})]);
	[o_spike_times{1},o_spike_times2{1}] = align_times(o_spike_times{1},o_spike_times2{1},tvec);
	rate1 = get_spike_rate(o_spike_times{1},tvec);
	rate2 = get_spike_rate(o_spike_times2{1},tvec);
	err1 = calc_err(rate1,rate2);
	cell_test2(cellnumi,1) = max(0,round(100-err1,1));
	%
	stim_list = {{linetype,teststim}};
	[r_loc,c_loc] = find(model.mr_loc == 1);
	for irand = 1:50
		model2 = model;
		for k2 = 1:size(model.mr_subset,1)
			rvec = randperm(length(r_loc));
			model2.mr_subset(k2,1) = r_loc(rvec(1));
			model2.mr_subset(k2,2) = c_loc(rvec(1));
		end
		[err_rand(:,irand),m_spike_times,m_spike_rate,o_spike_times,o_spike_rate,m_t] = test_model(model2,stim_list,sim_param);
	end	
	pacc_rand = max(0,round(100-err_rand,1));
	cell_rand(cellnumi,1) = mean(pacc_rand');
	%
end

% E
subplot('position',[0.8 0.13 0.17 0.32])
hold on
%
m_rand = mean(cell_rand([1:5,7:end]));
s_rand = std(cell_rand([1:5,7:end]));
%
m_test = mean(cell_test([1:5,7:end]));
s_test = std(cell_test([1:5,7:end]));
m_test2 = mean(cell_test2([1:5,7:end]));
s_test2 = std(cell_test2([1:5,7:end]));
m_test_trials = mean(cell_test_trials([1:5,7:end]));
s_test_trials = std(cell_test_trials([1:5,7:end]));
disp(['test = ',num2str(round(m_test)),' + ',num2str(round(s_test))])
disp(['test_trials = ',num2str(round(m_test_trials)),' + ',num2str(round(s_test_trials))])
[h,p] = ttest(cell_test,cell_test_trials);
disp(['p value for test vs. test_trials = ',num2str(p)])
%
disp(['rand = ',num2str(round(m_rand)),' + ',num2str(round(s_rand))])
[h,p] = ttest(cell_test,cell_rand);
disp(['p value for test vs. rand = ',num2str(p)])
%
disp(['test2 = ',num2str(round(m_test2)),' + ',num2str(round(s_test2))])
[h,p] = ttest(cell_test,cell_test2);
disp(['p value for test vs. test2 = ',num2str(p)])
bar([m_fit,m_test_trials,m_test,m_rand],'facecolor',0.5*[1,1,1],'edgecolor',0.5*[1,1,1])
errorbar([m_fit,m_test_trials,m_test,m_rand],[s_fit,s_test_trials,s_test,s_rand],'.k')
text(1,-5,'Fit','fontname','arial','fontsize',8,'rotation',90,'horizontalalignment','right')
text(2,-5,{'Exp','Trials'},'fontname','arial','fontsize',8,'rotation',90,'horizontalalignment','right')
text(3,-5,'Test','fontname','arial','fontsize',8,'rotation',90,'horizontalalignment','right')
text(4,-5,'Null','fontname','arial','fontsize',8,'rotation',90,'horizontalalignment','right')
hold off
set(gca,'xtick',[1,2,3,4])
set(gca,'xticklabel',{})
set(gca,'ytick',[0:20:100])
xlim([0,5])
ylim([0,100])
ylabel('R^2','fontname','arial','fontsize',8)
set(gca,'fontname','arial','fontsize',8)
set(gca,'tickdir','out')

annotation('textbox',[0 0.95 0.05 0.05],'edgecolor','none','string','A','fontname','arial','fontsize',12,'fontweight','bold');
annotation('textbox',[0.3 0.95 0.05 0.05],'edgecolor','none','string','B','fontname','arial','fontsize',12,'fontweight','bold');
annotation('textbox',[0 0.47 0.05 0.05],'edgecolor','none','string','C','fontname','arial','fontsize',12,'fontweight','bold');
annotation('textbox',[0.55 0.47 0.05 0.05],'edgecolor','none','string','D','fontname','arial','fontsize',12,'fontweight','bold');
annotation('textbox',[0.73 0.47 0.05 0.05],'edgecolor','none','string','E','fontname','arial','fontsize',12,'fontweight','bold');

if strcmp(savefig,'y')
	print(ff1,filetype,'-r600','figures_tactile/1');
end





