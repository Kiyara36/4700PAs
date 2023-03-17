 Is = 0.01e-12; %A
 Ib = 0.1e-12; %A
 Vb = 1.3; %V
 Gp = 0.1; %Mho
 
 V = linspace(-1.95,0.7,200);
 I_gen = Is*(exp(V*1.2/0.025) - 1) + Gp*V - Ib*(exp(-(V+Vb)*1.2/0.025) - 1); % generated current data
 noise = I_gen.*0.2.*randn(1,200);
 I_gen_noise = I_gen + noise; % generated current data with added noise
 
 % Create a polynomial fit to the data
 % 4th-order
 
 fourthOFit = polyfit(V, I_gen_noise, 4);
 I_fourthO = polyval(fourthOFit,V);
 
 % 8th-order
 
 eigthOFit = polyfit(V, I_gen_noise, 8);
 I_eigthO = polyval(eigthOFit,V);
 
 % Plots of noisy generated current data and polynomial fits
 figure(1)
 
 subplot(2,1,1); plot(V, I_gen_noise);
 hold on
 plot(V, I_fourthO)
 plot(V, I_eigthO)
 hold off
 title('Diode I-V Curve')
 xlabel('Voltage')
 ylabel('Current')
 legend('Generated Data','4th-Order Fit','8th-Order Fit')
 
 subplot(2,1,2); semilogy(V, abs(I_gen_noise));
 hold on
 semilogy(V, abs(I_fourthO))
 semilogy(V, abs(I_eigthO))
 hold off
 xlabel('Voltage')
 ylabel('Logarithmic Absolute Current')
 legend('Generated Data','4th-Order Fit','8th-Order Fit')
 
 % Create non-linear fit to the data
 
 % Two unknown param
 fo_1 = fittype('A.*(exp(1.2*x/25e-3)-1) + 0.1.*x - C*(exp(1.2*(-(x+1.3))/25e-3)-1)');
 ff_1 = fit(V',I_gen_noise',fo_1);
 If_1 = ff_1(V);
 
 % Three unknown param
 fo_2 = fittype('A.*(exp(1.2*x/25e-3)-1) + B.*x - C*(exp(1.2*(-(x+1.3))/25e-3)-1)');
 ff_2 = fit(V',I_gen_noise',fo_2);
 If_2 = ff_2(V);
 
 % Four unknown param
 fo_3 = fittype('A.*(exp(1.2*x/25e-3)-1) + B.*x - C*(exp(1.2*(-(x+D))/25e-3)-1)');
 ff_3 = fit(V',I_gen_noise',fo_3);
 If_3 = ff_3(V);
 
 % Plots of noisy data and nonlinear fitted data
 figure(2)
 
 subplot(2,1,1); plot(V, I_gen_noise);
 hold on
 plot(V, If_1)
 plot(V, If_2)
 plot(V, If_3)
 hold off
 title('Diode I-V Curve')
 xlabel('Voltage')
 ylabel('Current')
 legend('Generated Data','Two Unkown Parameters','Three Unkown Parameters', 'Four Unkown Parameters')
 
 subplot(2,1,2); semilogy(V, abs(I_gen_noise));
 hold on
 semilogy(V, abs(If_1))
 semilogy(V, abs(If_2))
 semilogy(V, abs(If_3))
 hold off
 xlabel('Voltage')
 ylabel('Logarithmic Absolute Current')
 legend('Generated Data','Two Unkown Parameters','Three Unkown Parameters', 'Four Unkown Parameters')
 
 % Use a neural net model
 
 inputs = V.';
 targets = I_gen_noise.';
 hiddenLayerSize = 10;
 net = fitnet(hiddenLayerSize);
 net.divideParam.trainRatio = 70/100;
 net.divideParam.valRatio = 15/100;
 net.divideParam.testRatio = 15/100;
 [net,tr] = train(net,inputs,targets);
 outputs = net(inputs);
 errors = gsubtract(outputs,targets);
 performance = perform(net,targets,outputs);
 view(net)
 Inn = outputs;
 
 figure(3)
 
 subplot(2,1,1); plot(V, I_gen_noise);
 hold on
 plot(V, Inn, '--')
 hold off
 title('Diode I-V Curve')
 xlabel('Voltage')
 ylabel('Current')
 legend('Generated Data','Neural Net')
 
 subplot(2,1,2); semilogy(V, abs(I_gen_noise));
 hold on
 semilogy(V, abs(Inn), '--')
 hold off
 xlabel('Voltage')
 ylabel('Logarithmic Absolute Current')
 legend('Generated Data','Neural Net')