%% ϸ������ͼ��չʾ
%���ݰ���1 data/2 data/3 data����
%���������Ϊȥ���� ȥ��һ�е�����

% ��ȡ��ǰ�ļ���������dat��ʽ���ļ�
filename=dir('*.dat');
numfile=length(filename);%�����ļ�����
firsttype=filename(1).name(end-7:end-4);%��һ�µ�һ���ļ�������
mkdir(cd,'temp');%�½��ļ����Ա����µ�����
allInt=struct('data1',[],'data2',[],'data3',[]); %��ͨ��

for i=1:3
 %��ȡ����
   IntID=filename(i).name;
   Int=load(IntID);  
   
 %���ݴ���
  finalInt=Int(:,2:end);%ɾ����һ�е�����
  sizefinal=size(finalInt);%��ɾ�������ݵ�������
  finalInt2=finalInt';%reshapeΪ�б任��������ת��
  tmp=reshape(finalInt2,sizefinal(1,1)*sizefinal(1,2),1);
  test=[0;tmp;0];%�����ж�������
  test2=test;
 %ȥ�쳣�����ѭ���ж�
for w=2:(sizefinal(1,1)*sizefinal(1,2)+1)
    meanl=(test(w-1)+test(w+1))/2;
    if (test(w)>meanl*8)
        test2(w)=meanl;
    end
end
  final=test2(2:end-1);%�õ�ȥ����������������
  finalInt=reshape(final,sizefinal(1,2),sizefinal(1,1))';%��ԭԭ����
  
 %��������
 IntSavePath=[cd,'/temp/',IntID];
 save (IntSavePath, '-ascii', '-double','finalInt');

 %�����������һ������
    if i==1
     allInt.data1=finalInt;
   elseif i==2
     allInt.data2=finalInt;
   elseif i==3
     allInt.data3=finalInt;
   end  %�����һ�����ݵ�allInt
end

%��ͼ������ͼ��
 %��һ������
  data1Max = max(max(allInt.data1));
  data2Max = max(max(allInt.data2));
  data3Max = max(max(allInt.data3));
  allInt.data1 = 1.25*allInt.data1/data1Max; %�����ʵ�����2 ������������� ����������� ��ͬ
  allInt.data2 = 1.25*allInt.data2/data2Max;
  allInt.data3 = 1.25*allInt.data3/data3Max;

 %ͼ�����1023*0.09 �� 256*0.36
  allInt.data1 = imresize(allInt.data1,[921,922]);%920.7:921.6=1023:1024
  allInt.data2 = imresize(allInt.data2,[921,922]);
  allInt.data3 = imresize(allInt.data3,[921,922]);
  a = zeros(921,922);  
  %1 data
  A(:,:,1) = allInt.data1;
  A(:,:,2) = a;
  A(:,:,3) = a;
  imshow(A);
  print(gcf,'-dtiff','488');   %����ͼ��
  %2 data
  B(:,:,1) = a;
  B(:,:,2) = allInt.data2;
  B(:,:,3) = a;
  imshow(B);
  print(gcf,'-dtiff','561');   %����ͼ��
  %3 data
  C(:,:,1) = a;
  C(:,:,2) = a;
  C(:,:,3) = allInt.data3;
  imshow(C);
  print(gcf,'-dtiff','640');   %����ͼ��
  %allData
  D= A+B+C;
  imshow(D);
  print(gcf,'-djpeg','Merge');   %����ͼ��

  %ɾ��������ļ���
  rmdir('temp','s')

  %��ԭ�е�Data����ͳһ��Odata�ļ����±��ڹ���
 mkdir(cd,'OData')
 movefile('*.dat','OData','f')