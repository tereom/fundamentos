// Ejemplo de estimación del máximo de uniforme
data {
  int n; // número de observaciones
  int y[n]; //número de preguntas correctas
}


parameters {
  real<lower=0, upper=1> theta_azar;
  real<lower=0, upper=1> theta_corr;
}

model {
  // inicial
  theta_azar ~ beta(1, 1);
  theta_corr ~ beta(1, 1);
  // en este caso, agregamos términos directamente a la log posterior
  for(i in 1:n){
    target+= log_sum_exp(
      log(theta_azar) + binomial_lpmf(y[i] | 10, 0.20),
      log(1 - theta_azar) + binomial_lpmf(y[i] | 10, theta_corr));
  }
}

