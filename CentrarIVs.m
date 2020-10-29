function IVset=CentrarIVs(RawIVset,circuit)
%%%funcion para centrar raw IVs a partir de un offset
%%%% Primeras versiones complicado que funcionen en todas las
%%%% circunstancias
if isfield(circuit,'ioffset')
    ioff=circuit.ioffset;
else
    ioff=0;
end
for i=1:length(RawIVset)
    if isfield(circuit,'voffset')
        voff=circuit.voffset;
    else
        [iaux,iii]=unique(RawIVset(i).ibias);
        vaux=RawIVset(i).vout(iii);
        [b,r]=within(iaux,ioff);
            if b
                iaux=iaux(r);
                vaux=vaux(r);
                voff=spline(iaux,vaux,ioff);
            else
                iaux=RawIVset(i).ibias(end-1:end);
                vaux=RawIVset(i).vout(end-1:end);
                voff=spline(iaux,vaux,ioff);
            end
    end

    IVset(i).ibias=RawIVset(i).ibias-ioff;
    IVset(i).vout=RawIVset(i).vout-voff;
    IVset(i).Tbath=RawIVset(i).Tbath;
end