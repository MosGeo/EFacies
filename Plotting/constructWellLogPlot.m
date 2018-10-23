function curveAxis = constructWellLogPlot(data, depth, minDepth, maxDepth, curvesToUse, logScaleVariables, lasHeader, axisBorder, curveAxis)

nVariables = numel(curvesToUse);
curvesNames = lasHeader.curves.variables;
units = lasHeader.curves.units;

[selectedData, selectedDepth] = extractInterval(data, depth, minDepth, maxDepth);
[selectedData, ~] = extractCurvesUsed(selectedData, curvesToUse, curvesNames); 

dx = axisBorder(3)/nVariables;

if isempty(curveAxis) == false
    for i = 1:numel(curveAxis)
    delete(curveAxis{i})
    end
end


for i =1:nVariables
   
    currentCurvesToUse = curvesToUse(i);

   x_initial = axisBorder(1) + (i-1)*(dx);
   curveAxis{i} = axes('Position',[x_initial axisBorder(2) (dx-.03) axisBorder(4)],'Box', 'on', 'xTick', [], 'yTick',[]);
   
   if sum(ismember(logScaleVariables, currentCurvesToUse))>0
       semilogx( selectedData(:,i), selectedDepth,'k' , 'LineWidth', 2)
   else
       plot( selectedData(:,i), selectedDepth, 'k', 'LineWidth', 2)        
   end
      set(gca,'YDir','reverse');
      if i ~= 1
          set(gca,'ytick',[])
      else
          ylabel(['Depth' ' (' units{1} ')'])
          %ylabel(['Depth'])
          %set(gca,'YTickLabel',num2str(get(gca,'YTick').'))
      end
      yLimitVector = round([min(selectedDepth) max(selectedDepth)]);

      set(gca,'ylim', yLimitVector)
      %title([curvesNames{currentCurvesToUse}],'interpreter', 'none')
      title([curvesNames{currentCurvesToUse}  ' (' units{currentCurvesToUse} ')'],'interpreter', 'none')
end
