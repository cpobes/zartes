function AnalizedData=AnalizeRun(analizeOptions)
%%%%%Funci�n para lanzar un an�lisis autom�tico sobre un RUN completo desde
%%%%%cualquier directorio de an�lisis. Podemos pasar como argumento s�lo el
%%%%%datadir (path al run a analizar) y coger� opciones por defecto, o
%%%%%pasar una estructura con las opciones de an�lisis, donde el datadir es
%%%%%obligatorio y el resto si no est�n, se cogen por defecto.

olddir=pwd;
if ischar(analizeOptions)
    datadir=analizeOptions;
else
    datadir=analizeOptions.datadir;
end

if isfield(analizeOptions,'PTrange')
    PTrange=analizeOptions.PTrange;
else
    PTrange=[0.05:0.01:0.9];
end

if isfield(analizeOptions,'PTmodel')
    PTmodel=analizeOptions.PTmodel;
else
    PTmodel=BuildPTbModel('GTcdirect'); %%%Definimos el modelo para el fit.
end

if isfield(analizeOptions,'RpTES')
    RpTES=analizeOptions.RpTES;
else
    RpTES=0.75;
end

if isfield(analizeOptions,'Tmax')
    Tmax=analizeOptions.Tmax;%%%Pasamos la temperatura m�xima para hacer el fit de las IVs. Esto hay que mirarlo a mano, pero una vez hecho la primera vez, queda para otros analisis.
else
    Tmax=1;
end

if isfield(analizeOptions,'ZfitOpt')
    ZfitOpt=analizeOptions.ZfitOpt;
else
    ZfitOpt.TFdata='HP';
    ZfitOpt.Noisedata='HP';
    ZfitOpt.f_ind=[1 1e5];%%%[fmin fmax] De momento no admite un rango arbitrario.
    %%%En realidad puede ser una matriz con f_ind(1,:)=[fmin1 fmax1],
    %%%f_ind(2,:)=[fmin2 fmax2], etc.
    %ZfitOpt.Temps=50;%Temp en mK.
    ZfitOpt.ThermalModel='default';
    ZfitOpt.NoiseFilterModel.model='medfilt'; %see BuildNoiseOptions
    ZfitOpt.NoiseFilterModel.wmed=40;
end
% if nargin>2
%     dir=varargin{1};
%     cd(dir);
% end

faux=figure('visible','off');

[IVset,IVsetN]=LoadIVsets(datadir);%%%Cargamos las IVs. Como el 'caller' es AnalizeRun, y no pasamos el circuit a LoadIVsets, dentro se ejecutara
%%% el load(circuit) desde dentro del datadir, por lo que se cargara el
%%% circuit correcto.
ind=[IVset.Tbath]<Tmax;
Gset=fitPvsTset(IVset(ind),PTrange,PTmodel);
GsetN=fitPvsTset(IVsetN(ind),PTrange,PTmodel);%%%Ajusto los datos P-Tbath.
close(faux);

%RpTES=0.75;%%%Defino el %Rn al que fijar los datos del TES.
TES=BuildTESStructFromRp(RpTES,Gset);
TESN=BuildTESStructFromRp(RpTES,GsetN);

cd(datadir);
evalin('caller','load(''circuit.mat'')'); %%esto va a ir machacando la estructura circuit del workspace, ojo si se usa en un analisis conjunto.
circuit=evalin('caller','circuit')
IVset=GetIVTES(circuit,IVset,TES);
IVsetN=GetIVTES(circuit,IVsetN,TESN);

if isfield(analizeOptions,'TES_sides')
    TES.sides=analizeOptions.TES_sides;
    gammas=[2 0.729]*1e3; %valores de gama para Mo y Au
    rhoAs=[0.107 0.0983]; %valores de Rho/A para Mo y Au
    hMo=45e-9; hAu=270e-9; %hAu=1.5e-6;%%%1Z11.!!!!!!!!!!!!!
    %CN=(gammas.*rhoAs)*([hMo ;hAu]*sides.^2).*TES.Tc; %%%Calculo directo
    CN=(gammas.*rhoAs).*([hMo hAu]*TES.sides.^2).*TES.Tc; %%%calculo de cada contribucion por separado.
    CN=sum(CN);
    TES.CN=CN;
    TESN.CN=CN;
else
    TES.CN=100e-15;%%%%Valores por defecto si no pasamos TES_sides, para que no de error.
    TESN.CN=100e-15;
end

if isfield(analizeOptions,'Cabs')
    TES.Cabs=analizeOptions.Cabs;
end
%TES.Rn=circuit.Rn; %TES.sides=(lado). Actualizo la estructura TES para incluir Rn.
%TESN.Rn=TES.Rn;%66.9e-3;%%%<-%%%%%%
%TFS=importTF('TFS.txt');%%%Necesitamos la TF en estado 'S'!

TESDATA=BuildDataStruct;
%P=FitZset(IVset,circuit,TES,TFS);%%%Ajustamos las Z positivas.
P=FitZset_remote(TESDATA,ZfitOpt);

%%%Solicion temporal para analizar tb negativas.

cd(strcat(datadir,'\Negative Bias'))
TESDATAN.IVset=IVsetN;
TESDATAN.circuit=TESDATA.circuit;
TESDATAN.TES=TESN;
%TESDATAN.TFS=TESDATA.TFS;
TFS=importTF('..\TFS.txt');
TESDATAN.TFS=TFS;
PN=P;
if(1)
PN=FitZset_remote(TESDATAN,ZfitOpt);
end
%PN=FitZset(IVsetN,circuit,TESN,TFS); 
cd ..


cd(olddir)

AnalizedData.circuit=TESDATA.circuit;
AnalizedData.IVset=IVset;
AnalizedData.IVsetN=IVsetN;
AnalizedData.PTmodel=PTmodel;
AnalizedData.Gset=Gset;
AnalizedData.GsetN=GsetN;
AnalizedData.RpTES=RpTES;
AnalizedData.TES=TES;
AnalizedData.TESN=TESN;
AnalizedData.TFS=TFS;
AnalizedData.P=P;
AnalizedData.PN=PN;
AnalizedData.analizeOptions.datadir=datadir;
AnalizedData.analizeOptions.PTrange=PTrange;
AnalizedData.analizeOptions.PTmodel=PTmodel;
AnalizedData.analizeOptions.RpTES=RpTES;
AnalizedData.analizeOptions.ZfitOpt=ZfitOpt;
if isfield(analizeOptions,'TES_sides')
    AnalizedData.analizeOptions.TES_sides=TES.sides;
end

