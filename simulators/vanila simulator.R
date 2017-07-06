quantile_simulator_vanila <- function(sz, accdt, Prob_0, Prob_1) {
  list( acc_dt = accdt + sample(seq(1, 365, 1), size = sz, replace = T),
        p_sev = runif(sz), 
        p_rpt_dt = runif(sz), 
        p_pay_dt = runif(sz), 
        Prob_0 = Prob_0,
        Case_Res_trans = NULL,
        Prob_1 = 0.75, 
        p_recovery_dt = runif(sz), 
        p_adequecy = runif(sz),
        sev_trend = 0
  )
}