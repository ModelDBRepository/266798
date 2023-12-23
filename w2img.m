% Author: Etay Hay
% Orientation processing by synaptic integration across first-order tactile neurons (Hay and Pruszynski 2020)

function w2 = w2img(ws)
	ws_max = zeros(size(ws{1}));
	ws2 = [];
	for k = 1:length(ws)
		ws2(:,:,k) = ws{k};
	end
	for i = 1:size(ws2,1)
		for j = 1:size(ws2,2)
			ws_max(i,j) = max(squeeze(ws2(i,j,:)));
		end
	end
	%ws_max_s = imgaussfilt(ws_max,4);
	%w2 = rot90(ws_max_s');
	w2 = rot90(ws_max');
end