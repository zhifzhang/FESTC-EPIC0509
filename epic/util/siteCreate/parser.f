C***********************************************************************
C   Portions of Models-3/CMAQ software were developed or based on      *
C   information from various groups: Federal Government employees,     *
C   contractors working on a United States Government contract, and    *
C   non-Federal sources (including research institutions).  These      *
C   research institutions have given the Government permission to      *
C   use, prepare derivative works, and distribute copies of their      *
C   work in Models-3/CMAQ to the public and to permit others to do     *
C   so.  EPA therefore grants similar permissions for use of the       *
C   Models-3/CMAQ software, but users are requested to provide copies  *
C   of derivative works to the Government without restrictions as to   *
C   use by others.  Users are responsible for acquiring their own      *
C   copies of commercial software associated with Models-3/CMAQ and    *
C   for complying with vendor requirements.  Software copyrights by    *
C   the MCNC Environmental Modeling Center are used with their         *
C   permissions subject to the above restrictions.                     *
C***********************************************************************

C***********************************************************************
C   routines for parsing a delimited text record
C***********************************************************************

C  Return the nth field of record
      Subroutine getField( record, delimiter, nth, field )

      CHARACTER*(*) record
      CHARACTER*(1) delimiter
      Integer nth
      CHARACTER*(*) field

      Integer nfields
      Integer i, pos1

      ! if delimiter is space, use method 2
      if( delimiter.eq.' ' ) then
        call getField2( record, delimiter, nth, field )
        call RightTrim(field)
        return
        endif
  
      pos1 = 1
      nfields = 0
      field = ''
      Do i=1, LEN(record)
       if( record(i:i) .eq. delimiter ) then
         nfields = nfields+1 
         if( nfields .eq. nth ) then
           if(pos1.lt.i) field = record(pos1:i-1)
           call RightTrim(field)
           return
           Endif
         pos1 = i+1
         Endif
       Enddo

      nfields = nfields+1 

      ! check if last field
      if( nfields .eq. nth ) then
        field = record(pos1:)
        Endif

      Call RightTrim(field)
      Return
      End
        
C  Return the nth field in record (method 2)
C  this method considers duplicate delimiters as one
C
      Subroutine getField2( record, delimiter, nth, field )
 
      CHARACTER*(*) record
      CHARACTER*(*) delimiter
      Integer nth
      CHARACTER*(*) field
 
      Integer nfields
      Integer i, pos1
      Logical infield
      Logical isDel
 
      nfields = 0
      field = ''
      infield = .false.
      Do i=1,LEN(record)
        isDel = (record(i:i).eq.delimiter)
 
         ! check for start of field
         if( .NOT.infield .and. .NOT.isDel ) then   
           nfields = nfields+1
           pos1 = i
           infield = .true.
           endif
 
        ! check for end of field
        if( infield .and. isDel ) then
          infield = .false.
          endif
 
        ! if end of nth field, return
        if( nfields.eq.nth .and. .not.infield ) then
          if(pos1.lt.i) field = record(pos1:i-1)
          return
          endif
        enddo
 
      ! check for last field
      if( nfields.eq.nth ) field = record(pos1:)
 
      Return
      End

  
C  Return the nth field of record
      Subroutine getParsedField(record, delimiter, nth, field, inDel)

      CHARACTER*(*) record
      CHARACTER*(*) delimiter
      Integer nth
      CHARACTER*(*) field
      Logical inDel 

      Integer nfields
      Integer i, pos1
  
      pos1 = 1
      nfields = 0
      field = ''
      Do i=1, LEN(record)
       if( index(delimiter,record(i:i)) .gt. 0 ) then
         nfields = nfields+1 
         if( nfields .eq. nth ) then
           if( pos1.lt.i ) field = record(pos1:i-1)
           return
           Endif

         ! define starting point of next field
         pos1 = i+1
         if( inDel ) pos1 = i
         
         Endif
       Enddo

      nfields = nfields+1 

      ! check if last field
      if( nfields .eq. nth ) then
        field = record(pos1:)
        Endif

      Return
      End
    
C****************************************************************************
C  routine to remove leading blank spaces from Character String
C****************************************************************************
      Subroutine LeftTrim( STRING )

      CHARACTER*(*) STRING
      Integer I

      Do I=1,LEN(STRING)
        if(STRING(I:I) .ne. CHAR(32)) Then
          STRING = STRING(I:)
          RETURN
          EndIf 
         EndDo

      Return
      End Subroutine LeftTrim

C****************************************************************************
C  routine to remove trailing white spaces from Character String
C****************************************************************************
      Subroutine RightTrim( STRING )
 
      CHARACTER*(*) STRING
      Integer I
 
      Do I=LEN(STRING),1,-1
        if(STRING(I:I) .lt. CHAR(32)) STRING(I:I) = CHAR(32)
        if(STRING(I:I) .gt. CHAR(32)) Exit
        EndDo

      Return
      End Subroutine RightTrim


C****************************************************************************
C  routine to remove quotation marks from character field
C****************************************************************************
      Subroutine rmQuots( string )
 
      Implicit none
      
      ! arguments                                                                      
      Character*(*) string
 
      Integer last, i
 
                    
      call LeftTrim(string)
      last = LEN_TRIM(string)

      ! check for blank string
      if( last.le.0 ) return
 
      ! if no quot marks, return
      if( string(1:1).ne.'"' .and. string(last:last).ne.'"') return
 
      ! remove last quot mark
      string(last:last) = ' '
            
      do i=1,last-1
        string(i:i) = string(i+1:i+1)
        enddo      
                    
      Return                                                                           
      End Subroutine rmQuots 

C****************************************************************************
C  routine to remove commas within quotation marks
C****************************************************************************
      Subroutine rmCommas( string )

      Implicit none

      ! arguments
      Character*(*) string

      Integer last, i
      Logical infield

      ! if no quot marks, return
      if( index(string, '"').le.0 ) return

      call LeftTrim(string)
      last = LEN_TRIM(string)

      ! check for blank string
      if( last.le.0 ) return
 
      infield = .false.

      do i=1,last
        if(string(i:i).eq.'"') infield = .NOT.infield 

        if( infield .and. string(i:i).eq.',') string(i:i) = ' '

        enddo

      Return
      End Subroutine rmCommas


C***********************************************************************
C  Routine to change character string to upper characters
C***********************************************************************
      SUBROUTINE UCASE ( STR )

      IMPLICIT NONE

      CHARACTER STR*( * )
      INTEGER I
      INTEGER K

      DO I = 1, LEN(STR)
        K = ICHAR(STR(I:I))
        IF ( ( K .GE. 97 ) .AND. ( K .LE. 122 ) )
     &    STR( I:I ) = CHAR( K - 32 )
      END DO

      RETURN
      END SUBROUTINE UCASE

