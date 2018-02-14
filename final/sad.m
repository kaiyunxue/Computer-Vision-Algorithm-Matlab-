function [pc_value] = sad(x1,y1,subject_image,x2,y2,reference_image)
%SAD Summary of this function goes here
%   sad(x1,y1,subject_image,x2,y2,reference_image)

window_size=13;

image_size=size(subject_image);

for i=0:(window_size-1)
    for j=0:(window_size-1)
        %disp('this is x_subject');
        %{disp(x1-((window_size-1)/2)+i);
        %disp('this is y_subject');
        %disp(y1-((window_size-1)/2)+i);
        %disp('this is x_ref');
        %disp(x2-((window_size-1)/2)+i);
        %disp('this is y_ref');
        %disp(y2-((window_size-1)/2)+i);
        
        if x1-((window_size-1)/2)+i>0 && x1-((window_size-1)/2)+i<=image_size(1,1) && y1-((window_size-1)/2)+j>0 && y1-((window_size-1)/2)+j<=image_size(1,2)
            
            if x2-((window_size-1)/2)+i>0 && x2-((window_size-1)/2)+i<=image_size(1,1) && y2-((window_size-1)/2)+j>0 && y2-((window_size-1)/2)+j<=image_size(1,2)
                
                diff_matrix(i+1,j+1)=abs(subject_image(x1-((window_size-1)/2)+i,y1-((window_size-1)/2)+j)-reference_image(x2-((window_size-1)/2)+i,y2-((window_size-1)/2)+j));
            end
        end
    end
end
pc_value=sum(sum(diff_matrix));
end

