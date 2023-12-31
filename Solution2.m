%% SOLUTION OF EXERCISE 2 - Suggestion: run one section at a time

%% Exercise 2 Point 1 - Generate and plot the independent signals S and their mixtures X (3 vars)

clear 
close all
clc

Fs=500;
t=[0:1/Fs:10-1/Fs];

amp1=0.75;  %amplitude of sine wave
f1=5;       %frequency of sine wave
s1=amp1*sin(2*pi*f1*t); %sine wave
amp2=1;     %amplitude of triangle wave
f2=7;       %frequency of triangle wave
s2=amp2*sawtooth(2*pi*f2*t,0.5); %triangle wave
amp3=0.5;   %amplitude of square wave
f3=3;       %frequency of sqaure wave
s3=amp3*square(2*pi*f3*t,40); %square wave

S=[s1;s2;s3];  %the three independent signals; S is a n=3 x m=5000 matrix
S=S-mean(S,2); %centering 

A=[0.5 0.5 0.7      %the mixing matrix
   0.7 0.2 0.4
   0.2 0.7 -0.5];

X=A*S;      %the artificial data X generated by mixing s1,s2,s3 via matrix A 
            %Being S centered, also X is centered (zero-mean)

% plot  the three independent signals s1,s2,s3
figure
for i=1:3
    subplot(3,1,i)
    plot(t,S(i,:),'linewidth',1)
    grid
    ylim([-1.2 1.2])
    title(['s',num2str(i)])
    set(gca,'fontsize',12)
end
xlabel('t (s)','fontsize',12)

% plot  the data X (r=n=3 signals)
[n,m]=size(X);

figure
for i=1:n
    subplot(n,1,i)
    plot(t,X(i,:),'linewidth',1)
    grid
    ylim([-2 2])
    title(['x',num2str(i)])
    set(gca,'fontsize',12)
end
xlabel('t (s)','fontsize',12)

%% Exercise 2  Points 2 and 3 - Principal Component Analysis 

Cx=cov(X');     % covariance matrix of X
[V,D]=eig(Cx); % produces a diagonal matrix D of the eigenvalues of Cx and 
               % a full matrix V whose columns are the corresponding
               % eigenvectors. Note: the eigenvalues along the diagonal in D are in increasing order 
L=flipud(fliplr(D)); % In this way, L is a diagonal matrix containing
                     % the eigenvalues along the diagonal in decreasing order
F=fliplr(V);         % F contains the eigenvectors (in columns) associated to the eigenvalues in L

Y=F'*X;  % Y contains the three principal components of X(each row is a principal component)

% or you can replace the previous three instructions with
% F=V';
% Y=F'*X;
% Y=flipud(Y); % Y are ordered so that var(Y(1,:))>var(Y(2,:))>var(Y(3,:)) 

[n,m]=size(Y);

figure
for i=1:n
    subplot(n,1,i)
    plot(t,Y(i,:),'linewidth',1);
    set(gca,'fontsize',12)
    grid
    title(['PC',num2str(i)],'fontsize',12)
    ylim([-2 2])
end
xlabel('t (s)','fontsize',12)

% The PCs are very different from the original independent
% components S (each PC is still a linear combination of the three original components s1, s2, s3):
% the PCs are uncorrelated but not independent.
%% Exercise 2  Points 4 and 5- Obtain the demixing matrix of X using EEGLAB and compute the independent components

% First, save the datased X in a .mat file
% comment the save istruction after the first use

% save dataX_ex2.mat X 

% Before executing the steps below, it is necessary to use EEGLAB to
% estimate the demixing matrix of X. Import in EEGLAB the data cointained in dataX_ex2.mat.  
% Then apply the ICA by using the options
% 'extended',1,'bias','off','rndreset','no' 
% Finally, following the instructions in Laboratory_Exercise2.pdf, export the computed demixing matrix
% in a .txt file using  'File>Export>Weight matrix to text file'.
% Here, the demixing matrix obtained by EEGLAB was saved in
% matrixW_X_ex.2.txt 

load matrixW_X_ex2.txt

W=matrixW_X_ex2; %demixing matrix of X (is a 3 x 3 matrix)
IC=W*X;  % IC has size n x m (n=3); it contains the estimated independent components (each row is an IC).
% Note that here, to reconstruct the ICs, the demixing matrix must be
% applied to X, since the Independent Component Analysis in EEGLAB was applied to X

[n,m]=size(IC);
figure
for i=1:n
    subplot(n,1,i)
    plot(t,IC(i,:),'linewidth',1);
    set(gca,'fontsize',12)
    grid
    title(['IC',num2str(i)],'fontsize',12)
    ylim([-0.6 0.6])    
end
xlabel('t (s)','fontsize',12)

%% Exercise 2 Point 6 to 8 - Generate and plot the mixtures X (5 vars), compute and plot the PCs

A=[0.5 0.5 0.7      %the mixing matrix
   0.7 0.2 0.4
   0.2 0.7 -0.5
  -0.6 0.3 0.2
   0.1 -0.5 0.4];

X=A*S;      %the artificial data X generated by mixing  s1,s2,s3 via matrix A 
            %Being S centered, also X is centered (zero-mean)

% plot the data X (n=5 signals)
[n,m]=size(X);

figure
for i=1:n
    subplot(n,1,i)
    plot(t,X(i,:),'linewidth',1)
    grid
    ylim([-2 2])
    title(['x',num2str(i)])
    set(gca,'fontsize',12)
end
xlabel('t (s)','fontsize',12)

%%% Principal Component Analysis %%%
Cx=cov(X');     % covariance matrix of X
[V,D]=eig(Cx); % produces a diagonal matrix D of the eigenvalues of Cx and 
               % a full matrix V whose columns are the corresponding
               % eigenvectors. Note: the eigenvalues in D are in increasing order 
L=flipud(fliplr(D)); % In this way, L is a diagonal matrix containing
                     % the eigenvalues in decreasing order
F=fliplr(V);         % F contains the eigenvectors (in columns) associated to the eigenvalues in L

Y=F'*X;  % Y contains the five principal components (each row is a principal component)

% or you can replace the previous three instructions with
% F=V';
% Y=F'*X;
% Y=flipud(Y); % Y are ordered so that var(Y(1,:))>var(Y(2,:))>...>var(Y(5,:)) 

[n,m]=size(Y);
figure
for i=1:n
    subplot(n,1,i)
    plot(t,Y(i,:),'linewidth',1);
    set(gca,'fontsize',12)
    grid
    title(['PC',num2str(i)],'fontsize',12)
    ylim([-2 2])
end
xlabel('t (s)','fontsize',12)

% PCA is able to recognize that three PCs explain all the original dataset X.
% However, the first three PCs are still very different from the original independent
% components s1, s2, s3 (each PC is still a linear combination of the original s1, s2, s3 ):
% the PCs are uncorrelated but not independent. 

%% Exercise 2  Points 9 and 10- Obtain the demixing matrix of the first three PCs Y(1:3,:) using EEGLAB and compute the independent components

% First, save the first three PCs in a .mat file
% comment the save istruction after the first use
Y3=Y(1:3,:);
%save PC3_ex2.mat Y3  
% 
% Before executing the steps below, it is necessary to use EEGLAB to
% estimate the demixing matrix of Y3. Import in EEGLAB the data cointained in PC3_ex2.mat.  
% Then apply the ICA by using the options
% 'extended',1,'bias','off','rndreset','no'
% Finally, following the instructions in Laboratory_Exercise2.pdf, export the computed demixing matrix
% in a .txt file using  'File>Export>Weight matrix to text file'.
% Here, the demixing matrix obtained by EEGLAB was saved in
% matrixW_PC3_ex.2.txt 

load matrixW_PC3_ex2.txt

W=matrixW_PC3_ex2; %demixing matrix of Y3 (W is a 3 x 3 matrix)
IC=W*Y3;  % IC has size n x m (n=3); it contains the estimated independent components (each row is an IC).
% Note that here, to reconstruct the ICs, the demixing matrix must be
% applied to the three PCs (Y3), since the Independent Component Analysis in EEGLAB was applied to Y3

figure
for i=1:3
    subplot(3,1,i)
    plot(t,IC(i,:),'linewidth',1);
    set(gca,'fontsize',12)
    grid
    title(['IC',num2str(i)],'fontsize',12)
    ylim([-0.7 0.7])    
end
xlabel('t (s)','fontsize',12)

%% Exercise 2  Note - EEGLAB can perform internally PCA before ICA. The 5 vars X are imported in EEGLAB and PCA before ICA is applied

% First, save the datased X in a .mat file
% comment the save istruction after the first use

%save dataX5_ex2.mat X 

% Before executing the steps below, it is necessary to use EEGLAB to
% estimate the demixing matrix of X. Import in EEGLAB the data cointained in dataX5_ex2.mat.  
% Then apply the ICA by using the options
% 'extended',1,'bias','off','rndreset','no','PCA',3 
% The last option ('PCA',3) serves to compute a number of ICs (=3) smaller than the number
% of variables X (=5). This means that internally the EEGLAB algorithm 
% first applies a PCA to X, maintaining only the first three PCs, then
% applies the ICA to the three PCs. 
% Finally, export the computed demixing matrix
% in a .txt file using  'File>Export>Weight matrix to text file'.
% Here, the demixing matrix obtained by EEGLAB was saved in
% matrixW_X5_ex.2.txt 

load matrixW_X5_ex2.txt

W=matrixW_X5_ex2; %demixing matrix of X (is a 3 x 5 matrix)
IC=W*X;  % IC has size n x m (n=3); it contains the estimated independent components (each row is an IC).
% Note that here, to reconstruct the ICs, the demixing matrix must be
% applied to X, since the Independent Component Analysis in EEGLAB was applied to X

[n,m]=size(IC);
figure
for i=1:n
    subplot(n,1,i)
    plot(t,IC(i,:),'linewidth',1);
    set(gca,'fontsize',12)
    grid
    title(['IC',num2str(i)],'fontsize',12)
    ylim([-0.5 0.5])    
end
xlabel('t (s)','fontsize',12)




