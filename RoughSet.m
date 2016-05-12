%Data2为条件属性, decision2为决策属性

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                 主函数                                    %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;

% 读取信息系统文件
% 读取文件信息, 每一行为一个胞元
file = textread('data2.txt','%s','delimiter','\n','whitespace','');

% 胞元的大小
[m,n]=size(file);

for i=1:m
% 读取每个胞元中字符，即分解胞元为新的胞元
  words=strread(file{i},'%s','delimiter',' ');
  % 转置
  words=words';
  X{i}=words;
end
% X信息系统
X=X';

% 信息系统的约简
[B,num,AT]=my_reduct(X);
%信息系统的不可等价关系
ind_AT=ind(X);
%显示约简信息系统
disp('约简后的条件系统为：');
[m,n]=size(B);
for i=1:m
  disp(B{i});
end

%读取决策系统文件
file = textread('decision2.txt','%s','delimiter','\n','whitespace','');
[m,n]=size(file);
for i=1:m
  words=strread(file{i},'%s','delimiter',' ');
  words=words';
  D{i}=words;
end D=D';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%决策系统的正域约简
X_D=X;
[l,k]=size(X_D{1});
pos_d=pos(X_D,D);%正域
for  i=1:m
%%%%%%%%%%%%%% 正 域 有 问 题%%%%%%%%%%%%%%%%%%%%%%%%%%%
  if(~ismember(num(i),pos_d))
    B{i}='';%若约简后的信息系统B{i}不在正域中则删除该行
  end
  %因为相同的条件得到的决策不一样
end


%将在正域规则下约简过的信息系统B连接决策系统D
[m,n]=size(B);
for i=1:m
  if(~isequal(B{i},''))
    B{i}{1,k+1}=D{i}{1};
  end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%显示约简决策系统
disp('约简后的决策系统为：');
[m,n]=size(B);
for i=1:m
  disp(B{i});
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                 辅助函数                                  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ind()寻找不可分辨关系
function yy=ind(X)
[m,n]=size(X);
% 计数器
k=1;
% 创建不可等价关系变量
ind_AT=cell(m,1);

for i=1:m
  %潜在问题，如i=m是终止循环，此时若最后一行不为空的话，将漏扫
  for j=(i+1):m
    %若X{i}不为空
    if(~isequal(X{i},''))
      %不可等价关系赋初值
      ind_AT{k}=union(ind_AT{k},i);
        if(isequal(X{i},X{j}))
          %若X{i}==X{j},则删除X{j}
          X{j}='';
          %寻找不可等价关系
          ind_AT{k}=union(ind_AT{k},j);
       end
     end
   end
   k=k+1;
end

--------------------------------------------------------------------------------
% my_reduct函数实现, y为约简后的cell数组，reduct_attr为可约去的属性 %X为行向量（元素为胞元）
function [C,num,reduct_attr]=my_reduct(X)
clc;
% 约简
[m,n]=size(X);
[p,k]=size(X{1});

% 寻找不可等价关系
ind_AT=ind(X);
% 可约去的的属性初始化
reduct_attr=[];
% 约简后的信息对应的个体
num=zeros(m,1);

for i=1:k
  B=delete_AT(X,i);
  %若IND(AT-{a}=IND(AT)
  if(isequal(ind_AT,ind(B))
    %则寻找到可约去的属性
    reduct_attr=union(reduct_attr,i);
    X=B;
  end
end

% 剔除重复的行
k=1;
for i=1:m
  if(~isequal(ind_AT{i},[]))
    C_i=ind_AT{i,1}(1);
    num(k)=i;
    %返回约简后的信息系统
    C{k,1}=X{C_i};
    k=k+1;
  end
end

--------------------------------------------------------------------------------
% delete_AT函数的源代码, 删除X中第i列的属性值
function y=delete_AT(X,ATi)
[m,n]=size(X);
[l,k]=size(X{1});
for i=1:m
  X{i}{ATi}='';
end
y=X;
--------------------------------------------------------------------------------
% pos函数实现, 求决策系统的正域函数 %X为条件属性，D为决策属性

function pos_d=pos(X,D)
% 求决策属性D的不可等价关系
ind_D=ind(D);
[m,n]=size(ind_D);
% 求信息系统属性X的不可等价关系
ind_X=ind(X);
% 存储正域个体的编号
low=[];
for i=1:m
  for j=1:m
    if(~isequal(ind_X{i},[])&&~isequal(ind_D{j},[]))
      if(ismember(ind_X{i},ind_D{j}))
        % 由性质Pos_AT(d)=low_AT(X1)Ulow_AT(X2)U...
          low=union(low,ind_X{i});
      end
    end
  end
end
pos_d=low;
