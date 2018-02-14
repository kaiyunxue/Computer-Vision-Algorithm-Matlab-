
%copy of copy2 main file to work on full reduced image size of 300*200 and
%previously the code was as described in following 2 lines of comments
%FOR A PORTION OF IMAGE
%first calculated the [R|t] and then transformed ref camera to origin

IL=rgb2gray(imread('C:/Users/viraj/OneDrive/Documents/MATLAB/Project/Input/herzjesu/0003.png'));
IR=rgb2gray(imread('C:/Users/viraj/OneDrive/Documents/MATLAB/Project/Input/herzjesu/0005.png'));
reference_image=rgb2gray(imread('C:/Users/viraj/OneDrive/Documents/MATLAB/Project/Input/herzjesu/0004.png'));

%K is same for all images
K=[2759.48, 0, 1520.69; 0, 2764.16,1006.81; 0 0 1];

%modify K because the image is resized
resize=[0.097,0,0;
    0,0.097,0
    0,0,1];
K=resize*K;

%for image 5
right_R_given=[0.44845 0.222462 0.865681; 
0.893807 -0.110026 -0.434746; 
-0.00146672 0.968713 -0.248179];

right_t_given=[-4.05799; -2.77303; 0.600184];



%{
for image 7
left_R_given=[0.995535 0.003721 0.0943235;
    0.0943815 -0.02118 -0.995311;
    -0.00170578 0.999769 -0.0214366];

left_t_given=[-17.6302;-3.36186;0.0325247];
%}

%for image 3
left_R_given=[0.267665 0.106626 0.957594; 
0.963503 -0.0340398 -0.265526; 
0.00428434 0.993716 -0.111846];

left_t_given=[-5.67296; -8.26979; 0.354114];

%{
%for image 6
right_R_given=[0.508394 0.205159 0.836328; 
0.8611 -0.113776 -0.495542; 
-0.00651118 0.972093 -0.234505];

right_t_given=[-3.38936; -0.132223; 0.897199];
%}

%for image 4
ref_R_given=[0.359338 0.176807 0.916305; 
0.933185 -0.0613277 -0.354124; 
-0.00641675 0.982333 -0.187031];

ref_t_given=[-4.58094; -5.84533; 0.298433];

ref_R=transpose(ref_R_given);
ref_t=-ref_R*ref_t_given;

n=[0;0;-1];

left_R=transpose(left_R_given);
left_t=-left_R*left_t_given;
right_R=transpose(right_R_given);
right_t=-right_R*right_t_given;

left_t=left_t-ref_t;
left_R=left_R/ref_R;

right_t=right_t-ref_t;
right_R=right_R/ref_R;




%for j=1:30000:(size(reference_image,1)*size(reference_image,2))
    
    %disp('for j');
    %disp(j);
    %[t1,t2]=ind2sub([size(reference_image,1),size(reference_image,2)],j);
    %x=[t1;t2;1];
for w=1:size(reference_image,2)
    for e=1:size(reference_image,1)
        x=[w;e;1];    
        for d=1:40
            x_newL=K*(left_R-left_t*(transpose(n)./d))*(K\x);
            x_newL=x_newL./x_newL(3,1);
            x_newL=uint32(x_newL);
            x_coordL=x_newL(1,1);
            y_coordL=x_newL(2,1);

            x_newR=K*(right_R-right_t*(transpose(n)./d))*(inv(K)*x);
            x_newR=x_newR./x_newR(3,1);
            x_newR=uint32(x_newR);
            x_coordR=x_newR(1,1);
            y_coordR=x_newR(2,1);

            %disp('here1');
            pc_value1=99999999;
            
            
            %NOTE: x coordinate in the image is the column in the matrix,
            %so we pass the matrix index to sad function and not image
            %coordinates
            if y_coordL>0 && y_coordL<size(IL,1) && x_coordL>0 && x_coordL<size(IL,2)
                %disp('entered here1');
                pc_value1=sad(y_coordL,x_coordL,IL,x(2,1),x(1,1),reference_image);
            end

            %disp('here2');
            pc_value2=99999999;

            if y_coordR>0 && y_coordR<size(IR,1) && x_coordR>0 && x_coordR<size(IR,2)
                %disp('entered here2');
                pc_value2=sad(y_coordR,x_coordR,IR,x(2,1),x(1,1),reference_image);
            end


            PC_matrix(x(2,1),x(1,1),d)=pc_value1+pc_value2;

        end

    end
end


%end
%imshowpair(IL,IR,'montage');

[M,D]=min(PC_matrix,[],3);

depthmap=mat2gray(D,[0 d]);

imwrite(depthmap,'depthmap_herzjesu_ref4.png');
imshow(depthmap);

