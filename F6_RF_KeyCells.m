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

ff1 = figure();
set(gcf,'paperunits','centimeters');
pwidth = ploscb_pwidth;
pheight = ploscb_pwidth*0.35;
set(gcf,'papersize',[pwidth pheight]);
set(gcf,'paperposition',[0, 0, pwidth, pheight]);

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
cellnum = 1;
data = load(['../../Data/Tactile/',cellnames{cellnum},'.txt']);
dot_xy = get_dotxy(cellnum);
sim_param = struct('dx',dx,'dy',dy,'data',data,'drum_speed',drum_speed,'dot_xy',dot_xy,'cellnum',cellnum,'patch_length_x',12,'patch_length_y',12);

ang = 20;
noise = 5;
t_win = 50;
nc_type = '1';
load(['models/N1wnc1_1_nc',nc_type,'_nz',int2str(noise),'_tw',int2str(t_win),'_ang',int2str(ang),'_ga.mat']);
m1 = mean(ws1')';
m2 = mean(ws2')';
for k = 1:length(m1)
	[ci(k,:),bs] = bootci(200,{@mean,ws1(k,:)},'alpha',0.05/length(m1));
	m1a(k,1) = mean(bs);
end
inds1 = find(ci(:,1) > 0);
inds2 = find(ci(:,2) < 0);
inds3 = find(~ismember([1:length(m1)],union(inds1,inds2)));

load(['models/N1angles1_',int2str(noise),'.mat']);
inds = [2,4,6,3,5];
for k=1:length(inds)
	subplot('position',[(0.05+0.19*(k-1)), 0.43, 0.16, 0.16*pwidth/pheight]);
	k2 = inds1(inds(k));
	plot_skin_patch(models2,k2,sim_param.patch_length_x,{'k'});
	subplot('position',[(0.05+0.19*(k-1)), 0.02, 0.16, 0.25]);
	hold on
	x = m_t{find(stim_angles==ang)};
	y = get_spike_rate(m_spike_times{k2,find(stim_angles==ang),1},x);
	plot(x,y,'k');
	x = m_t{find(stim_angles==-ang)};
	y = get_spike_rate(m_spike_times{k2,find(stim_angles==-ang),1},x);
	plot(x,y,'r');
	ylim([0,350])
	if k==1
		xl = xlim;
		yl = ylim;
		scale_time = 30;
		scale_rate = 50;
		line(xl(2)-[0,scale_time],yl(1) + 0.3*(yl(2) - yl(1)) + [0,0],'linewidth',0.8,'color','k');
		line(xl(2)-[0,0],yl(1) + 0.3*(yl(2)-yl(1)) + [0,scale_rate],'linewidth',0.8,'color','k');
		text(xl(2)-60,yl(1) + 0.2*(yl(2)-yl(1)),[int2str(scale_time),' ms'],'fontname','arial','fontsize',8);
		text(xl(2)+35,yl(1) + 0.33*(yl(2)-yl(1)),[int2str(scale_rate),' Hz'],'fontname','arial','fontsize',8,'rotation',90);
	end
	hold off
	axis off;
end

annotation('textbox',[0.08 0.92 0.9 0.05],'edgecolor','none','string','RF of Example Key First-Order Neurons','fontname','arial','fontsize',8);
annotation('textbox',[0.08 0.3 0.5 0.05],'edgecolor','none','string','Response Firing Rate','fontname','arial','fontsize',8);
annotation('line',[0.34,0.36],[0.31,0.31],'color','k','linewidth',1.5)
annotation('textbox',[0.36 0.3 0.15 0.05],'edgecolor','none','string',[num2str(ang),'\circ'],'fontname','arial','fontsize',8);
annotation('line',[0.41,0.43],[0.31,0.31],'color','r','linewidth',1.5)
annotation('textbox',[0.43 0.3 0.15 0.05],'edgecolor','none','string',[num2str(-ang),'\circ'],'fontname','arial','fontsize',8);

annotation('textbox',[0 0.95 0.05 0.05],'edgecolor','none','string','A','fontname','arial','fontsize',12,'fontweight','bold');
annotation('textbox',[0 0.35 0.05 0.05],'edgecolor','none','string','B','fontname','arial','fontsize',12,'fontweight','bold');


if strcmp(savefig,'y')
	print(ff1,filetype,'-r300','figures_tactile/6');
end





