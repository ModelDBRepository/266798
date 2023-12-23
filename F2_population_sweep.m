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
	
drum_speed = .03; % (mm/ms)
dx = drum_speed; % RF resolution x-axis (mm)
dy = 0.4; % RF resolution y-axis (mm)

ff1 = figure();
set(gcf,'paperunits','centimeters');
pwidth = ploscb_pwidth;
pheight = ploscb_pwidth*2/3;
set(gcf,'papersize',[pwidth pheight]);
set(gcf,'paperposition',[0, 0, pwidth, pheight]);

cellnum = 1;
data = load(['../../Data/Tactile/',cellnames{cellnum},'.txt']);
dot_xy = get_dotxy(cellnum);
sim_param = struct('dx',dx,'dy',dy,'data',data,'drum_speed',drum_speed,'dot_xy',dot_xy,'cellnum',cellnum,'patch_length_x',12,'patch_length_y',12);
model_type = '1';
noise_level = 0;
Nboot = 100;
load(['models/N1angles1_',int2str(noise_level),'.mat']);
Ncells = length(models2);
tlim = [];
for k = 1:length(stim_list)
	tlim(k) = length(m_t{k});
end

colormap('hot');
% A
annotation('textbox',[0.02 0.8 0.01 0.05],'edgecolor','none','string','-\theta','fontname','arial','fontsize',8);
[stim1, tempo] = get_stim(stim_list{1},sim_param);
stim1n = add_noise_stim(stim1,get_noise_stim(stim1,noise_level,dy/dx));
stim2n = get_stim_t(stim1n,round(tempo(end)/2),stim_list{1},sim_param);
tempfig = figure();
	subplot('position',[0,0,1,1])
	imagesc(rot90(stim2n'))
	colormap('gray')
	axis off image
	set(tempfig,'color','w')
	img = getframe(tempfig);
close(tempfig);
figure(ff1)
subplot('position',[0.05 0.79 0.08*pheight/pwidth 0.08])
imshow(img.cdata)

annotation('textbox',[0.02 0.6 0.01 0.05],'edgecolor','none','string','-\theta','fontname','arial','fontsize',8);
[stim1, tempo] = get_stim(stim_list{1},sim_param);
stim1n = add_noise_stim(stim1,get_noise_stim(stim1,noise_level,dy/dx));
stim2n = get_stim_t(stim1n,round(tempo(end)/2),stim_list{1},sim_param);
tempfig = figure();
	subplot('position',[0,0,1,1])
	imagesc(rot90(stim2n'))
	colormap('gray')
	axis off image
	set(tempfig,'color','w')
	img = getframe(tempfig);
close(tempfig);
figure(ff1)
subplot('position',[0.05 0.59 0.08*pheight/pwidth 0.08])
imshow(img.cdata)

annotation('textbox',[0.02 0.7 0.01 0.05],'edgecolor','none','string','\theta','fontname','arial','fontsize',8);
[stim1, tempo] = get_stim(stim_list{end},sim_param);
stim1n = add_noise_stim(stim1,get_noise_stim(stim1,noise_level,dy/dx));
stim2n = get_stim_t(stim1n,round(tempo(end)/2),stim_list{end},sim_param);
stim2 = get_stim_t(stim1,round(tempo(end)/2),stim_list{end},sim_param);
tempfig = figure();
	subplot('position',[0,0,1,1])
	imagesc(rot90(stim2n'))
	colormap('gray')
	axis off image
	set(tempfig,'color','w')
	img = getframe(tempfig);
close(tempfig);
figure(ff1)
subplot('position',[0.035 0.67 0.12*pheight/pwidth 0.12])
imshow(img.cdata)

annotation('textbox',[0.04 0.9 0.1 0.05],'edgecolor','none','string','Stimulus','fontname','arial','fontsize',8);
annotation('textbox',[0.11 0.735 0.05 0.025],'edgecolor','none','string','\rightarrow','fontname','arial','fontsize',12);
model_inds = [104,106,121,218];
model_colors = {'k','r',0.6*[0,1,0],[20,100,160]/255,0.6*[0,0,1],[180,120,0]/255,'m','c',[0.5,0.5,0.2]};

subplot('position',[0.15 0.55 0.32*pheight/pwidth 0.32])
plot_skin_patch(models2,model_inds,sim_param.patch_length_x,model_colors);

for celli = 1:4
	if celli<=3
		annotation('textbox',[0.39 (0.93 - 0.085*celli) 0.1 0.05],'edgecolor','none','string',int2str(celli),'fontname','arial','fontsize',8);
		subplot('position',[0.41 (0.925 - 0.085*celli) 0.08*pheight/pwidth 0.08])
	else
		annotation('textbox',[0.37 (0.95 - 0.085*(celli+1)) 0.1 0.05],'edgecolor','none','string',int2str(Ncells),'fontname','arial','fontsize',8);
		subplot('position',[0.41 (0.945 - 0.085*(celli+1)) 0.08*pheight/pwidth 0.08])
	end
	plot_skin_patch(models2,model_inds(celli),sim_param.patch_length_x,model_colors(celli));
end

annotation('textbox',[0.1 0.95 0.3 0.025],'edgecolor','none','string',{'Skin','Mechanoreceptors'},'fontname','arial','fontsize',8,'horizontalalignment','center');
annotation('textbox',[0.36 0.95 0.3 0.025],'edgecolor','none','string','1st Order Tactile Neurons','fontname','arial','fontsize',8,'horizontalalignment','center');
annotation('textbox',[0.42 0.65 0.05 0.025],'edgecolor','none','string','.','fontname','arial','fontsize',8);
annotation('textbox',[0.42 0.635 0.05 0.025],'edgecolor','none','string','.','fontname','arial','fontsize',8);
annotation('textbox',[0.42 0.62 0.05 0.025],'edgecolor','none','string','.','fontname','arial','fontsize',8);
for celli = 1:4
	if celli<=3
		subplot('position',[0.47 (0.935 - 0.085*celli) 0.08 0.05])
		annotation('textbox',[0.55 (0.955 - 0.085*celli) 0.05 0.025],'edgecolor','none','string','*','fontname','arial','fontsize',12);
	else
		subplot('position',[0.47 (0.96 - 0.085*(celli+1)) 0.08 0.05])
		annotation('textbox',[0.55 (0.98 - 0.085*(celli+1)) 0.05 0.025],'edgecolor','none','string','*','fontname','arial','fontsize',12);
	end
	v = m_spike_times{model_inds(celli),length(stim_angles),1};
	hold on
	for spikei = 1:length(v)
		plot(v(spikei)*[1,1],[0.5,1.5],'k','linewidth',0.5)
	end
	hold off
	xlim([-5, max(tlim)])
	ylim([0,2])
	set(gca,'xtick',[])
	set(gca,'ytick',[])
	set(gca,'box','on')
end
annotation('textbox',[0.44 0.89 0.15 0.05],'edgecolor','none','string','Spikes','fontname','arial','fontsize',8,'horizontalalignment','center');

tau1 = 0.5;
tau2 = 65;
tvec = 0:0.1:round(3*tau2);
epspfun = exp(-tvec/tau2) - exp(-tvec/tau1);
for celli = 1:4
	if celli<=3
		subplot('position',[0.58 (0.945 - 0.085*celli) 0.02 0.03])
		annotation('textbox',[0.6 (0.965 - 0.085*celli) 0.05 0.025],'edgecolor','none','string','\rightarrow','fontname','arial','fontsize',12);
	else
		subplot('position',[0.58 (0.97 - 0.085*(celli+1)) 0.02 0.03])
		annotation('textbox',[0.6 (0.99 - 0.085*(celli+1)) 0.05 0.025],'edgecolor','none','string','\rightarrow','fontname','arial','fontsize',12);
	end
	plot(tvec,epspfun,'k');
	xlim([-0.1*tvec(end),tvec(end)])
	ylim([min(epspfun)-0.2*max(epspfun),1.2*max(epspfun)])
	set(gca,'xtick',[])
	set(gca,'ytick',[])
	set(gca,'box','on')
end

for celli = 1:4
	if celli<=3
		subplot('position',[0.64 (0.935 - 0.085*celli) 0.08 0.05])
	else
		subplot('position',[0.64 (0.96 - 0.085*(celli+1)) 0.08 0.05])
	end
	v = st2epsp(m_t{length(stim_angles)},m_spike_times{model_inds(celli),length(stim_angles),1},0.5,65);
	plot(m_t{length(stim_angles)},v,'k','linewidth',0.5)
	hold off
	xlim([-5, max(tlim)])
	ylim([min(v)-0.2*max(v),max(v)+0.2*max(v)])
	set(gca,'xtick',[])
	set(gca,'ytick',[])
	set(gca,'box','on')
end
annotation('textbox',[0.61 0.89 0.15 0.05],'edgecolor','none','string','PSP','fontname','arial','fontsize',8,'horizontalalignment','center');

annotation('line',[0.72,0.82],[0.88,0.77])
annotation('line',[0.72,0.82],[0.79,0.77])
annotation('line',[0.72,0.82],[0.71,0.77])
annotation('line',[0.72,0.82],[0.56,0.77])

annotation('line',[0.72,0.82],[0.88,0.67])
annotation('line',[0.72,0.82],[0.79,0.67])
annotation('line',[0.72,0.82],[0.71,0.67])
annotation('line',[0.72,0.82],[0.56,0.67])

annotation('textbox',[0.76 0.85 0.15 0.05],'edgecolor','none','string',{'Synaptic','Integration'},'fontname','arial','fontsize',8,'horizontalalignment','center');
for i = 1:2
	posh = 0.75 - 0.1*(i-1);
	annotation('ellipse',[0.82,posh,0.03,0.03*pwidth/pheight]);
	annotation('textbox',[0.81 (posh+0.02) 0.05 0.025],'edgecolor','none','string','$$\sum$$','Interpreter','latex','fontname','arial','fontsize',6,'horizontalalignment','center');
end
annotation('textbox',[0.85 0.7 0.05 0.05],'edgecolor','none','string','\rightarrow','fontname','arial','fontsize',12);
annotation('textbox',[0.845 0.72 0.05 0.05],'edgecolor','none','string','Max','fontname','arial','fontsize',8);

annotation('textbox',[0.88 0.78 0.1 0.05],'edgecolor','none','string','Classification','fontname','arial','fontsize',8);
tempfig = figure();
	subplot('position',[0,0,1,1])
	imagesc(rot90(stim2'))
	colormap('gray')
	axis off image
	set(tempfig,'color','w')
	img = getframe(tempfig);
close(tempfig);
figure(ff1)
subplot('position',[0.9 0.67 0.12*pheight/pwidth 0.12])
imshow(img.cdata)

% B
subplot('position',[0.05 0.34 0.15 0.05])
celli = 1;
v = m_spike_times{model_inds(celli),length(stim_angles),1};
hold on
for spikei = 1:length(v)
	plot(v(spikei)*[1,1],[0.5,1.5],'k','linewidth',0.5)
end
hold off
xlim([-5, max(tlim)])
ylim([0,2])
axis off
set(gca,'box','off')
annotation('textbox',[0.04 0.37 0.2 0.05],'edgecolor','none','string','Spikes','fontname','arial','fontsize',8);

subplot('position',[0.05 0.22 0.15 0.05])
v = st2epsp(m_t{length(stim_angles)},m_spike_times{model_inds(celli),length(stim_angles),1},0.5,3);
plot(m_t{length(stim_angles)},v,'k','linewidth',0.5)
xlim([-5, max(tlim)])
ylim([min(v)-0.2*max(v),max(v)+0.2*max(v)])
axis off
set(gca,'box','off')
annotation('textbox',[0.04 0.26 0.3 0.05],'edgecolor','none','string','PSP, AMPA (\tau_{decay} = 3 ms)','fontname','arial','fontsize',8);

subplot('position',[0.05 0.1 0.15 0.05])
v = st2epsp(m_t{length(stim_angles)},m_spike_times{model_inds(celli),length(stim_angles),1},0.5,65);
plot(m_t{length(stim_angles)},v,'k','linewidth',0.5)
xlim([-5, max(tlim)])
ylim([min(v)-0.2*max(v),max(v)+0.2*max(v)])
axis off
set(gca,'box','off')
annotation('textbox',[0.04 0.13 0.3 0.05],'edgecolor','none','string','PSP, NMDA (\tau_{decay} = 65 ms)','fontname','arial','fontsize',8);

subplot('position',[0.05 0.05 0.15 0.03])
plot([0,100],[1,1],'k','linewidth',1.5')
text(0,0,'100 ms','fontname','arial','fontsize',8)
xlim([-5, max(tlim)])
axis off
set(gca,'box','off')


% C-D
colors = {'r','b',0.5*[0,1,0],'k'};
colors2 = {0.8*[1,0,0],0.8*[0,0,1],0.8*[1,1,1],0.8*[0,1,0]};
noises = [0,1,5,10];

for subplot_i = 1:2
	if subplot_i == 1
		nc_type = 1;
		subplot('position',[0.33 0.1 0.15 0.3])
		annotation('textbox',[0.33 0.4 0.25 0.05],'edgecolor','none','string','AMPA, t_{win} > 100 ms','fontname','arial','fontsize',8);
	else
		nc_type = 2;
		subplot('position',[0.58 0.1 0.15 0.3])
		annotation('textbox',[0.58 0.4 0.25 0.05],'edgecolor','none','string','NMDA, t_{win} > 100 ms','fontname','arial','fontsize',8);
	end
	hold on
	mperf = [];
	for noise_i = 1:length(noises)
		load(['models/N1acc1_1_nc',int2str(nc_type),'_nz',int2str(noises(noise_i)),'_tw0_ga.mat']);
		for k2 = 1:size(performance,2)
			x = performance(:,k2);
			if noises(noise_i) == 0
				ci = mean(x)*[1,1];
				mperf(noise_i,k2) = mean(x);
			else
				[ci,bs] = bootci(Nboot,@mean,x);
				mperf(noise_i,k2) = mean(bs);
			end
			lb(k2) = ci(1);
			ub(k2) = ci(2);
		end
		bounds = [lb,fliplr(ub)];
		fill([senss,fliplr(senss)],bounds,colors{noise_i},'edgecolor','none')
		alpha(0.3)
	end
	for noise_i = 1:length(noises)
		plot(senss,mperf(noise_i,:),'o','color',colors{noise_i},'markerfacecolor',colors{noise_i},'markersize',2)
		plot(senss,mperf(noise_i,:),'color',colors{noise_i},'linewidth',1)
	end
	xlim([-1,23])
	ylim([0.4,1.05])
	xl = xlim;
	yl = ylim;
	for noise_i = 1:length(noises)
		text(xl(1)+0.65*(xl(2)-xl(1)),yl(1)+(0.6-0.1*(noise_i-1))*(yl(2)-yl(1)),[int2str(noises(noise_i)),'%'],'fontname','arial','fontsize',8)
		plot(xl(1)+0.6*(xl(2)-xl(1)),yl(1)+(0.6-0.1*(noise_i-1))*(yl(2)-yl(1)),'o','color',colors{noise_i},'markerfacecolor',colors{noise_i},'markersize',2)
	end
	text(21,0.65,'Noise','fontname','arial','fontsize',8,'rotation',90)
	plot(xl,0.5*[1,1],'--','color',0.5*[1,1,1])
	text(xl(1)+0.6*(xl(2)-xl(1)),0.47,'Chance','color',0.5*[1,1,1],'fontname','arial','fontsize',8)
	hold off
	set(gca,'box','off')
	set(gca,'tickdir','out')
	set(gca,'fontname','arial','fontsize',8);
	set(gca,'xtick',senss(end:-1:1));
	set(gca,'ytick',[0.4:0.2:1]);
	xlabel('Orientation (\circ)','fontname','arial','fontsize',8);
	ylabel('Test Performance','fontname','arial','fontsize',8);
end

% E
subplot('position',[0.83 0.1 0.15 0.3])
annotation('textbox',[0.79 0.4 0.25 0.05],'edgecolor','none','string','AMPA - NMDA, t_{win} > 100 ms','fontname','arial','fontsize',8);
hold on
mperf = [];
for noise_i=2:length(noises)
	load(['models/N1acc1_1_nc1_nz',int2str(noises(noise_i)),'_tw0_ga.mat']);
	performance_A = performance;
	load(['models/N1acc1_1_nc2_nz',int2str(noises(noise_i)),'_tw0_ga.mat']);
	performance_N = performance;
	for k2 = 1:size(performance,2)
		x = performance_A(:,k2) - performance_N(:,k2);
		if noises(noise_i) == 0
			ci = mean(x)*[1,1];
			mperf(1,k2) = mean(x);
		else
			[ci,bs] = bootci(Nboot,@mean,x);
			mperf(1,k2) = mean(bs);
		end
		lb(k2) = ci(1);
		ub(k2) = ci(2);
	end
	bounds = [lb,fliplr(ub)];
	fill([senss,fliplr(senss)],bounds,colors{noise_i},'edgecolor','none')
	alpha(0.3)
	plot(senss,mperf(1,:),'o','color',colors{noise_i},'markerfacecolor',colors{noise_i},'markersize',2)
	plot(senss,mperf(1,:),'color',colors{noise_i},'linewidth',1)
end
xlim([-1,23])
ylim([-0.3,0.1])
xl = xlim;
yl = ylim;
for noise_i = 2:length(noises)
	text(xl(1)+0.65*(xl(2)-xl(1)),yl(1)+(0.4-0.1*(noise_i-1))*(yl(2)-yl(1)),[int2str(noises(noise_i)),'%'],'fontname','arial','fontsize',8)
	plot(xl(1)+0.6*(xl(2)-xl(1)),yl(1)+(0.4-0.1*(noise_i-1))*(yl(2)-yl(1)),'o','color',colors{noise_i},'markerfacecolor',colors{noise_i},'markersize',2)
end
text(xl(1)+0.9*(xl(2)-xl(1)),yl(1)+0.1*(yl(2)-yl(1)),'Noise','fontname','arial','fontsize',8,'rotation',90)
hold off
set(gca,'box','off')
set(gca,'tickdir','out')
set(gca,'fontname','arial','fontsize',8);
set(gca,'xtick',senss(end:-1:1));
set(gca,'ytick',[-0.3:0.1:0.2]);
xlabel('Orientation (\circ)','fontname','arial','fontsize',8);
ylabel('\Delta Test Performance','fontname','arial','fontsize',8);

annotation('textbox',[0 0.95 0.05 0.05],'edgecolor','none','string','A','fontname','arial','fontsize',12,'fontweight','bold');
annotation('textbox',[0 0.45 0.05 0.05],'edgecolor','none','string','B','fontname','arial','fontsize',12,'fontweight','bold');
annotation('textbox',[0.25 0.45 0.05 0.05],'edgecolor','none','string','C','fontname','arial','fontsize',12,'fontweight','bold');
annotation('textbox',[0.51 0.45 0.05 0.05],'edgecolor','none','string','D','fontname','arial','fontsize',12,'fontweight','bold');
annotation('textbox',[0.75 0.45 0.05 0.05],'edgecolor','none','string','E','fontname','arial','fontsize',12,'fontweight','bold');

if strcmp(savefig,'y')
	print(ff1,filetype,'-r300','figures_tactile/2');
end





