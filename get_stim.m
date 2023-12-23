% Author: Etay Hay
% Orientation processing by synaptic integration across first-order tactile neurons (Hay and Pruszynski 2020)

function [stim1,m_t] = get_stim(stim,sim_param)
	dx = sim_param.dx;
	dy = sim_param.dy;
	rf_size1 = round(sim_param.patch_length_y/dx);
	rf_size2 = round(sim_param.patch_length_x/dx);
	stim1 = zeros(rf_size1,rf_size2);
	dot_diam = dy;
	line_thickness = 0.5;
	if strcmp(stim{1},'dot') || strcmp(stim{1},'dot2') 
		i1 = 1 + round((stim{2}-1)*dot_diam/dx);
		i2 = round(stim{2}*dot_diam/dx);
		stim1(i1:i2,rf_size2-[1:floor(dot_diam/dx)]) = 0.5;
	elseif strcmp(stim{1},'line') || strcmp(stim{1},'line2') || strcmp(stim{1},'linepress') || strcmp(stim{1},'line3mm')
		line_angle = stim{2}*2*pi/360;
		for k = 1:rf_size1
			if line_angle <= 0
				yi = k;
			else
				yi = rf_size1 - k + 1;
			end
			stim1(yi,1 + [1:floor((((line_thickness^2) * (1 + tan(line_angle)^2))^0.5)/dx)] + floor((k-1)*abs(tan(line_angle)))) = 0.5;
		end
		stim1 = stim1(:,end:-1:1);
	elseif strcmp(stim{1},'2dots')
		for k = 1:length(stim{2})		
			i1 = 1 + round((stim{2}(k)-1)*dot_diam/dx);
			i2 = 1 + round(stim{2}(k)*dot_diam/dx);
			stim1(i1:i2,rf_size2 + [1:floor(dot_diam/dx)]) = 0.5;
		end
	end
	i0 = find(sum(stim1)~=0,1,'first');
	stim1 = stim1(:,i0:end);
	stim1 = [zeros(rf_size1,rf_size2), stim1, zeros(rf_size1,rf_size2)];
	if strcmp(stim{1},'linepress')
		j1 = max(1,round((size(stim1,2) - rf_size2)/2));
		j2 = j1 + rf_size2 - 1;
		stim1 = stim1(:,j1:j2);
		m_t = 0:1:200;
	else
		m_t = 0:(size(stim1,2)-rf_size2);
	end
	if strcmp(stim{1},'line3mm')
		l1 = 3*cos(line_angle);
		i1 = round(rf_size1/2 - l1/dx);
		i2 = round(rf_size1/2 + l1/dx);
		stim1(1:i1,:) = 0;
		stim1(i2:end,:) = 0;		
	end
end

