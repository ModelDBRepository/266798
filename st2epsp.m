% Author: Etay Hay
% Orientation processing by synaptic integration across first-order tactile neurons (Hay and Pruszynski 2020)

function v = st2epsp(tvec,st,tau1,tau2)
	t = 1:round(3*tau2);
	epspfun = exp(-t/tau2) - exp(-t/tau1);
	epspfun = epspfun';
	v = zeros(length(tvec),1);
	for k = 1:length(st)
		t1 = st(k)+1;
		t2 = min(length(tvec),t1+length(t)-1);
		v(t1:t2) = v(t1:t2) + epspfun(1:(t2-t1+1));
	end
end
