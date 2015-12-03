function showIVsims(Ttes,Ites,Ib,TESparam)

Rsh=TESparam.Rsh;Rpar=TESparam.Rpar;Rn=TESparam.Rn;
Ic=TESparam.Ic;Tc=TESparam.Tc;

%Vtes=Ib*Rsh-Ites*(Rsh+Rpar);
Rtes=Rn*FtesTI(Ttes/Tc,Ites/Ic);
Vtes=Ites.*Rtes;
Ptes=Ites.*Vtes;
%Rtes=Vtes./Ites;
rtes=Rtes/Rn;
%rtes=FtesTI(ttes,ites);
ites=Ites/Ic;
ttes=Ttes/Tc;
%subplot(1,2,1) 
%
Rf=7e3;%ojo, este parametro puede cambiar.
Vout=Ites*Rf*66/22;%
subplot(2,4,1);plot(Ib,Vout,'.-'),grid on%,hold on
xlabel('Ibias(A)');ylabel('Vout(V)');
subplot(2,4,5);plot(Vtes,Ites,'.-'),grid on%,hold on
xlabel('Vtes(V)');ylabel('Ites(A)');
subplot(2,4,2);plot(Vtes,Ptes,'.-'),grid on%,hold on
xlabel('Vtes(V)');ylabel('Ptes(W)');
subplot(2,4,6);plot(rtes,Ptes,'.-'),grid on%,hold on
xlabel('Rtes(%)');ylabel('Ptes(W)');

Trange=[0:1e-2:1.5];Irange=[0:1e-2:1.5];
[X,Y]=meshgrid(Trange,Irange);
TESparam=SetOP(X*Tc,Y*Ic,TESparam);
stab=StabilityCheck(TESparam);

subplot(1,2,2)
%contourf(X,Y,FtesTI(X,Y));
contourf(X*Tc,Y*Ic,TESparam.R0/Rn);
hold on

colormap gray
colormap(flipud(colormap))
alpha(0.1)
%contourf(Trange,Irange,~stab.stab);
contourf(X*Tc,Y*Ic,~stab.stab);
colormap cool
%plot3(ttes,ites,rtes,'.r','markersize',15)
plot3(Ttes,Ites,rtes,'.y','markersize',15)
%Tb=min(Ttes);%ojo, Ttes(1) no vale para barrido en bajada.
Tb=Ttes(Ites==0);
plotNSslopes(Tb,TESparam)
hold off

