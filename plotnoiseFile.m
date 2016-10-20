function [thres,expres]=plotnoiseFile(IVstr,p,circuit,ZTES)
%pinta ruido y compara con Irwin a partir de fichero

[noise,file]=loadnoise();

if iscell(file)
    N=length(file)
    for i=1:N        
        Ib=sscanf(file{i},'HP_noise_%duA*')*1e-6; %%%HP_noise para ZTES18.!!!
        OP=setTESOPfromIb(Ib,IVstr,p);
        ncols=max(ceil(N/3),1);
        subplot(ceil(N/ncols),ncols,i)
        hold off;%figure
        loglog(noise{i}(:,1),V2I(noise{i}(:,2),circuit.Rf),'r'),hold on,grid on,%%%for noise in Current
        
        auxnoise=plotnoise('irwin',ZTES,OP,circuit);hold on;
        
        %para pintar NEP.
         f=logspace(0,6);
%         %loglog(f,auxnoise.sI),hold on
         sIaux=ppval(spline(f,auxnoise.sI),noise{i}(:,1));
         NEP=(V2I(noise{i}(:,2),circuit.Rf)-3e-12)./sIaux;
%         loglog(noise{i}(:,1),NEP,'r'),hold on,grid on,%%%for noise in Power
        
        %%resolucion experimental o teorica. Devolver un parametro u otro.
        expres(1,i)=OP.R0/ZTES.Rn;    
        RES=2.35/sqrt(trapz(noise{i}(:,1),1./NEP.^2))/2/1.609e-19;
        expres(2,i)=RES;
        thres(1,i)=OP.R0/ZTES.Rn;
        thres(2,i)=auxnoise.Res;
        set(gca,'xlim',[100 1e5]);
        %set(gca,'ylim',[1e-11 1e-9]);
        %set(gca,'ylim',[1e-18 1e-16]);
    end
else
    Ib=sscanf(file,'HP_noise_%duA*')*1e-6;
    OP=setTESOPfromIb(Ib,IVstr,p);

    hold off;%figure
    %loglog(noise(:,1),V2I(noise(:,2),circuit.Rf),'r'),hold on,grid on,%%%for noise in Current
    loglog(noise(:,1),V2I(noise(:,2),circuit.Rf).*OP.V0,'r'),hold on,grid on,%%%for noise in Power
    plotnoise('irwin',ZTES,OP,circuit)
end


