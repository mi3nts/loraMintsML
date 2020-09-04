function [] = drawPredictorImportainceLora(regressionTree,yLimit,...
                                        estimator,variableNames,nodeID,...
                                         saveNameFig,MiddleTile2)
%GETPREDICTORIMPORTAINCE Summary of this function goes here
%   Detailed explanation goes here

imp = 100*(regressionTree.predictorImportance/sum(regressionTree.predictorImportance));

xLimit = max(imp)+5;

[sortedImp,isortedImp] = sort(imp,'descend');

figure_1= figure('Tag','PREDICTOR_IMPORTAINCE_PLOT',...
        'NumberTitle','off',...
        'units','pixels',...   
        'OuterPosition',[0 0 2000 1300],...
        'Name','predictorImportance',...
        'Visible','on'...
    )

barh(imp(isortedImp));hold on ; grid on ;
set(gca,'ydir','reverse');
xlabel('Scaled Importance(%)','FontSize',20);
ylabel('Predictor Rank','FontSize',20);
   % Create title
    Top_Title=strcat(estimator," - Predictor Importaince Estimates")
    Middle_Title = strcat("Node " +string(nodeID))
    title({Top_Title;Middle_Title;MiddleTile2},'FontSize',21);

% title('Predictor Importaince Estimates')
ylim([.5 (yLimit+.5)]);
yticks([1:1:yLimit])
xlim([0 (xLimit)]);
xticks([0:1:xLimit])

% sortedPredictorLabels= regressionTree.PredictorNames(isortedImp);

sortedPredictorLabels= variableNames(isortedImp);

    for n = 1:yLimit
        text(...
            imp(isortedImp(n))+ 0.05,n,...
            sortedPredictorLabels(n),...
            'FontSize',15 , 'Interpreter', 'tex'...
            )
    end
%     
    saveas(figure_1,char(saveNameFig));
    Fig_name =strrep(saveNameFig,'.png','.fig');
    saveas(figure_1,char(Fig_name));

    
end
                                     