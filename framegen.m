FileName = '/home/ztpt/Dokumenty/projekty/optonavi/software/irn_flow/deterministic.dat';
F = fopen(FileName, 'w');

xRes = 320;
yRes = 240;
Frames = 100000;
Cycles = 50;
Offset = 32000;
Amplitude = 0;
Noise = 10;
FPN = 0;
Radius = 100;
LensNoise = 0;
LensCenter = [xRes/2+20 yRes/2+5];

[XGrid,YGrid] = meshgrid(1:xRes,1:yRes);
diagonal = sqrt((xRes/2).^2 + (yRes/2).^2);
lens = cos(sqrt((XGrid - LensCenter(1)).^2 + (YGrid - LensCenter(2)).^2)/diagonal*0.5*pi())';
background = (Amplitude .* rand(xRes+Radius*2+2, yRes+Radius*2+2) + Offset);
FPN_array = FPN .* rand(xRes, yRes);

i = 1:Frames;
x = sin(i/Frames*2*pi*Cycles)*Radius;
y = cos(i/Frames*2*pi*Cycles)*Radius;
ox = int32(size(background,1)/2+1);
oy = int32(size(background,2)/2+1);

%figure;
for i = 1:Frames
    data = uint16( background((ox-xRes/2+x(i)):(ox+xRes/2-1+x(i)), (oy-yRes/2+y(i)):(oy+yRes/2-1+y(i))) +     Noise .* rand(xRes, yRes) + lens*i/Frames*LensNoise+FPN_array);
    %data = data + uint16(Noise .* rand(xRes, yRes) + lens*i/Frames*LensNoise)+FPN_array;
    fwrite(F,data,'uint16');
    %imagesc(data')
    %pause(0.01);
end


SNR = std(double(background),1,'all') / std(double(Noise .* rand(xRes, yRes)+double(FPN_array)),1,'all')

fclose(F);
