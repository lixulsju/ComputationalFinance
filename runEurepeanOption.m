% runEuropeanOption
% pricing Eurepean
clc; close all; clear variables;rng(1192)
T = 1;S0 = 30;r = 0.1;K = 30;
Nsim = 1e5; Nstep = 40;N = 300; M = 300;
epsilon = 0.01;
model = 'VG';
optionType = 'Put';
theta = 0.5;
NumMethod = 'implicit';
switch optionType
	case 'Call'
		switch model
			case 'BS'
				param = 0.6;
				% 1) closed formula
				PriceExact = blsprice(S0,K,r,T,param);
				% 2) MC
				[PriceMC, check, IC] = PricingOptionMC( S0,r,T,K,param,Nsim,Nstep,...
					model,optionType);
				% 3) FFT
				[ priceFFT, check_marting ] = FFT(K, S0, T, r, model, param);
				% 4) PDE LogPrice implementation short
				[pricePDELogPrice] = FDLogPrice1( S0,K,r,T,N,M,param,optionType,NumMethod,theta);
				% 5) LogPrice implementation full
				[pricePDELogPrice2] = FDLogPrice2( S0,K,r,T,N,M,param,optionType,NumMethod,theta);
				% 6) PDE Price implementation short
				[pricePDEPrice] = FDPrice1( S0,K,r,T,N,M,param,optionType,NumMethod,theta);
				% 7) FEM LogPrice implementation short
				[pricePDE_FEM_LogPrice] = FEMLogPrice1( S0,K,r,T,N,M,param,optionType,NumMethod,theta);
				% this is ti check the implementation for Levy
				param = [0.6;0;0.1;0.1];model = 'Merton';
				[pricePIDEcheck] = FDLevyLogMoneyness1( S0,K,r,T,N,M,param,model,optionType,NumMethod,theta);
			case 'Merton'
				param = [0.5;0.6;0.1;0.1];
				% 1) MC
				[PriceMC, check, IC] = PricingOptionMC( S0,r,T,K,param,Nsim,Nstep,...
					model,optionType);
				% 3) FFT
				[ priceFFT, check_marting ] = FFT(K, S0, T, r, model, param);
				% 4) PIDE
				[pricePIDE] = FDLevyLogMoneyness1( S0,K,r,T,N,M,param,model,optionType,NumMethod,theta);
			case 'Kou'
				param = [0.6;0.01;9;6;0.3];
				% 1) MC
				[PriceMC, check, IC] = PricingOptionMC( S0,r,T,K,param,Nsim,Nstep,...
					model,optionType);
				% 3) FFT
				[ priceFFT, check_marting ] = FFT(K, S0, T, r, model, param);
				% 4) PIDE
				[pricePIDE] = FDLevyLogMoneyness1( S0,K,r,T,N,M,param,model,optionType,NumMethod,theta);
			case 'VG'
				param = [0.2;0.8];
				% 1) MC
				[PriceMC, check, IC] = PricingOptionMC( S0,r,T,K,param,Nsim,Nstep,...
					model,optionType);
				% 3) FFT
				[ priceFFT, check_marting ] = FFT(K, S0, T, r, model, param);
				% 4) PIDE logmonyness
				[pricePDElogmoneyness] = FDLevyLogMoneyness1AI( S0,K,r,T,N,M,param,model,optionType,NumMethod,theta,...
					epsilon);
			case 'VG2'
				param = [0.16;0.0694;0.0166];
				% 4) PIDE logmonyness
				[pricePDElogmoneyness] = FDLevyLogMoneyness1AI( S0,K,r,T,N,M,param,model,optionType,NumMethod,theta,...
					epsilon);
			case 'NIG'
				param = [0.2;0.8];
				% 1) MC
				[PriceMC, check, IC] = PricingOptionMC( S0,r,T,K,param,Nsim,Nstep,...
					model,optionType);
				% 3) FFT
				[ priceFFT, check_marting ] = FFT(K, S0, T, r, model, param);
				% 4) PIDE
			otherwise
		end
	case 'Put'
		switch model
			case 'BS'
				param = 0.6;
				% 1) closed formula
				[~, PriceExact] = blsprice(S0,K,r,T,param);
				% 2) MC
				[PriceMC, check, IC] = PricingOptionMC( S0,r,T,K,param,Nsim,Nstep,...
					model,optionType);
				% 3) FFT
				% call put parity
				% 4) PDE short implementation
				[pricePDELogPrice] = FDLogPrice1( S0,K,r,T,N,M,param,optionType,NumMethod,theta);
				% 5) PDE Price implementation short
				[pricePDEPrice] = FDPrice1( S0,K,r,T,N,M,param,optionType,NumMethod,theta);
				% 7) FEM LogPrice implementation short
				[pricePDE_FEM_LogPrice] = FEMLogPrice1( S0,K,r,T,N,M,param,optionType,NumMethod,theta);
			case 'Merton'
				param = [0.5;0.6;0.1;0.1];
				% 1) MC
				[PriceMC, check, IC] = PricingOptionMC( S0,r,T,K,param,Nsim,Nstep,...
					model,optionType);
				% 2) PIDE
				[pricePIDE] = FDLevyLogMoneyness1( S0,K,r,T,N,M,param,model,optionType,NumMethod,theta);
			case 'Kou'
				param = [0.6;0.01;9;6;0.3];
				% 1) MC
				[PriceMC, check, IC] = PricingOptionMC( S0,r,T,K,param,Nsim,Nstep,...
					model,optionType);
				% 2) PIDE
				[pricePIDE] = FDLevyLogMoneyness1( S0,K,r,T,N,M,param,model,optionType,NumMethod,theta);
			case 'VG'
				param = [0.2;0.8];
				% 1) MC
				[PriceMC, check, IC] = PricingOptionMC( S0,r,T,K,param,Nsim,Nstep,...
					model,optionType);
				% 2) PIDE logmoneyness
				[pricePDElogmoneyness] = FDLevyLogMoneyness1AI( S0,K,r,T,N,M,param,model,optionType,NumMethod,theta,...
					epsilon);
			case 'NIG'
				param = [0.2; 0.8];
				% 1) MC
				[PriceMC, check, IC] = PricingOptionMC( S0,r,T,K,param,Nsim,Nstep,...
					model,optionType);
			otherwise
		end
	otherwise
end