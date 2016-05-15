function [rgbResult] = alignChannels_ssd(red, green, blue)
R = red;
best_G = green;
best_B = blue;
best_ssd_G = sum(sum((red-green).^2));
best_ssd_B = sum(sum((red-blue).^2));

for p = -30:30
    for q = -30:30
        G = circshift(green, [p, q]);
        curr_ssd_G = sum(sum((R-G).^2));
        if curr_ssd_G < best_ssd_G
            best_G = G;
            best_ssd_G = curr_ssd_G;
        end
    end
end

for p = -30:30
    for q = -30:30
        B = circshift(blue, [p, q]);
        curr_ssd_B = sum(sum((R-B).^2));
        if curr_ssd_B < best_ssd_B
            best_B = B;
            best_ssd_B = curr_ssd_B;
        end
    end
end

rgbResult = cat(3, R, best_G, best_B);
end