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
pwidth = ploscb_pwidth*3/4;
pheight = ploscb_pwidth/2;
set(gcf,'papersize',[pwidth pheight]);
set(gcf,'paperposition',[0, 0, pwidth, pheight]);

Nboot = 100;
colors = {'r','b',0.5*[0,1,0],'k'};
colors2 = {0.8*[1,0,0],0.8*[0,0,1],0.8*[1,1,1],0.8*[0,1,0]};
t_wins = [5,10,20,50,0];
t_wins2 = [5,10,20,50,100];
xticks = [5,20,50,100];
xlabels = {'5','20','50','Inf'};
noises = [0,1,5,10];

% A
subplot('position',[0.1 0.6 0.18 0.3])
nc_type = 1;
noise_i = 4;
angle_inds = [3,5,6];
hold on
mperf = [];
for angle_i = 1:length(angle_inds)
	for t_win_i = 1:length(t_wins)
		load(['models/N1acc1_1_nc',int2str(nc_type),'_nz',int2str(noises(noise_i)),'_tw',int2str(t_wins(t_win_i)),'_ga.mat']);
		x = performance(:,angle_inds(angle_i));
		[ci,bs] = bootci(Nboot,@mean,x);
		mperf(angle_i,t_win_i) = mean(bs);
		lb(t_win_i) = ci(1);
		ub(t_win_i) = ci(2);
	end
	bounds = [lb,fliplr(ub)];
	fill([t_wins2,fliplr(t_wins2)],bounds,colors{angle_i},'edgecolor','none')
	alpha(0.3)
end
for angle_i = 1:length(angle_inds)
	plot(t_wins2,mperf(angle_i,:),'o','color',colors{angle_i},'markerfacecolor',colors{angle_i},'markersize',2)
	plot(t_wins2,mperf(angle_i,:),'color',colors{angle_i},'linewidth',1)
end
xlim([-1,110])
ylim([0.4,1.05])
xl = xlim;
yl = ylim;
for angle_i = 1:length(angle_inds)
	text(115,yl(1)+(0.75-0.12*(angle_i-1))*(yl(2)-yl(1)),[int2str(senss(angle_inds(angle_i))),'\circ'],'fontname','arial','fontsize',8)
	plot(110,yl(1)+(0.75-0.12*(angle_i-1))*(yl(2)-yl(1)),'o','color',colors{angle_i},'markerfacecolor',colors{angle_i},'markersize',2)
end
text(135,0.8,'\theta','fontname','arial','fontsize',8)
plot(xl,0.5*[1,1],'--','color',0.5*[1,1,1])
text(xl(1)+0.6*(xl(2)-xl(1)),0.47,'Chance','color',0.5*[1,1,1],'fontname','arial','fontsize',8)
hold off
ylabel('Test Performance','fontname','arial','fontsize',8);
annotation('textbox',[0.1 0.91 0.3 0.05],'edgecolor','none','string',['AMPA, noise = ',int2str(noises(noise_i)),'%'],'fontname','arial','fontsize',8);
set(gca,'box','off')
set(gca,'tickdir','out')
set(gca,'fontname','arial','fontsize',8);
set(gca,'xtick',xticks);
set(gca,'xticklabel',xlabels)
set(gca,'ytick',[0.4:0.2:1]);
xlabel('Time window (ms)','fontname','arial','fontsize',8);

% B
subplot('position',[0.43 0.6 0.18 0.3])
nc_type = 2;
noise_i = 4;
angle_inds = [3,5,6];
hold on
mperf = [];
for angle_i = 1:length(angle_inds)
	for t_win_i = 1:length(t_wins)
		load(['models/N1acc1_1_nc',int2str(nc_type),'_nz',int2str(noises(noise_i)),'_tw',int2str(t_wins(t_win_i)),'_ga.mat']);
		x = performance(:,angle_inds(angle_i));
		[ci,bs] = bootci(Nboot,@mean,x);
		mperf(angle_i,t_win_i) = mean(bs);
		lb(t_win_i) = ci(1);
		ub(t_win_i) = ci(2);
	end
	bounds = [lb,fliplr(ub)];
	fill([t_wins2,fliplr(t_wins2)],bounds,colors{angle_i},'edgecolor','none')
	alpha(0.3)
end
for angle_i = 1:length(angle_inds)
	plot(t_wins2,mperf(angle_i,:),'o','color',colors{angle_i},'markerfacecolor',colors{angle_i},'markersize',2)
	plot(t_wins2,mperf(angle_i,:),'color',colors{angle_i},'linewidth',1)
end
xlim([-1,110])
ylim([0.4,1.05])
xl = xlim;
yl = ylim;
for angle_i = 1:length(angle_inds)
	text(115,yl(1)+(0.75-0.12*(angle_i-1))*(yl(2)-yl(1)),[int2str(senss(angle_inds(angle_i))),'\circ'],'fontname','arial','fontsize',8)
	plot(110,yl(1)+(0.75-0.12*(angle_i-1))*(yl(2)-yl(1)),'o','color',colors{angle_i},'markerfacecolor',colors{angle_i},'markersize',2)
end
text(135,0.8,'\theta','fontname','arial','fontsize',8)
plot(xl,0.5*[1,1],'--','color',0.5*[1,1,1])
text(xl(1)+0.6*(xl(2)-xl(1)),0.47,'Chance','color',0.5*[1,1,1],'fontname','arial','fontsize',8)
hold off
ylabel('Test Performance','fontname','arial','fontsize',8);
annotation('textbox',[0.43 0.91 0.3 0.05],'edgecolor','none','string',['NMDA, noise = ',int2str(noises(noise_i)),'%'],'fontname','arial','fontsize',8);
set(gca,'box','off')
set(gca,'tickdir','out')
set(gca,'fontname','arial','fontsize',8);
set(gca,'xtick',xticks);
set(gca,'xticklabel',xlabels)
set(gca,'ytick',[0.4:0.2:1]);
xlabel('Time window (ms)','fontname','arial','fontsize',8);

% C
subplot('position',[0.76 0.6 0.18 0.27])
annotation('textbox',[0.72 0.91 0.4 0.05],'edgecolor','none','string',['AMPA - NMDA, noise = ',int2str(noises(noise_i)),'%'],'fontname','arial','fontsize',8);
hold on
mperf = [];
for angle_i = 1:length(angle_inds)
	for t_win_i = 1:length(t_wins)
		load(['models/N1acc1_1_nc1_nz',int2str(noises(noise_i)),'_tw',int2str(t_wins(t_win_i)),'_ga.mat']);
		performance_A = performance;
		load(['models/N1acc1_1_nc2_nz',int2str(noises(noise_i)),'_tw',int2str(t_wins(t_win_i)),'_ga.mat']);
		performance_N = performance;
		x = performance_A(:,angle_inds(angle_i)) - performance_N(:,angle_inds(angle_i));
		[ci,bs] = bootci(Nboot,@mean,x);
		mperf(1,t_win_i) = mean(bs);
		lb(t_win_i) = ci(1);
		ub(t_win_i) = ci(2);
	end
	bounds = [lb,fliplr(ub)];
	fill([t_wins2,fliplr(t_wins2)],bounds,colors{angle_i},'edgecolor','none')
	alpha(0.3)
	plot(t_wins2,mperf(1,:),'o','color',colors{angle_i},'markerfacecolor',colors{angle_i},'markersize',2)
	plot(t_wins2,mperf(1,:),'color',colors{angle_i},'linewidth',1)
end
xlim([-1,110])
ylim([-0.2,0.3])
xl = xlim;
yl = ylim;
for angle_i = 1:length(angle_inds)
	text(xl(1)+0.75*(xl(2)-xl(1)),yl(1)+(0.85-0.12*(angle_i-1))*(yl(2)-yl(1)),[int2str(senss(angle_inds(angle_i))),'\circ'],'fontname','arial','fontsize',8)
	plot(xl(1)+0.7*(xl(2)-xl(1)),yl(1)+(0.85-0.12*(angle_i-1))*(yl(2)-yl(1)),'o','color',colors{angle_i},'markerfacecolor',colors{angle_i},'markersize',2)
end
text(xl(1)+0.9*(xl(2)-xl(1)),yl(1)+0.7*(yl(2)-yl(1)),'\theta','fontname','arial','fontsize',8)
hold off
ylabel('\Delta Test Performance','fontname','arial','fontsize',8);
set(gca,'box','off')
set(gca,'tickdir','out')
set(gca,'fontname','arial','fontsize',8);
set(gca,'xtick',xticks);
set(gca,'xticklabel',xlabels)
set(gca,'ytick',[-0.2:0.2:0.4]);
xlabel('Time window (ms)','fontname','arial','fontsize',8);

% D
subplot('position',[0.1 0.1 0.18 0.3])
nc_type = 1;
hold on
mperf = [];
for noise_i = 1:length(noises)
	load(['models/N1acc1_1_nc',int2str(nc_type),'_nz',int2str(noises(noise_i)),'_tw5_ga.mat']);
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
	text(xl(1)+0.72*(xl(2)-xl(1)),yl(1)+(0.7-0.12*(noise_i-1))*(yl(2)-yl(1)),[int2str(noises(noise_i)),'%'],'fontname','arial','fontsize',8)
	plot(xl(1)+0.67*(xl(2)-xl(1)),yl(1)+(0.7-0.12*(noise_i-1))*(yl(2)-yl(1)),'o','color',colors{noise_i},'markerfacecolor',colors{noise_i},'markersize',2)
end
text(xl(2),0.7,'Noise','fontname','arial','fontsize',8,'rotation',90)
plot(xl,0.5*[1,1],'--','color',0.5*[1,1,1])
text(xl(1)+0.6*(xl(2)-xl(1)),0.47,'Chance','color',0.5*[1,1,1],'fontname','arial','fontsize',8)
hold off
annotation('textbox',[0.1 0.4 0.3 0.05],'edgecolor','none','string','AMPA, t_{win} = 5 ms','fontname','arial','fontsize',8);
set(gca,'box','off')
set(gca,'tickdir','out')
set(gca,'fontname','arial','fontsize',8);
set(gca,'xtick',senss(end:-1:1));
set(gca,'ytick',[0.4:0.2:1]);
xlabel('Orientation (\circ)','fontname','arial','fontsize',8);
ylabel('Test Performance','fontname','arial','fontsize',8);

% E
subplot('position',[0.43 0.1 0.18 0.3])
nc_type = 2;
hold on
mperf = [];
for noise_i = 1:length(noises)
	load(['models/N1acc1_1_nc',int2str(nc_type),'_nz',int2str(noises(noise_i)),'_tw5_ga.mat']);
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
	text(xl(1)+0.72*(xl(2)-xl(1)),yl(1)+(0.7-0.12*(noise_i-1))*(yl(2)-yl(1)),[int2str(noises(noise_i)),'%'],'fontname','arial','fontsize',8)
	plot(xl(1)+0.67*(xl(2)-xl(1)),yl(1)+(0.7-0.12*(noise_i-1))*(yl(2)-yl(1)),'o','color',colors{noise_i},'markerfacecolor',colors{noise_i},'markersize',2)
end
text(xl(2),0.7,'Noise','fontname','arial','fontsize',8,'rotation',90)
plot(xl,0.5*[1,1],'--','color',0.5*[1,1,1])
text(xl(1)+0.6*(xl(2)-xl(1)),0.47,'Chance','color',0.5*[1,1,1],'fontname','arial','fontsize',8)
hold off
annotation('textbox',[0.43 0.4 0.3 0.05],'edgecolor','none','string','NMDA, t_{win} = 5 ms','fontname','arial','fontsize',8);
set(gca,'box','off')
set(gca,'tickdir','out')
set(gca,'fontname','arial','fontsize',8);
set(gca,'xtick',senss(end:-1:1));
set(gca,'ytick',[0.4:0.2:1]);
xlabel('Orientation (\circ)','fontname','arial','fontsize',8);
ylabel('Test Performance','fontname','arial','fontsize',8);


% F
subplot('position',[0.76 0.1 0.18 0.27])
annotation('textbox',[0.72 0.4 0.4 0.05],'edgecolor','none','string','AMPA - NMDA, t_{win} = 5 ms','fontname','arial','fontsize',8);
hold on
mperf = [];
for noise_i = 2:length(noises)
	load(['models/N1acc1_1_nc1_nz',int2str(noises(noise_i)),'_tw5_ga.mat']);
	performance_A = performance;
	load(['models/N1acc1_1_nc2_nz',int2str(noises(noise_i)),'_tw5_ga.mat']);
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
ylim([-0.1,0.2])
xl = xlim;
yl = ylim;
for noise_i = 2:length(noises)
	text(xl(1)+0.6*(xl(2)-xl(1)),yl(1)+(0.95-0.12*(noise_i-2))*(yl(2)-yl(1)),[int2str(noises(noise_i)),'%'],'fontname','arial','fontsize',8)
	plot(xl(1)+0.55*(xl(2)-xl(1)),yl(1)+(0.95-0.12*(noise_i-2))*(yl(2)-yl(1)),'o','color',colors{noise_i},'markerfacecolor',colors{noise_i},'markersize',2)
end
text(xl(1)+0.9*(xl(2)-xl(1)),yl(1)+0.7*(yl(2)-yl(1)),'Noise','fontname','arial','fontsize',8,'rotation',90)
hold off
set(gca,'box','off')
set(gca,'tickdir','out')
set(gca,'fontname','arial','fontsize',8);
set(gca,'xtick',senss(end:-1:1));
set(gca,'ytick',[-0.2:0.1:0.2]);
xlabel('Orientation (\circ)','fontname','arial','fontsize',8);
ylabel('\Delta Test Performance','fontname','arial','fontsize',8);


annotation('textbox',[0 0.95 0.05 0.05],'edgecolor','none','string','A','fontname','arial','fontsize',12,'fontweight','bold');
annotation('textbox',[0.33 0.95 0.05 0.05],'edgecolor','none','string','B','fontname','arial','fontsize',12,'fontweight','bold');
annotation('textbox',[0.66 0.95 0.05 0.05],'edgecolor','none','string','C','fontname','arial','fontsize',12,'fontweight','bold');
annotation('textbox',[0 0.45 0.05 0.05],'edgecolor','none','string','D','fontname','arial','fontsize',12,'fontweight','bold');
annotation('textbox',[0.33 0.45 0.05 0.05],'edgecolor','none','string','E','fontname','arial','fontsize',12,'fontweight','bold');
annotation('textbox',[0.66 0.45 0.05 0.05],'edgecolor','none','string','F','fontname','arial','fontsize',12,'fontweight','bold');


if strcmp(savefig,'y')
	print(ff1,filetype,'-r300','figures_tactile/3');
end





