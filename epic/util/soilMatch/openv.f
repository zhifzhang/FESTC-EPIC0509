
      SUBROUTINE OPENV( NUM, FNAM, DIR, MODE )
!     VERIFIES THE EXISTENCE OF A FILE BEFORE OPENING IT

      CHARACTER(*), INTENT  (IN) ::DIR
      CHARACTER(*), INTENT  (IN) ::FNAM
      CHARACTER*1,  INTENT  (IN) ::MODE
      CHARACTER*300                FULLFNM
      CHARACTER*300                TDIR
      LOGICAL::XMIS

C..Output files directories
      TDIR=ADJUSTL(DIR)
C     FNM=ADJUSTR(TDIR)//ADJUSTL(FNAM)
      FULLFNM=TRIM(DIR)//'/'//ADJUSTL(FNAM)
C     print*, "DIR: ", NUM, FULLFNM
      INQUIRE(FILE=FULLFNM,EXIST=XMIS)

C     OPEN(NUM,FILE=TRIM(FULLFNM))
      IF( XMIS==.TRUE. .AND. MODE == 'R')THEN
          OPEN(NUM, FILE=TRIM(FULLFNM))
      ELSE IF ( XMIS==.FALSE. .AND. MODE == 'R' ) THEN
          WRITE(*,'(/A/)') 'File '//trim(FULLFNM)//' is missing.'
          CALL EXIT(1)

      ELSE IF( XMIS==.FALSE. .AND. MODE == 'W')THEN
          OPEN(NUM, FILE=TRIM(FULLFNM))

C     ELSE IF ( XMIS==.TRUE. .AND. MODE == 'W')THEN
C         WRITE(*,'(/A/)') 'File '//trim(FULLFNM)//' is already exist.'
C         CALL EXIT(1)
      ELSE
          OPEN(NUM, FILE=TRIM(FULLFNM))
      END IF

      RETURN
      END

