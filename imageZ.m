%% 细胞成像图象展示
%数据按照1 data/2 data/3 data处理
%输出新数据为去亮点 去第一列的数据

% 读取当前文件下下所有dat格式的文件
filename=dir('*.dat');
numfile=length(filename);%计数文件个数
firsttype=filename(1).name(end-7:end-4);%看一下第一个文件部分名
mkdir(cd,'temp');%新建文件夹以保存新的数据
allInt=struct('data1',[],'data2',[],'data3',[]); %三通道

for i=1:3
 %读取数据
   IntID=filename(i).name;
   Int=load(IntID);  
   
 %数据处理
  finalInt=Int(:,2:end);%删掉第一列的数据
  sizefinal=size(finalInt);%求删掉后数据的行列数
  finalInt2=finalInt';%reshape为列变换，所以先转置
  tmp=reshape(finalInt2,sizefinal(1,1)*sizefinal(1,2),1);
  test=[0;tmp;0];%构建判断列向量
  test2=test;
 %去异常亮点的循环判断
for w=2:(sizefinal(1,1)*sizefinal(1,2)+1)
    meanl=(test(w-1)+test(w+1))/2;
    if (test(w)>meanl*8)
        test2(w)=meanl;
    end
end
  final=test2(2:end-1);%得到去亮点后的列向量数据
  finalInt=reshape(final,sizefinal(1,2),sizefinal(1,1))';%还原原矩阵
  
 %保存数据
 IntSavePath=[cd,'/temp/',IntID];
 save (IntSavePath, '-ascii', '-double','finalInt');

 %数据输出至下一步计算
    if i==1
     allInt.data1=finalInt;
   elseif i==2
     allInt.data2=finalInt;
   elseif i==3
     allInt.data3=finalInt;
   end  %保存归一化数据到allInt
end

%画图并保存图像
 %归一化数据
  data1Max = max(max(allInt.data1));
  data2Max = max(max(allInt.data2));
  data3Max = max(max(allInt.data3));
  allInt.data1 = 1.25*allInt.data1/data1Max; %可以适当乘以2 以提高整体亮度 过大整体很亮 下同
  allInt.data2 = 1.25*allInt.data2/data2Max;
  allInt.data3 = 1.25*allInt.data3/data3Max;

 %图像调整1023*0.09 和 256*0.36
  allInt.data1 = imresize(allInt.data1,[921,922]);%920.7:921.6=1023:1024
  allInt.data2 = imresize(allInt.data2,[921,922]);
  allInt.data3 = imresize(allInt.data3,[921,922]);
  a = zeros(921,922);  
  %1 data
  A(:,:,1) = allInt.data1;
  A(:,:,2) = a;
  A(:,:,3) = a;
  imshow(A);
  print(gcf,'-dtiff','488');   %保存图像
  %2 data
  B(:,:,1) = a;
  B(:,:,2) = allInt.data2;
  B(:,:,3) = a;
  imshow(B);
  print(gcf,'-dtiff','561');   %保存图像
  %3 data
  C(:,:,1) = a;
  C(:,:,2) = a;
  C(:,:,3) = allInt.data3;
  imshow(C);
  print(gcf,'-dtiff','640');   %保存图像
  %allData
  D= A+B+C;
  imshow(D);
  print(gcf,'-djpeg','Merge');   %保存图像

  %删除缓存的文件夹
  rmdir('temp','s')

  %将原有的Data数据统一到Odata文件夹下便于管理
 mkdir(cd,'OData')
 movefile('*.dat','OData','f')