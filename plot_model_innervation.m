% Author: Etay Hay
% Orientation processing by synaptic integration across first-order tactile neurons (Hay and Pruszynski 2020)

function [] = plot_model_innervation(model,patch_length,plot_mode)
	colors = {[255,219,172]/255,[0,0,0]/255,0.6*[1,1,1]};
	rectangle('position',[0 0 patch_length patch_length],'facecolor',colors{1},'edgecolor','k')
	d_mr = model.d_mr;
	hold on
	[indsR,indsC] = find(model.mr_loc == 1);
	shifti = (patch_length - d_mr*(max(indsR) + min(indsR)))/2; 
	shiftj = (patch_length - d_mr*(max(indsC) + min(indsC)))/2;
	if (plot_mode == 1)
		verts0 = [];
		verts1 = [];
		for k = 1:size(model.mr_loc,1)
			inds = find(model.mr_loc(k,:)==1);
			if ~isempty(inds)
				[vmin,imin] = min(inds);
				verts0(end+1,:) = [k,vmin];
				[vmax,imax] = max(inds);
				verts1(end+1,:) = [k,vmax];
			end
		end
		verts = [verts0(1,:);verts1;verts0(end:-1:1,:)];
		plot(verts(:,2)*d_mr+shiftj-d_mr/2,verts(:,1)*d_mr+shifti-d_mr/2,'color',colors{3})	
	end
	for k = 1:size(model.mr_subset,1)
		i = model.mr_subset(k,1);
		j = model.mr_subset(k,2);
		plot(j*d_mr+shiftj-d_mr/2,i*d_mr+shifti-d_mr/2,'o','color',colors{2},'markerfacecolor',colors{2},'markersize',1)
	end
	hold off
	xlim([0,patch_length])
	ylim([0,patch_length])
	axis off
end
