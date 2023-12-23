% Author: Etay Hay
% Orientation processing by synaptic integration across first-order tactile neurons (Hay and Pruszynski 2020)

function [] = plot_skin_patch(models,show_num,patch_length,colors)
	d_mr = models{1}.d_mr;
	mr_loc = models{1}.mr_loc;
	hold on
	rectangle('position',[0 0 patch_length patch_length],'facecolor',[255,219,172]/255,'edgecolor','k')
	for k2 = 1:length(show_num)
		k = show_num(k2);
		%bi = boundary(models{k}.mr_subset(:,2),models{k}.mr_subset(:,1));
		color1 = colors{k2};
		%plot(models{k}.mr_subset(bi,2)*d_mr,models{k}.mr_subset(bi,1)*d_mr,'color',color1)
		if (models{k}.spiking_type == "simple")
				y = models{k}.mr_subset(1,1)*d_mr;
				x = models{k}.mr_subset(1,2)*d_mr;
				th = 0:pi/50:2*pi;
				r = models{k}.mr_r1;
				xunit = r * cos(th) + x;
				yunit = r * sin(th) + y;
				plot(xunit, yunit,'color',color1);
				r = models{k}.mr_r2;
				xunit = r * cos(th) + x;
				yunit = r * sin(th) + y;
				plot(xunit, yunit,'color',color1);
		else
			for k2 = 1:size(models{k}.mr_subset,1)
				i = models{k}.mr_subset(k2,1);
				j = models{k}.mr_subset(k2,2); 
				plot(j*d_mr,i*d_mr,'o','color',color1,'markerfacecolor',color1,'markersize',1)
			end
		end
	end
	xlim([0,patch_length])
	ylim([0,patch_length])
	hold off
	axis off;
end
