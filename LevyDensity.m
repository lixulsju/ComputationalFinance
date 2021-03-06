
function k = LevyDensity(param, model)
%LevyDensity returns the Levy density for different models
% INPUT:
%   lambda = jump intensity
%   param = model parameters
%   model =
switch model
	
	case 'Merton'
		% Merton parameters: sigma = diffusion volatility
		%                    lambda = jump intensity
		%                    mu = mean jump size
		%                    delta = std jump size
		lambda = param(2); % jump intensity
		mu = param(3); % mean jump size
		delta = param(4); % std jump size
		k = @(y) (lambda/(delta*sqrt(2*pi)) * exp(-(y - mu).^2/(2*delta^2)));
	case 'Kou'
		% parametri Kou: 1)   sigma = diffusion volatility;
		%                     lambda = jump intensity
		%                     lambda_p = positive jump parameter
		%                     param_m = negative jump parameter
		%                     p = probability positive jump
		lambda = param(2);
		lambda_p = param(3);
		lambda_m = param(4);
		p = param(5);
		k = @(y) p * lambda * lambda_p * exp(-lambda_p * y) .* (y > 0) + ...
			(1 - p) * lambda * lambda_m * exp(-lambda_m * abs(y)) .* (y < 0);
	case 'VG'
		% parametri VG: 1) theta = Brownian drift to be subordinated
		%               2) sigma = Brownian volatility to be subordinated
		%               3) kappa = subordinator volatility
		theta = param(1);
		sigma = param(2);
		kappa = param(3);
		A = theta / sigma^2;
		B = sqrt(theta^2 + 2 * sigma^2 / kappa) / sigma^2;
		k = @(y) exp(A .* y - B .* abs(y)) ./ (kappa .* abs(y));
	case 'VG2'
		% 		a = param(1);
		% 		eta_p = param(2);
		% 		eta_m = param(3);
		% 		k = @(y) a * ((-exp(eta_m * y)./y) .* (y<0) +...
		% 			(exp(-eta_p * y)./y) .* (y>0));
		nu = param(1);
		etaN = param(2);
		etaP = param(3);
		k=@(y) 1./(nu*abs(y)).*exp(-abs(y)/etaN).*(y<0)+...
			1./(nu*abs(y)).*exp(-abs(y)/etaP).*(y>0);
	case 'NIG'
		
	otherwise
		error('invalid model');
end
end % function LevyDensity