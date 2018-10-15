MODULE RBF_DAT
    
    
REAL*8, ALLOCATABLE,SAVE :: ZBJD_CSD(:,:),ZBJD_CFD(:,:),ZX_CSD(:,:),ZX_CFD(:,:),RBF_Temp(:)
    
REAL*8, ALLOCATABLE,SAVE :: GSA(:,:),GSB(:),GSX(:)           !高传强改 2013.9.30
real*8, allocatable, SAVE:: RBF_xs(:,:), RBF_right(:,:),RBF_slove(:,:)
REAL*8,SAVE :: RADI,R1,R2,RRR

INTEGER, SAVE :: GSN,JDZS_CSD,JDZS_CFD,ELEMENT,ZXZS,XUHAO,SEC,DDD   !高传强改 2013.9.30

INTEGER, ALLOCATABLE,SAVE :: LJ_CFD(:,:),GP(:,:),DD(:)
   
    
    
end MODULE RBF_DAT