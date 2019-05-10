function xd = ipdynamics(x, u)
%IPDYNAMICS Inverted pendulum dynamics
%   XD = IPDYNAMICS(X, U) returns the state vector derivative given a
%   current state X = [THETA, DTHETA] and action U = [MOTOR_VOLTAGE]
%
%   AUTHOR:
%      Wouter Caarls <wouter@caarls.org>

  J_ = 0.000191;
  m_ = 0.055;
  g_ = 9.81;
  l_ = 0.042;
  b_ = 0.000003;
  K_ = 0.0536;
  R_ = 9.5;
  
  u = min(max(u, -3), 3);

  a = x(1);
  ad = x(2);
  add = (1/J_)*(m_*g_*l_*sin(a)-b_*ad-(K_*K_/R_)*ad+(K_/R_)*u);

  xd = x;
  xd(1) = ad;
  xd(2) = add;
  
end
