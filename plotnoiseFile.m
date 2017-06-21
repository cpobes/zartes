function si0=plotnoiseFile(IVset,P,circuit,ZTES,varargin)
%pinta ruido y compara con Irwin a partir de fichero
%V170112. IVstr es la estructura a la temperatura de interés, y p es la
%estructura de parámetros también a esa temepratura.

%v170113. Paso ya el IVset completo y P completo.

%v170621. Puedo pasar estructura con opciones de pintado.

% wdir=strcat(num2str(IVstr.Tbath*1e3),'mK');
% if nargin>4
%     %wdir=varargin{1};
%     wfiles=varargin{1};
%     [noise,file]=loadnoise(0,wdir,wfiles);
% else
%     %%%listar ficheros
%     d=pwd;
%     strcat(d,'\',wdir)
%     D=dir(strcat(d,'\',wdir,'\HP*'));
%     [~,s2]=sort([D(:).datenum]',1,'descend');
%     filesNoise={D(s2).name}%%%ficheros en orden de %Rn!!!
% 
%     [noise,file]=loadnoise(0,wdir,filesNoise);
% end

    option.tipo='current';
    option.boolcomponents=0;
    option.Mph=0;
    option.Mjo=0;
    
if nargin==4
    [noise,file,path]=loadnoise();
    %%%buscamos la IV y P correspondientes a la Tbath dada
    path
    Tbath=sscanf(char(regexp(path,'\d*mK','match')),'%dmK');
    [~,Tind]=min(abs([IVset.Tbath]*1e3-Tbath));%%%En general Tbath de la IVsest tiene que ser exactamente la misma que la del directorio, pero en algun run he puesto el valor 'real'.(ZTES20)
    IVstr=IVset(Tind);
    [~,Tind]=min(abs([P.Tbath]*1e3-Tbath));
    p=P(Tind).p;
end
if nargin==5
    if isstruct(varargin{1})
        option=varargin{1};
            [noise,file,path]=loadnoise();
            %%%buscamos la IV y P correspondientes a la Tbath dada
            path
            Tbath=sscanf(char(regexp(path,'\d*mK','match')),'%dmK');
            [~,Tind]=min(abs([IVset.Tbath]*1e3-Tbath));%%%En general Tbath de la IVsest tiene que ser exactamente la misma que la del directorio, pero en algun run he puesto el valor 'real'.(ZTES20)
            IVstr=IVset(Tind);
            [~,Tind]=min(abs([P.Tbath]*1e3-Tbath));
            p=P(Tind).p;
    else
    wdir=varargin{1};
    d=pwd;
%     D=dir(strcat(d,'\',wdir,'\HP*'));
%     [~,s2]=sort([D(:).datenum]',1,'descend');
%     filesNoise={D(s2).name}%%%ficheros en orden de %Rn!!!
    filesNoise=ListInBiasOrder(strcat(wdir,'\HP*'),'ascend')
    [noise,file]=loadnoise(0,wdir,filesNoise);
    Tbath=sscanf(wdir,'%dmK');
    [~,Tind]=min(abs([IVset.Tbath]*1e3-Tbath));%%%En general Tbath de la IVsest tiene que ser exactamente la misma que la del directorio, pero en algun run he puesto el valor 'real'.(ZTES20)
    IVstr=IVset(Tind);
    [~,Tind]=min(abs([P.Tbath]*1e3-Tbath));
    p=P(Tind).p;
    end
end
if nargin==6     
    if isstruct(varargin{2})
        option=varargin{2};
        wdir=varargin{1};
        d=pwd;
        %     D=dir(strcat(d,'\',wdir,'\HP*'));
        %     [~,s2]=sort([D(:).datenum]',1,'descend');
        %     filesNoise={D(s2).name}%%%ficheros en orden de %Rn!!!
        filesNoise=ListInBiasOrder(strcat(wdir,'\HP*'),'ascend')
        [noise,file]=loadnoise(0,wdir,filesNoise);
        Tbath=sscanf(wdir,'%dmK');
        [~,Tind]=min(abs([IVset.Tbath]*1e3-Tbath));%%%En general Tbath de la IVsest tiene que ser exactamente la misma que la del directorio, pero en algun run he puesto el valor 'real'.(ZTES20)
        IVstr=IVset(Tind);
        [~,Tind]=min(abs([P.Tbath]*1e3-Tbath));
        p=P(Tind).p;
    else
    wdir=varargin{1};
    wfiles=varargin{2};
   [noise,file]=loadnoise(0,wdir,wfiles);
      Tbath=sscanf(wdir,'%dmK');
    [~,Tind]=min(abs([IVset.Tbath]*1e3-Tbath));%%%En general Tbath de la IVsest tiene que ser exactamente la misma que la del directorio, pero en algun run he puesto el valor 'real'.(ZTES20)
    IVstr=IVset(Tind);
    [~,Tind]=min(abs([P.Tbath]*1e3-Tbath));
    p=P(Tind).p;
    end
end 
if nargin==7
    wdir=varargin{1};
    wfiles=varargin{2};
    option=varargin{3};
   [noise,file]=loadnoise(0,wdir,wfiles);
      Tbath=sscanf(wdir,'%dmK');
    [~,Tind]=min(abs([IVset.Tbath]*1e3-Tbath));%%%En general Tbath de la IVsest tiene que ser exactamente la misma que la del directorio, pero en algun run he puesto el valor 'real'.(ZTES20)
    IVstr=IVset(Tind);
    [~,Tind]=min(abs([P.Tbath]*1e3-Tbath));
    p=P(Tind).p;
end

% [IVstr.Tbath]
% [P(Tind).Tbath]

%tipo='current';%%% 'NEP' or 'current'
%tipo='NEP';
tipo=option.tipo;
boolcomponents=option.boolcomponents;%%%%para pintar o no las componentes
Mph=option.Mph;
Mjo=option.Mjo;

if ~iscell(file) file={file};end
if iscell(file)
    N=length(file)
    
    for i=1:N        
        i
        Ib=sscanf(file{i},'HP_noise_%duA*')*1e-6 %%%HP_noise para ZTES18.!!!
        OP=setTESOPfromIb(Ib,IVstr,p);
        %%OP.Tbath=1.5*OP.Tbath;%%%effect of Tbath error.Despreciable.
        nrows=3;
        ncols=max(ceil(N/nrows),1);
        subplot(ceil(N/ncols),ncols,i);
        hold off;%figure
        
        %%ZTES.Tc=1.3*ZTES.Tc;%%effect of Tc error.
        %auxnoise=plotnoise('irwin',ZTES,OP,circuit,0);hold on;%%%quinto argumento 'M'.
        
        if Mjo==1
            M=OP.M;
        else
            M=0;
        end
        
        auxnoise=noisesim('irwin',ZTES,OP,circuit,M);
        f=logspace(0,6,1000);
        si0(i)=auxnoise.sI(1);
        
            if(strcmp(tipo,'current'))
                
                loglog(noise{i}(:,1),V2I(noise{i}(:,2)*1e12,circuit.Rf),'.-r'),hold on,grid on,%%%for noise in Current.  Multiplico 1e12 para pA/sqrt(Hz)!Ojo, tb en plotnoise!
                if Mph==0
                    totnoise=sqrt(auxnoise.sum.^2+auxnoise.squidarray.^2);
                else
                    totnoise=sqrt(auxnoise.max.^2+auxnoise.jo.^2+auxnoise.sh.^2+auxnoise.squidarray.^2);
                end
                %%%normalization test
                %ind=find(noise{i}(:,1)>100&noise{i}(:,1)<1000);
                %loglog(noise{i}(:,1),noise{i}(:,2)/median(noise{i}(ind,2)),'.-r'),hold on,grid on,%%%for noise in Current.  Multiplico 1e12 para pA/sqrt(Hz)!Ojo, tb en plotnoise!
                %totnoise=sqrt(auxnoise.sum.^2+auxnoise.squidarray.^2)/auxnoise.sI(1);
                
                %totnoise=sqrt(auxnoise.max.^2+auxnoise.jo.^2+auxnoise.sh.^2+auxnoise.squidarray.^2);%%%To make F=1;

                if ~boolcomponents
                    %loglog(f,totnoise/totnoise(1));%%para pintar normalizados.
                    loglog(f,totnoise*1e12,'b');
                    h=findobj(gca,'color','b');
                    %legend({'Experimental','STM'})
                    
                else
                    loglog(f,auxnoise.jo*1e12,f,auxnoise.ph*1e12,f,auxnoise.sh*1e12,f,totnoise*1e12);
                    legend('experimental','jhonson','phonon','shunt','total')
                    h=findobj(gca,'displayname','total');
                end
                ylabel('pA/Hz^{0.5}','fontsize',12,'fontweight','bold')
                
            elseif (strcmp(tipo,'NEP'))
                
                sIaux=ppval(spline(f,auxnoise.sI),noise{i}(:,1));
                NEP=sqrt((V2I(noise{i}(:,2),circuit.Rf).^2-auxnoise.squid.^2))./sIaux;
                loglog(noise{i}(:,1),NEP*1e18,'.-r'),hold on,grid on,
                    if Mph==0
                        totNEP=auxnoise.NEP;
                    else
                        totNEP=sqrt(auxnoise.max.^2+auxnoise.jo.^2+auxnoise.sh.^2)./auxnoise.sI;
                    end
                if ~boolcomponents
                    loglog(f,totNEP*1e18,'b');hold on;grid on;
                    h=findobj(gca,'color','b');
                else
                    loglog(f,auxnoise.jo*1e18./auxnoise.sI,f,auxnoise.ph*1e18./auxnoise.sI,f,auxnoise.sh*1e18./auxnoise.sI,f,totNEP*1e18);
                    legend('experimental','jhonson','phonon','shunt','total');
                    h=findobj(gca,'displayname','total');
                end
               ylabel('aW/Hz^{0.5}','fontsize',12,'fontweight','bold')
            end
            xlabel('\nu(Hz)','fontsize',12,'fontweight','bold')
            
            
        axis([10 1e5 1 1e4])
        %h=get(gca,'children')
        set(h(1),'linewidth',3);
        set(gca,'fontsize',11);
        set(gca,'linewidth',2)
        set(gca,'XMinorGrid','off','YMinorGrid','off','GridLineStyle','-')
        title(strcat(num2str(round(OP.r0*100)),'%Rn'),'fontsize',12);
         
         %%%obsolet0.
         if(0)
         sIaux=ppval(spline(f,auxnoise.sI),noise{i}(:,1));
         NEP=sqrt((V2I(noise{i}(:,2),circuit.Rf).^2-auxnoise.squid.^2))./sIaux;
         %figure
            loglog(noise{i}(:,1),NEP*1e18,'r'),hold on,grid on,%%%for noise in Power
         %   loglog(f,auxnoise.NEP*1e18,'b'),hold on,grid on,%%%for noise in Power
        
         %%resolucion experimental o teorica. Devolver un parametro u otro.
         expres(1,i)=OP.R0/ZTES.Rn;
         RES=2.35/sqrt(trapz(noise{i}(:,1),1./NEP.^2))/2/1.609e-19;
         expres(2,i)=RES;
         thres(1,i)=OP.R0/ZTES.Rn;
         thres(2,i)=auxnoise.Res;
         end
         
        %set(gca,'xlim',[100 1e5]);
        %set(gca,'ylim',[1e-11 1e-9]);
        %set(gca,'ylim',[1e-18 1e-16]);
        
        %%%Salvar la figura 
        fi=strcat('-f',num2str(gcf));
        name=strcat('figs\Noise',num2str(Tbath),'mK');
        print(fi,name,'-dpng','-r0')
         
    end
else
    Ib=sscanf(file,'HP_noise_%duA*')*1e-6;
    OP=setTESOPfromIb(Ib,IVstr,p);

    hold off;%figure
    %loglog(noise(:,1),V2I(noise(:,2),circuit.Rf),'r'),hold on,grid on,%%%for noise in Current
    loglog(noise(:,1),V2I(noise(:,2),circuit.Rf).*OP.V0,'r'),hold on,grid on,%%%for noise in Power
    plotnoise('irwin',ZTES,OP,circuit)
end


