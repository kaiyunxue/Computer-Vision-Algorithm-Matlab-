clear;
rawP = [ 776.649963  -298.408539 -32.048386  993.1581875 132.852554  120.885834  -759.210876 1982.174000 0.744869  0.662592  -0.078377 4.629312012;
    431.503540  586.251892  -137.094040 1982.053375 23.799522   1.964373    -657.832764 1725.253500 -0.321776 0.869462  -0.374826 5.538025391;
    -153.607925 722.067139  -127.204468 2182.4950   141.564346  74.195686   -637.070984 1551.185125 -0.769772 0.354474  -0.530847 4.737782227;
    -823.909119 55.557896   -82.577644  2498.20825  -31.429972  42.725830   -777.534546 2083.363250 -0.484634 -0.807611 -0.335998 4.934550781;
    -715.434998 -351.073730 -147.460815 1978.534875 29.429260   -2.156084   -779.121704 2028.892750 0.030776  -0.941587 -0.335361 4.141203125;
    -417.221649 -700.318726 -27.361042  1599.565000 111.925537  -169.101776 -752.020142 1982.983750 0.542421  -0.837170 -0.070180 3.929336426;
    94.934860   -668.213623 -331.895508 769.8633125 -549.403137 -58.174614  -342.555359 1286.971000 0.196630  -0.136065 -0.970991 3.574729736;
    452.159027  -658.943909 -279.703522 883.495000  -262.442566 1.231108    -751.532349 1884.149625 0.776201  0.215114  -0.592653 4.235517090];

P = zeros(3,4,8);

for i = 0 : 7
    silho_path = ['silh_cam0',num2str(i),'_00023_0000008550.pbm'];
    img_path = ['cam0',num2str(i),'_00023_0000008550.png'];
    silhouettes(:,:,i+1) = imread(silho_path);
%     figure;
%     imshow(silhouettes(:,:,i+1));
    img(:,:,:,i+1) = imread(img_path);
%         figure;
%     imshow(img(:,:,:,i+1));
end
for i=1:8
    for j=1:3
        P(j,1:4,i) = rawP(i,4*(j-1)+1:4*(j-1)+4);
    end
end
ii = 1;
for x = -2.5 : 0.025 : 2.5
    for y = -3.0 : 0.025 : 3.0
        for z = 0 : 0.025 : 2.5
            Pos = [x;y;z;1];
            pos = project(Pos,P);
            goodProjection = 0;
            
            for I = 1 : 8
                % %                 pos_ = pos(:,:,I);
                if pos(1,1,I)>0 && pos(1,1,I)<=780 && pos(2,1,I)>0 && pos(2,1,I)<=582
                    isTrue = silhouettes(pos(2,1,I)  ,pos(1,1,I),I);
                    if isTrue
                        goodProjection = goodProjection + 1;
                    end
                end
            end
            if goodProjection == 8
                cloud(uint16(x*40+101),uint16(y*40+121),uint16(z*40+1)) = 1;
            else
                cloud(uint16(x*40+101),uint16(y*40+121),uint16(z*40+1)) = 0;
            end
        end
    end
end

[M,N,O] = size(cloud);
[X Y Z] = meshgrid(1:N, 1:M, 1:O);

FV = isosurface(X,Y,Z,cloud,0);
h=patch(isosurface(X,Y,Z,cloud,0));
AAA = isonormals(X,Y,Z,cloud,h);

points = FV.vertices;
[n_points,NI] = size(points);
faces = FV.faces;
[n_faces,NI] = size(faces);

[p_n,NI] = size(points);
for i = 1 : p_n
    truepoints(i,2) = (points(i,1)-121)/40;
    truepoints(i,1) = (points(i,2)-101)/40;
    truepoints(i,3) = (points(i,3)-1)/40;   
end
for i = 1 : p_n
    p = truepoints(i,:);
    p = p';
    p = [p;1];
    for ii = 1 : 8
        imgp = P(:,:,ii)*p;
        imgp = floor(imgp/imgp(3,1));
        color = img(imgp(2,1),imgp(1,1),:,1);
        img(imgp(2,1),imgp(1,1),1,ii) = 255;
        img(imgp(2,1),imgp(1,1),2,ii) = 255;
        img(imgp(2,1),imgp(1,1),3,ii) = 255;
        colors(1:3,i,ii) = color(1,1,1:3);
    end
end

for ii = 1 : 8
    figure;
    imshow(img(:,:,:,ii));
end
% for i = 1 : p_n
%     color_s(1:8,1) = colors(1,i,1:8);
%     color_s(1:8,2) = colors(2,i,1:8);
%     color_s(1:8,3) = colors(3,i,1:8);
%     color_sorted = sort(color_s);
%     for ii = 1 : 7
%         color_dif(ii,:) = color_sorted(ii+1,:) - color_sorted(ii,:);
%     end
%     good_r = find(color_dif(:,1)<10);
%     good_g = find(color_dif(:,2)<10);
%     good_b = find(color_dif(:,3)<10);
%     [a,b] = size(good_r);
%     N = 0;
%     Nmax = 0;
%     bg = 1;
%     ed = 1;
%     if good_r(a,1) - good_r(1,1) == a - 1
%         bg = 1;ed = a;
%     else
%         for i = 1 : a
%             if good_r(i,1) - good_r(bg,1) == i - bg
%                 N= N+1;
%             else
%                 if N > Nmax
%                     Nmax = N;
%                     N = 0;
%                     bg = ed;
%                     ed = i;
%                 else
%                     N = 0;
%                 end
%             end
%         end
%     end
%             
% end


fid=fopen('coloredPtCloud.ply','w+');
fprintf(fid,'ply\r\n');
fprintf(fid,'format ascii 1.0\r\n');
fprintf(fid,'element vertex %d\r\n',n_points);
fprintf(fid,'property float32 x\r\n');
fprintf(fid,'property float32 y\r\n');
fprintf(fid,'property float32 z\r\n');
fprintf(fid,'property uchar red\r\n');
fprintf(fid,'property uchar green\r\n');
fprintf(fid,'property uchar blue\r\n');
fprintf(fid,'element face %d\r\n',n_faces);
fprintf(fid,'property list uchar int vertex_indices\r\n');
fprintf(fid,'end_header\r\n');
for i=1:n_points
    fprintf(fid,'%f %f %f %d %d %d\r\n',points(i,1),points(i,2),points(i,3),colors(1,i),colors(2,i),colors(3,i));
end
for i=1:n_faces
    fprintf(fid,'%d %d %d %d\r\n',3,faces(i,1)-1,faces(i,2)-1,faces(i,3)-1);
end
fclose(fid);