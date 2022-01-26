clc;
clear all;
close all;
% m = [3.5 3.8];
% sigma = [0.1 0;0 0.2];
% x1=mgd(20,2,m,sigma);
% 
% m = [5 5];
% sigma = [0.1 0;0 0.2];
% x2=mgd(20,2,m,sigma);
% 
%   m = [2.0 2.5];
%   sigma = [1 0;0 1];
%   x3=mgd(20,2,m,sigma);

% m=[35 35];
% sigma=[100 0 ; 0 100]
% x4=mgd(20,2,m,sigma);
load agg.txt
     data=agg(:,1:end-1);
     C=agg(:,end);

% subplot(2,1,1)
% figure(1)
% plot(data(:,1),data(:,2),'.');
% xlabel('x1')
% ylabel('x2')
% 
% title('PFCM')
%  axis([0 8 0 8])
[mx,nx]=size(data);
cluster_n=6;
options = [2;	% exponent for the partition matrix U
		100;	% max. number of iteration
		1e-5;	% min. amount of improvement
		1];	% info display during iteration 
    
expo = options(1);		% Exponent for U
max_iter = options(2);		% Max. iteration
min_impro = options(3);		% Min. improvement
display = options(4);	% Display info or not

 % FCM Clustering
X1=ones(mx,1);
obj_fcn = zeros(max_iter, 1);	% Array for objective function
obj_fcn1 = zeros(max_iter, 1);

% initialize partition matrix

U=rand(cluster_n,mx);
col_sum=sum(U);
U=U./col_sum(ones(cluster_n,1),:);
% compute the cluster prototypes
for i= 1 : max_iter
mf = U.^expo; sumf = sum(mf');
v = (mf*data)./(sumf'*ones(1,nx));

% compute the distances

for j = 1 : cluster_n,
    xv = data - X1*v(j,:);
    d(:,j) = sum((xv*eye(nx).*xv),2);
end;
  distout=sqrt(d);
  obj_fcn(i) = sum(sum(mf.*d'));
  if display, 
		fprintf('Iteration count = %d, obj. fcn = %f\n', i, obj_fcn(i));
    end
  if i > 1,
		if abs(obj_fcn(i) - obj_fcn(i-1)) < min_impro, break; end,
    end
  
  % Update the partition matrix
  d = (d+1e-10).^(-1/(expo-1));
  
  U1 = (d ./ (sum(d,2)*ones(1,cluster_n)));
  U=U1';
end






% hold on;
% plot(v(:,1),v(:,2),'gd')
% hold on;
%vi=[3.34  0 ;-3.34  0 ];
%plot(vi(:,1),vi(:,2),'k*')

% possibilistic fuzzy c-means clustering

a=1;b=2;eta=3;
t1=rand(cluster_n,mx);
col_sum=sum(t1);
t1=t1./col_sum(ones(cluster_n,1),:);

for k=1:max_iter
t=t1.^eta;mf=U.^expo;
%for i=1:cluster_n
 %   temp1=0;sum1=0;
  %  for j=1:mx
   %     temp=a*mf(j,i)+b*t(i,j);
    %    sum1=temp+sum1;
     %   temp1=temp.*data(j,:)+temp1;
     %end
    %v1(i,:)=temp1./sum1;
    %end
 mf1=mf+t;   sumf1= sum(mf1');
 v1 = (mf1*data)./(sumf1'*ones(1,nx));   
for j = 1 : cluster_n,
    xv = data - X1*v1(j,:);
    dx(:,j) = sum((xv*eye(nx).*xv),2);
end; 
 %gamma=sum(mf.*dx',2)./sum(mf,2);
 %const=repmat(gamma',mx,1);
 %temp=(1-t1).^eta;
 %temp1=gamma.*sum(temp,2);
 obj_fcn1(k)=sum(sum(mf1'.*dx));
 if display, 
		fprintf('Iteration count = %d, obj. fcn = %f\n', k, obj_fcn1(k));
    end
  if k > 1,
		if abs(obj_fcn1(k) - obj_fcn1(k-1)) < min_impro, break; end,
    end
 dx = (dx+1e-10).^(-1/(expo-1));
  
  t2 = (dx ./ (sum(d,2)*ones(1,cluster_n)));
  t1=t2';   
  
 %temp2 = (b*(dx+1e-10)./repmat(gamma',mx,1)).^(1/(eta-1));
 %t2=1./(1+temp2);
 %t1=t2';
 %dx = (dx).^(-1/(expo-1));
 %U2 = (dx ./ (sum(dx,2)*ones(1,cluster_n)));  
 %U=U2';
end
% hold on
% plot(v1(:,1),v1(:,2),'b.')
% subplot(2,1,2)

%Assignment for classification
[d1,d2]=max(U);
Cc=[];
for i=1:cluster_n
    Ci=C(find(d2==i));
    dum1=hist(Ci,1:cluster_n);
    [dd1,dd2]=max(dum1);
    Cc(i)=dd2;
end
% %%%%%a
for i=1:max(C)
    
    index=find(C==i);
    count(i)=prod(size((index)));   
    err=(Cc(d2(index))~=i);
    eindex=find(err);
    misclass(i)=sum(err);
   
end 
misclass


% ACCURACY AND ERROR
sum1=0;
sume=0;
for i=1:max(C)
    countc(i)=count(i)-misclass(i);
    sum1=sum1+countc(i);
    sume=sume+misclass(i);
end
for i=1:cluster_n
         fprintf('No. of data points in cluster %d= %d\n',i,countc(i));
end
accuracy=(sum1/mx)*100;
fprintf('Accuracy= %f%%\n\n',accuracy);
error=(sume/mx)*100;
fprintf('Error Rate= %f%%\n\n',error);

A=sum(misclass)
s=silhouette(x,d2');
S=mean(s)
u=d2;v=C;
[sse] = clus_sse(d2,x,v);

Randindex=adjrand(u,v);
Norm=nmi1(u,v')
table = [A  S Randindex Norm sum(sse) accuracy];
	colnam = {'Total Misclassification','Silhouette','Rand Index','NMI','SSE', 'Accuracy'};
	h = figure('Name','Metrics','NumberTitle','off','Position',[200 200 400 150]);
	rownam = {'FCM'};
	uitable('Parent',h,'Data',table,'ColumnName',colnam,'RowName',rownam,'Position',[20 20 360 130]);
        
