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
pwidth = ploscb_pwidth/2;
pheight = ploscb_pwidth/2;
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
nc_type = '2';
subplot('position',[0.13 0.6 0.3 0.3])
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
hold on
[vs,is] = sort(m1a(inds1),'descend');
for k = 1:length(inds1)
	k2 = inds1(is(k));
	rectangle('position',[k-0.5, ci(k2,1), 1, (ci(k2,2)-ci(k2,1))],'facecolor','k','edgecolor','k')
end
[vs,is] = sort(m1a(inds3),'descend');
for k = 1:length(inds3)
	k2 = inds3(is(k));
	rectangle('position',[k-0.5+length(inds1), ci(k2,1), 1, (ci(k2,2)-ci(k2,1))],'facecolor',0.7*[1,1,1],'edgecolor',0.7*[1,1,1])
end
[vs,is] = sort(m1a(inds2),'descend');
for k = 1:length(inds2)
	k2 = inds2(is(k));
	rectangle('position',[k-0.5+length(inds1)+length(inds3), ci(k2,1), 1, (ci(k2,2)-ci(k2,1))],'facecolor','k','edgecolor','k')
end
hold off
xlim([0,(length(m1)+1)])
xlabel('First-order neurons','fontname','arial','fontsize',8);
ylabel(['Weight, ',int2str(ang),'\circ unit'],'fontname','arial','fontsize',8);
set(gca,'xtick',[1,length(m1)])
%set(gca,'xtick',[])
set(gca,'box','off')
set(gca,'tickdir','out')
set(gca,'fontname','arial','fontsize',8);

subplot('position',[0.68 0.6 0.3 0.3])
for k = 1:length(m1)
	[ci(k,:),bs] = bootci(200,{@mean,ws1(k,:)},'alpha',0.05/length(m1));
end
inds1e = find(ci(:,1) > 0);
inds1i = find(ci(:,2) < 0);
inds1 = union(inds1e,inds1i);
for k = 1:length(m2)
	[ci(k,:),bs] = bootci(200,{@mean,ws2(k,:)},'alpha',0.05/length(m2));
end
inds2e = find(ci(:,1) > 0);
inds2i = find(ci(:,2) < 0);
inds2 = union(inds2e,inds2i);
inds = union(inds1e,inds2e);
plot(m1(inds),m2(inds),'.k')
xlim([-0.25,0.5])
ylim([-0.5,0.5])
xl = xlim;
yl = ylim;
[r,p] = corr(m1(inds),m2(inds))
text(xl(1) + 0.2*(xl(2)-xl(1)),yl(1) + 0.1*(yl(2)-yl(1)),['r = ',num2str(round(r,2))],'fontname','arial','fontsize',8);
xlabel(['Weights, ',int2str(ang),'\circ unit'],'fontname','arial','fontsize',8);
ylabel(['Weights, -',int2str(ang),'\circ unit'],'fontname','arial','fontsize',8);
title('Key Synaptic Weights','fontweight','normal','fontname','arial','fontsize',8);
set(gca,'xtick',[-1:0.5:1])
set(gca,'ytick',[-1:0.5:1])
set(gca,'box','off')
set(gca,'tickdir','out')
set(gca,'fontname','arial','fontsize',8);

% C,D
load(['models/N1angles1_',int2str(noise),'.mat']);
w_img1 = zeros(size(models2{1}.mr_loc));
w_img2 = zeros(size(models2{1}.mr_loc));
if strcmp(savefig,'y')
	for k = 1:length(m1)
		for k2 = 1:size(models2{k}.mr_subset,1)
			i = ceil(models2{k}.mr_subset(k2,1));
			j = ceil(models2{k}.mr_subset(k2,2));
			w_img1(i,j) = w_img1(i,j) + m1(k);
		end
	end
	for k = 1:length(m2)
		for k2 = 1:size(models2{k}.mr_subset,1)
			i = ceil(models2{k}.mr_subset(k2,1));
			j = ceil(models2{k}.mr_subset(k2,2));
			w_img2(i,j) = w_img2(i,j) + m2(k);
		end
	end
end
subplot('position',[0.1 0.05 0.36 0.36])
w_img1 = imgaussfilt(w_img1,5);
imagesc(rot90(w_img1'));
ylabel(['RF, ',int2str(ang),'\circ unit'],'fontname','arial','fontsize',8);
set(gca,'xtick',[])
set(gca,'ytick',[])
subplot('position',[0.6 0.05 0.36 0.36])
w_img2 = imgaussfilt(w_img2,5);
imagesc(rot90(w_img2'));
ylabel(['RF, -',int2str(ang),'\circ unit'],'fontname','arial','fontsize',8);
set(gca,'xtick',[])
set(gca,'ytick',[])

angles = [1,3,5,10,15,20];
for nc_type = 1:2
	Nkey = [];
	NkeyE = [];
	NkeyI = [];
	key_corr = [];
	if nc_type == 1
		disp('AMPA classifiers')
	else
		disp('NMDA classifiers')
	end
	for i_angle = 1:length(angles)
		load(['models/N1wnc1_1_nc',int2str(nc_type),'_nz',int2str(noise),'_tw',int2str(t_win),'_ang',int2str(angles(i_angle)),'_ga.mat']);
		m1 = mean(ws1')';
		m2 = mean(ws2')';
		for k = 1:length(m1)
			[ci(k,:),bs] = bootci(200,{@mean,ws1(k,:)},'alpha',0.05/length(m1));
			m1a(k,1) = mean(bs);
		end
		inds1e = find(ci(:,1) > 0);
		inds1i = find(ci(:,2) < 0);
		inds1 = union(inds1e,inds1i);
		Nkey = [Nkey; length(inds1)];
		NkeyE = [NkeyE; length(inds1e)];
		NkeyI = [NkeyI; length(inds1i)];
		for k = 1:length(m2)
			[ci(k,:),bs] = bootci(200,{@mean,ws2(k,:)},'alpha',0.05/length(m2));
		end
		inds2e = find(ci(:,1) > 0);
		inds2i = find(ci(:,2) < 0);
		inds2 = union(inds2e,inds2i);
		inds = union(inds1e,inds2e);
		key_corr(i_angle,1) = corr(m1(inds),m2(inds));
	end
	inds3 = find(NkeyE~=0);
	[r,p] = corr(angles',Nkey)
	disp(['Nkey = ',num2str(mean(Nkey(inds3))),' +- ',num2str(std(Nkey(inds3)))])
	disp(['NkeyE = ',num2str(mean(NkeyE(inds3))),' +- ',num2str(std(NkeyE(inds3)))])
	disp(['NkeyI = ',num2str(mean(NkeyI(inds3))),' +- ',num2str(std(NkeyI(inds3)))])
	disp(['corr between key inputs = ',num2str(round(mean(key_corr(inds3)),2)),' + ',num2str(round(std(key_corr(inds3)),2))])
end

annotation('textbox',[0 0.95 0.05 0.05],'edgecolor','none','string','A','fontname','arial','fontsize',12,'fontweight','bold');
annotation('textbox',[0.47 0.95 0.05 0.05],'edgecolor','none','string','B','fontname','arial','fontsize',12,'fontweight','bold');
annotation('textbox',[0 0.45 0.05 0.05],'edgecolor','none','string','C','fontname','arial','fontsize',12,'fontweight','bold');


if strcmp(savefig,'y')
	print(ff1,filetype,'-r300','figures_tactile/5');
end





