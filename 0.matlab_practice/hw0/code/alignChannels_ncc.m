function [rgbResult] = alignChannels_ncc(red, green, blue)
R = red;
R_norm = sqrt(sum(sum(red.^2)));
G_norm = sqrt(sum(sum(green.^2)));
B_norm = sqrt(sum(sum(blue.^2)));
best_G = green;
best_B = blue;
best_ncc_G = sum(sum(red.*green))/(R_norm*G_norm);
best_ncc_B = sum(sum(red.*blue))/(R_norm*B_norm);


for p = -30:30
    for q = -30:30
        G = circshift(green, [p, q]);
        curr_ncc_G = sum(sum(R.*G))/(R_norm*G_norm);
        if curr_ncc_G < best_ncc_G
            best_G = G;
            best_ncc_G = curr_ncc_G;
        end
    end
end

for p = -30:30
    for q = -30:30
        B = circshift(blue, [p, q]);
        curr_ncc_B = sum(sum((R-B).^2));
        if curr_ncc_B < best_ncc_B
            best_B = B;
            best_ncc_B = curr_ncc_B;
        end
    end
end

rgbResult = cat(3, R, best_G, best_B);
end