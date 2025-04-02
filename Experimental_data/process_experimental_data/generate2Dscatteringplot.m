%Plots
function generate2Dscatteringplot(samplename,inpath,outpath,smootheningflag)
opts = delimitedTextImportOptions("NumVariables", 61);
opts.DataLines = [1, Inf];
opts.Delimiter = ",";
opts.VariableTypes(:) = {'double'};%["double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
data = table2array(readtable([inpath samplename '_processeddata.txt'], opts));
if smootheningflag
    smootheningparams = [1 1];
    datasize = size(data);
    BigGrid=[data(:,1:datasize(2)-1) data(:,1:datasize(2)-1) data(:,1:datasize(2)-1)]; %This is done because data in theta is periodic
    BigGrid=smoothdata(BigGrid,2,'movmean',smootheningparams(1),'omitnan');
    BigGrid=BigGrid(:,datasize(2)-1+(1:datasize(2)));
    data=smoothdata(BigGrid,1,'movmean',smootheningparams(2),'omitnan');
    %data(mask_Iq_qthetaGrid)=NaN;
end
nanmask = isnan(data);
clear opts
fontsize_axlabel=35;
fontsize_ticks=30;
fontsize_title=30;
fontname='Arial';
%qmin_exponent=-2; qmax_exponent=3;
q_incr=0.5;
q_trunc=0;
q_shift=0.01;
cmax=1; cmin=-2;
cincr = 0.001;
%cmax=-3; cmin=-8;
%Finaldata=Finalxy;
%nq=501;
%ntheta=181;
%qmin_exponent=-2;
%qmax_exponent=3;
nq=61;
ntheta=61;
%qmin_exponent=-3;
%qmax_exponent=0;
qmin_exponent=-2.1;
qmax_exponent=-0.9;
qgrid = logspace(qmin_exponent,qmax_exponent,nq)'*ones(1,ntheta);
thetagrid = ones(nq,1)*linspace(0,pi,ntheta);
Finaldata=10.^data;
%
figure('Position', [1000 100 870 840]);
axhandle=axes('Units', 'pixels', 'Position', [130 110 700 700]);
plotx=(log10(qgrid)-qmin_exponent+q_shift).*cos(thetagrid);
ploty=(log10(qgrid)-qmin_exponent+q_shift).*sin(thetagrid);
plotz=max(min(log10(Finaldata),cmax),cmin);
plotz(nanmask)=NaN;
contourf(plotx,ploty,plotz,(cmin:cincr:cmax),'EdgeColor','None','Parent',axhandle);
hold on;
contourf(-plotx,-ploty,plotz,(cmin:cincr:cmax),'EdgeColor','None','Parent',axhandle);
axhandle.XTickMode='manual';
axhandle.YTickMode='manual';
axhandle.FontName=fontname;
axhandle.FontSize=fontsize_ticks;
axhandle.CLim=[cmin cmax];
axis square
%colorbar;
%title('$$\log_{10}(I(\mathbf{q}))$$','interp','latex','FontSize',fontsize_title,'FontName',fontname);
xlb=xlabel('$$q_1 (\mathrm{\AA}^{-1})$$ ','interp','latex','FontSize',fontsize_axlabel,'FontName',fontname);
ylb=ylabel('$$q_2 (\mathrm{\AA}^{-1})$$ ','interp','latex','FontSize',fontsize_axlabel,'FontName',fontname);
%ticks=q_shift:q_incr:(qmax_exponent-qmin_exponent-q_trunc+q_shift);
ticks=(log10([10^-2 2*10^-2 3*10^-2 4*10^-2 5*10^-2 6*10^-2 7*10^-2 8*10^-2 9*10^-2 10^-1]))+2+q_shift;
ticks=[-fliplr(ticks) ticks];
xticks(ticks);
yticks(ticks);
%qmin_exponent_label=round(qmin_exponent/q_incr)*q_incr;
%qmax_exponent_label=round(qmax_exponent/q_incr)*q_incr;
%ticklables=num2cell((qmin_exponent_label:q_incr:(qmax_exponent_label-q_trunc)));
ticklables=num2cell(log10([10^-2 2*10^-2 3*10^-2 4*10^-2 5*10^-2 6*10^-2 7*10^-2 8*10^-2 9*10^-2 10^-1]));
formattick_positive=@(num)['10^{' num2str(num) '}'];
formattick_negative=@(num)['-10^{' num2str(num) '}'];
ticklablespositive=cellfun(formattick_positive,ticklables,'UniformOutput',false);
ticklablesnegative=cellfun(formattick_negative,ticklables,'UniformOutput',false);
ticklables=[fliplr(ticklablesnegative) ticklablespositive];
ticklables{2}=' ';
ticklables{3}=' ';
ticklables{5}=' ';
ticklables{6}=' ';
ticklables{7}=' ';
ticklables{9}=' ';
ticklables{12}=' ';
ticklables{14}=' ';
ticklables{15}=' ';
ticklables{16}=' ';
ticklables{18}=' ';
ticklables{19}=' ';
xticklabels(ticklables);
yticklabels(ticklables);
axislimit=qmax_exponent-qmin_exponent-q_trunc+q_shift;
axis([-axislimit axislimit -axislimit axislimit]);
axhandle.XTickLabelRotation=0;
axhandle.YTickLabelRotation=0;
xlb.Position=[-0.3 -3.7 1];
ylb.Position=[-3.7 -0.3 1];
axhandle.Color='None';
axhandle.LineWidth=2;
%Draw radial gridlines
%qexp=[log10([8 9 10 20 30 40 50 60 70 80 90 100]*1e-3) qmax_exponent]-qmin_exponent-q_trunc+q_shift;
%theta=linspace(0,2*pi,361)';
%Xrad=cos(theta)*qexp;
%Yrad=sin(theta)*qexp;
%line(Xrad(:,[3 5 9 12]),Yrad(:,[3 5 9 12]),'LineStyle',':','Color', 'black','LineWidth',0.5);
%line(Xrad(241:301,1:12),Yrad(241:301,1:12),'LineStyle',':','Color', 'black','LineWidth',0.5);
%line(Xrad(241:301,[3 5 9 12]),Yrad(241:301,[3 5 9 12]),'LineStyle','-','Color', 'black','LineWidth',2);
%line(Xrad(1:60:361,:)',Yrad(1:60:361,:)','LineStyle',':','Color', 'black','LineWidth',0.5);
%line(Xrad([241 301],:)',Yrad([241 301],:)','LineStyle','-','Color', 'black','LineWidth',2);
load('speed_colormap.mat');
colormap(flipud(speed_colormap));
%load('thermal_colormap.mat');
%colormap(flipud(thermal_colormap));
axis off;
%print([outpath 'samples_' num2str(sampleid) '_subsampledorig_data' xyzstr '.png'],'-dpng','-r600');
exportgraphics(axhandle,[outpath samplename '_2Dplot.png'],Resolution=600);
%exportgraphics(axhandle,[outpath 'gridlines.pdf'],ContentType="vector");
close;
end
