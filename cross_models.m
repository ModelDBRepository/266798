% Author: Etay Hay
% Orientation processing by synaptic integration across first-order tactile neurons (Hay and Pruszynski 2020)

function models2 = cross_models(models,p_cross)
	Nmr = size(models{1}.mr_subset,1);
	models2 = models;
	inds = randperm(length(models));
	inds1 = inds(1:round(length(models)/2));
	inds2 = inds((1+round(length(models)/2)):length(models));
	for k=1:length(inds1)
		if rand()<p_cross
			cross_j = 1 + floor(Nmr*rand());
			models2{inds1(k)}.mr_subset(1:cross_j,:) = models{inds2(k)}.mr_subset(1:cross_j,:);
			models2{inds1(k)}.mr_w(1:cross_j) = models{inds2(k)}.mr_w(1:cross_j);
			models2{inds2(k)}.mr_subset(1:cross_j,:) = models{inds1(k)}.mr_subset(1:cross_j,:);
			models2{inds2(k)}.mr_w(1:cross_j) = models{inds1(k)}.mr_w(1:cross_j);
		end
		if rand()<p_cross
			models2{inds1(k)}.m_maxrate = models{inds2(k)}.m_maxrate;
			models2{inds2(k)}.m_maxrate = models{inds1(k)}.m_maxrate;
		end
		if rand()<p_cross
			models2{inds1(k)}.mr_r1 = models{inds2(k)}.mr_r1;
			models2{inds2(k)}.mr_r1 = models{inds1(k)}.mr_r1;
		end
		if rand()<p_cross
			models2{inds1(k)}.mr_r2 = models{inds2(k)}.mr_r2;
			models2{inds2(k)}.mr_r2 = models{inds1(k)}.mr_r2;
		end
	end
end
