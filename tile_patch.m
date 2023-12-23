% Author: Etay Hay
% Orientation processing by synaptic integration across first-order tactile neurons (Hay and Pruszynski 2020)

function models2 = tile_patch(Ntype,models_ex,sim_param)
	warning off
	close all;
	rng(1234);
	patch_length_x = sim_param.patch_length_x;
	patch_length_y = sim_param.patch_length_y;
	dx = sim_param.dx;
	d_mr = models_ex{1}.d_mr;
	mr_loc = zeros(round(patch_length_y/d_mr),round(patch_length_x/d_mr));
	d_cell = 10/12; % density of ~144/cm2
	dm_cell = round(d_cell/d_mr);
	cells_offset = [];
	models2 = {};
	max_lx = 0;
	max_ly = 0;
	for k = 1:length(models_ex)
		model = models_ex{k};
		[indsR,indsC] = find(model.mr_loc == 1);
		cell_length_x = (max(indsC) - min(indsC))*d_mr;
		cell_length_y = (max(indsR) - min(indsR))*d_mr;
		if cell_length_x > max_lx
			max_lx = cell_length_x;
		end
		if cell_length_y > max_ly
			max_ly = cell_length_y;
		end
	end
	cell_length_x = max_lx;
	cell_length_y = max_ly;
	for i = 1:floor((patch_length_y + cell_length_y)/d_cell)
		for j = 1:floor((patch_length_x + cell_length_x)/d_cell)
			offset_i = -floor((cell_length_y/2)/d_mr) + (i-1)*dm_cell;
			offset_j = -floor((cell_length_x/2)/d_mr) + (j-1)*dm_cell;
			cells_offset(end+1,:) = [offset_i,offset_j];
			if mod(i,2) == 0
				cells_offset(end,2) = cells_offset(end,2) + round(dm_cell/2);
			end
		end
	end
	models3 = {};
	for k = 1:size(cells_offset,1)
		rvec = randperm(length(models_ex));
		model = models_ex{rvec(1)};
		if strcmp(Ntype,'N1')
			models2{k} = model_rotation(model);
		elseif strcmp(Ntype,'N4')
			models2{k} = make_simple_model(model);
		else
			models2{k} = model_variation(model);
		end
		models2{k}.mr_loc = mr_loc;
		offset1 = floor((max(models2{k}.mr_subset(:,1)) + min(models2{k}.mr_subset(:,1)))/2);
		offset2 = floor((max(models2{k}.mr_subset(:,2)) + min(models2{k}.mr_subset(:,2)))/2);
		models2{k}.mr_subset(:,1) = models2{k}.mr_subset(:,1) + cells_offset(k,1) - offset1;
		models2{k}.mr_subset(:,2) = models2{k}.mr_subset(:,2) + cells_offset(k,2) - offset2;
		inds1 = find(sum((models2{k}.mr_subset > 0),2)==2);
		inds2 = find(sum((models2{k}.mr_subset <= size(mr_loc)),2)==2);
		inds = intersect(inds1,inds2);
		if ~isempty(inds)
			models3{end+1} = models2{k};
			models3{end}.mr_subset = models2{k}.mr_subset(inds,:);
			models3{end}.mr_loc = mr_loc;
		end
	end
	if strcmp(Ntype,'N3')
		for k = 1:length(models3)
			for k2 = 1:size(models3{k}.mr_subset,1)
				rvec2 = randperm(size(mr_loc,1));
				models3{k}.mr_subset(k2,1) = rvec2(1);
				rvec2 = randperm(size(mr_loc,2));
				models3{k}.mr_subset(k2,2) = rvec2(1);
			end
		end
	end
	models2 = models3;
	disp([int2str(length(models2)),' cells'])
end



