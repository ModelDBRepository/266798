% Author: Etay Hay
% Orientation processing by synaptic integration across first-order tactile neurons (Hay and Pruszynski 2020)

function [x1,x2,ytrial,t] = get_stim_param(stim,sim_param)
	if strcmp(stim{1},'dot')
		x1 = sim_param.dot_xy(1,1);
		x2 = sim_param.dot_xy(2,1);
		ytrials = sim_param.dot_xy(2,2):-sim_param.dy:sim_param.dot_xy(1,2);
		ytrial = ytrials(stim{2});
	elseif strcmp(stim{1},'line') || strcmp(stim{1},'line2')
		if sim_param.cellnum == 1
			ytrial = -9;
			if stim{2} == 0
				x1 = 148;
				x2 = 153;
			elseif stim{2} == -22.5
				x1 = 138;
				x2 = 143;
			elseif stim{2} == 22.5
				x1 = 158;
				x2 = 163;
			elseif stim{2} == -45
				x1 = 127;
				x2 = 134;
			elseif stim{2} == 45
				x1 = 167;
				x2 = 174;
			elseif stim{2} == 30
				x1 = 78;
				x2 = 86;
				ytrial = -5.6;
			end
		elseif sim_param.cellnum == 2
			ytrial = -9;
			if stim{2} == 0
				x1 = 147;
				x2 = 152;
			elseif stim{2} == -22.5
				x1 = 137;
				x2 = 142;
			elseif stim{2} == 22.5
				x1 = 157;
				x2 = 162;
			elseif stim{2} == -45
				x1 = 127;
				x2 = 132;
			elseif stim{2} == 45
				x1 = 167;
				x2 = 172;
			elseif stim{2} == 30
				x1 = 77;
				x2 = 84;
				ytrial = -5.6;
			end
		elseif sim_param.cellnum == 3
			ytrial = -8.6;
			if stim{2} == 0
				x1 = 148;
				x2 = 152;
			elseif stim{2} == -22.5
				x1 = 138;
				x2 = 142;
			elseif stim{2} == 22.5
				x1 = 158;
				x2 = 161;
			elseif stim{2} == -45
				x1 = 129;
				x2 = 133;
			elseif stim{2} == 45
				x1 = 168;
				x2 = 171;
			elseif stim{2} == 30
				x1 = 78;
				x2 = 83;
				ytrial = -5.6;
			end
		elseif sim_param.cellnum == 4
			ytrial = -8.4;
			if stim{2} == 0
				x1 = 149;
				x2 = 155;
			elseif stim{2} == -22.5
				x1 = 137;
				x2 = 144;
			elseif stim{2} == 22.5
				x1 = 158;
				x2 = 165;
			elseif stim{2} == -45
				x1 = 126;
				x2 = 133;
			elseif stim{2} == 45
				x1 = 170;
				x2 = 176;
			elseif stim{2} == 30
				x1 = 80;
				x2 = 86;
				ytrial = -5.6;
			end
		elseif sim_param.cellnum == 5
			ytrial = -9.8;
			if stim{2} == 0
				x1 = 148;
				x2 = 154;
			elseif stim{2} == -22.5
				x1 = 137;
				x2 = 144;
			elseif stim{2} == 22.5
				x1 = 157;
				x2 = 165;
			elseif stim{2} == -45
				x1 = 126;
				x2 = 134;
			elseif stim{2} == 45
				x1 = 167;
				x2 = 176;
			elseif stim{2} == 30
				x1 = 79;
				x2 = 87;
				ytrial = -5.6;
			end
		elseif sim_param.cellnum == 6
			if stim{2} == 0
				x1 = 145;
				x2 = 154;
				ytrial = -9.8;
			elseif stim{2} == -22.5
				x1 = 135;
				x2 = 142;
				ytrial = -9.8;
			elseif stim{2} == 22.5
				x1 = 155;
				x2 = 164;
				ytrial = -9;
			elseif stim{2} == -45
				x1 = 125;
				x2 = 133;
				ytrial = -9.8;
			elseif stim{2} == 45
				x1 = 165;
				x2 = 173;
				ytrial = -9;
			elseif stim{2} == 30
				x1 = 77;
				x2 = 84;
				ytrial = -5.6;
			end
		elseif sim_param.cellnum == 7
			ytrial = -8.4;
			if stim{2} == 0
				x1 = 148;
				x2 = 152;
			elseif stim{2} == -22.5
				x1 = 139;
				x2 = 142;
			elseif stim{2} == 22.5
				x1 = 158;
				x2 = 162;
			elseif stim{2} == -45
				x1 = 129;
				x2 = 133;
			elseif stim{2} == 45
				x1 = 168;
				x2 = 173;
			elseif stim{2} == 30
				x1 = 75;
				x2 = 79;
				ytrial = -5.6;
			end
		elseif sim_param.cellnum == 8
			ytrial = -7.4;
			if stim{2} == 0
				x1 = 149;
				x2 = 154;
			elseif stim{2} == -22.5
				x1 = 137;
				x2 = 143;
			elseif stim{2} == 22.5
				x1 = 158;
				x2 = 164;
			elseif stim{2} == -45
				x1 = 126;
				x2 = 133;
			elseif stim{2} == 45
				x1 = 168;
				x2 = 177;
			elseif stim{2} == 30
				x1 = 78;
				x2 = 86;
				ytrial = -5.6;
			end
		elseif sim_param.cellnum == 9
			ytrial = -8.4;
			if stim{2} == 0
				x1 = 148;
				x2 = 151;
			elseif stim{2} == -22.5
				x1 = 138;
				x2 = 140;
			elseif stim{2} == 22.5
				x1 = 159;
				x2 = 162;
			elseif stim{2} == -45
				x1 = 126;
				x2 = 132;
			elseif stim{2} == 45
				x1 = 169;
				x2 = 172;
			elseif stim{2} == -30
				x1 = 72;
				x2 = 77;
				ytrial = -5.6;
			end
		elseif sim_param.cellnum == 10
			ytrial = -8.8;
			if stim{2} == 0
				x1 = 148;
				x2 = 152;
			elseif stim{2} == -22.5
				x1 = 137;
				x2 = 142;
			elseif stim{2} == 22.5
				x1 = 157;
				x2 = 163;
			elseif stim{2} == -45
				x1 = 127;
				x2 = 133;
			elseif stim{2} == 45
				x1 = 167;
				x2 = 173;
			elseif stim{2} == -30
				x1 = 72;
				x2 = 78;
				ytrial = -5.6;
			end
		elseif sim_param.cellnum == 11
			if stim{2} == 0
				x1 = 148;
				x2 = 154;
				ytrial = -8.4;
			elseif stim{2} == -22.5
				x1 = 138;
				x2 = 144;
				ytrial = -8.4;
			elseif stim{2} == 22.5
				x1 = 158;
				x2 = 164;
				ytrial = -8.4;
			elseif stim{2} == -45
				x1 = 127;
				x2 = 135;
				ytrial = -8.8;
			elseif stim{2} == 45
				x1 = 168;
				x2 = 174;
				ytrial = -8.8;
			elseif stim{2} == -30
				x1 = 73;
				x2 = 80;
				ytrial = -5.6;
			end
		elseif sim_param.cellnum == 12
			if stim{2} == 0
				x1 = 151;
				x2 = 155;
				ytrial = -8.4;
			elseif stim{2} == -22.5
				x1 = 140;
				x2 = 144;
				ytrial = -8.4;
			elseif stim{2} == 22.5
				x1 = 161;
				x2 = 165;
				ytrial = -8.8;
			elseif stim{2} == -45
				x1 = 129;
				x2 = 134;
				ytrial = -8.8;
			elseif stim{2} == 45
				x1 = 171;
				x2 = 176;
				ytrial = -8.4;
			elseif stim{2} == -30
				x1 = 74;
				x2 = 80;
				ytrial = -5.6;
			end
		elseif sim_param.cellnum == 13
			if stim{2} == 0
				x1 = 152;
				x2 = 155;
				ytrial = -8;
			elseif stim{2} == -22.5
				x1 = 141;
				x2 = 144;
				ytrial = -8;
			elseif stim{2} == 22.5
				x1 = 162;
				x2 = 166;
				ytrial = -7.6;
			elseif stim{2} == -45
				x1 = 130;
				x2 = 134;
				ytrial = -8;
			elseif stim{2} == 45
				x1 = 173;
				x2 = 177;
				ytrial = -8;
			elseif stim{2} == 30
				x1 = 77;
				x2 = 81;
				ytrial = -5.6;
			end
		elseif sim_param.cellnum == 15
			if stim{2} == 0
				x1 = 147;
				x2 = 155;
				ytrial = -7.4;
			elseif stim{2} == -22.5
				x1 = 136;
				x2 = 144;
				ytrial = -7.4;
			elseif stim{2} == 22.5
				x1 = 157;
				x2 = 165;
				ytrial = -7.8;
			elseif stim{2} == -45
				x1 = 125;
				x2 = 133;
				ytrial = -7.4;
			elseif stim{2} == 45
				x1 = 169;
				x2 = 177;
				ytrial = -7.4;
			elseif stim{2} == 30
				x1 = 78;
				x2 = 87;
				ytrial = -5.6;
			end
		elseif sim_param.cellnum == 16
			if stim{2} == 0
				x1 = 149;
				x2 = 154;
				ytrial = -8.2;
			elseif stim{2} == -22.5
				x1 = 138;
				x2 = 144;
				ytrial = -8.2;
			elseif stim{2} == 22.5
				x1 = 160;
				x2 = 164;
				ytrial = -8.2;
			elseif stim{2} == -45
				x1 = 127;
				x2 = 134;
				ytrial = -8.2;
			elseif stim{2} == 45
				x1 = 169;
				x2 = 176;
				ytrial = -8.6;
			elseif stim{2} == 30
				x1 = 80;
				x2 = 86;
				ytrial = -5.6;
			end
		elseif sim_param.cellnum == 17
			if stim{2} == 0
				x1 = 148;
				x2 = 154;
				ytrial = -8.2;
			elseif stim{2} == -22.5
				x1 = 137;
				x2 = 144;
				ytrial = -8.2;
			elseif stim{2} == 22.5
				x1 = 158;
				x2 = 164;
				ytrial = -8.6;
			elseif stim{2} == -45
				x1 = 125;
				x2 = 133;
				ytrial = -8.2;
			elseif stim{2} == 45
				x1 = 169;
				x2 = 176;
				ytrial = -8.6;
			elseif stim{2} == 30
				x1 = 79;
				x2 = 87;
				ytrial = -5.6;
			end
		elseif sim_param.cellnum == 18
			if stim{2} == 0
				x1 = 151;
				x2 = 154;
				ytrial = -8.6;
			elseif stim{2} == -22.5
				x1 = 140;
				x2 = 144;
				ytrial = -8.6;
			elseif stim{2} == 22.5
				x1 = 161;
				x2 = 164;
				ytrial = -8.6;
			elseif stim{2} == -45
				x1 = 129;
				x2 = 133;
				ytrial = -7.8;
			elseif stim{2} == 45
				x1 = 171;
				x2 = 176;
				ytrial = -7.8;
			elseif stim{2} == 30
				x1 = 81;
				x2 = 86;
				ytrial = -5.6;
			end
		end
	end	
	t = 0:((x2-x1)/sim_param.drum_speed);
end

