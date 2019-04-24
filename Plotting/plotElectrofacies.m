function [resultsFigure] = plotElectrofacies(curvesToUse, logScaleVariables, data, depth, lasHeader, curvesNames, upscaledClasses, maxnClasses, minnClasses, maxProb, selectedProb, mainScale, isDrawLines, colorMap, variablesToPlot)
%PLOTELECTROFACIES Plots the electrofacies results
%   Plots the electrofacies results

%% Preprocessing

% Defaults
if ~exist('variablesToPlot', 'var'); variablesToPlot = 1:numel(curvesToUse); end


%% Main

% Initialize figures
resultsFigure = figure('Name','ElectroMos', 'NumberTitle','off', 'Color', 'white');
set(gcf,'units','normalized','outerposition',[0 0 1 1])

nVariables = numel(variablesToPlot);
%rawData = score
yLimitVector = round([min(depth) max(depth)]);

for i =1:nVariables
   currentCurvesToUse = curvesToUse(variablesToPlot(i));
   subplot(1, nVariables+4,i)
   
   if logScaleVariables(currentCurvesToUse) == true
       semilogx(data(:,i), depth,'k' , 'LineWidth', 2)
   else
       plot(data(:,i), depth, 'k', 'LineWidth', 2)        
   end
      set(gca,'YDir','reverse');
      if i ~= 1
          set(gca,'ytick',[])
      else
          if  isempty(lasHeader) == false
            ylabel(['Depth' ' (' lasHeader.curves.units{1} ')'])
          else
            ylabel(['Depth']);
          end
          %set(gca,'YTickLabel',num2str(get(gca,'YTick').'))
      end
      set(gca,'ylim', yLimitVector)
      %title([curvesNames{currentCurvesToUse}],'interpreter', 'none')
      if  isempty(lasHeader) == false
         title([curvesNames{currentCurvesToUse}],'interpreter', 'none')
         xlabel(lasHeader.curves.units{currentCurvesToUse});
      else
         title([curvesNames{currentCurvesToUse}],'interpreter', 'none')
      end
      set(gca, 'FontUnits','points', 'FontWeight','normal', 'FontSize',12, 'FontName','Times')

end

%scaledFinalClasses =255*(finalClasses-min(finalClasses(:))) ./ (max(finalClasses(:)-min(finalClasses(:))));
subplot(1,nVariables+4, [nVariables+1 nVariables+4])
classesToShow = upscaledClasses(:, end-maxnClasses+1:end-minnClasses + 1);


% Special Colomap
classesUsed = unique(classesToShow(:));
classesToShowFinal = nan(size(classesToShow));
for i = 1:numel(classesUsed)
     classesToShowFinal(classesToShow == classesUsed(i)) = i;
end

imagesc(classesToShowFinal)
colormap(colorMap);

yticklabels = min(depth):50:max(depth);
yticks = linspace(1, size(data, 1), numel(yticklabels));
set(gca, 'YTick', yticks, 'YTickLabel', yticklabels(:))

set(gca,'ytick',[])
title ('Multi-Scale Electrofacies')
set(gca, 'FontUnits','points', 'FontWeight','normal', 'FontSize',12, 'FontName','Times')


% Update Plot
ax= gca;

%XTick = get(ax, 'XTick');
xtick = 1:(maxnClasses-minnClasses)+1;

XTickLabel = num2str(xtick'+minnClasses-1);
set(ax,'XTick',xtick)
set(ax,'XTickLabel',flipud(XTickLabel));
set(ax, 'TickLength',[0 0])
hold on

% Obtain the tick mark locations
xtickHalf = xtick+.5; 
% Obtain the limits of the y axis
ylim = get(gca,'Ylim');
X = repmat(xtickHalf,2,1);
Y = repmat(ylim',1,size(xtickHalf,2));
% Plot line data

if isDrawLines == true
plot(X,Y, 'k')
end


% subplot(1, nVariables+4,nVariables+3)
% plot(maxProb,  depth,'k' , 'LineWidth', 2)
% set(gca,'ylim', yLimitVector)
% set(gca,'YDir','reverse');
% set(gca,'ytick',[])
% xlim([0 1])
% title(['Max P (' num2str(mean(maxProb), '%.3f') ') - S' num2str(mainScale)])
% 
% subplot(1, nVariables+4,nVariables+4)
% plot(selectedProb,  depth,'k' , 'LineWidth', 2)
% set(gca,'ylim', yLimitVector)
% set(gca,'YDir','reverse');
% set(gca,'ytick',[])
% xlim([0 1])
% title(['Sampled P (' num2str(mean(selectedProb), '%.3f') ') - S' num2str(mainScale)])



end

