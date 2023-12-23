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
pheight = ploscb_pwidth*0.25;
set(gcf,'papersize',[pwidth pheight]);
set(gcf,'paperposition',[0, 0, pwidth, pheight]);

cellnum = 1;
data = load(['../../Data/Tactile/',cellnames{cellnum},'.txt']);
dot_xy = get_dotxy(cellnum);
sim_param = struct('dx',dx,'dy',dy,'data',data,'drum_speed',drum_speed,'dot_xy',dot_xy,'cellnum',cellnum,'patch_length_x',12,'patch_length_y',12);
model_type = '1';
Nboot = 100;

%A
noise_level = 5;
load(['models/N4angles1_',int2str(noise_level),'.mat']);
model_inds = [50,104,123,218];
model_colors = {'k','r',0.6*[0,1,0],[20,100,160]/255,0.6*[0,0,1],[180,120,0]/255,'m','c',[0.5,0.5,0.2]};
subplot('position',[0.05 0.1 0.15 0.15*pwidth/pheight])
plot_skin_patch(models2,model_inds,sim_param.patch_length_x,model_colors);
annotation('textbox',[0.03 0.85 0.25 0.05],'edgecolor','none','string','Population with simple RF','fontname','arial','fontsize',8);

%B-D
noise_level = 5;
colors = {'k','r'};
colors2 = {0.8*[1,1,1],0.8*[1,0,0],0.8*[0,0,1]};
for subplot_i = 1:3
	if subplot_i == 1
		nc_type = 1;
		tw = 0;
		subplot('position',[0.33 0.18 0.15 0.6])
		annotation('textbox',[0.32 0.85 0.25 0.05],'edgecolor','none','string','AMPA, t_{win} > 100 ms','fontname','arial','fontsize',8);
	elseif subplot_i == 2
		nc_type = 2;
		tw = 0;
		subplot('position',[0.58 0.18 0.15 0.6])
		annotation('textbox',[0.57 0.85 0.25 0.05],'edgecolor','none','string','NMDA, t_{win} > 100 ms','fontname','arial','fontsize',8);
	else
		nc_type = 1;
		tw = 5;
		subplot('position',[0.83 0.18 0.15 0.6])
		annotation('textbox',[0.82 0.85 0.25 0.05],'edgecolor','none','string','AMPA, t_{win} = 5 ms','fontname','arial','fontsize',8);
	end
	hold on
	mperf = [];
	ntypes = {'N1','N4'};
	senss2 = [20,10,3,1];
	for ntype_i = 1:length(ntypes)
		load(['models/',ntypes{ntype_i},'acc1_1_nc',int2str(nc_type),'_nz',int2str(noise_level),'_tw',int2str(tw),'_ga.mat']);
		for k2 = 1:length(senss2)
			k3 = find(senss==senss2(k2));
			x = performance(:,k3);
			if noise_level == 0
				ci = mean(x)*[1,1];
				mperf(ntype_i,k2) = mean(x);
			else
				[ci,bs] = bootci(Nboot,@mean,x);
				mperf(ntype_i,k2) = mean(bs);
			end
			lb(k2) = ci(1);
			ub(k2) = ci(2);
		end
		bounds = [lb,fliplr(ub)];
		fill([senss2,fliplr(senss2)],bounds,colors{ntype_i},'edgecolor','none')
		alpha(0.3)
	end
	for ntype_i = 1:length(ntypes)
		plot(senss2,mperf(ntype_i,:),'o','color',colors{ntype_i},'markerfacecolor',colors{ntype_i},'markersize',2)
		plot(senss2,mperf(ntype_i,:),'color',colors{ntype_i},'linewidth',1)
	end
	xlim([-1,23])
	ylim([0.4,1.05])
	xl = xlim;
	yl = ylim;
	for ntype_i = 1:length(ntypes)
		if strcmp(ntypes(ntype_i),'N1')
			RF_type = 'Complex RF';
		else
			RF_type = 'Simple RF';
		end			
		text(xl(1)+0.4*(xl(2)-xl(1)),yl(1)+(0.6-0.1*(ntype_i-1))*(yl(2)-yl(1)),RF_type,'fontname','arial','fontsize',8)
		plot(xl(1)+0.35*(xl(2)-xl(1)),yl(1)+(0.6-0.1*(ntype_i-1))*(yl(2)-yl(1)),'o','color',colors{ntype_i},'markerfacecolor',colors{ntype_i},'markersize',2)
	end
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

annotation('textbox',[0 0.95 0.05 0.05],'edgecolor','none','string','A','fontname','arial','fontsize',12,'fontweight','bold');
annotation('textbox',[0.25 0.95 0.05 0.05],'edgecolor','none','string','B','fontname','arial','fontsize',12,'fontweight','bold');
annotation('textbox',[0.5 0.95 0.05 0.05],'edgecolor','none','string','C','fontname','arial','fontsize',12,'fontweight','bold');
annotation('textbox',[0.75 0.95 0.05 0.05],'edgecolor','none','string','D','fontname','arial','fontsize',12,'fontweight','bold');

if strcmp(savefig,'y')
	print(ff1,filetype,'-r300','figures_tactile/7');
end





