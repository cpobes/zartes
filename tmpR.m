%script para deducir las R(T) de un TES a partir de las IVs medidas en el
%diluci�n y que sal�an an�malas. 
[r30,x30,y30]=RIT(iv30c(:,1)*1e-6,iv30c(:,2),.030);
[r60,x60,y60]=RIT(iv60c(:,1)*1e-6,iv60c(:,2),.060);
[r70,x70,y70]=RIT(iv70c(:,1)*1e-6,iv70c(:,2),.070);
[r80,x80,y80]=RIT(iv80c(:,1)*1e-6,iv80c(:,2),.080);
[r85,x85,y85]=RIT(iv85c(:,1)*1e-6,iv85c(:,2),.085);
[r90,x90,y90]=RIT(iv90c(:,1)*1e-6,iv90c(:,2),.090);
[r95,x95,y95]=RIT(iv95c(:,1)*1e-6,iv95c(:,2),.095);
[r100,x100,y100]=RIT(iv100c(:,1)*1e-6,iv100c(:,2),.100);
[r105,x105,y105]=RIT(iv105c(:,1)*1e-6,iv105c(:,2),.105);
[r110,x110,y110]=RIT(iv110c(:,1)*1e-6,iv110c(:,2),.110);
[r115,x115,y115]=RIT(iv115c(:,1)*1e-6,iv115c(:,2),.115);
[r120,x120,y120]=RIT(iv120c(:,1)*1e-6,iv120c(:,2),.120);
[r125,x125,y125]=RIT(iv125c(:,1)*1e-6,iv125c(:,2),.125);
x=[x30;x60;x70;x80;x85;x90;x95;x100;x105;x110;x115;x120;x125];
y=[y30;y60;y70;y80;y85;y90;y95;y100;y105;y110;y115;y120;y125];
z=[r30;r60;r70;r80;r85;r90;r95;r100;r105;r110;r115;r120;r125];

% [r210,x210,y210]=RIT(t210(500:750,2)*1e-6,-t210(500:750,4)+0.02,.210);
% [r215,x215,y215]=RIT(t215(500:750,2)*1e-6,-t215(500:750,4)+0.02,.215);
% [r220,x220,y220]=RIT(t220(500:750,2)*1e-6,-t220(500:750,4)+0.02,.220);
% [r225,x225,y225]=RIT(t225(500:750,2)*1e-6,-t225(500:750,4)+0.02,.225);
% [r230,x230,y230]=RIT(t230(500:750,2)*1e-6,-t230(500:750,4)+0.02,.23);
% [r250,x250,y250]=RIT(t250(50:75,2)*1e-6,-t250(50:75,4)+0.02,.25);
% [r300,x300,y300]=RIT(t300(50:75,2)*1e-6,-t300(50:75,4)+0.02,.3);
% [r500,x500,y500]=RIT(t500(100:150,2)*1e-6,-t500(100:150,4)+0.02,.5);
% x=[x210;x215;x220;x225;x230;x250;x300;x500];
% y=[y210;y215;y220;y225;y230;y250;y300;y500];
% z=[r210;r215;r220;r225;r230;r250;r300;r500];
% % plot(y100,r100)
% % hold on
% % plot(y105,r105)
% % plot(y110,r110)
% % plot(y120,r120)
% % plot(y130,r130)
% % plot(y150,r150)
% plot(y,z,'.'),hold on;
% plot(y210(end),r210(end),'or')
% plot(y215(end-1),r215(end-1),'or')
% plot(y220(end-1),r220(end-1),'or')
% plot(y225(end-1),r225(end-1),'or')
% plot(y230(end-1),r230(end-1),'or')
% plot(y250(end-1),r250(end-1),'or')
% plot(y300(end-1),r300(end-1),'or')
% plot(y500(end-1),r500(end-1),'or')


% TES viejo.
% [r150,x150,y150]=RIT(-IV150(:,2)*1e-6,IV150(:,3),.150);
% [r130,x130,y130]=RIT(-IV130(:,2)*1e-6,IV130(:,3),.130);
% [r120,x120,y120]=RIT(-IV120a(:,2)*1e-6,IV120a(:,3),.120);
% [r110,x110,y110]=RIT(-IV110a(:,2)*1e-6,IV110a(:,3),.110);
% [r105,x105,y105]=RIT(-IV105a(:,2)*1e-6,IV105a(:,3),.105);
% [r100,x100,y100]=RIT(-IV100(:,2)*1e-6,IV100(:,3),.1);
% x=[x100;x105;x110;x120;x130;x150];
% y=[y100;y105;y110;y120;y130;y150];
% z=[r100;r105;r110;r120;r130;r150];
% plot(y,z)
% % plot(y100,r100)
% % hold on
% % plot(y105,r105)
% % plot(y110,r110)
% % plot(y120,r120)
% % plot(y130,r130)
% % plot(y150,r150)
% plot(y130(end),r130(end),'or')
% plot(y130(end-1),r130(end-1),'or')
% plot(y150(end-1),r150(end-1),'or')
% plot(y120(end-1),r120(end-1),'or')
% plot(y110(end-1),r110(end-1),'or')
% plot(y105(end-1),r105(end-1),'or')
% plot(y100(end-1),r100(end-1),'or')