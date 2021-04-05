%Load xxx.mat

%Daten einlesen
lfp=CLFP_01___Central;
lfp=double(lfp);
lfp=lfp';
%Frequenz
Fs=CLFP_01___Central_KHz_Orig*1000;
plot(CLFP_01___Central);
n=4;
%Filter (explorativ um die Frequenzbänder zu visualisieren)
fpass=[0 4;4 8;8 13;13 40;40 100];
[b,a]=butter(n,2*fpass(1,2)*2/Fs,"low");
lfp(:,2)=filtfilt(b,a,lfp(:,1));

for ii=2:length(fpass);
 lfp(:,ii+1)=bandpass(lfp(:,1),fpass(ii,:)*2/Fs);
end;

%Chronux params festlegen
params.Fs=Fs ;   
params.tapers=[3 9];
params.fpass=[0 50];
params.err=[1 0.05];
movingwin= [0.5 0.05];
maxDb=15;

%Locdetrend und DC removal
f0=50;
lfp(:,1)=locdetrend(lfp(:,1),Fs,movingwin);
lfp(:,1)=rmlinesc(lfp(:,1),params,f0);

%Frequenzspektrum
[S,f,Serr]=mtspectrumc(lfp(:,1),params);
plot(f,S,"Color","red")
hold on
plot(f,Serr,"Color","blue","LineStyle","-.")
xlim ([0 ,50])
xlabel("Frequenz in Hz")
hold off

%Spektrogramm Frequenz-Zeit
[s,t,f]=mtspecgramc(lfp(:,1),movingwin,params);
plot_matrix(s,t,f); xlabel([])
caxis([0 15])
colorbar