% Finds num_buttons of the most similar buttons.

function filenames = findMatchingButtons(circle, num_buttons, similarity_threshold)
    persistent buttons;
    
    if isempty(buttons)
        buttons = load('..\buttons\buttons.mat');
    end
    
    if nargin < 4
        scale = 1;
    end
    
    max_similarities = repmat(-1e10, 1, num_buttons);
    indices = zeros(1, num_buttons, 'uint32');
    
    for i = 1:length(buttons.data)
        
        if circle.radius >= 10000
            similarity = dominantColorsSimilarity(circle.dominant_colors, buttons.data(i).dominant_colors, 30);
        else
            similarity = meanColorSimilarity(circle.mean_color_lab, buttons.data(i).mean_color_lab);
        end
        
        if any(similarity > max_similarities)
            [~, idx] = min(max_similarities);
            max_similarities(idx) = similarity;
            indices(idx) = i;
        end
    end
    
    if(any(indices))
        [max_similarities, idx] = sort(max_similarities, 'descend');
        indices = indices(idx);
        
        % Remove any matches that are too unsimilar compared to the most
        % similar match, determined by similarity_threshold.
        indices(max_similarities(1) > (max_similarities + similarity_threshold)) = [];
        
        filenames = string({buttons.data(indices).filename});
    else
        filenames = '';
    end
end
