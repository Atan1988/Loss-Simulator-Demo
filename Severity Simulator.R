### a flexible q function that returns values given quantile
d_generic <- function( x, distr, parvars) {
  d <- get(paste0("d", distr))
  parnames <- colnames(parvars)
  parvars <- as.vector(t(parvars[1, ]))
  
  args_inte <- setNames(append(list(x),  lapply(parvars, identity)), 
                        c("x", parnames))
  do.call(d, args = args_inte)
}

q_generic <- function(p, distr, parvars) {
  q <- get(paste0("q", distr))
  parnames <- colnames(parvars)
  parvars <- as.vector(t(parvars[1, ]))
  
  args_inte <- setNames(append(list(p),  lapply(parvars, identity)), 
                        c("p", parnames))
  do.call(q, args = args_inte)
}

severity_simulator <- function(acc_dt, p_sev, p_rpt_dt, p_pay_dt, Prob_0, Case_Res_trans, 
                               Prob_1, p_recovery_dt, p_adequecy, distr_sev = 'gamma', distr_rpt_dt = 'exp', 
                               distr_pay_dt = 'exp', distr_pay_adequecy = 'unif', distr_recovery_dt = 'exp', 
                               parvars_sev, parvars_rpt_dt, 
                               parvars_pay_dt, parvars_pay_adequecy, parvars_recovery_dt, 
                               sev_trend) {
  
   sev_vec <- q_generic(p_sev, distr = distr_sev, parvars = parvars_sev)
   
   rpt_dt_vec <- acc_dt + q_generic(p_rpt_dt, distr = distr_rpt_dt, parvars = parvars_rpt_dt)
   
   pay_dt_vec <- rpt_dt_vec + q_generic(p_pay_dt, distr = distr_pay_dt, parvars = parvars_pay_dt)
   
   liability_0_vec <- runif(length(acc_dt))
   
   liability_0_vec <- ifelse(liability_0_vec >= Prob_0, 1, 0)
   
   Y <- sev_vec * liability_0_vec * exp( as.numeric(pay_dt_vec -  acc_dt)/365.25 * sev_trend)
   
   liability_1_vec <- runif(length(acc_dt))
   
   liability_1_vec <- ifelse(liability_1_vec >= Prob_1, 1, 0)
   
   pay_adequecy_vec <- q_generic(p_adequecy, distr = distr_pay_adequecy , parvars = parvars_pay_adequecy)
   
   P <- ifelse(liability_1_vec == 0, Y, Y * pay_adequecy_vec)
   
   R <- Y - P
   
   recover_dt_vec <- pay_dt_vec + q_generic(p_recovery_dt, distr = distr_recovery_dt, parvars = parvars_recovery_dt)
   
   data.frame(Accident_Date = acc_dt, 
              Reported_Date = rpt_dt_vec, 
              Payment_Date = pay_dt_vec, 
              Payment = P, 
              Recovery = R, 
              Recovery_Date = recover_dt_vec)
}


# parm_list <- list(acc_dt = as.Date("2017-1-1") + sample(seq(1, 365, 1), size = 100, replace = T), 
#                   p_sev = runif(100), p_rpt_dt=runif(100), p_pay_dt=runif(100), Prob_0 = 0.25,
#                   Case_Res_trans = NULL,
#                   Prob_1 = 0.75, p_recovery_dt = runif(100), p_adequecy = runif(100),
#                   distr_sev = 'gamma', distr_rpt_dt = 'exp',
#                   distr_pay_dt = 'exp', distr_pay_adequecy = 'unif', distr_recovery_dt = 'exp',
#                   parvars_sev = data.frame(shape = 2, scale = 25000),
#                   parvars_rpt_dt = data.frame(rate = 1 / 250),
#                   parvars_pay_dt = data.frame(rate = 1 / 150),
#                   parvars_pay_adequecy=data.frame(min = 1, max = 2),
#                   parvars_recovery_dt = data.frame(rate = 1 / 100),
#                   sev_trend = 0)
# 
# do.call(severity_simulator, parm_list)

# gamma_sim <- severity_simulator(acc_dt = as.Date("2017-1-1") + sample(seq(1, 365, 1), size = 100, replace = T), 
#                                 p_sev = runif(100), p_rpt_dt=runif(100), p_pay_dt=runif(100), Prob_0 = 0.25, 
#                                 Case_Res_trans = NULL, 
#                                 Prob_1 = 0.75, p_recovery_dt = runif(100), p_adequecy = runif(100), 
#                                 distr_sev = 'gamma', distr_rpt_dt = 'exp', 
#                                 distr_pay_dt = 'exp', distr_pay_adequecy = 'unif', distr_recovery_dt = 'exp', 
#                                 parvars_sev = data.frame(shape = 2, scale = 25000), 
#                                 parvars_rpt_dt = data.frame(rate = 1 / 250), 
#                                 parvars_pay_dt = data.frame(rate = 1 / 150), 
#                                 parvars_pay_adequecy=data.frame(min = 1, max = 2), 
#                                 parvars_recovery_dt = data.frame(rate = 1 / 100), 
#                                 sev_trend = 0)