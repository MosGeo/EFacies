function curveAxis = constructWellLogPlot(data, depth, curvesToUse, logScaleVariables, lasHeader, axisBorder, curveAxis)

nVariables = numel(curvesToUse);


curvesNames = lasHeader.curves.variables;

[.02 .15 .5 .52];

dx = axisBorder(3)/nVariables - .2;

if isempty(curveAxis) == false
for i = 1:numel(curveAxis)
delete(curveAxis{i})
end
end

for i =1:nVariables
   currentCurvesToUse = curvesToUse(i);
   %subplot(1, nVariables,i)
   x_initial = axisBorder(1) + (i-1)*dx + .2
   curveAxis{i} = axes('Position',[x_initial axisBorder(2) dx axisBorder(4)],'Box', 'on', 'xTick', [], 'yTick',[]);
   
   if ismember(logScaleVariables,currentCurvesToUse) == true
       semilogx( data(:,i), depth,'k' , 'LineWidth', 2)
   else
       plot( data(:,i), depth, 'k', 'LineWidth', 2)        
   end
      set(gca,'YDir','reverse');
      if i ~= 1
          set(gca,'ytick',[])
      else
          ylabel(['Depth' ' (' lasHeader.curves.units{1} ')'])
          %ylabel(['Depth'])
          set(gca,'YTickLabel',num2str(get(gca,'YTick').'))
      end
      yLimitVector = round([min(depth) max(depth)]);
      set(gca,'ylim', yLimitVector)
      %title([curvesNames{currentCurvesToUse}],'interpreter', 'none')
      title([curvesNames{currentCurvesToUse}  ' (' lasHeader.curves.units{currentCurvesToUse} ')'],'interpreter', 'none')
end
