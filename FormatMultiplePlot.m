function FormatMultiplePlot(handle,options)
%%%handle is a handle to the plot children objects
%%%get for instance as: handle=get(gca,'children');

%%%list of propertiy names:
names={'Color' 'LineStyle' 'LineWidth' 'Marker' 'MarkerSize' 'MarkerEdgeColor' 'MarkerFaceColor'};
lineColors = {[0,0,1];[1,0,0];[0,0.5,0];[0,0,0];[1,1,0];[1,0,1];[0,1,1];[0.5 0.5 0.5]};%b,r,dark green, k, y, m, c, grey

if nargin==1
    %%%build here your style options

    opt=BuildPlotOptionsScript();
    names=opt.names;
    values=opt.values;
    
elseif nargin==2
    
    names=options.names;
    values=options.values;

end

set(handle,names,values(1:length(handle),:));
set(handle,'fontsize',11);
    