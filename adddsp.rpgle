     HOPTION(*NODEBUGIO)
     D PSDS           SDS
     DFILENAME                 1      8
     **FREE
           //File Declation
            Dcl-f DSP02D WORKSTN;
            Dcl-f pf2 usage(*input:*output) keyed;
            Dcl-s validate1 ind;
            Dcl-s valWindow ind;
            DpgName=FileName;
            dow *IN03 = *OFF;
            setll *hival pf2;
            readp pf2;
            dId=empId+1;
            EXFMT RCDO1;

            if *In03 = *On;
               leave;
            elseif *IN05 = *On;
               clear RCDO1;
            else;
                 exsr validate;
                if validate1 = *on;
                   clear derror;
                   exsr addRecord;
                endif;
            endif;
            enddo;
           *Inlr = *On;

           //adding the record
           begsr addRecord;
             empId=did;
             empName=dName;
             slry=dsalary;
            dow *IN12 = *OFF;
               exfmt win01;
               exsr windw;
               if valWindow=*On;
                   write EMPDET;
                   derror = 'Record Added successfully';
                   clear dName;
                   clear dSalary;
                   exsr clearWind;
                   LEAVE;
              elseif wfld1='N'or wfld1='n';
                  derror = 'Record Not Added';
                  exsr clearWind;
                  LEAVE;
              endif;
            enddo;
           endsr;

           begsr clearWind;
              *In91=*OFF;
              clear werror;
              clear WFLD1;
            endsr;

           begsr windw;

             select;
               when wfld1=*blank;
                *In91=*On;
                 werror='Enter the value Y or N';
               when %check('YN':wfld1)<>0;
                 *In91=*On;
                 Werror= 'Enter the correct Letter Y or N';
               other;
                 if wfld1='Y';
                    valWindow = *On;
               //     leavesr;
                 else;
                    *In12=*OFF;
                    valWindow= *Off;
                //      leavesr;
                 endif;
               endsl;
            endsr;


           begsr validate;
             exsr turnOffIndicator;
             select;
               when dName= *blank;
                 *In50 = *On;
                 derror= 'Enter the valid Name';
                when (%check('QWERTYUIOPLKJHGFDSAZXCVBNM':
                 %trim(dName) ) <> 0 );

                   *In50 = *On;
                   derror= 'Enter a Valid Name';
               when dsalary= *zeros;
                  *In51 = *On;
                  derror= 'Enter the valid Amount';
               other;
                  validate1 = *On;
               endsl;
            endsr;

           begsr turnOffIndicator;
             *IN50= *OFF;
             *IN51= *OFF;
             *IN12=*OFF;
             validate1 = *OFF;
             valWindow=*OFF;
           endsr;