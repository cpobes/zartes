function P=FitZset(IVset,circuit,TES,TFS,varargin)
%%%Ajuste autom�tico de Z(w) para varias temperaturas de ba�o

%%%definimos variables necesarias.
Rsh=circuit.Rsh;
Rpar=circuit.Rpar;
L=circuit.L;
fS=TFS.f;

%%%si no pasamos files busca todos los directorios del tipo xxxmK
if nargin==4
    f=ls;
    [i,j]=size(f);
    fc=mat2cell(f,ones(1,i),j);
    dirs=regexp(fc,'^\d+mK','match');
    dirs=dirs(~cellfun('isempty',dirs))
    for i=1:length(dirs) dirs{i}=char(dirs{i}),end
    
    for i=1:length(dirs),aux(i)=sscanf(dirs{i},'%d');end
    aux=sort(aux);
    for i=1:length(aux) dirs{i}=strcat(num2str(aux(i)),'mK'),end
elseif nargin==5
    t=varargin{1};
    for i=1:length(t) dirs{i}=strcat(num2str(t(i)),'mK');end
end

dirs
pause(1)
for i=1:length(dirs)
    %%%buscamos los ficheros a analizar en cada directorio.
    d=pwd;
    %dirs{i},pause(1)
%    files=ls(strcat(d,'\',dirs{i}));
    
%%%devolvemos los ficheros en orden de fecha. Pero ojo si se pierde esa
%%%info. Creo ListInBiasOrder para que se listen siempre en orden de
%%%corriente.
    %D=dir(strcat(d,'\',dirs{i},'\TF*'));
    D=strcat(d,'\',dirs{i},'\TF*');
%     [~,s2]=sort([D(:).datenum]',1,'descend');
%     filesZ={D(s2).name}%%%ficheros en orden de %Rn!!!
    filesZ=ListInBiasOrder(D);
    %D=dir(strcat(d,'\',dirs{i},'\HP*'));
    D=strcat(d,'\',dirs{i},'\HP*');
%     [~,s2]=sort([D(:).datenum]',1,'descend');
%     filesNoise={D(s2).name}%%%ficheros en orden de %Rn!!!
    filesNoise=ListInBiasOrder(D);
    
%     [ii,jj]=size(files);
%     filesc=mat2cell(files,ones(1,ii),jj);
%     filesZ=regexp(filesc,'^TF_-?\d+.?\d+uA','match');
%     filesZ=filesZ(~cellfun('isempty',filesZ))
%     filesNoise=regexp(filesc,'^HP_noise_-?\d+.?\d+uA','match');
%     filesNoise=filesNoise(~cellfun('isempty',filesNoise));
%     %length(filesNoise)
%     for ii=1:length(filesZ) 
%         filesZ{ii}=char(filesZ{ii});
%         if ~isempty(filesNoise)filesNoise{ii}=char(filesNoise{ii});end
%     end
%     %filesc
    
    %%%buscamos la IV correspondiente a la Tmc dada
    Tbath=sscanf(dirs{i},'%dmK');
    %Tind=[IVset.Tbath]*1e3==Tbath;
    [~,Tind]=min(abs([IVset.Tbath]*1e3-Tbath));%%%En general Tbath de la IVsest tiene que ser exactamente la misma que la del directorio, pero en algun run he puesto el valor 'real'.(ZTES20)
    IV=IVset(Tind);
    
    %%%hacemos loop en cada fichero a analizar.

    for jj=1:length(filesZ)
        thefile=strcat(d,'\',dirs{i},'\',filesZ{jj}); %%%quito '.txt' respecto a version anterior. 
        if ~isempty(filesNoise) thenoisefile=strcat(d,'\',dirs{i},'\',filesNoise{jj}); end%%%quito'.txt'
        offset=0;%-9e-6;
        Ib=sscanf(char(regexp(thefile,'-?\d+.?\d+uA','match')),'%fuA')*1e-6+offset
        
        %%%importamos la TF
            data=importdata(thefile);%size(data)
            tf=data(:,2)+1i*data(:,3);
            Rth=Rsh+Rpar+2*pi*L*data(:,1)*1i;
            ztes=(TFS.tf./tf-1).*Rth;
            
%             Cp=100e-12;
%             Zth=Rsh./(1+2*pi*Cp*data(:,1)*1i*Rsh)+Rpar+2*pi*L*data(:,1)*1i;
%             ztes=(TFS.tf./tf-1).*Zth;
            
            %plot(ztes,'.'),hold on
            %size(ztes)
        %%%valores iniciales del fit
            Zinf=real(ztes(end));
            Z0=real(ztes(1));
            Y0=real(1./ztes(1));
            tau0=1e-4;
            feff0=1e2;
            
         %%%Hacemos el ajuste a Z(w)
            %p0=[Zinf Z0 tau0];
            p0=[Zinf Z0 tau0 1e-3 1e-6];%%%p0 for 2 block model.
            pinv0=[Zinf 1/Y0 tau0];
             [p,aux1,aux2,aux3,out]=lsqcurvefit(@fitZ,p0,fS,[real(ztes) imag(ztes)]);%%%uncomment for real parameters.
                %[p,aux1,aux2,aux3,out]=lsqcurvefit(@fitZ,pinv0,fS,[real(1./zt{i}) imag(1./zt{i})]);%%%uncomment for inverse Ztes fit.
            %[p,aux1,aux2,aux3,out]=lsqcurvefit(@fitReZ,p0,fS,[real(ztes)],[0 -Inf 0],[1 Inf 1]);%%%uncomment for real part only.
                %[p,aux1,aux2,aux3,out]=lsqcurvefit(@fitZ,p0,fS,zt{i});%%%uncommetn for complex parameters
                %p=[p(1) 1/p(2) 1/p(3)];%solo para 1/Ztesvfits.                
         
         %%%Extraemos los par�metros del ajuste.
         
            param=GetModelParameters(p,IV,Ib,TES,circuit);
            resN=aux1;
            P(i).p(jj)=param;
            P(i).residuo(jj)=resN;
            
         %%%Analizamos el ruido
         if ~isempty(filesNoise)
            [noisedata,file]=loadnoise(0,dirs{i},filesNoise{jj});%%%quito '.txt'
            OP=setTESOPfromIb(Ib,IV,param);
            noiseIrwin=noisesim('irwin',TES,OP,circuit);
            noiseIrwin.squid=3e-12;
            %size(noisedata),size(noiseIrwin.sum)
            f=logspace(0,6,1000);
            sIaux=ppval(spline(f,noiseIrwin.sI),noisedata{1}(:,1));
            NEP=(V2I(noisedata{1}(:,2),circuit.Rf)-noiseIrwin.squid)./sIaux;
            RES=2.35/sqrt(trapz(noisedata{1}(:,1),1./NEP.^2))/2/1.609e-19;
            P(i).ExRes(jj)=RES;
            P(i).ThRes(jj)=noiseIrwin.Res;
            
            %%%Excess noise trials.
            findx=find(noisedata{1}(:,1)>1e2);
            xdata=noisedata{1}(findx,1);
            ydata=V2I(noisedata{1}(findx,2)-noiseIrwin.squid,circuit.Rf);
            %size(ydata)
            P(i).M(jj).M=lsqcurvefit(@(x,xdata) fitnoise(x,xdata,TES,OP,circuit),0,xdata,ydata);
%         ns=ppval(spline(f,noiseIrwin.sum),noisedata{1}(:,1));
%         excess(:,1)=noisedata{1}(:,1);
%         excess(:,2)=V2I(noisedata{1}(:,2),circuit.Rf)-noiseIrwin.squid-ns;
%         excess;
%         P(i).exnoise{jj}=excess;
         end         
    end
        %%%Pasamos ExRes y ThRes dentro de P.p
        if ~isempty(filesNoise)
        for jj=1:length(filesZ) P(i).p(jj).ExRes=P(i).ExRes(jj);P(i).p(jj).ThRes=P(i).ThRes(jj);end
        end
        P(i).Tbath=Tbath*1e-3;%%%se lee en mK
end
if ~isempty(filesNoise) P=rmfield(P,{'ExRes','ThRes'});end
    
