function N=SnoiseModel(circuit, Tbath)
%%%Funci�n para devolver el modelo de ruido total en estado normal o
%%%superconductor en unidades de A/sqrt(Hz).
Kb=1.38e-23;

invMin=circuit.invMin;
invMf=circuit.invMf;
Rf=circuit.Rf;
RL=circuit.Rsh+circuit.Rpar;

if isfield(circuit,'squid')
    i_squid=circuit.squid;
else
    i_squid=3e-12;
end

tau=circuit.L/RL;
f=logspace(0,6,1000);
w=2*pi*f;

Tc=0;
Rtes=0; %TES estado superconductor.
Ttes=max(Tbath,Tc);

Zcirc=RL+Rtes+1i*w*circuit.L;% impedancia del circuito.
v2_sh=4*Kb*Tbath*RL; % ruido voltaje Rsh (mas parasita).
v2_tes=4*Kb*Ttes*Rtes;%ruido voltaje en el TES en estado superconductor. En realidad es cero, lo pongo as� por mantener la misma estructura del ruido en estado normal.
i_jo=sqrt(v2_sh+v2_tes)./abs(Zcirc);

%(Rf*invMf/invMin) factor para convertir en Voltaje.
%i_jo=sqrt(4*Kb*Tbath/RL)./sqrt(1+(tau*w).^2);

N=sqrt(i_jo.^2+i_squid^2);