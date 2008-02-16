function set_all_parameters(xparam1)

% function set_all_parameters(xparam1)
% Sets parameters value 
% 
% INPUTS
%    xparam1:   vector of parameters to be estimated (initial values)
%    
% OUTPUTS
%    none
%        
% SPECIAL REQUIREMENTS
%    none
%  
% part of DYNARE, copyright Dynare Team (2003-2008)
% Gnu Public License.

  global estim_params_ M_
  
  nvx = estim_params_.nvx;
  ncx = estim_params_.ncx;
  nvn = estim_params_.nvn;
  ncn = estim_params_.ncn;
  np = estim_params_.np;
  Sigma_e = M_.Sigma_e;
  H = M_.H;
  
  % setting shocks variance
  if nvx
    var_exo = estim_params_.var_exo;
    for i=1:nvx
      k =var_exo(i,1);
      Sigma_e(k,k) = xparam1(i)^2;
    end
  end
  % update offset
  offset = nvx
  
  % setting measument error variance
  if nvn
    var_endo = estim_params_.var_endo;
    for i=1:nvn
      k = var_endo(i,1);
      H(k,k) = xparam1(i+offset)^2;
    end
  end
  
  % update offset
  offset = nvx+nvn;
  
  % setting shocks covariances
  if ncx
    corrx = estim_params_.corrx;
    for i=1:ncx
      k1 = corrx(i,1);
      k2 = corrx(i,2);
      Sigma_e(k1,k2) = xparam1(i+offset)*sqrt(Sigma_e(k1,k1)*Sigma_e(k2,k2));
      Sigma_e(k2,k1) = Sigma_e(k1,k2);
    end
  end
  
  % update offset
    offset = nvx+nvn+ncx;
  % setting measurement error covariances
  if ncn
    corrn = estim_params_.corrn;
    for i=1:ncn
      k1 = corr(i,1);
      k2 = corr(i,2);
      H(k1,k2) = xparam1(i+offset)*sqrt(H(k1,k1)*H(k2,k2));
      H(k2,k1) = H(k1,k2);
    end
  end
  
  % update offset
  offset = nvx+ncx+nvn+ncn;
  % setting structural parameters
  %
  if np
    M_.params(estim_params_.param_vals(:,1)) = xparam1(offset+1:end);
  end
  
  % updating matrices in M_
  if nvx
    M_.Sigma_e = Sigma_e;
  end
  if nvn
    M_.H = H;
  end
