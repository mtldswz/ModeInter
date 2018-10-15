
  !-----------振型插值程序，将结构网格振型插值到气动网格上，基于模态的气弹分析需要------------
  !-----------CFD网格要求给出需要插值的边界的网格，一般是物面网格；CSD网格要求给出计算或实验的振型控制点，及各阶振型，具体数据要求见说明----------
  !-----------针对一般情形，给出了两种常见情形的预处理，其他情况需要自己根据实际情况处理--------------------------------
  !*************************************************  Enjoy it!!***********************************************
    PROGRAM  RBF
    use RBF_DAT
    implicit none 
    INTEGER  I,J,K,NSTEP,WMD

    
!-----------------------------------预处理模块----------------------------------------


!-------------------------------------------------------------------------------------
    
     NSTEP=3
!--------------------------------读网格基本参数-------------------------------------    
    OPEN(1,FILE='wg.dat')
    READ(1,*) JDZS_CFD,element
    CLOSE(1)
    
    OPEN(2,FILE='MODE.DAT')
    READ(2,*) JDZS_CSD,ZXZS
    CLOSE(2)
    
    open(3,file='biaotou.dat')
    read(3,*) sec
    CLOSE(3)
    
    
     WMD=0
    DO i = 1,JDZS_CSD,NStep
       WMD=WMD+1
    ENDDO
    GSN=WMD
    
    write(*,*) '****************** Mode Interpolation with RBF Method ***********************'
    WRITE(*,*) '  The CFD grid is ',JDZS_CFD
    WRITE(*,*) '  The CSD grid is ',JDZS_CSD
    WRITE(*,*) '  The slected CSD grid is ',GSN
    
   
  !--------------------------------------分配空间---------------------------------- 
    allocate (ZBJD_CFD(3,JDZS_CFD)); ZBJD_CFD(:,:) = 0.
    allocate (LJ_CFD(4,ELEMENT)); LJ_CFD(:,:) = 0
    allocate (ZBJD_CSD(3,JDZS_CSD)); ZBJD_CSD(:,:) = 0.
    allocate (ZX_CSD(3*ZXZS,JDZS_CSD)); ZX_CSD(:,:) = 0. 
    allocate (ZX_CFD(3*ZXZS,JDZS_CFD)); ZX_CFD(:,:) = 0. 
    allocate (RBF_Temp(3*ZXZS)); rbf_temp(:) = 0. 
    allocate (GP(3,SEC)); GP(:,:) = 0.
    allocate (DD(SEC)); DD(:) = 0.
    
    allocate (RBF_xs(GSN,GSN)); RBF_xs(:,:) = 0.
    allocate (GSA(GSN,GSN)); GSA(:,:) = 0.
    allocate (RBF_right(3*ZXZS,GSN)); RBF_right(:,:) = 0.
    allocate (GSB(GSN)); GSB(:) = 0.
    allocate (RBF_slove(3*ZXZS,GSN)); RBF_slove(:,:) = 0.
    allocate (GSX(GSN)); GSX(:) = 0.
    
    
!----------------------------------读初始气动网格---------------------------------
    OPEN(1,FILE='wg.dat')
    READ(1,*) JDZS_CFD,element
    do i=1,JDZS_CFD
        read(1,*) ZBJD_CFD(1:3,i)
    enddo
    do j=1,element
       read(1,*) LJ_CFD(:,j)
    enddo
    close(1)
    
    open(1,file='biaotou.dat')
    read(1,*) sec
    do J=1,sec
        read (1,*) gp(1:3,J)
        DD(J)=GP(1,J)*GP(2,J)*GP(3,J)
    ENDDO
    CLOSE(1)
    
    
    
    !读振型网格
    open(1,file='mode.dat')
    read(1,*) jdzs_CSD,zxzs
    do i=1,jdzs_CSD
       read(1,*) XUHAO, zbjd_csd(1:3,i)
    enddo
    do i=1,zxzs
        read(1,*) 
        do j=1,jdzs_CSD
            read(1,*)xuhao, (zx_csd(k,j),k=((i-1)*3+1),((i-1)*3+3))
        enddo
    enddo
    close(1)
    
    open (1, file='zx_csd.dat')
     do i=1,jdzs_CSD
        write(1,"(45(e15.7))") zbjd_csd(1:3,i)
     enddo
     close(1)
    
!------------------------------------------------------------------------------------    
    Radi=maxval(abs(ZBJD_CSD(:,:)))*0.4

   
   !------------------------------------计算系数矩阵-------------------------------------------
    DO I=1,JDZS_CSD,NStep
        DO J=1,JDZS_CSD,NStep
            R1=(sqrt((ZBJD_CSD(1,I)-ZBJD_CSD(1,J))**2+(ZBJD_CSD(2,I)-ZBJD_CSD(2,J))**2+(ZBJD_CSD(3,I)-ZBJD_CSD(3,J))**2))/Radi
            IF (R1>=1.) THEN
                RBF_xs((I-1)/NStep+1,(J-1)/NStep+1)=0.
            ELSE
                RBF_xs((I-1)/NStep+1,(J-1)/NStep+1)=((1-R1)**4)*(4*R1+1)
            ENDIF
        ENDDO
    ENDDO 
    
    
!---------------------------------计算右端项-----------------------------------   
    DO I=1,JDZS_CSd,NStep
        RBF_right(:,(I-1)/NStep+1)=ZX_CSD(:,i)*0.05
    ENDDO
    

!-------------------------------------求解方程组--------------------------------
    DO K=1,3*ZXZS
        DO I=1,GSN
            DO J=1,GSN
                GSA(I,J)=RBF_xs(I,J)
            ENDDO
        ENDDO
        DO I=1,GSN
            GSB(I)=RBF_right(K,I)
        ENDDO
        CALL Gauss_Sedal()
        DO I=1,GSN
            RBF_slove(K,I)=GSX(I)
        ENDDO
    ENDDO 
        
    !收回不用数组的内存
    deallocate (GSA)
    deallocate (GSB)
    deallocate (GSX)
  
    !-------------------------------------------------气动振型插值---------------------------------------------
    do i = 1,jdzs_cfd
        RBF_temp(:)=0.
        do j=1,JDZS_CSD,NStep
           R2=(SQRT((ZBJD_CFD(1,i)-ZBJD_CSD(1,J))**2+(ZBJD_CFD(2,i)-ZBJD_CSD(2,J))**2+(ZBJD_CFD(3,i)-ZBJD_CSD(3,J))**2))/Radi
           ! R2= (.slqm.(ZB_JD0(:,JD_BJDYJD(i))-ZBJD_CSD(:,j)))/Radi
            if (R2>=1) then
                RRR=0.
            else
                RRR=((1-R2)**4)*(4*R2+1)
            endif
            RBF_Temp(:)=RBF_Temp(:)+RBF_slove(:,(j-1)/NStep+1)*RRR
        enddo
        
        ZX_CFD(:,i)=RBF_temp(:)  
    enddo
  
    
!! 做振型局部调整！！！！
   !DO i=1,JDZS_CFD
   !     !IF ((ZBJD_CFD(2,I)<2.968) .AND. (ZBJD_CFD(2,I)<(1.953*ZBJD_CFD(1,I)-20.027)) .AND. (ZBJD_CFD(2,I)>(-0.0598*ZBJD_CFD(1,I)+1.575))) THEN
   !     IF (ZBJD_CFD(2,I)>-0.01)  THEN
   !         ZX_CFD(:,I)=ZX_CFD(:,I)
   !     ELSE
   !         ZX_CFD(:,I)=0.
   !     ENDIF
   ! ENDDO
   
    
    
     
!振型输出
open(1,file='mode.plt')
do i=1,jdzs_cfd
    write(1,"(45(e15.7))") zbjd_cfd(:,i),zx_cfd(:,i)
enddo
do j=1,element
    write(1,*) lj_cfd(:,j)
enddo
close(1)

DDD=0
OPEN(1, file='mode_3d_shape.dat')
do i=1,sec
    write(1,*) 'ZONE T="aesurf1_mode1.p3d:',i,'"'
    write(1,*) 'STRANDID=0, SOLUTIONTIME=0'
    write(1,*) 'I=',GP(1,i),', J=',GP(2,I), ', K=', GP(3,I), ', ZONETYPE=Ordered'
    write(1,*) 'DATAPACKING=POINT'
    write(1,*) 'DT=(SINGLE SINGLE SINGLE)'
   
    DO J=DDD+1,DDD+DD(I)
        WRITE(1,"(18(e15.7))") zbjd_cfd(1:3,J),zx_cfd(:,J)
    ENDDO
    
   !WRITE(1,"(3(e15.7))") zbjd_cfd(1:3,DDD+1:DDD+DD(I))+zx_cfd(1:3,DDD+1:DDD+DD(I))
       DDD=DDD+DD(I)
ENDDO
CLOSE(1)

DDD=0
OPEN(1, file='mode_3d_1.dat')
do i=1,sec
    write(1,*) 'ZONE T="aesurf1_mode1.p3d:',i,'"'
    write(1,*) 'STRANDID=0, SOLUTIONTIME=0'
    write(1,*) 'I=',GP(1,i),', J=',GP(2,I), ', K=', GP(3,I), ', ZONETYPE=Ordered'
    write(1,*) 'DATAPACKING=POINT'
    write(1,*) 'DT=(SINGLE SINGLE SINGLE)'
   
    !DO J=DDD+1,DDD+DD(I)
    !    WRITE(1,"(27(e15.7))") zbjd_cfd(1:3,J),zx_cfd(:,J)
    !ENDDO
    !
   WRITE(1,"(3(e15.7))") zbjd_cfd(1:3,DDD+1:DDD+DD(I))+zx_cfd(1:3,DDD+1:DDD+DD(I))
       DDD=DDD+DD(I)
ENDDO
CLOSE(1)

DDD=0
OPEN(1, file='mode_3d_2.dat')
do i=1,sec
    write(1,*) 'ZONE T="aesurf1_mode1.p3d:',i,'"'
    write(1,*) 'STRANDID=0, SOLUTIONTIME=0'
    write(1,*) 'I=',GP(1,i),', J=',GP(2,I), ', K=', GP(3,I), ', ZONETYPE=Ordered'
    write(1,*) 'DATAPACKING=POINT'
    write(1,*) 'DT=(SINGLE SINGLE SINGLE)'
   
    !DO J=DDD+1,DDD+DD(I)
    !    WRITE(1,"(27(e15.7))") zbjd_cfd(1:3,J),zx_cfd(:,J)
    !ENDDO
    !
   WRITE(1,"(3(e15.7))") zbjd_cfd(1:3,DDD+1:DDD+DD(I))+zx_cfd(4:6,DDD+1:DDD+DD(I))
       DDD=DDD+DD(I)
ENDDO
CLOSE(1)

DDD=0
OPEN(1, file='mode_3d_3.dat')
do i=1,sec
    write(1,*) 'ZONE T="aesurf1_mode1.p3d:',i,'"'
    write(1,*) 'STRANDID=0, SOLUTIONTIME=0'
    write(1,*) 'I=',GP(1,i),', J=',GP(2,I), ', K=', GP(3,I), ', ZONETYPE=Ordered'
    write(1,*) 'DATAPACKING=POINT'
    write(1,*) 'DT=(SINGLE SINGLE SINGLE)'
   
    !DO J=DDD+1,DDD+DD(I)
    !    WRITE(1,"(27(e15.7))") zbjd_cfd(1:3,J),zx_cfd(:,J)
    !ENDDO
    !
   WRITE(1,"(3(e15.7))") zbjd_cfd(1:3,DDD+1:DDD+DD(I))+zx_cfd(7:9,DDD+1:DDD+DD(I))
       DDD=DDD+DD(I)
ENDDO
CLOSE(1)

DDD=0
OPEN(1, file='mode_3d_4.dat')
do i=1,sec
    write(1,*) 'ZONE T="aesurf1_mode1.p3d:',i,'"'
    write(1,*) 'STRANDID=0, SOLUTIONTIME=0'
    write(1,*) 'I=',GP(1,i),', J=',GP(2,I), ', K=', GP(3,I), ', ZONETYPE=Ordered'
    write(1,*) 'DATAPACKING=POINT'
    write(1,*) 'DT=(SINGLE SINGLE SINGLE)'
   
    !DO J=DDD+1,DDD+DD(I)
    !    WRITE(1,"(27(e15.7))") zbjd_cfd(1:3,J),zx_cfd(:,J)
    !ENDDO
    !
   WRITE(1,"(3(e15.7))") zbjd_cfd(1:3,DDD+1:DDD+DD(I))+zx_cfd(10:12,DDD+1:DDD+DD(I))
       DDD=DDD+DD(I)
ENDDO
CLOSE(1)

DDD=0
OPEN(1, file='mode_3d_5.dat')
do i=1,sec
    write(1,*) 'ZONE T="aesurf1_mode1.p3d:',i,'"'
    write(1,*) 'STRANDID=0, SOLUTIONTIME=0'
    write(1,*) 'I=',GP(1,i),', J=',GP(2,I), ', K=', GP(3,I), ', ZONETYPE=Ordered'
    write(1,*) 'DATAPACKING=POINT'
    write(1,*) 'DT=(SINGLE SINGLE SINGLE)'
   
    !DO J=DDD+1,DDD+DD(I)
    !    WRITE(1,"(27(e15.7))") zbjd_cfd(1:3,J),zx_cfd(:,J)
    !ENDDO
    !
   WRITE(1,"(3(e15.7))") zbjd_cfd(1:3,DDD+1:DDD+DD(I))+zx_cfd(13:15,DDD+1:DDD+DD(I))
       DDD=DDD+DD(I)
ENDDO
CLOSE(1)

        
    !释放内存
    deallocate (RBF_xs)
    deallocate (RBF_right)
    deallocate (RBF_slove)
  
   
    
END




subroutine GAUSS_Sedal()
    use RBF_DAT
    implicit none
    
    !!需要继续修改-------------------------------------
    INTEGER K,I,J,IS,JS(GSN)
     
    REAL*8 T,D
    
  !  WRITE(*,*) GSA(:,:)
    
    DO K=1,GSN-1
      !全选主元法，从右下角n-k+1阶子阵中选取绝对值最大的元素
      D=0.
      DO I=K,GSN
         DO J=K,GSN
            IF(ABS(GSA(I,J)) > D) THEN
               D=ABS(GSA(I,J))
               JS(K)=J             ! 记下最大数值的列数
               IS=I                ! 记下最大数值的行数
            ENDIF
         ENDDO
      ENDDO
  
      IF(D == 0.0) THEN
        WRITE(*,*) 'fail'
        STOP         
      ELSE
          !对行进行变换
        IF (JS(K) /= K) then
          DO I=1,GSN               
            T=GSA(I,K)
            GSA(I,K)=GSA(I,JS(K))
            GSA(I,JS(K))=T
          ENDDO
        ENDIF
      !对行做出调整
        IF(IS /= K) THEN
          DO J=K,GSN       
           T=GSA(K,J)       
           GSA(K,J)=GSA(IS,J)
           GSA(IS,J)=T
          ENDDO
!对b数组做出对应的调整
         T=GSB(K)
         GSB(K)=GSB(IS)
         GSB(IS)=T
        ENDIF
      ENDIF
      
      !高斯消元法的核心变换
      DO I=K+1,GSN
         GSA(I,K)=GSA(I,K)/GSA(K,K)
      ENDDO
  
      DO I=K+1,GSN
         DO J=K+1,GSN
            GSA(I,J)=GSA(I,J)-GSA(I,K)*GSA(K,J)
         ENDDO
         GSB(I)=GSB(I)-GSA(I,K)*GSB(K)
      ENDDO
    ENDDO   ! 结束最外层循环
  
! 回代
    GSX(GSN)=GSB(GSN)/GSA(GSN,GSN)
    DO I=GSN-1,1,-1
       T=0
       DO J=I+1,GSN
          T=T+GSA(I,J)*GSX(J)
       ENDDO
          GSX(I)=(GSB(I)-T)/GSA(I,I)
    ENDDO
! 由于在全主元法中进行了列变换，所以最后应对x（i）进行对应的调整
    DO K=GSN-1,1,-1
       IF (JS(K) /= K) THEN
          T=GSX(K)
          GSX(K)=GSX(JS(K))
          GSX(JS(K))=T
        ENDIF
    ENDDO




END subroutine GAUSS_Sedal