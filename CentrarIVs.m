function IVset=CentrarIVs(RawIVset,circuit)
%%%funcion para centrar raw IVs a partir de un offset

if isfield(circuit,'ioffset')
    ioff=circuit.ioffset;
else
    ioff=0;
end
for i=1:length(RawIVset)
    %ind=find(abs(RawIVset(i).ibias)<10);%%%seleccionamos el rango de corrietnes cercano a 0.
    ind=find(sign(RawIVset(i).ibias(1))*(RawIVset(i).ibias)<0);%%%seleccionamos los puntos que pasan al otro lado.
    if isfield(circuit,'voffset')
        voff=circuit.voffset;
    else
        voff=nan;
    end
    [iaux,iii]=unique(RawIVset(i).ibias(ind));
    vaux=RawIVset(i).vout(ind);
    vaux=vaux(iii);
        if isnan(voff)
        %voff=spline(iaux,vaux,ioff);
        ff=fit(iaux,vaux,fittype('poly1')); %%%El spline vale si el punto est� dentro del rango de ajuste.
        voff=ff(ioff);
        end
    IVset(i).ibias=RawIVset(i).ibias-ioff;
    IVset(i).vout=RawIVset(i).vout-voff;
    IVset(i).Tbath=RawIVset(i).Tbath;
end