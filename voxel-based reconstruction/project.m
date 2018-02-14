function [ pos ] = project( Pos,P )

for i = 1 : 8
    P_i = P(:,:,i);
    pos_i = P_i * Pos;
    pos_i = floor(pos_i / pos_i(3,1));
    pos(:,:,i) = pos_i;
end
pos = uint32(pos);
end

